import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/profile_module_controller.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/preferred_age_range_screen_controller.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/age_range_picker_widget.dart';
import '../../Common/widgets/shimmers/preferred_age_range_screen_shimmer_widget.dart';

class PreferredAgeRangeScreen extends StatefulWidget {
  const PreferredAgeRangeScreen({super.key});

  @override
  State<PreferredAgeRangeScreen> createState() => _PreferredAgeRangeScreenState();
}

class _PreferredAgeRangeScreenState extends State<PreferredAgeRangeScreen> {
  late PreferredAgeRangeScreenController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<PreferredAgeRangeScreenController>()) {
      Get.put(PreferredAgeRangeScreenController());
    }
    controller = Get.find<PreferredAgeRangeScreenController>();
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<PreferredAgeRangeScreenController>()) {
        Get.delete<PreferredAgeRangeScreenController>();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileModuleController>();

    return GetBuilder<PreferredAgeRangeScreenController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: PreferredAgeRangeScreenShimmerWidget(),
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
                            text: "What's Your Preferred Age Range?",
                            textType: TextType.head,
                          ),
                          heightSpace(05),
                          const CommonTextWidget(
                            text:
                                "Tell us your ideal age range for connections, So we can filter matches that suit you better.",
                            textType: TextType.des,
                          ),
                          heightSpace(15),
                          Obx(
                            () => AgeRangePickerWidget(
                              minAge: profileController.minAge.value,
                              maxAge: profileController.maxAge.value,
                              onMinAgeChanged: (age) {
                                if (age <= profileController.maxAge.value) {
                                  profileController.minAge.value = age;
                                }
                              },
                              onMaxAgeChanged: (age) {
                                if (age >= profileController.minAge.value) {
                                  profileController.maxAge.value = age;
                                }
                              },
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
                          controller.updatePreferredAgeRange(context);
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
