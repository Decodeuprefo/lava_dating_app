import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/profile_module_controller.dart';
import 'package:lava_dating_app/View/profileModule/select_religion_screen.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glass_container_widget.dart';
import 'about_me_screen.dart';

enum ChipSize { normal, compact }

class InterestsAndHobbies extends StatelessWidget {
  const InterestsAndHobbies({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileModuleController());
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
                          children: List.generate(controller.interests.length, (index) {
                            final interest = controller.interests[index];
                            final isSelected = controller.selectedInterests.contains(interest);
                            return GlassContainerWidget(
                              text: interest,
                              imagePath: controller.iconPaths[index],
                              isSelected: isSelected,
                              onTap: () {
                                controller.toggleInterest(interest);
                                controller.refreshScreen();
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
                      if (controller.selectedInterests.isEmpty) {
                        showSnackBar(context, "Please Select any items");
                      } else {
                        Get.to(() => const ReligionScreen());
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
