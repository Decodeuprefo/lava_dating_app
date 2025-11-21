import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/profile_module_controller.dart';
import 'package:lava_dating_app/View/profileModule/select_education_screen.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glass_container_widget.dart';

class LifestyleScreen extends StatelessWidget {
  const LifestyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileModuleController());
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
                          children: List.generate(controller.drinkingOptions.length, (index) {
                            final option = controller.drinkingOptions[index];
                            final isSelected = controller.selectedDrinking.contains(option);
                            return GlassContainerWidget(
                              text: option,
                              isSelected: isSelected,
                              onTap: () {
                                controller.toggleDrinking(option);
                                controller.refreshScreen();
                              },
                            );
                          }),
                        ),
                      ),
                      heightSpace(30),
                      // Do you smoke section
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
                          children: List.generate(controller.smokingOptions.length, (index) {
                            final option = controller.smokingOptions[index];
                            final isSelected = controller.selectedSmoking.contains(option);
                            return GlassContainerWidget(
                              text: option,
                              isSelected: isSelected,
                              onTap: () {
                                controller.toggleSmoking(option);
                                controller.refreshScreen();
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
                child: Builder(
                  builder: (context) => AppButton(
                    text: "Continue",
                    textStyle: CommonTextStyle.regular18w500,
                    onPressed: () {
                      if (controller.selectedDrinking.isEmpty &&
                          controller.selectedSmoking.isEmpty) {
                        showSnackBar(context, "Please Select any items");
                      } else {
                        Get.to(() => const SelectEducationScreen());
                      }
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
}
