import 'dart:async';
import 'package:get/get.dart';
import '../Api/api_controller.dart';
import '../Model/swipe_deck_model.dart';
import '../View/homeModule/congratulations_screen.dart';
import '../View/homeModule/dashboard_screen.dart';
import 'home_screen_controller.dart';

class SwipeScreenController extends GetxController {
  final ApiController _apiController = Get.find<ApiController>();

  // Dynamic list of profiles
  final RxList<Map<String, dynamic>> profiles = <Map<String, dynamic>>[].obs;

  // Current index in the stack
  final RxInt currentIndex = 0.obs;

  // Total swipes available
  final RxInt totalSwipes = 30.obs;

  // Swipes left
  final RxInt swipesLeft = 30.obs;

  // Loading state
  bool isLoading = false;

  // Match loading state (for showing shimmer when match is detected)
  final RxBool isMatchLoading = false.obs;

  // Pagination state
  int currentSkip = 0;
  final int limit = 20;

  // bool hasMore = true;
  bool hasMore = false;
  int totalProfiles = 0;

  // Filter tracking
  bool _filtersApplied = false;

  // Lists for different actions
  final RxList<Map<String, dynamic>> likedProfiles = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> superLikedProfiles = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> passedProfiles = <Map<String, dynamic>>[].obs;

  // Snackbar state
  final RxBool showSnackbar = false.obs;
  final RxString snackbarMessage = ''.obs;
  final RxString lastActionType = ''.obs; // 'like', 'pass', 'superLike'
  Map<String, dynamic>? lastSwipedProfile;
  int? lastSwipedIndex;
  Timer? _snackbarTimer;

  // Prevent multiple clicks
  bool _isActionInProgress = false;

  // Action image state (for showing images on swipe actions)
  final RxString currentActionImage = ''.obs; // 'like', 'dislike', 'superlike', or ''
  final RxBool showActionImage = false.obs;
  
  // Card swipe animation state
  final RxBool isCardSwiping = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeSwipesFromHomeData();
    fetchSwipeDeck();
  }

  // Initialize total swipes from HomeScreenModel
  void _initializeSwipesFromHomeData() {
    try {
      final homeController = Get.find<HomeScreenController>();
      final totalDailySwipes = homeController.homeData?.stats?.totalDailySwipes;
      if (totalDailySwipes != null && totalDailySwipes > 0) {
        totalSwipes.value = totalDailySwipes;
      }
      final remainingSwipes = homeController.homeData?.stats?.remainingSwipes;
      if (remainingSwipes != null) {
        swipesLeft.value = remainingSwipes;
      }
    } catch (e) {
      print('Error initializing swipes from home data: $e');
    }
  }

  Future<void> fetchSwipeDeck({bool loadMore = false, bool useFilters = false}) async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      // Prepare filter parameters if filters are applied
      int? minAgeParam;
      int? maxAgeParam;
      double? maxDistanceParam;
      String? gendersParam;
      String? locationParam;

      if (useFilters || _filtersApplied) {
        minAgeParam = minAge.value.toInt();
        maxAgeParam = maxAge.value.toInt();
        maxDistanceParam = maxDistance.value;
        gendersParam = _mapGenderToApiFormat(selectedGender.value);
        locationParam = selectedLocation.value;
      }

      final response = await _apiController.getSwipeDeck(
        limit: limit,
        skip: loadMore ? currentSkip : 0,
        minAge: minAgeParam,
        maxAge: maxAgeParam,
        maxDistance: maxDistanceParam,
        genders: gendersParam,
        location: locationParam,
      );

      isLoading = false;
      update();

      if (response.statusCode == 200 || response.statusCode == 201 && response.body != null) {
        try {
          final deckData = SwipeDeckModel.fromJson(response.body);
          final mappedProfiles = deckData.profiles?.map((profile) {
                return _mapProfileToUiFormat(profile);
              }).toList() ??
              [];

          if (loadMore) {
            profiles.addAll(mappedProfiles);
            currentSkip += mappedProfiles.length;
          } else {
            // Replace profiles for initial load or filter apply
            profiles.value = mappedProfiles;
            currentIndex.value = 0;
            currentSkip = mappedProfiles.length;
          }

          // Update pagination state
          hasMore = deckData.hasMore ?? false;
          totalProfiles = deckData.total ?? 0;

          // Initialize total swipes from HomeScreenModel if not already set
          if (totalSwipes.value == 30) {
            _initializeSwipesFromHomeData();
          }

          // Fetch remaining swipes from API
          _fetchRemainingSwipes();

          update();
        } catch (e) {
          print('Error parsing swipe deck data: $e');
        }
      } else {
        final errorMessage = _apiController.getErrorMessage(response);
        print('Error fetching swipe deck: $errorMessage');
      }
    } catch (e) {
      isLoading = false;
      update();
      print('Network error fetching swipe deck: $e');
    }
  }

  Map<String, dynamic> _mapProfileToUiFormat(DeckProfile profile) {
    // Get first image from photos array
    final imageUrl = profile.photos?.isNotEmpty == true ? profile.photos!.first : null;

    // Build location string from city and country
    final location = _buildLocationString(profile.city, profile.country);

    return {
      'id': profile.id,
      'name': profile.firstName ?? '',
      'location': location,
      'bio': profile.bio ?? '',
      'imageUrl': imageUrl,
      'age': profile.age,
      'profileData': profile,
    };
  }

  // Build location string from city and country
  String _buildLocationString(String? city, String? country) {
    if (city != null && city.isNotEmpty && country != null && country.isNotEmpty) {
      return '$city, $country';
    } else if (city != null && city.isNotEmpty) {
      return city;
    } else if (country != null && country.isNotEmpty) {
      return country;
    }
    return '';
  }

  // Load more profiles (for pagination)
  Future<void> loadMoreProfiles() async {
    if (hasMore && !isLoading) {
      await fetchSwipeDeck(loadMore: true, useFilters: _filtersApplied);
    }
  }

  // Handle like action
  void onLike() {
    // Prevent multiple clicks
    if (_isActionInProgress || currentIndex.value >= profiles.length) {
      return;
    }

    final profile = profiles[currentIndex.value];
    final profileId = profile['id'] as String?;

    // Check if profile is already in any list (shouldn't happen after undo, but safety check)
    if (profileId != null) {
      final alreadyLiked = likedProfiles.any((p) => p['id'] == profileId);
      final alreadySuperLiked = superLikedProfiles.any((p) => p['id'] == profileId);
      final alreadyPassed = passedProfiles.any((p) => p['id'] == profileId);

      if (alreadyLiked || alreadySuperLiked || alreadyPassed) {
        // Profile already swiped, remove from all lists first (shouldn't happen, but safety)
        likedProfiles.removeWhere((p) => p['id'] == profileId);
        superLikedProfiles.removeWhere((p) => p['id'] == profileId);
        passedProfiles.removeWhere((p) => p['id'] == profileId);
      }
    }

    _isActionInProgress = true;

    final index = currentIndex.value;
    final targetUserId = profileId;

    // Store for undo
    lastSwipedProfile = Map<String, dynamic>.from(profile); // Create a copy
    lastSwipedIndex = index;
    lastActionType.value = 'like';
    likedProfiles.add(profile);

    // Show action image
    currentActionImage.value = 'like';
    showActionImage.value = true;

    // Delay before moving to next card to show image animation
    Future.delayed(const Duration(milliseconds: 600), () {
      // Move to next card after image is visible
      _moveToNext();
      
      // Check if profiles array is now empty after moving (last profile was swiped)
      // This ensures empty state is shown immediately
      if (profiles.isEmpty || currentIndex.value >= profiles.length) {
        update(); // Force UI update to show empty state
      }
      
      // Hide image after card swipe completes
      Future.delayed(const Duration(milliseconds: 300), () {
        showActionImage.value = false;
        currentActionImage.value = '';
      });
    });

    _showSnackbar('You liked ${profile['name']} feeling unsure?');

    // Call API in background (non-blocking)
    if (targetUserId != null && targetUserId.isNotEmpty) {
      _swipeUserInBackground(targetUserId, 'LIKE').then((_) {
        _isActionInProgress = false;
      }).catchError((error) {
        _isActionInProgress = false;
      });
    } else {
      _isActionInProgress = false;
    }
  }

  // Background API call for swipe action
  Future<void> _swipeUserInBackground(String targetUserId, String action) async {
    try {
      final response = await _apiController.swipeUser(
        targetUserId: targetUserId,
        action: action,
      );

      if (response.statusCode == 200 || response.statusCode == 201 && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        final isMatch = body['isMatch'] as bool? ?? false;

        if (isMatch) {
          isMatchLoading.value = true;

          final matchedProfile = profiles.firstWhereOrNull(
            (p) => p['id'] == targetUserId,
          );

          String? currentUserImageUrl;
          try {
            final homeController = Get.find<HomeScreenController>();
            final currentUserPhotos = homeController.homeData?.user?.photos;
            if (currentUserPhotos != null && currentUserPhotos.isNotEmpty) {
              currentUserImageUrl = currentUserPhotos.first;
            }
          } catch (e) {
            print('Error getting current user image: $e');
          }

          // Get matched user's image
          final matchedUserImageUrl = matchedProfile?['imageUrl'] as String?;

          // Small delay to show shimmer before navigation
          Future.delayed(const Duration(milliseconds: 500), () {
            // Reset match loading before navigation
            isMatchLoading.value = false;

            Get.to(
              () => CongratulationsScreen(
                user1ImageUrl: currentUserImageUrl,
                user2ImageUrl: matchedUserImageUrl,
                onSayHello: () {
                  // Handle say hello action
                  Get.back();
                },
                onKeepSwiping: () {
                  // Close congratulations screen and navigate to Dashboard with SwipeScreen selected (index 1)
                  Get.back(); // Close congratulations screen first
                  // Navigate to DashboardScreen with SwipeScreen selected
                  Get.offAll(() => const DashboardScreen(initialIndex: 1));
                },
              ),
              transition: Transition.noTransition,
            );
          });
        }

        // Fetch remaining swipes after swipe action
        _fetchRemainingSwipes();
      } else {
        final errorMessage = _apiController.getErrorMessage(response);
        print('Error in swipe action: $errorMessage');
      }
    } catch (e) {
      print('Network error in swipe action: $e');
    }
  }

  // Fetch remaining swipes from API
  Future<void> _fetchRemainingSwipes() async {
    try {
      final response = await _apiController.getRemainingSwipes();
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null) {
          final body = response.body as Map<String, dynamic>;
          final remainingSwipes = body['remainingSwipes'] as int?;
          if (remainingSwipes != null) {
            swipesLeft.value = remainingSwipes;
          }
        }
      }
    } catch (e) {
      print('Error fetching remaining swipes: $e');
    }
  }

  // Handle super like action
  void onSuperLike() {
    // Prevent multiple clicks
    if (_isActionInProgress || currentIndex.value >= profiles.length) {
      return;
    }

    final profile = profiles[currentIndex.value];
    final profileId = profile['id'] as String?;

    // Check if profile is already in any list (shouldn't happen after undo, but safety check)
    if (profileId != null) {
      final alreadyLiked = likedProfiles.any((p) => p['id'] == profileId);
      final alreadySuperLiked = superLikedProfiles.any((p) => p['id'] == profileId);
      final alreadyPassed = passedProfiles.any((p) => p['id'] == profileId);

      if (alreadyLiked || alreadySuperLiked || alreadyPassed) {
        // Profile already swiped, remove from all lists first (shouldn't happen, but safety)
        likedProfiles.removeWhere((p) => p['id'] == profileId);
        superLikedProfiles.removeWhere((p) => p['id'] == profileId);
        passedProfiles.removeWhere((p) => p['id'] == profileId);
      }
    }

    _isActionInProgress = true;

    final index = currentIndex.value;
    final targetUserId = profileId;

    // Store for undo
    lastSwipedProfile = Map<String, dynamic>.from(profile); // Create a copy
    lastSwipedIndex = index;
    lastActionType.value = 'superLike';
    superLikedProfiles.add(profile);

    // Show action image
    currentActionImage.value = 'superlike';
    showActionImage.value = true;

    // Delay before moving to next card to show image animation
    Future.delayed(const Duration(milliseconds: 600), () {
      // Move to next card after image is visible
      _moveToNext();
      
      // Check if profiles array is now empty after moving (last profile was swiped)
      // This ensures empty state is shown immediately
      if (profiles.isEmpty || currentIndex.value >= profiles.length) {
        update(); // Force UI update to show empty state
      }
      
      // Hide image after card swipe completes
      Future.delayed(const Duration(milliseconds: 300), () {
        showActionImage.value = false;
        currentActionImage.value = '';
      });
    });

    _showSnackbar('You super liked ${profile['name']} feeling unsure?');

    // Call API in background (non-blocking)
    if (targetUserId != null && targetUserId.isNotEmpty) {
      _swipeUserInBackground(targetUserId, 'SUPER_LIKE').then((_) {
        _isActionInProgress = false;
      }).catchError((error) {
        _isActionInProgress = false;
      });
    } else {
      _isActionInProgress = false;
    }
  }

  // Handle pass/cancel action (DISLIKE)
  void onPass() {
    // Prevent multiple clicks
    if (_isActionInProgress || currentIndex.value >= profiles.length) {
      return;
    }

    final profile = profiles[currentIndex.value];
    final profileId = profile['id'] as String?;

    // Check if profile is already in any list (shouldn't happen after undo, but safety check)
    if (profileId != null) {
      final alreadyLiked = likedProfiles.any((p) => p['id'] == profileId);
      final alreadySuperLiked = superLikedProfiles.any((p) => p['id'] == profileId);
      final alreadyPassed = passedProfiles.any((p) => p['id'] == profileId);

      if (alreadyLiked || alreadySuperLiked || alreadyPassed) {
        // Profile already swiped, remove from all lists first (shouldn't happen, but safety)
        likedProfiles.removeWhere((p) => p['id'] == profileId);
        superLikedProfiles.removeWhere((p) => p['id'] == profileId);
        passedProfiles.removeWhere((p) => p['id'] == profileId);
      }
    }

    _isActionInProgress = true;

    final index = currentIndex.value;
    final targetUserId = profileId;

    // Store for undo
    lastSwipedProfile = Map<String, dynamic>.from(profile); // Create a copy
    lastSwipedIndex = index;
    lastActionType.value = 'pass';
    passedProfiles.add(profile);

    // Show action image
    currentActionImage.value = 'dislike';
    showActionImage.value = true;

    // Delay before moving to next card to show image animation
    Future.delayed(const Duration(milliseconds: 600), () {
      // Move to next card after image is visible
      _moveToNext();
      
      // Check if profiles array is now empty after moving (last profile was swiped)
      // This ensures empty state is shown immediately
      if (profiles.isEmpty || currentIndex.value >= profiles.length) {
        update(); // Force UI update to show empty state
      }
      
      // Hide image after card swipe completes
      Future.delayed(const Duration(milliseconds: 300), () {
        showActionImage.value = false;
        currentActionImage.value = '';
      });
    });

    _showSnackbar('You passed ${profile['name']} feeling unsure?');

    // Call API in background (non-blocking)
    if (targetUserId != null && targetUserId.isNotEmpty) {
      _swipeUserInBackground(targetUserId, 'DISLIKE').then((_) {
        _isActionInProgress = false;
      }).catchError((error) {
        _isActionInProgress = false;
      });
    } else {
      _isActionInProgress = false;
    }
  }

  void onSkip() {
    // Allow skip even on last profile, but prevent if no profiles or action in progress
    if (_isActionInProgress || currentIndex.value >= profiles.length || profiles.isEmpty) {
      return;
    }

    _isActionInProgress = true;

    final profile = profiles[currentIndex.value];
    final targetUserId = profile['id'] as String?;

    // Check if this is the last profile (before removing)
    final wasLastProfile = currentIndex.value >= profiles.length - 1;

    profiles.removeAt(currentIndex.value);
    profiles.add(profile);

    // After skip, check if profiles array is now effectively empty for UI display
    // If we were at the last position, currentIndex might now be out of bounds
    if (wasLastProfile) {
      // We skipped the last profile, set currentIndex to indicate no more cards
      currentIndex.value = profiles.length; // Set to length to indicate no more cards
      update(); // Force UI update to show empty state
    } else {
      // Not the last profile, currentIndex stays valid (shows next profile)
      // If currentIndex is now out of bounds after removal, adjust it
      if (currentIndex.value >= profiles.length) {
        currentIndex.value = profiles.length - 1;
      }
      update(); // Force UI update
    }

    if (targetUserId != null && targetUserId.isNotEmpty) {
      _skipUserInBackground(targetUserId).then((_) {
        _isActionInProgress = false;
      }).catchError((error) {
        _isActionInProgress = false;
      });
    } else {
      _isActionInProgress = false;
    }
  }

  // Background API call for skip action
  Future<void> _skipUserInBackground(String targetUserId) async {
    try {
      final response = await _apiController.skipUser(targetUserId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Fetch remaining swipes after skip action
        _fetchRemainingSwipes();
      } else {
        final errorMessage = _apiController.getErrorMessage(response);
        print('Error in skip action: $errorMessage');
      }
    } catch (e) {
      print('Network error in skip action: $e');
    }
  }

  void _moveToNext() {
    // Check if this was the last profile
    final wasLastProfile = currentIndex.value >= profiles.length - 1;

    // Set swiping state for animation
    isCardSwiping.value = true;

    if (currentIndex.value < profiles.length - 1) {
      currentIndex.value++;
      // Force UI update
      update();

      if (currentIndex.value >= profiles.length - 3 && hasMore && !isLoading) {
        loadMoreProfiles();
      }
      
      // Reset swiping state after animation
      Future.delayed(const Duration(milliseconds: 300), () {
        isCardSwiping.value = false;
      });
    } else {
      // This was the last profile
      // Increment index to indicate no more cards (for hasMoreCards check)
      if (profiles.isNotEmpty) {
        currentIndex.value = profiles.length; // Set to length to indicate no more cards
      }

      if (hasMore && !isLoading) {
        loadMoreProfiles();
      } else {
        // No more profiles available - ensure UI updates to show empty state
        update();
      }
    }

    // After moving, check if profiles array is now effectively empty for UI
    // This ensures empty state is shown when last profile is swiped
    if (wasLastProfile && !hasMore) {
      update(); // Force UI update to show empty state
    }
  }

  // Get progress (0.0 to 1.0)
  double get progress {
    if (totalSwipes.value == 0) return 0.0;
    final usedSwipes = totalSwipes.value - swipesLeft.value;
    return (usedSwipes / totalSwipes.value).clamp(0.0, 1.0);
  }

  // Get current profile
  Map<String, dynamic>? get currentProfile {
    if (currentIndex.value < profiles.length) {
      return profiles[currentIndex.value];
    }
    return null;
  }

  // Check if there are more cards
  bool get hasMoreCards {
    // If profiles is empty, no cards
    if (profiles.isEmpty) return false;
    // If currentIndex is beyond profiles length, no more cards
    if (currentIndex.value >= profiles.length) return false;
    // Otherwise, check if there are more profiles
    return currentIndex.value < profiles.length;
  }

  // Filter state
  final RxString selectedLocation = 'San Francisco'.obs;
  final RxDouble minDistance = 0.0.obs;
  final RxDouble maxDistance = 30.0.obs;
  final RxDouble minAge = 18.0.obs;
  final RxDouble maxAge = 35.0.obs;
  final RxString selectedGender = 'Man'.obs; // 'Man', 'Women', 'Other'

  // Filter methods
  void setLocation(String location) {
    selectedLocation.value = location;
  }

  void setDistanceRange(double min, double max) {
    minDistance.value = min;
    maxDistance.value = max;
  }

  void setAgeRange(double min, double max) {
    minAge.value = min;
    maxAge.value = max;
  }

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  void clearAllFilters() {
    selectedLocation.value = 'San Francisco';
    minDistance.value = 0.0;
    maxDistance.value = 30.0;
    minAge.value = 18.0;
    maxAge.value = 35.0;
    selectedGender.value = 'Man';
    // Reset filter flag and reload without filters
    _filtersApplied = false;
    currentSkip = 0;
    hasMore = true;
    // Clear profiles immediately to show shimmer
    profiles.clear();
    currentIndex.value = 0;
    update();
    fetchSwipeDeck(useFilters: false);
  }

  void applyFilters() {
    // Mark filters as applied
    _filtersApplied = true;
    // Reset pagination
    currentSkip = 0;
    hasMore = true;
    // Clear profiles immediately to show shimmer
    profiles.clear();
    currentIndex.value = 0;
    update();
    // Fetch with filters
    fetchSwipeDeck(useFilters: true);
  }

  // Map gender from UI format to API format
  String _mapGenderToApiFormat(String uiGender) {
    switch (uiGender.toLowerCase()) {
      case 'man':
        return 'MALE';
      case 'women':
        return 'FEMALE';
      case 'other':
        return 'OTHER';
      default:
        return 'MALE';
    }
  }

  // Show snackbar
  void _showSnackbar(String message) {
    _snackbarTimer?.cancel();
    snackbarMessage.value = message;
    showSnackbar.value = true;
    // Auto-hide after 4 seconds
    _snackbarTimer = Timer(const Duration(seconds: 4), () {
      hideSnackbar();
    });
  }

  // Hide snackbar
  void hideSnackbar() {
    _snackbarTimer?.cancel();
    showSnackbar.value = false;
  }

  // Undo last action
  void undoLastAction() {
    if (lastSwipedProfile == null || lastSwipedIndex == null) return;

    // Reset action in progress flag to allow new actions
    _isActionInProgress = false;

    // Remove from respective list
    if (lastActionType.value == 'like') {
      likedProfiles.removeWhere((p) => p['id'] == lastSwipedProfile!['id']);
    } else if (lastActionType.value == 'superLike') {
      superLikedProfiles.removeWhere((p) => p['id'] == lastSwipedProfile!['id']);
    } else if (lastActionType.value == 'pass') {
      passedProfiles.removeWhere((p) => p['id'] == lastSwipedProfile!['id']);
    }

    // Check if profile already exists at current index (to avoid duplicates)
    final profileId = lastSwipedProfile!['id'] as String?;
    if (profileId != null) {
      // Remove profile if it already exists in the list (shouldn't happen, but safety check)
      profiles.removeWhere((p) => p['id'] == profileId);
    }

    // Check if profiles was empty (last profile was swiped)
    final wasProfilesEmpty = profiles.isEmpty;

    // Restore profile at the original position (lastSwipedIndex)
    final restoreIndex = lastSwipedIndex!;
    // Clamp restoreIndex to valid range
    final validIndex = restoreIndex.clamp(0, profiles.length);
    profiles.insert(validIndex, lastSwipedProfile!);

    // Set currentIndex to show the restored card
    // If profiles was empty, set index to 0, otherwise use validIndex
    currentIndex.value = wasProfilesEmpty ? 0 : validIndex;

    // Clear last action
    lastSwipedProfile = null;
    lastSwipedIndex = null;
    lastActionType.value = '';
    hideSnackbar();

    // Update UI to reflect restored profile
    update();

    // Call API in background (non-blocking)
    _undoLastActionInBackground().then((_) {
      // Fetch remaining swipes after undo
      _fetchRemainingSwipes();
    });
  }

  // Background API call for undo action
  Future<void> _undoLastActionInBackground() async {
    try {
      await _apiController.undoLastAction();
    } catch (e) {
      // Silently handle errors - UI already updated
      print('Error undoing last action: $e');
    }
  }
}
