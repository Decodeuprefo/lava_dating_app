import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glass_container_widget.dart';
import '../../Controller/profile_module_controller.dart';
import 'kids_screen.dart';

class SelectMaritalStatus extends StatefulWidget {
  const SelectMaritalStatus({super.key});

  @override
  State<SelectMaritalStatus> createState() => _SelectMaritalStatusState();
}

final controller = Get.put(ProfileModuleController());

class _SelectMaritalStatusState extends State<SelectMaritalStatus> {
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
                              isSelected: controller.maritalStatus.value == "Single",
                              onTap: () {
                                controller.setMaritalStatus("Single");
                              },
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            ),
                            GlassContainerWidget(
                              text: "Married",
                              isSelected: controller.maritalStatus.value == "Married",
                              onTap: () {
                                controller.setMaritalStatus("Married");
                              },
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            ),
                            GlassContainerWidget(
                              text: "Separated",
                              isSelected: controller.maritalStatus.value == "Separated",
                              onTap: () {
                                controller.setMaritalStatus("Separated");
                              },
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            ),
                            GlassContainerWidget(
                              text: "Divorced",
                              isSelected: controller.maritalStatus.value == "Divorced",
                              onTap: () {
                                controller.setMaritalStatus("Divorced");
                              },
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            ),
                            GlassContainerWidget(
                              text: "Widowed",
                              isSelected: controller.maritalStatus.value == "Widowed",
                              onTap: () {
                                controller.setMaritalStatus("Widowed");
                              },
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            ),
                            GlassContainerWidget(
                              text: "Never married",
                              isSelected: controller.maritalStatus.value == "Never married",
                              onTap: () {
                                controller.setMaritalStatus("Never married");
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
                child: Builder(
                  builder: (context) => AppButton(
                    text: "Continue",
                    textStyle: CommonTextStyle.regular18w500,
                    onPressed: () {
                      if (controller.maritalStatus.value.isEmpty) {
                        showSnackBar(context, "Please select your relationship status");
                      } else {
                        Get.to(() => const KidsScreen());
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
