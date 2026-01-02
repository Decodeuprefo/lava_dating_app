import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glass_container_widget.dart';
import '../../Common/widgets/shimmers/kids_screen_shimmer_widget.dart';
import '../../Controller/setProfileControllers/kids_screen_controller.dart';
import '../../Controller/setProfileControllers/profile_module_controller.dart';

class KidsScreen extends StatefulWidget {
  const KidsScreen({super.key});

  @override
  State<KidsScreen> createState() => _KidsScreenState();
}

class _KidsScreenState extends State<KidsScreen> {
  final profileController = Get.find<ProfileModuleController>();
  late KidsScreenController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<KidsScreenController>()) {
      Get.put(KidsScreenController());
    }
    controller = Get.find<KidsScreenController>();
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<KidsScreenController>()) {
        Get.delete<KidsScreenController>();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KidsScreenController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: KidsScreenShimmerWidget(),
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
                            text: "Do you have children?",
                            textType: TextType.head,
                          ),
                          heightSpace(5),
                          const CommonTextWidget(
                            text:
                                "Sharing this helps us connect you with people who understand your lifestyle.",
                            textType: TextType.des,
                          ),
                          heightSpace(30),
                          Obx(
                            () => Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                GlassContainerWidget(
                                  text: "Yes",
                                  isSelected: profileController.hasChildren.value == "Yes",
                                  onTap: () {
                                    profileController.setHasChildren("Yes");
                                  },
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                ),
                                GlassContainerWidget(
                                  text: "No",
                                  isSelected: profileController.hasChildren.value == "No",
                                  onTap: () {
                                    profileController.setHasChildren("No");
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
                        textStyle: CommonTextStyle.regular16w500,
                        onPressed: () {
                          controller.updateKidsStatus(context);
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
