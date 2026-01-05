import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glassmorphic_background_widget.dart';
import '../../Common/widgets/shimmers/select_gender_screen_shimmer_widget.dart';
import '../../Controller/setProfileControllers/select_gender_screen_controller.dart';

class SelectGenderScreen extends StatefulWidget {
  const SelectGenderScreen({super.key});

  @override
  State<SelectGenderScreen> createState() => _SelectGenderScreenState();
}

enum GenderOption { none, male, female, other }

class _SelectGenderScreenState extends State<SelectGenderScreen> {
  late SelectGenderScreenController controller;
  GenderOption selected = GenderOption.none;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<SelectGenderScreenController>()) {
      try {
        Get.delete<SelectGenderScreenController>();
      } catch (e) {}
    }
    controller = Get.put(SelectGenderScreenController(), permanent: false);
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<SelectGenderScreenController>()) {
        Get.delete<SelectGenderScreenController>();
      }
    } catch (e) {}
    super.dispose();
  }

  void _onSelect(GenderOption option) {
    setState(() {
      selected = option;
    });
  }

  String _getGenderString(GenderOption option) {
    switch (option) {
      case GenderOption.male:
        return 'MALE';
      case GenderOption.female:
        return 'FEMALE';
      case GenderOption.other:
        return 'OTHER';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    const double tileRadius = 10.0;
    return Scaffold(
      body: BackgroundContainer(child: SafeArea(
        child: GetBuilder<SelectGenderScreenController>(
          builder: (ctrl) {
            if (ctrl.isLoading) {
              return const SelectGenderScreenShimmerWidget();
            }
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightSpace(130),
                      const Text(
                        "What's Your Gender?",
                        style: CommonTextStyle.semiBold30w600,
                      ),
                      const Text(
                        "Choose the gender that best represents you. You can update this later in settings.",
                        style: CommonTextStyle.regular14w400,
                      ),
                      heightSpace(50),
                      GenderTile(
                        label: "I'm a man",
                        isSelected: selected == GenderOption.male,
                        borderRadius: tileRadius,
                        onTap: () => _onSelect(GenderOption.male),
                      ),
                      heightSpace(10),
                      GenderTile(
                        label: "I'm a woman",
                        isSelected: selected == GenderOption.female,
                        borderRadius: tileRadius,
                        onTap: () => _onSelect(GenderOption.female),
                      ),
                      heightSpace(10),
                      GenderTile(
                        label: 'Other',
                        isSelected: selected == GenderOption.other,
                        borderRadius: tileRadius,
                        onTap: () => _onSelect(GenderOption.other),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ).marginSymmetric(horizontal: 20),
                ),
                AppButton(
                  text: "Continue",
                  textStyle: CommonTextStyle.regular16w500,
                  onPressed: ctrl.isLoading
                      ? null
                      : () {
                          setState(() {});
                          if (selected == GenderOption.none) {
                            showSnackBar(context, 'Please select your gender to continue',
                                isErrorMessageDisplay: true);
                            return;
                          }
                          controller.updateGender(context, _getGenderString(selected));
                        },
                ).marginSymmetric(horizontal: 20, vertical: 20),
              ],
            );
          },
        ),
      )),
    );
  }
}

class GenderTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final double borderRadius;
  final VoidCallback onTap;

  const GenderTile({
    super.key,
    required this.label,
    required this.isSelected,
    this.borderRadius = 10.0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // subtle scale when selected
    final double scale = isSelected ? 1.02 : 1.0;

    final LinearGradient borderGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isSelected
          ? [
              ColorConstants.lightOrange,
              ColorConstants.lightOrange,
              ColorConstants.lightOrange,
              ColorConstants.lightOrange,
              ColorConstants.lightOrange,
              ColorConstants.lightOrange,
              ColorConstants.lightOrange,
            ]
          : [
              const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
              const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
              const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
              const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
              const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
              const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
              const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
            ],
      stops: const [0.0, 0.5, 1.0, 0.55, 0.70, 0.85, 1.00],
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Stack(
          children: [
            GlassmorphicBackgroundWidget(
              borderRadius: borderRadius,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              blur: 8.0,
              border: isSelected ? 2.0 : 0.8,
              borderGradient: borderGradient,
              linearGradient: isSelected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ColorConstants.lightOrange,
                        ColorConstants.lightOrange,
                      ],
                    )
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(255, 255, 255, 0.10),
                        Color.fromRGBO(255, 255, 255, 0.10),
                      ],
                      stops: [0.5, 0.5],
                    ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: CommonTextStyle.regular14w400.copyWith(
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Subtle top-left shine for depth
            Positioned.fill(
              child: IgnorePointer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.04),
                          Colors.transparent,
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.25, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
