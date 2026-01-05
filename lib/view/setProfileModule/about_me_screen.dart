import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/about_me_screen_controller.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/profile_module_controller.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/text_form_field_widget.dart';
import '../../Common/widgets/shimmers/about_me_screen_shimmer_widget.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({
    super.key,
  });

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  final profileModuleController = Get.find<ProfileModuleController>();
  late AboutMeScreenController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AboutMeScreenController>()) {
      try {
        Get.delete<AboutMeScreenController>();
      } catch (e) {}
    }
    controller = Get.put(AboutMeScreenController(), permanent: false);
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<AboutMeScreenController>()) {
        Get.delete<AboutMeScreenController>();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: GetBuilder<AboutMeScreenController>(
            builder: (ctrl) {
              if (ctrl.isLoading) {
                return const AboutMeScreenShimmerWidget();
              }
              return Column(
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
                            text: 'Add Your Attractive Bio about You',
                            textType: TextType.head,
                          ),
                          const CommonTextWidget(
                            text: 'Introduce Yourself Beyond the Basics.',
                            textType: TextType.des,
                          ),
                          heightSpace(50),
                          TextFormFieldWidget(
                            controller: profileModuleController.aboutMeController,
                            hint: "Wright something about you...",
                            maxLines: 8,
                            maxLength: 300,
                            counterWidget: const SizedBox.shrink(),
                            onChanged: (val) {
                              setState(() {});
                            },
                          ),
                          heightSpace(8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${profileModuleController.aboutMeController.text.length}/300',
                              style: CommonTextStyle.regular12w400.copyWith(
                                color: ColorConstants.greyLight,
                              ),
                            ),
                          ),
                        ],
                      ).marginSymmetric(horizontal: 20),
                    ),
                  ),
                  AppButton(
                    text: "Continue",
                    textStyle: CommonTextStyle.regular16w500,
                    onPressed: ctrl.isLoading
                        ? null
                        : () {
                            final bio = profileModuleController.aboutMeController.text.trim();
                            if (bio.isEmpty) {
                              showSnackBar(context, 'Please enter your bio to continue',
                                  isErrorMessageDisplay: true);
                              return;
                            }
                            controller.updateBio(context, bio);
                          },
                  ).marginSymmetric(horizontal: 20, vertical: 20)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
