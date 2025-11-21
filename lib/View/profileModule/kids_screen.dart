import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/View/profileModule/preferred_distance_screen.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glass_container_widget.dart';
import '../../Controller/profile_module_controller.dart';

class KidsScreen extends StatefulWidget {
  const KidsScreen({super.key});

  @override
  State<KidsScreen> createState() => _KidsScreenState();
}

final controller = Get.put(ProfileModuleController());

class _KidsScreenState extends State<KidsScreen> {
  @override
  Widget build(BuildContext context) {
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
                              isSelected: controller.hasChildren.value == "Yes",
                              onTap: () {
                                controller.setHasChildren("Yes");
                              },
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            ),
                            GlassContainerWidget(
                              text: "No",
                              isSelected: controller.hasChildren.value == "No",
                              onTap: () {
                                controller.setHasChildren("No");
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
                    textStyle: CommonTextStyle.regular18w500,
                    onPressed: () {
                      if (controller.hasChildren.value.isEmpty) {
                        showSnackBar(context, "Please select an option");
                      } else {
                        // Navigate to next screen
                        Get.to(() => const PreferredDistanceScreen());
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
