import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/select_height_screen_controller.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/age_range_picker_widget.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glassmorphic_background_widget.dart';
import '../../Common/widgets/height_picker_widget.dart';
import '../../Common/widgets/shimmers/select_height_screen_shimmer_widget.dart';
import '../../Controller/setProfileControllers/profile_module_controller.dart';

class SelectHeightScreen extends StatefulWidget {
  const SelectHeightScreen({super.key});

  @override
  State<SelectHeightScreen> createState() => _SelectHeightScreenState();
}

class _SelectHeightScreenState extends State<SelectHeightScreen> {
  final profileController = Get.find<ProfileModuleController>();
  late SelectHeightScreenController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<SelectHeightScreenController>()) {
      Get.put(SelectHeightScreenController());
    }
    controller = Get.find<SelectHeightScreenController>();
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<SelectHeightScreenController>()) {
        Get.delete<SelectHeightScreenController>();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectHeightScreenController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: SelectHeightScreenShimmerWidget(),
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
                      child: Column(
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
                            text: "How tall are you?",
                            textType: TextType.head,
                          ),
                          heightSpace(100),
                          Obx(
                            () => HeightPickerWidget(
                              key:
                                  ValueKey('height_picker_${profileController.feetORCm.value}'),
                              minHeight: profileController.minHeight.value,
                              maxHeight: profileController.maxHeight.value,
                              isFtCm: profileController.feetORCm,
                              onMinHeightChanged: (hig) {
                                profileController.minHeight.value = hig;
                              },
                              onMaxHeightChanged: (hig) {
                                profileController.maxHeight.value = hig;
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
                                  selectedValue: profileController.heightUnit.value,
                                  onValueChanged: (value) =>
                                      profileController.heightUnit.value = value,
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
                        textStyle: CommonTextStyle.regular16w500,
                        onPressed: () {
                          controller.updateHeight(context);
                        },
                      ),
                    ),
                  ),
                ],
              ).marginSymmetric(horizontal: 20),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassSegmentedControl({
    required String selectedValue,
    required Function(String) onValueChanged,
  }) {
    return GlassmorphicBackgroundWidget(
      borderRadius: 10,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildGlassSegment(
            label: "ft/in",
            isSelected: selectedValue == "ft/in",
            onTap: () {
              onValueChanged("ft/in");
              profileController.feetORCm.value = true;
              // Set default values when switching to ft/in
              if (profileController.minHeight.value < 4 || profileController.minHeight.value > 7) {
                profileController.minHeight.value = 5;
              }
              if (profileController.maxHeight.value < 0 || profileController.maxHeight.value > 11) {
                profileController.maxHeight.value = 0;
              }
            },
            isLeft: profileController.feetORCm,
          ),
          _buildGlassSegment(
            label: "cm",
            isSelected: selectedValue == "cm",
            onTap: () {
              profileController.minHeight.value = 160;
              onValueChanged("cm");
              profileController.feetORCm.value = false;
            },
            isLeft: profileController.feetORCm,
          ),
        ],
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
