import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/profile_module_controller.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glass_container_widget.dart';
import 'select_lifestyle_screen.dart';

class ReligionScreen extends StatelessWidget {
  const ReligionScreen({super.key});

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
                          children: List.generate(controller.religions.length, (index) {
                            final religion = controller.religions[index];
                            final isSelected = controller.selectedReligion.contains(religion);
                            return GlassContainerWidget(
                              text: religion,
                              isSelected: isSelected,
                              onTap: () {
                                controller.toggleReligion(religion);
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
                      if (controller.selectedReligion.isEmpty) {
                        showSnackBar(context, "Please Select any items");
                      } else {
                        Get.to(() => const LifestyleScreen());
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
