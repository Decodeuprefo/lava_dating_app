import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glass_container_widget.dart';
import '../../Controller/profile_module_controller.dart';
import 'location_permission_screen.dart';

class RaceFlagsScreen extends StatelessWidget {
  const RaceFlagsScreen({super.key});

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
                        text: "What's your ethnicity?",
                        textType: TextType.head,
                      ),
                      const CommonTextWidget(
                        text: "Rep your roots! Choose up to two",
                        textType: TextType.des,
                      ),
                      heightSpace(30),
                      Obx(
                        () => Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.start,
                          children: List.generate(controller.ethnicities.length, (index) {
                            final ethnicity = controller.ethnicities[index];
                            final isSelected = controller.selectedEthnicity.contains(ethnicity);
                            return GlassContainerWidget(
                              text: ethnicity,
                              isSelected: isSelected,
                              onTap: () {
                                controller.toggleEthnicity(ethnicity);
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
                      if (controller.selectedEthnicity.isEmpty) {
                        showSnackBar(context, "Please select at least one ethnicity");
                      } else {
                        // Navigate to next screen
                        Get.to(() => const LocationPermissionScreen());
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
