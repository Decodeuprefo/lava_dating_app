import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glass_container_widget.dart';
import '../../Common/widgets/shimmers/select_marital_status_screen_shimmer_widget.dart';
import '../../Controller/setProfileControllers/profile_module_controller.dart';
import '../../Controller/setProfileControllers/select_marital_status_screen_controller.dart';

class SelectMaritalStatus extends StatefulWidget {
  const SelectMaritalStatus({super.key});

  @override
  State<SelectMaritalStatus> createState() => _SelectMaritalStatusState();
}

class _SelectMaritalStatusState extends State<SelectMaritalStatus> {
  late SelectMaritalStatusScreenController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<SelectMaritalStatusScreenController>()) {
      Get.put(SelectMaritalStatusScreenController());
    }
    controller = Get.find<SelectMaritalStatusScreenController>();
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<SelectMaritalStatusScreenController>()) {
        Get.delete<SelectMaritalStatusScreenController>();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileModuleController>();

    return GetBuilder<SelectMaritalStatusScreenController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: SelectMaritalStatusScreenShimmerWidget(),
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
                            text: "What's your relationship status?",
                            textType: TextType.head,
                          ),
                          heightSpace(5),
                          const CommonTextWidget(
                            text:
                                "Let us know your current status so we can match you with people who share your path.",
                            textType: TextType.des,
                          ),
                          heightSpace(30),
                          Obx(
                            () => Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                GlassContainerWidget(
                                  text: "Single",
                                  isSelected: profileController.maritalStatus.value == "Single",
                                  onTap: () {
                                    profileController.setMaritalStatus("Single");
                                  },
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                ),
                                GlassContainerWidget(
                                  text: "Married",
                                  isSelected: profileController.maritalStatus.value == "Married",
                                  onTap: () {
                                    profileController.setMaritalStatus("Married");
                                  },
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                ),
                                GlassContainerWidget(
                                  text: "Separated",
                                  isSelected: profileController.maritalStatus.value == "Separated",
                                  onTap: () {
                                    profileController.setMaritalStatus("Separated");
                                  },
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                ),
                                GlassContainerWidget(
                                  text: "Divorced",
                                  isSelected: profileController.maritalStatus.value == "Divorced",
                                  onTap: () {
                                    profileController.setMaritalStatus("Divorced");
                                  },
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                ),
                                GlassContainerWidget(
                                  text: "Widowed",
                                  isSelected: profileController.maritalStatus.value == "Widowed",
                                  onTap: () {
                                    profileController.setMaritalStatus("Widowed");
                                  },
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                ),
                                GlassContainerWidget(
                                  text: "Never married",
                                  isSelected:
                                      profileController.maritalStatus.value == "Never married",
                                  onTap: () {
                                    profileController.setMaritalStatus("Never married");
                                  },
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                ),
                              ],
                            ),
                          ),
                          heightSpace(40),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: AppButton(
                      text: "Continue",
                      textStyle: CommonTextStyle.regular16w500,
                      onPressed: controller.isLoading
                          ? null
                          : () {
                              controller.updateMaritalStatus(context);
                            },
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
}
