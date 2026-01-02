import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Common/widgets/glass_background_widget.dart';
import 'package:lava_dating_app/Controller/home_screen_controller.dart';
import 'package:lava_dating_app/View/chatModule/notification_list_screen.dart';
import 'package:lava_dating_app/View/homeModule/swipe_screen.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/services/storage_service.dart';
import '../../Common/widgets/animated_white_button.dart';
import '../../Common/widgets/glass_circular_button.dart';
import '../../Common/widgets/glass_profile_card.dart';
import '../../Common/widgets/glass_match_card.dart';
import '../../Common/widgets/shimmers/home_screen_shimmer_widget.dart';

class HomeScreenSplash extends StatefulWidget {
  const HomeScreenSplash({super.key});

  @override
  State<HomeScreenSplash> createState() => _HomeScreenSplashState();
}

class _HomeScreenSplashState extends State<HomeScreenSplash> with WidgetsBindingObserver {
  final RxInt matchesCount = 16.obs;
  final RxInt swipesLeft = 16.obs;
  final RxInt totalSwipes = 30.obs;
  final RxBool isUnlimitedSwipes = true.obs;
  final controller = Get.put(HomeScreenController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAndShowSafetyDialog();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // App is going to background - set killed flag
      StorageService.setAppKilledFlag();
    } else if (state == AppLifecycleState.resumed) {
      // App resumed - check if it was killed
      _checkAndShowSafetyDialog();
    }
  }

  Future<void> _checkAndShowSafetyDialog() async {
    // Wait a bit for the screen to build
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Check if it's first launch
    final isFirstLaunch = !StorageService.isSafetyDialogShownOnFirstLaunch();

    // Check if app was killed and user returned
    final wasKilled = await StorageService.checkAndClearAppKilledFlag();

    // Show dialog if first launch OR app was killed
    if (isFirstLaunch || wasKilled) {
      if (isFirstLaunch) {
        await StorageService.setSafetyDialogShownOnFirstLaunch();
      }

      // Show dialog
      _showSafetyDialog(Navigator.of(context, rootNavigator: true).context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      builder: (homeController) {
        if (homeController.isLoading) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: HomeScreenShimmerWidget(),
              ),
            ),
          );
        }

        return Scaffold(
          body: BackgroundContainer(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                heightSpace(22),
                                Text(
                                  homeController.homeData?.user?.firstName != null
                                      ? "Hi ${homeController.homeData!.user!.firstName}"
                                      : "",
                                  style: CommonTextStyle.regular14w500,
                                ),
                                Text(
                                  "Welcome back!",
                                  style: CommonTextStyle.regular22w600
                                      .copyWith(fontFamily: "Poppins-SemiBold"),
                                ),
                              ],
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => const NotificationListScreen());
                                },
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  "assets/icons/notification_icon.png",
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                        heightSpace(24),
                        Row(
                          children: [
                            SizedBox(height: 86, child: _buildMatchesCard(homeController)),
                            widthSpace(15),
                            Flexible(
                              flex: (homeController.homeData?.stats?.isUnlimitedSwipes ?? false)
                                  ? 3
                                  : 2,
                              child: _buildSwipesCard(homeController),
                            ),
                          ],
                        ),
                        heightSpace(30),
                        _buildCircularGlassButtons(),
                        heightSpace(30),
                      ],
                    ).marginSymmetric(horizontal: 20),
                    homeController.homeData?.suggestions == null ||
                            homeController.homeData?.suggestions?.isEmpty == true
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Suggestion",
                                style: CommonTextStyle.regular16w500,
                              ).marginOnly(left: 20),
                              heightSpace(10),
                              SizedBox(
                                height: 180,
                                child: _buildSuggestionsList(),
                              ),
                              heightSpace(30),
                            ],
                          ),
                    homeController.homeData?.recentMatches?.isEmpty == true ||
                            homeController.homeData?.recentMatches == null
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Matches",
                                style: CommonTextStyle.regular16w500,
                                textAlign: TextAlign.start,
                              ).marginSymmetric(horizontal: 20),
                              heightSpace(10),
                              SizedBox(
                                height: 150,
                                child: _buildMatchesList(),
                              ),
                              heightSpace(20)
                            ],
                          ),
                    homeController.homeData?.recentMatches?.isEmpty == true ||
                            homeController.homeData?.recentMatches == null ||
                            homeController.homeData?.suggestions == null ||
                            homeController.homeData?.suggestions?.isEmpty == true
                        ? const Center(
                            child: Text(
                            "No Data Found!",
                            style: CommonTextStyle.regular16w500,
                          ))
                        : const SizedBox(),
                    heightSpace(100),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMatchesList() {
    return GetBuilder<HomeScreenController>(
      builder: (homeController) {
        final recentMatches = homeController.homeData?.recentMatches ?? [];
        if (recentMatches.isEmpty) {
          return const SizedBox.shrink();
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recentMatches.length,
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 20,
          ),
          itemBuilder: (context, index) {
            final match = recentMatches[index];
            final imageUrl =
                match.user?.photos?.isNotEmpty == true ? match.user!.photos!.first : null;
            final name = match.user?.firstName ?? "";
            final age = match.user?.age != null ? "Age ${match.user!.age}" : "";

            return Padding(
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: GlassMatchCard(
                name: name,
                age: age,
                imageUrl: imageUrl,
                onTap: () {
                  // Navigate to match profile or chat screen
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showSafetyDialog(BuildContext context) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    showGeneralDialog(
      context: rootContext,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.5),
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final media = MediaQuery.of(context).size;
        final dialogWidth = media.width * 0.88 > 480 ? 480.0 : media.width * 0.88;
        final dialogMaxHeight = media.height * 0.72;
        return Center(
          child: FadeTransition(
            opacity: animation,
            child: Material(
              type: MaterialType.transparency,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: media.width,
                  maxHeight: dialogMaxHeight,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: GlassBackgroundWidget(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/icons/HomeSplash/warning_icon.png",
                              height: 28,
                              width: 28,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(width: 12),
                            const Text("Stay Safe", style: CommonTextStyle.regular16w500),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Be cautious about sharing personal information with strangers. Never share financial or sensitive details.",
                          style: CommonTextStyle.regular12w400,
                        ),
                        heightSpace(28),
                        Center(
                          child: AnimatedWhiteButton(
                            label: 'Got it',
                            width: 100,
                            height: 35,
                            onTap: () {
                              print('Got it tapped');
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ).marginSymmetric(horizontal: 20);
      },
    );
  }

  Widget _buildMatchesCard(HomeScreenController homeController) {
    final matchesCount = homeController.homeData?.stats?.matchesCount ?? 0;
    final formattedCount = matchesCount < 10 ? "0$matchesCount" : "$matchesCount";

    return SizedBox(
      height: 86,
      child: GlassBackgroundWidget(
        borderRadius: 10,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Matches",
              style: CommonTextStyle.regular18w500,
            ),
            heightSpace(4),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/matches_heart_icon.png",
                  height: 30,
                  width: 30,
                ),
                widthSpace(12),
                Text(
                  formattedCount,
                  style: CommonTextStyle.bold24w700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipesCard(HomeScreenController homeController) {
    final remainingSwipes = homeController.homeData?.stats?.remainingSwipes ?? 0;
    final totalDailySwipes = homeController.homeData?.stats?.totalDailySwipes ?? 100;
    final isUnlimitedSwipes = homeController.homeData?.stats?.isUnlimitedSwipes ?? false;

    // Calculate progress (avoid division by zero)
    final progress = totalDailySwipes > 0 ? remainingSwipes / totalDailySwipes : 0.0;

    return GlassBackgroundWidget(
      borderRadius: 10,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.grey.withOpacity(0.3),
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      ColorConstants.lightOrange,
                    ),
                    backgroundColor: ColorConstants.circularColor,
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ],
            ),
          ),
          widthSpace(15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Swipes Left: $remainingSwipes/$totalDailySwipes",
                  style: CommonTextStyle.regular18w500,
                ),
                isUnlimitedSwipes
                    ? Column(
                        children: [
                          heightSpace(5),
                          const Text(
                            "Unlimited Swipes",
                            style: CommonTextStyle.regular14w500,
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularGlassButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GlassCircularButton(
          label: "Search",
          size: 60,
          icon: Image.asset(
            "assets/icons/HomeSplash/home_search_icon.png",
            height: 36,
            width: 36,
          ),
          onTap: () {},
        ),
        GlassCircularButton(
          label: "Like",
          size: 60,
          icon: Image.asset(
            "assets/icons/HomeSplash/home_heart.png",
            height: 36,
            width: 36,
          ),
          onTap: () {},
        ),
        GlassCircularButton(
          label: "Settings",
          size: 60,
          icon: Image.asset(
            "assets/icons/HomeSplash/home_setting.png",
            height: 36,
            width: 36,
          ),
          onTap: () {},
        ),
        GlassCircularButton(
          label: "Boost",
          size: 60,
          icon: Image.asset(
            "assets/icons/HomeSplash/home_boost.png",
            height: 36,
            width: 36,
          ),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSuggestionsList() {
    return GetBuilder<HomeScreenController>(
      builder: (homeController) {
        final suggestions = homeController.homeData?.suggestions ?? [];

        if (suggestions.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: suggestions.length,
          padding: const EdgeInsetsDirectional.only(start: 20),
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];

            // Get first image from photos array
            final imageUrl =
                suggestion.user?.photos?.isNotEmpty == true ? suggestion.user!.photos!.first : null;

            // Determine first line text based on action
            final firstLineText = suggestion.action == "SUPER_LIKE"
                ? "This user really likes you"
                : "This user likes you";

            // Get user's first name for second line
            final secondLineText = suggestion.user?.firstName ?? "";

            // Show "View Profile" based on canSeeDetails
            final showViewProfile = suggestion.canSeeDetails ?? false;

            return Padding(
              padding: const EdgeInsets.only(
                right: 16,
              ),
              child: GlassProfileCard(
                firstLineText: firstLineText,
                secondLineText: secondLineText,
                imageUrl: imageUrl,
                showViewProfile: showViewProfile,
                onTap: () {
                  // Get.to(() => const SwipeScreen());
                },
              ),
            );
          },
        );
      },
    );
  }
}
