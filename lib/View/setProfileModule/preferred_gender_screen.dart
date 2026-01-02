import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glass_container_widget.dart';
import '../../Common/widgets/shimmers/preferred_gender_screen_shimmer_widget.dart';
import '../../Controller/setProfileControllers/preferred_gender_screen_controller.dart';
import '../../Controller/setProfileControllers/profile_module_controller.dart';

class PreferredGenderScreen extends StatefulWidget {
  const PreferredGenderScreen({super.key});

  @override
  State<PreferredGenderScreen> createState() => _PreferredGenderScreenState();
}

class _PreferredGenderScreenState extends State<PreferredGenderScreen> {
  final profileController = Get.find<ProfileModuleController>();
  late PreferredGenderScreenController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<PreferredGenderScreenController>()) {
      Get.put(PreferredGenderScreenController());
    }
    controller = Get.find<PreferredGenderScreenController>();
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<PreferredGenderScreenController>()) {
        Get.delete<PreferredGenderScreenController>();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PreferredGenderScreenController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: PreferredGenderScreenShimmerWidget(),
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
                            text: "I'm looking to meet Women or Men",
                            textType: TextType.head,
                          ),
                          heightSpace(5),
                          const CommonTextWidget(
                            text:
                                "Select the gender you'd like to connect with, This helps us personalize your matches better.",
                            textType: TextType.des,
                          ),
                          heightSpace(30),
                          Obx(
                            () => Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                GlassContainerWidget(
                                  text: "Male",
                                  isSelected: profileController.preferredGender.value == "Male",
                                  imagePath: 'assets/icons/male_gen.png',
                                  onTap: () {
                                    profileController.setPreferredGender("Male");
                                  },
                                  borderRadius: 10,
                                ),
                                GlassContainerWidget(
                                  text: "Female",
                                  isSelected: profileController.preferredGender.value == "Female",
                                  imagePath: 'assets/icons/female_gen.png',
                                  onTap: () {
                                    profileController.setPreferredGender("Female");
                                  },
                                  borderRadius: 10,
                                ),
                                GlassContainerWidget(
                                  text: "Other",
                                  isSelected: profileController.preferredGender.value == "Other",
                                  onTap: () {
                                    profileController.setPreferredGender("Other");
                                  },
                                  borderRadius: 10,
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                    child: Builder(
                      builder: (context) => AppButton(
                        text: "Continue",
                        textStyle: CommonTextStyle.regular16w500,
                        onPressed: () {
                          controller.updatePreferredGender(context);
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
}
