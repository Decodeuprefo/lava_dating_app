import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/profile_module_controller.dart';
import 'package:lava_dating_app/View/setProfileModule/preferred_age_range_screen.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glass_container_widget.dart';

class SelectRelationshipTypeScreen extends StatelessWidget {
  const SelectRelationshipTypeScreen({super.key});

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
                        text: "What are you looking for?",
                        textType: TextType.head,
                      ),
                      const CommonTextWidget(
                        text: "Choose the kind of connection you want to build.",
                        textType: TextType.des,
                      ),
                      heightSpace(30),
                      Obx(
                        () => Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.start,
                          children: List.generate(controller.relationshipTypes.length, (index) {
                            final relationshipType = controller.relationshipTypes[index];
                            final isSelected =
                                controller.selectedRelationshipType.contains(relationshipType);
                            return GlassContainerWidget(
                              text: relationshipType,
                              imagePath: controller.relationshipTypeIconPaths[index],
                              isSelected: isSelected,
                              imageHeight: 36,
                              imageWidth: 36,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                              onTap: () {
                                controller.toggleRelationshipType(relationshipType);
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
                    textStyle: CommonTextStyle.regular18w500,
                    onPressed: () {
                      if (controller.selectedRelationshipType.isEmpty) {
                        showSnackBar(context, "Please Select any items");
                      } else {
                        Get.to(() => const PreferredAgeRangeScreen());
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
