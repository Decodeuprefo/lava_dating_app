import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glass_container_widget.dart';
import '../../Common/widgets/shimmers/race_flags_screen_shimmer_widget.dart';
import '../../Controller/setProfileControllers/race_flags_screen_controller.dart';
import '../../Controller/setProfileControllers/profile_module_controller.dart';

class RaceFlagsScreen extends StatefulWidget {
  const RaceFlagsScreen({super.key});

  @override
  State<RaceFlagsScreen> createState() => _RaceFlagsScreenState();
}

class _RaceFlagsScreenState extends State<RaceFlagsScreen> {
  late RaceFlagsScreenController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<RaceFlagsScreenController>()) {
      Get.put(RaceFlagsScreenController());
    }
    controller = Get.find<RaceFlagsScreenController>();
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<RaceFlagsScreenController>()) {
        Get.delete<RaceFlagsScreenController>();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileModuleController>();

    return GetBuilder<RaceFlagsScreenController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: RaceFlagsScreenShimmerWidget(),
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
                            text: "What's your ethnicity?",
                            textType: TextType.head,
                          ),
                          const CommonTextWidget(
                            text: "Rep your roots! Choose up to two",
                            textType: TextType.des,
                          ),
                          heightSpace(50),
                          Obx(
                            () => Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              children:
                                  List.generate(profileController.ethnicities.length, (index) {
                                final ethnicity = profileController.ethnicities[index];
                                final isSelected =
                                    profileController.selectedEthnicity.contains(ethnicity);
                                return GlassContainerWidget(
                                  text: ethnicity,
                                  isSelected: isSelected,
                                  onTap: () {
                                    profileController.toggleEthnicity(ethnicity);
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
                    child: Builder(
                      builder: (context) => AppButton(
                        text: "Continue",
                        textStyle: CommonTextStyle.regular16w500,
                        onPressed: () {
                          controller.updateEthnicity(context);
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
