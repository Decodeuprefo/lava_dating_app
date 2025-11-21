import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/View/profileModule/race_flags_screen.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Controller/profile_module_controller.dart';

class PreferredDistanceScreen extends StatefulWidget {
  const PreferredDistanceScreen({super.key});

  @override
  State<PreferredDistanceScreen> createState() => _PreferredDistanceScreenState();
}

final controller = Get.put(ProfileModuleController());

class _PreferredDistanceScreenState extends State<PreferredDistanceScreen> {
  @override
  void initState() {
    super.initState();
    controller.preferredDistance.value = 22.0;
  }

  @override
  Widget build(BuildContext context) {
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
                            InkWell(
                              onTap: Get.back,
                              child: SvgPicture.asset(
                                "assets/icons/back_arrow.svg",
                                height: 30,
                                width: 30,
                                fit: BoxFit.fill,
                              ),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0x752A1F3A),
                                  border: Border.all(
                                    color: const Color(0x66A898B8),
                                    width: 1.0,
                                  ),
                                ),
                                child: Text(
                                  "You'll meet people within ${controller.preferredDistance.value.round()} km, just around your island and nearby areas!",
                                  style: CommonTextStyle.regular14w400,
                                ),
                              ),
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
                    textStyle: CommonTextStyle.regular18w500,
                    onPressed: () {
                      Get.to(() => const RaceFlagsScreen());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomSlider() {
    return Obx(() {
      final rawValue = controller.preferredDistance.value.toDouble();
      final currentValue = rawValue.clamp(5.0, 500.0);
      final displayValue = controller.preferredDistance.value;
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
                    thumbShape: const _CustomSliderThumb(
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
                      controller.setPreferredDistance(value);
                    },
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: -40,
                child: Align(
                  alignment: Alignment(
                    (position * 2 - 1).clamp(-1.0, 1.0),
                    0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                    decoration: BoxDecoration(
                      color: ColorConstants.lightOrange,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "${displayValue.round()}",
                      style: CommonTextStyle.regular15w400.copyWith(
                        color: Colors.white,
                      ),
                    ),
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

class _CustomSliderThumb extends SliderComponentShape {
  final double enabledThumbRadius;

  const _CustomSliderThumb({
    this.enabledThumbRadius = 12.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Paint thumbPaint = Paint()
      ..color = ColorConstants.lightOrange
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = ColorConstants.neutralStrongDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawCircle(center, enabledThumbRadius, thumbPaint);
    canvas.drawCircle(center, enabledThumbRadius, borderPaint);
  }
}
