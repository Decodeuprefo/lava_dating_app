import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/profile_module_controller.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/select_languages_spoken_controller.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glassmorphic_background_widget.dart';
import '../../Common/widgets/shimmers/select_languages_spoken_screen_shimmer_widget.dart';

class SelectLanguagesSpoken extends StatefulWidget {
  const SelectLanguagesSpoken({super.key});

  @override
  State<SelectLanguagesSpoken> createState() => _SelectLanguagesSpokenState();
}

class _SelectLanguagesSpokenState extends State<SelectLanguagesSpoken> {
  late SelectLanguagesSpokenController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<SelectLanguagesSpokenController>()) {
      Get.put(SelectLanguagesSpokenController());
    }
    controller = Get.find<SelectLanguagesSpokenController>();
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<SelectLanguagesSpokenController>()) {
        Get.delete<SelectLanguagesSpokenController>();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileModuleController>();

    return GetBuilder<SelectLanguagesSpokenController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: SelectLanguagesSpokenScreenShimmerWidget(),
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
                            text: "Which languages do you speak?",
                            textType: TextType.head,
                          ),
                          heightSpace(20),
                          const CommonTextWidget(
                            text: "Choose the languages you love to speak.",
                            textType: TextType.des,
                          ),
                          heightSpace(55),
                          Obx(
                            () => Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              children:
                                  List.generate(profileController.languageOptions.length, (index) {
                                final language = profileController.languageOptions[index];
                                final isSelected =
                                    profileController.selectedLanguages.contains(language);
                                return GestureDetector(
                                  onTap: () {
                                    profileController.toggleLanguage(language);
                                    profileController.refreshScreen();
                                  },
                                  child: GlassmorphicBackgroundWidget(
                                    borderRadius: 10,
                                    border: isSelected ? 2.0 : 0.8,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                    borderGradient: isSelected
                                        ? const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              ColorConstants.lightOrange,
                                              ColorConstants.lightOrange,
                                              ColorConstants.lightOrange,
                                              ColorConstants.lightOrange,
                                              ColorConstants.lightOrange,
                                              ColorConstants.lightOrange,
                                              ColorConstants.lightOrange,
                                            ],
                                            stops: [0.0, 0.5, 1.0, 0.55, 0.70, 0.85, 1.00],
                                          )
                                        : null,
                                    child: Text(
                                      language,
                                      style: CommonTextStyle.regular14w400,
                                    ),
                                  ),
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
                          controller.updateLanguages(context);
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
