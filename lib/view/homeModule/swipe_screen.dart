import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/loading_overlay_widget.dart';
import 'package:lava_dating_app/Common/widgets/glassmorphic_background_widget.dart';
import 'package:lava_dating_app/Common/widgets/shimmers/swipe_screen_shimmer_widget.dart';
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
    return GetBuilder<SwipeScreenController>(
      builder: (swipeController) {
        if (swipeController.isLoading && swipeController.profiles.isEmpty) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: SwipeScreenShimmerWidget(),
              ),
            ),
          );
        }
        return Scaffold(
          body: Stack(
            children: [
              BackgroundContainer(
                child: SafeArea(
                  child: Stack(
                    children: [
                      Obx(() => (swipeController.profiles.isEmpty && !swipeController.isLoading) ||
                              (!swipeController.hasMoreCards && !swipeController.isLoading)
                          ? Column(
                              children: [
                                _buildSearchBar(),
                                Expanded(
                                  child: Center(
                                    child: _buildEmptyState(),
                                  ),
                                ),
                              ],
                            )
                          : SingleChildScrollView(
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
                                        Obx(() => swipeController.hasMoreCards
                                            ? _buildCardStack()
                                            : _buildEmptyState()),
                                        Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: _buildActionButtons()),
                                        // Action image overlay
                                        Obx(() => swipeController.showActionImage.value
                                            ? _buildActionImage(
                                                swipeController.currentActionImage.value)
                                            : const SizedBox.shrink()),
                                      ],
                                    ),
                                  ),
                                  heightSpace(25),
                                  _buildProgressBar(),
                                  heightSpace(100),
                                ],
                              ),
                            )),
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
              // Match loading overlay
              Obx(() => swipeController.isMatchLoading.value
                  ? Container(
                      color: Colors.black.withOpacity(0.7),
                      child: const Center(
                        child: SwipeScreenShimmerWidget(),
                      ),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
        );
      },
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
      final isSwiping = controller.isCardSwiping.value;

      if (currentIndex >= profiles.length) {
        return const SizedBox.shrink();
      }
      final profile = profiles[currentIndex];

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Start from right
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: Padding(
          key: ValueKey<int>(currentIndex), // Key ensures animation triggers
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildProfileCard(profile),
        ),
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
                      style: CommonTextStyle.regular24w600.copyWith(fontFamily: "Poppins-SemiBold"),
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

  Widget _buildActionImage(String actionType) {
    String imagePath;
    switch (actionType) {
      case 'like':
        imagePath = "assets/images/hibiscus_flower.png";
        break;
      case 'dislike':
        imagePath = "assets/images/coconut_fruit_white.png";
        break;
      case 'superlike':
        imagePath = "assets/images/lei_flower.png";
        break;
      default:
        return const SizedBox.shrink();
    }

    return Positioned(
      top: 100,
      left: 30,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.scale(
              scale: 0.5 + (value * 0.5), // Scale from 0.5 to 1.0
              child: Image.asset(
                imagePath,
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
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
          heightSpace(60)
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
                width: 50,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                children: [
                  Text(
                    "Filter",
                    style: CommonTextStyle.regular20w600.copyWith(fontFamily: "Poppins-SemiBold"),
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
              _buildFilterActionButtons(context),
              heightSpace(20)
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationSection() {
    return Obx(() => _CustomLocationSelector(
          selectedValue: controller.selectedLocation.value,
          items: const ['San Francisco', 'New York', 'Los Angeles', 'Chicago', 'Dallas'],
          hint: "Select Location",
          onItemSelected: (String value) {
            controller.setLocation(value);
          },
        ));
  }

  Widget _buildDistanceSection() {
    return Obx(() {
      // Ensure min value is 5, but allow slider to start from 0
      final currentValue = controller.maxDistance.value < 5 ? 5.0 : controller.maxDistance.value;
      final clampedValue = currentValue.clamp(5.0, 100.0);

      // Calculate position for the badge (0.0 to 1.0, where 0.0 is left and 1.0 is right)
      // Map from 5-100 range to 0-1 position
      final position = ((clampedValue - 5) / (100 - 5)).clamp(0.0, 1.0);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Distance",
            style: CommonTextStyle.bold16w700,
          ),
          heightSpace(16),
          Stack(
            clipBehavior: Clip.none,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: ColorConstants.lightOrange,
                  inactiveTrackColor: ColorConstants.lightOrange.withOpacity(0.3),
                  thumbColor: Colors.white,
                  overlayColor: ColorConstants.lightOrange.withOpacity(0.2),
                  thumbShape:
                      const BorderedSliderThumbShape(enabledThumbRadius: 10, borderWidth: 1),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                  trackHeight: 4,
                  // Yeh line main hai jo full width karegi
                  trackShape: FullWidthSliderTrackShape(),
                ),
                child: SizedBox(
                  width: double.infinity, // Poori screen ki width lega
                  child: Slider(
                    value: clampedValue,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    onChanged: (double value) {
                      // Clamp value to minimum 5
                      final newValue = value < 5 ? 5.0 : value;
                      controller.setDistanceRange(0, newValue);
                    },
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: -45,
                child: Align(
                  alignment: Alignment(
                    (position * 2 - 1).clamp(-1.0, 1.0),
                    0,
                  ),
                  child: _BadgeWithTail(
                    value: "${clampedValue.toInt()} km",
                  ),
                ),
              ),
            ],
          ),
          heightSpace(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "0 km",
                style: CommonTextStyle.bold14w700.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _BadgeWithTail({required String value}) {
    return CustomPaint(
      painter: _BadgePainter(),
      child: Text(
        value,
        style: CommonTextStyle.bold14w700.copyWith(
          color: Colors.white,
        ),
      ).marginOnly(bottom: 25),
    );
  }

  Widget _buildAgeSection() {
    return Obx(() {
      final minAge = controller.minAge.value;
      final maxAge = controller.maxAge.value;

      // Calculate positions for both thumbs (0.0 to 1.0)
      final minPosition = ((minAge - 18) / (100 - 18)).clamp(0.0, 1.0);
      final maxPosition = ((maxAge - 18) / (100 - 18)).clamp(0.0, 1.0);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Age", style: CommonTextStyle.bold16w700),
          heightSpace(16),
          Stack(
            clipBehavior: Clip.none,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: ColorConstants.lightOrange,
                  inactiveTrackColor: ColorConstants.lightOrange.withOpacity(0.3),
                  thumbColor: Colors.white,
                  overlayColor: ColorConstants.lightOrange.withOpacity(0.2),
                  rangeThumbShape:
                      const BorderedRangeSliderThumbShape(enabledThumbRadius: 10, borderWidth: 1),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                  trackHeight: 4,
                  rangeTrackShape: FullWidthRangeSliderTrackShape(),
                ),
                child: SizedBox(
                  width: double.infinity, // Ye ab kaam karega
                  child: RangeSlider(
                    values: RangeValues(minAge, maxAge),
                    min: 18,
                    max: 100,
                    divisions: 82,
                    onChanged: (RangeValues values) {
                      controller.setAgeRange(values.start, values.end);
                    },
                  ),
                ),
              ),
              // Badge for min age
              Positioned(
                left: 0,
                right: 15,
                bottom: -45,
                child: Align(
                  alignment: Alignment(
                    (minPosition * 2 - 1).clamp(-1.0, 1.0),
                    0,
                  ),
                  child: _BadgeWithTail(
                    value: "${minAge.toInt()}",
                  ),
                ),
              ),
              // Badge for max age
              Positioned(
                left: 0,
                right: 15,
                bottom: -45,
                child: Align(
                  alignment: Alignment(
                    (maxPosition * 2 - 1).clamp(-1.0, 1.0),
                    0,
                  ),
                  child: _BadgeWithTail(
                    value: "${maxAge.toInt()}",
                  ),
                ),
              ),
            ],
          ),
          heightSpace(10),
        ],
      );
    });
  }

  Widget _buildInterestedInSection() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Interested In", style: CommonTextStyle.bold16w700),
            heightSpace(16),
            Row(
              children: [
                Expanded(
                    child: _buildGenderButton(
                        label: "Man",
                        isSelected: controller.selectedGender.value == 'Man',
                        onTap: () => controller.setGender('Man'))),
                widthSpace(12),
                Expanded(
                    child: _buildGenderButton(
                        label: "Women",
                        isSelected: controller.selectedGender.value == 'Women',
                        onTap: () => controller.setGender('Women'))),
                widthSpace(12),
                Expanded(
                    child: _buildGenderButton(
                        label: "Other",
                        isSelected: controller.selectedGender.value == 'Other',
                        onTap: () => controller.setGender('Other'))),
              ],
            ),
          ],
        ));
  }

  Widget _buildGenderButton(
      {required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? ColorConstants.lightOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? ColorConstants.lightOrange : Colors.white.withOpacity(0.3),
              width: 1),
        ),
        child: Center(
            child: Text(label,
                style: CommonTextStyle.regular14w500
                    .copyWith(color: isSelected ? Colors.white : Colors.white))),
      ),
    );
  }

  Widget _buildFilterActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.8)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                controller.clearAllFilters();
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ColorConstants.lightOrange, width: 1),
                ),
                child: Center(
                    child: Text("Clear All",
                        style: CommonTextStyle.regular16w400
                            .copyWith(color: ColorConstants.lightOrange))),
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
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                    color: ColorConstants.lightOrange, borderRadius: BorderRadius.circular(12)),
                child: Center(
                    child: Text("Apply",
                        style: CommonTextStyle.regular16w400.copyWith(color: Colors.white))),
              ),
            ),
          ),
        ],
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
              color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        children: [
          Expanded(
              child: Obx(() => Text("💖 ${controller.snackbarMessage.value}",
                  style: CommonTextStyle.regular14w500.copyWith(color: Colors.black)))),
          widthSpace(12),
          GestureDetector(
            onTap: () => controller.undoLastAction(),
            child: Text('Undo',
                style: CommonTextStyle.regular14w600.copyWith(
                    color: ColorConstants.lightOrange, decoration: TextDecoration.underline)),
          ),
        ],
      ),
    );
  }
}

class _BadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    const triangleHeight = 8.0;
    final badgeHeight = size.height - triangleHeight;
    final badgeWidth = size.width;
    const borderRadius = 10.0;
    const triangleWidth = 10.0;

    final badgeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, triangleHeight, badgeWidth, badgeHeight),
      const Radius.circular(borderRadius),
    );
    canvas.drawRRect(badgeRect, paint);

    final trianglePath = Path();
    final centerX = badgeWidth / 2;
    trianglePath.moveTo(centerX - triangleWidth / 2, triangleHeight);
    trianglePath.lineTo(centerX, 0);
    trianglePath.lineTo(centerX + triangleWidth / 2, triangleHeight);
    trianglePath.close();
    canvas.drawPath(trianglePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CustomLocationSelector extends StatefulWidget {
  final String selectedValue;
  final List<String> items;
  final String hint;
  final Function(String) onItemSelected;

  const _CustomLocationSelector({
    required this.selectedValue,
    required this.items,
    required this.hint,
    required this.onItemSelected,
  });

  @override
  State<_CustomLocationSelector> createState() => _CustomLocationSelectorState();
}

class _CustomLocationSelectorState extends State<_CustomLocationSelector>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(_CustomLocationSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild when selectedValue changes
    if (oldWidget.selectedValue != widget.selectedValue) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _selectItem(String item) {
    widget.onItemSelected(item);
    _toggleExpansion();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggleExpansion,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorConstants.lightOrange,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Location",
                      style:
                          CommonTextStyle.regular11w300.copyWith(color: ColorConstants.lightOrange),
                    ),
                    heightSpace(5),
                    Row(
                      children: [
                        Text(
                          widget.selectedValue,
                          style: CommonTextStyle.regular14w300,
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
        heightSpace(5),
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: -1.0,
          child: GlassmorphicBackgroundWidget(
            borderRadius: 10,
            padding: EdgeInsets.zero,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < widget.items.length; i++) ...[
                    InkWell(
                      onTap: () => _selectItem(widget.items[i]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.items[i],
                                style: CommonTextStyle.regular14w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (i < widget.items.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Image.asset(
                          "assets/images/border_line.png",
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
