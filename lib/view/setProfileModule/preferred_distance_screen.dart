import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glassmorphic_background_widget.dart';
import '../../Common/widgets/shimmers/preferred_distance_screen_shimmer_widget.dart';
import '../../Controller/setProfileControllers/preferred_distance_screen_controller.dart';
import '../../Controller/setProfileControllers/profile_module_controller.dart';

class PreferredDistanceScreen extends StatefulWidget {
  const PreferredDistanceScreen({super.key});

  @override
  State<PreferredDistanceScreen> createState() => _PreferredDistanceScreenState();
}

final controller = Get.put(ProfileModuleController());

class _PreferredDistanceScreenState extends State<PreferredDistanceScreen> {
  double _sliderValue = 100.0;
  final profileController = Get.find<ProfileModuleController>();


  late PreferredDistanceScreenController distanceController;

  @override
  void initState() {
    super.initState();
    _sliderValue = 100.0;
    profileController.preferredDistance.value = 100.0;
    if (!Get.isRegistered<PreferredDistanceScreenController>()) {
      Get.put(PreferredDistanceScreenController());
    }
    distanceController = Get.find<PreferredDistanceScreenController>();
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<PreferredDistanceScreenController>()) {
        Get.delete<PreferredDistanceScreenController>();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PreferredDistanceScreenController>(
      builder: (ctrl) {
        if (ctrl.isLoading) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: PreferredDistanceScreenShimmerWidget(),
              ),
            ),
          );
        }
        return Scaffold(
          body: BackgroundContainer(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                heightSpace(13),
                                // Hide back button if this is the root/first screen
                                Builder(
                                  builder: (context) {
                                    final route = ModalRoute.of(context);
                                    final isFirstRoute = route?.isFirst ?? false;
                                    final canPop = Navigator.of(context).canPop();
                                    
                                    // Show back button only if:
                                    // 1. This is NOT the first route in navigation stack
                                    // 2. AND Navigator can pop (has previous route)
                                    if (!isFirstRoute && canPop) {
                                      return InkWell(
                                        onTap: Get.back,
                                        child: SvgPicture.asset(
                                          "assets/icons/back_arrow.svg",
                                          height: 30,
                                          width: 30,
                                          fit: BoxFit.fill,
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                                heightSpace(90),
                                const CommonTextWidget(
                                  text: "How Far Should We Look for Matches?",
                                  textType: TextType.head,
                                ),
                                heightSpace(5),
                                const CommonTextWidget(
                                  text: "Choose how near or far you'd like your island to reach",
                                  textType: TextType.des,
                                ),
                                heightSpace(30),
                                // Map placeholder
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset("assets/images/map_image.png"),
                                ),
                                heightSpace(30),
                                Text(
                                  "Preferred Distance",
                                  style: CommonTextStyle.regular18w600.copyWith(
                                    color: ColorConstants.lightOrange,
                                  ),
                                ),
                                heightSpace(20),
                              ],
                            ).paddingSymmetric(horizontal: 20),
                            _buildCustomSlider(),
                            heightSpace(30),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: GlassmorphicBackgroundWidget(
                                borderRadius: 10,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                                child: Text(
                                  "You'll meet people within ${profileController.preferredDistance.value.round()} km, just around your island and nearby areas!",
                                  style: CommonTextStyle.regular14w400,
                                ),
                              ),
                            ),
                            heightSpace(40),
                          ],
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    child: Builder(
                      builder: (context) => AppButton(
                        text: "Continue",
                        textStyle: CommonTextStyle.regular16w500,
                        onPressed: () {
                          distanceController.updatePreferredDistance(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomSlider() {
    return Obx(() {
      // Get the current value from controller
      double controllerValue = profileController.preferredDistance.value.toDouble();

      // Use local state if controller value is invalid, otherwise use controller value
      double sliderValue;
      if (controllerValue == 0.0 || controllerValue < 5.0) {
        // If controller value is invalid, use local state (100.0) and update controller
        sliderValue = _sliderValue;
        profileController.preferredDistance.value = _sliderValue;
      } else {
        // Use controller value and sync local state
        sliderValue = controllerValue;
        _sliderValue = controllerValue;
      }

      // Clamp the value to valid range (5.0 to 500.0)
      final currentValue = sliderValue.clamp(5.0, 500.0);
      final displayValue = profileController.preferredDistance.value;
      // Calculate position for the badge (0.0 to 1.0, where 0.0 is left and 1.0 is right)
      final position = ((currentValue - 5) / (500 - 5)).clamp(0.0, 1.0);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 8,
                    thumbShape: const CustomSliderThumb(
                      enabledThumbRadius: 12,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 20,
                    ),
                    activeTrackColor: ColorConstants.lightOrange,
                    inactiveTrackColor: ColorConstants.lightOrange.withOpacity(0.3),
                    thumbColor: Colors.white,
                    overlayColor: ColorConstants.lightOrange.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: currentValue,
                    min: 5.0,
                    max: 500.0,
                    divisions: null,
                    onChanged: (value) {
                      // Update both local state and controller
                      _sliderValue = value;
                      profileController.setPreferredDistance(value);
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
                    value: "${displayValue.round()}",
                  ),
                ),
              ),
            ],
          ),
          heightSpace(10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "5 Km",
                style: CommonTextStyle.regular14w400,
              ),
              Text(
                "500 Km",
                style: CommonTextStyle.regular14w400,
              ),
            ],
          ).paddingSymmetric(horizontal: 20),
        ],
      );
    });
  }
}

class _BadgeWithTail extends StatelessWidget {
  final String value;

  const _BadgeWithTail({
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BadgePainter(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.only(top: 8), // Space for the triangle
        child: Text(
          value,
          style: CommonTextStyle.regular15w400.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _BadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorConstants.lightOrange
      ..style = PaintingStyle.fill;

    // Calculate badge dimensions
    const triangleHeight = 8.0;
    final badgeHeight = size.height - triangleHeight;
    final badgeWidth = size.width;
    const borderRadius = 10.0;
    const triangleWidth = 10.0;

    // Draw rounded rectangle (badge body)
    final badgeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, triangleHeight, badgeWidth, badgeHeight),
      const Radius.circular(borderRadius),
    );
    canvas.drawRRect(badgeRect, paint);

    // Draw upward-pointing triangle at top center
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


