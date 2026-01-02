import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/profile_module_controller.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/interests_and_hobbies_controller.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glass_container_widget.dart';
import '../../Common/widgets/shimmers/interests_and_hobbies_screen_shimmer_widget.dart';
import 'about_me_screen.dart';

enum ChipSize { normal, compact }

class InterestsAndHobbies extends StatefulWidget {
  const InterestsAndHobbies({super.key});

  @override
  State<InterestsAndHobbies> createState() => _InterestsAndHobbiesState();
}

class _InterestsAndHobbiesState extends State<InterestsAndHobbies> {
  late InterestsAndHobbiesController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<InterestsAndHobbiesController>()) {
      Get.put(InterestsAndHobbiesController());
    }
    controller = Get.find<InterestsAndHobbiesController>();
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<InterestsAndHobbiesController>()) {
        Get.delete<InterestsAndHobbiesController>();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileModuleController>();

    return GetBuilder<InterestsAndHobbiesController>(
      builder: (ctrl) {
        if (ctrl.isLoading) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: InterestsAndHobbiesScreenShimmerWidget(),
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
                            text: 'What are Your Interests & Hobbies?',
                            textType: TextType.head,
                          ),
                          const CommonTextWidget(
                            text:
                                'Choose a few items you like. This helps us find better matches and provides other people a place to start a discussion.',
                            textType: TextType.des,
                          ),
                          heightSpace(28),
                          Obx(
                            () => Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              children: List.generate(profileController.interests.length, (index) {
                                final interest = profileController.interests[index];
                                final isSelected =
                                    profileController.selectedInterests.contains(interest);
                                return GlassContainerWidget(
                                  text: interest,
                                  imagePath: profileController.iconPaths[index],
                                  isSelected: isSelected,
                                  onTap: () {
                                    profileController.toggleInterest(interest);
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
                      onPressed: ctrl.isLoading
                          ? null
                          : () {
                              ctrl.updateInterests(context);
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
