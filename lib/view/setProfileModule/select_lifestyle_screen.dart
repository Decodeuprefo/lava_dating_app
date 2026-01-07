import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/profile_module_controller.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/select_lifestyle_screen_controller.dart';
import 'package:lava_dating_app/View/setProfileModule/select_education_screen.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glass_container_widget.dart';
import '../../Common/widgets/shimmers/lifestyle_screen_shimmer_widget.dart';

class LifestyleScreen extends StatefulWidget {
  const LifestyleScreen({super.key});

  @override
  State<LifestyleScreen> createState() => _LifestyleScreenState();
}

class _LifestyleScreenState extends State<LifestyleScreen> {
  late SelectLifestyleScreenController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<SelectLifestyleScreenController>()) {
      Get.put(SelectLifestyleScreenController());
    }
    controller = Get.find<SelectLifestyleScreenController>();
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<SelectLifestyleScreenController>()) {
        Get.delete<SelectLifestyleScreenController>();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileModuleController>();

    return GetBuilder<SelectLifestyleScreenController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: LifestyleScreenShimmerWidget(),
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
                            text: "What's your lifestyle compatibility?",
                            textType: TextType.head,
                          ),
                          const CommonTextWidget(
                            text: "Discover Your Perfect Daily Match.",
                            textType: TextType.des,
                          ),
                          heightSpace(30),
                          // Do you drink section
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/cheers_icon.png",
                                fit: BoxFit.fill,
                                height: 27,
                                width: 27,
                              ),
                              widthSpace(10),
                              const Text(
                                "Do you drink?",
                                style: CommonTextStyle.regular18w500,
                              ),
                            ],
                          ),
                          heightSpace(16),
                          Obx(
                            () => Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              children:
                                  List.generate(profileController.drinkingOptions.length, (index) {
                                final option = profileController.drinkingOptions[index];
                                final isSelected =
                                    profileController.selectedDrinking.contains(option);
                                return GlassContainerWidget(
                                  text: option,
                                  isSelected: isSelected,
                                  onTap: () {
                                    profileController.toggleDrinking(option);
                                    profileController.refreshScreen();
                                  },
                                );
                              }),
                            ),
                          ),
                          heightSpace(30),
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/smoking_icon.png",
                                fit: BoxFit.fill,
                                height: 27,
                                width: 27,
                              ),
                              widthSpace(10),
                              const Text(
                                "Do you smoke?",
                                style: CommonTextStyle.regular18w500,
                              ),
                            ],
                          ),
                          heightSpace(16),
                          Obx(
                            () => Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              children:
                                  List.generate(profileController.smokingOptions.length, (index) {
                                final option = profileController.smokingOptions[index];
                                final isSelected =
                                    profileController.selectedSmoking.contains(option);
                                return GlassContainerWidget(
                                  text: option,
                                  isSelected: isSelected,
                                  onTap: () {
                                    profileController.toggleSmoking(option);
                                    profileController.refreshScreen();
                                  },
                                );
                              }),
                            ),
                          ),
                          heightSpace(30),
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/dumbbell.png",
                                fit: BoxFit.fill,
                                height: 27,
                                width: 27,
                              ),
                              widthSpace(10),
                              const Text(
                                "Do you workout?",
                                style: CommonTextStyle.regular18w500,
                              ),
                            ],
                          ),
                          heightSpace(16),
                          Obx(
                            () => Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              children:
                                  List.generate(profileController.workoutOptions.length, (index) {
                                final option = profileController.workoutOptions[index];
                                final isSelected =
                                    profileController.selectedWorkout.contains(option);
                                return GlassContainerWidget(
                                  text: option,
                                  isSelected: isSelected,
                                  onTap: () {
                                    profileController.toggleWorkout(option);
                                    profileController.refreshScreen();
                                  },
                                );
                              }),
                            ),
                          ),
                          heightSpace(30),
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/veterinary.png",
                                fit: BoxFit.fill,
                                height: 27,
                                width: 27,
                              ),
                              widthSpace(10),
                              const Text(
                                "Do you have any pets?",
                                style: CommonTextStyle.regular18w500,
                              ),
                            ],
                          ),
                          heightSpace(16),
                          Obx(
                            () => Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              children:
                                  List.generate(profileController.petsOptions.length, (index) {
                                final option = profileController.petsOptions[index];
                                final isSelected = profileController.selectedPets.contains(option);
                                return GlassContainerWidget(
                                  text: option,
                                  isSelected: isSelected,
                                  onTap: () {
                                    profileController.togglePets(option);
                                    profileController.refreshScreen();
                                  },
                                );
                              }),
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
                              controller.updateLifestyle(context);
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
