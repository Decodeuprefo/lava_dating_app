import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/View/profileModule/select_marital_status.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glass_container_widget.dart';
import '../../Controller/profile_module_controller.dart';

class PreferredGenderScreen extends StatefulWidget {
  const PreferredGenderScreen({super.key});

  @override
  State<PreferredGenderScreen> createState() => _PreferredGenderScreenState();
}

final controller = Get.put(ProfileModuleController());

class _PreferredGenderScreenState extends State<PreferredGenderScreen> {
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
                        text: "I'm looking to meet\nWomen or Men",
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
                              isSelected: controller.preferredGender.value == "Male",
                              imagePath: 'assets/icons/male_gen.png',
                              onTap: () {
                                controller.setPreferredGender("Male");
                              },
                              borderRadius: 14,
                            ),
                            GlassContainerWidget(
                              text: "Female",
                              isSelected: controller.preferredGender.value == "Female",
                              imagePath: 'assets/icons/female_gen.png',
                              onTap: () {
                                controller.setPreferredGender("Female");
                              },
                              borderRadius: 14,
                            ),
                            GlassContainerWidget(
                              text: "Other",
                              isSelected: controller.preferredGender.value == "Other",
                              onTap: () {
                                controller.setPreferredGender("Other");
                              },
                              borderRadius: 14,
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
                    textStyle: CommonTextStyle.regular18w500,
                    onPressed: () {
                      if (controller.preferredGender.value.isEmpty) {
                        showSnackBar(context, "Please select a gender preference");
                      } else {
                        // Navigate to next screen
                        Get.to(() => const SelectMaritalStatus());
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
