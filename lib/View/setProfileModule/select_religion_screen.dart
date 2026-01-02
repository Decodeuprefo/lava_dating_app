import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/profile_module_controller.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/select_religion_screen_controller.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glass_container_widget.dart';
import '../../Common/widgets/shimmers/religion_screen_shimmer_widget.dart';
import 'select_lifestyle_screen.dart';

class ReligionScreen extends StatefulWidget {
  const ReligionScreen({super.key});

  @override
  State<ReligionScreen> createState() => _ReligionScreenState();
}

class _ReligionScreenState extends State<ReligionScreen> {
  late SelectReligionScreenController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<SelectReligionScreenController>()) {
      Get.put(SelectReligionScreenController());
    }
    controller = Get.find<SelectReligionScreenController>();
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<SelectReligionScreenController>()) {
        Get.delete<SelectReligionScreenController>();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileModuleController>();

    return GetBuilder<SelectReligionScreenController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: ReligionScreenShimmerWidget(),
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
                            text: "What's your religion or spiritual view?",
                            textType: TextType.head,
                          ),
                          const CommonTextWidget(
                            text:
                                "Sharing this helps us connect you with people who respect your values.",
                            textType: TextType.des,
                          ),
                          heightSpace(30),
                          Obx(
                            () => Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              children: List.generate(profileController.religions.length, (index) {
                                final religion = profileController.religions[index];
                                final isSelected =
                                    profileController.selectedReligion.contains(religion);
                                return GlassContainerWidget(
                                  text: religion,
                                  isSelected: isSelected,
                                  onTap: () {
                                    profileController.toggleReligion(religion);
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
                              controller.updateReligion(context);
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
