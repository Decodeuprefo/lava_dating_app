import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/View/profileModule/preferred_gender_screen.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/age_range_picker_widget.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/height_picker_widget.dart';
import '../../Controller/profile_module_controller.dart';

class SelectHeightScreen extends StatefulWidget {
  const SelectHeightScreen({super.key});

  @override
  State<SelectHeightScreen> createState() => _SelectHeightScreenState();
}

final controller = Get.put(ProfileModuleController());

class _SelectHeightScreenState extends State<SelectHeightScreen> {
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
                  child: Column(
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
                        text: "How tall are you?",
                        textType: TextType.head,
                      ),
                      heightSpace(100),
                      Obx(
                        () => HeightPickerWidget(
                          key: ValueKey('height_picker_${controller.feetORCm.value}'),
                          minHeight: controller.minHeight.value,
                          maxHeight: controller.maxHeight.value,
                          isFtCm: controller.feetORCm,
                          onMinHeightChanged: (hig) {
                            controller.minHeight.value = hig;
                          },
                          onMaxHeightChanged: (hig) {
                            controller.maxHeight.value = hig;
                          },
                        ),
                      ),
                      heightSpace(30),
                      // Height Unit Selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Height unit",
                            style: CommonTextStyle.regular14w400.copyWith(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          Obx(
                            () => _buildGlassSegmentedControl(
                              selectedValue: controller.heightUnit.value,
                              onValueChanged: (value) => controller.heightUnit.value = value,
                            ),
                          ),
                        ],
                      ),
                      heightSpace(40),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Builder(
                  builder: (context) => AppButton(
                    text: "Continue",
                    textStyle: CommonTextStyle.regular18w500,
                    onPressed: () {
                      // Navigate to next screen - you can update this
                      Get.to(() => const PreferredGenderScreen());
                    },
                  ),
                ),
              ),
            ],
          ).marginSymmetric(horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildGlassSegmentedControl({
    required String selectedValue,
    required Function(String) onValueChanged,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0x752A1F3A),
            border: Border.all(
              color: const Color(0x66A898B8),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGlassSegment(
                label: "ft/in",
                isSelected: selectedValue == "ft/in",
                onTap: () {
                  onValueChanged("ft/in");
                  controller.feetORCm.value = true;
                },
                isLeft: controller.feetORCm,
              ),
              _buildGlassSegment(
                label: "cm",
                isSelected: selectedValue == "cm",
                onTap: () {
                  // Set default height to 160 cm first, then change mode
                  // This ensures the widget gets the correct value when it rebuilds
                  controller.minHeight.value = 160;
                  onValueChanged("cm");
                  controller.feetORCm.value = false;
                },
                isLeft: controller.feetORCm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassSegment({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required RxBool isLeft,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: isLeft.value ? const Radius.circular(10) : Radius.zero,
            bottomLeft: isLeft.value ? const Radius.circular(10) : Radius.zero,
            topRight: !isLeft.value ? const Radius.circular(10) : Radius.zero,
            bottomRight: !isLeft.value ? const Radius.circular(10) : Radius.zero,
          ),
          color: isSelected ? ColorConstants.lightOrange : Colors.transparent,
        ),
        child: Text(
          label,
          style: CommonTextStyle.regular12w400.copyWith(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
