import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Controller/swipe_screen_controller.dart';
import 'package:lava_dating_app/View/homeModule/match_user_profile_screen.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  final controller = Get.put(SwipeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSearchBar(),
                    heightSpace(20),
                    const Text(
                      "Suggested Match",
                      style: CommonTextStyle.regular22w500,
                    ).marginSymmetric(horizontal: 20),
                    heightSpace(20),
                    SizedBox(
                      height: 495,
                      child: Stack(
                        children: [
                          Obx(() =>
                              controller.hasMoreCards ? _buildCardStack() : _buildEmptyState()),
                          Positioned(bottom: 0, left: 0, right: 0, child: _buildActionButtons()),
                        ],
                      ),
                    ),
                    heightSpace(25),
                    _buildProgressBar(),
                    heightSpace(20),
                  ],
                ),
              ),
              Obx(() => controller.showSnackbar.value
                  ? Positioned(
                      bottom: 100, // Above bottom navigation bar (100px height)
                      left: 20,
                      right: 20,
                      child: _buildSnackbar(),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Image.asset(
                  "assets/icons/HomeSplash/white_search_icon.png",
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Search by name, hobby, or city...",
                      hintStyle: CommonTextStyle.regular14w400.copyWith(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        widthSpace(20),
        GestureDetector(
          onTap: () => _showFilterBottomSheet(context),
          child: Image.asset(
            "assets/icons/HomeSplash/filter_icon.png",
            height: 32,
            width: 32,
            fit: BoxFit.fill,
          ),
        )
      ]),
    );
  }

  Widget _buildCardStack() {
    return Obx(() {
      final currentIndex = controller.currentIndex.value;
      final profiles = controller.profiles;
      if (currentIndex >= profiles.length) {
        return const SizedBox.shrink();
      }
      final profile = profiles[currentIndex];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _buildProfileCard(profile),
      );
    });
  }

  Widget _buildProfileCard(Map<String, dynamic> profile) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const MatchUserProfileScreen(), transition: Transition.noTransition);
      },
      child: Container(
        height: 450,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              Image.network(
                profile['imageUrl'] ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade800,
                    child: const Center(
                      child: Icon(Icons.person, size: 100, color: Colors.white54),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: controller.onSkip,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: ColorConstants.lightOrange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Skip",
                      style: CommonTextStyle.regular14w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 60,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name - large bold white text
                    Text(
                      profile['name'] ?? '',
                      style: CommonTextStyle.regular24w600,
                    ),
                    heightSpace(10),
                    // Location with grey icon
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/HomeSplash/location_pin_icon.png",
                          height: 24,
                          width: 24,
                        ),
                        widthSpace(10),
                        Text(
                          profile['location'] ?? '',
                          style: CommonTextStyle.regular16w500,
                        ),
                      ],
                    ),
                    heightSpace(5),
                    // Bio
                    Text(
                      profile['bio'] ?? '',
                      style: CommonTextStyle.regular12w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.close,
            iconColor: ColorConstants.lightOrange,
            backgroundColor: Colors.white,
            size: 78,
            onTap: controller.onPass,
            imagePath: "assets/icons/HomeSplash/swipe_dislike_button.png",
          ),
          _buildActionButton(
            icon: Icons.favorite,
            iconColor: Colors.white,
            backgroundColor: ColorConstants.lightOrange,
            size: 89,
            onTap: controller.onLike,
            imagePath: "assets/icons/HomeSplash/swipe_like_button.png",
          ),
          _buildActionButton(
            icon: Icons.star,
            iconColor: Colors.purple.shade400,
            backgroundColor: Colors.white,
            size: 78,
            onTap: controller.onSuperLike,
            imagePath: "assets/icons/HomeSplash/swipe_star_button.png",
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String imagePath,
    required Color iconColor,
    required Color backgroundColor,
    required double size,
    required VoidCallback onTap,
  }) {
    final isOrangeButton = backgroundColor == ColorConstants.lightOrange;

    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            boxShadow: isOrangeButton
                ? [
                    const BoxShadow(
                      color: Color.fromRGBO(233, 64, 87, 0.2),
                      blurRadius: 15,
                      spreadRadius: 0,
                      offset: Offset(0, 15),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Center(
            child: SizedBox(
              width: isOrangeButton ? 50 : 30,
              height: isOrangeButton ? 50 : 30,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          )),
    );
  }

  Widget _buildProgressBar() {
    return Obx(() {
      final swipesLeft = controller.swipesLeft.value;
      final totalSwipes = controller.totalSwipes.value;
      final progress = controller.progress;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$swipesLeft/$totalSwipes swipes left",
              textAlign: TextAlign.center,
              style: CommonTextStyle.regular14w500.copyWith(fontSize: 13),
            ),
            heightSpace(12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                height: 6,
                width: 140,
                color: const Color(0xFF4A2C2C), // Dark reddish-brown track
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: ColorConstants.lightOrange, // Bright orange fill
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          ),
          heightSpace(20),
          const Text(
            "No more profiles",
            style: CommonTextStyle.regular18w500,
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.8), // Dark grey overlay
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 30),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                children: [
                  const Text(
                    "Filter",
                    style: CommonTextStyle.regular20w600,
                  ).marginOnly(left: 20),
                ],
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    heightSpace(20),
                    _buildLocationSection(),
                    heightSpace(30),
                    _buildDistanceSection(),
                    heightSpace(30),
                    _buildAgeSection(),
                    heightSpace(30),
                    _buildInterestedInSection(),
                    heightSpace(40),
                  ],
                ),
              ),
              // Action Buttons
              _buildFilterActionButtons(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationSection() {
    return Obx(() => GestureDetector(
          onTap: () {
            // Show location picker
            _showLocationPicker();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFF262626), // Dark charcoal grey
              borderRadius: BorderRadius.circular(16), // More rounded corners
              border: Border.all(
                color: ColorConstants.lightOrange, // Bright orange border
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location label inside container
                    Text("Location",
                        style: CommonTextStyle.regular11w300
                            .copyWith(color: ColorConstants.lightOrange)),
                    heightSpace(5),
                    Row(
                      children: [
                        Text(
                          controller.selectedLocation.value,
                          style: CommonTextStyle.regular14w300,
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_drop_down_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildDistanceSection() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Distance",
              style: CommonTextStyle.regular14w500,
            ),
            heightSpace(16),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: ColorConstants.lightOrange,
                inactiveTrackColor: Colors.white.withOpacity(0.2),
                thumbColor: Colors.white,
                overlayColor: ColorConstants.lightOrange.withOpacity(0.2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                trackHeight: 4,
              ),
              child: RangeSlider(
                values: RangeValues(
                  controller.minDistance.value,
                  controller.maxDistance.value,
                ),
                min: 0,
                max: 30,
                divisions: 30,
                onChanged: (RangeValues values) {
                  controller.setDistanceRange(values.start, values.end);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "0 km",
                  style: CommonTextStyle.regular12w400.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                Text(
                  "${controller.maxDistance.value.toInt()} km",
                  style: CommonTextStyle.regular12w400.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildAgeSection() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Age",
              style: CommonTextStyle.regular14w500,
            ),
            heightSpace(16),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: ColorConstants.lightOrange,
                inactiveTrackColor: Colors.white.withOpacity(0.2),
                thumbColor: Colors.white,
                overlayColor: ColorConstants.lightOrange.withOpacity(0.2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                trackHeight: 4,
              ),
              child: RangeSlider(
                values: RangeValues(
                  controller.minAge.value,
                  controller.maxAge.value,
                ),
                min: 18,
                max: 100,
                divisions: 82,
                onChanged: (RangeValues values) {
                  controller.setAgeRange(values.start, values.end);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${controller.minAge.value.toInt()}",
                  style: CommonTextStyle.regular14w500,
                ),
                Text(
                  "${controller.maxAge.value.toInt()}",
                  style: CommonTextStyle.regular14w500,
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildInterestedInSection() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Interested In",
              style: CommonTextStyle.regular14w500,
            ),
            heightSpace(16),
            Row(
              children: [
                Expanded(
                  child: _buildGenderButton(
                    label: "Man",
                    isSelected: controller.selectedGender.value == 'Man',
                    onTap: () => controller.setGender('Man'),
                  ),
                ),
                widthSpace(12),
                Expanded(
                  child: _buildGenderButton(
                    label: "Women",
                    isSelected: controller.selectedGender.value == 'Women',
                    onTap: () => controller.setGender('Women'),
                  ),
                ),
                widthSpace(12),
                Expanded(
                  child: _buildGenderButton(
                    label: "Other",
                    isSelected: controller.selectedGender.value == 'Other',
                    onTap: () => controller.setGender('Other'),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildGenderButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? ColorConstants.lightOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ColorConstants.lightOrange : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: CommonTextStyle.regular14w500.copyWith(
              color: isSelected ? Colors.white : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                controller.clearAllFilters();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorConstants.lightOrange,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Clear All",
                    style: CommonTextStyle.regular16w500.copyWith(
                      color: ColorConstants.lightOrange,
                    ),
                  ),
                ),
              ),
            ),
          ),
          widthSpace(16),
          Expanded(
            child: GestureDetector(
              onTap: () {
                controller.applyFilters();
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: ColorConstants.lightOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Apply",
                    style: CommonTextStyle.regular16w500.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              "Select Location",
              style: CommonTextStyle.regular20w600,
            ),
            heightSpace(20),
            ...['San Francisco', 'New York', 'Los Angeles', 'Chicago', 'Dallas']
                .map((location) => ListTile(
                      title: Text(
                        location,
                        style: CommonTextStyle.regular16w500,
                      ),
                      onTap: () {
                        controller.setLocation(location);
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
            heightSpace(20),
          ],
        ),
      ),
    );
  }

  Widget _buildSnackbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => Text("💖 ${controller.snackbarMessage.value}",
                style: CommonTextStyle.regular14w500.copyWith(color: Colors.black))),
          ),
          widthSpace(12),
          GestureDetector(
            onTap: () {
              controller.undoLastAction();
            },
            child: Text('Undo',
                style: CommonTextStyle.regular14w600.copyWith(
                  color: ColorConstants.lightOrange,
                  decoration: TextDecoration.underline,
                )),
          ),
        ],
      ),
    );
  }
}
