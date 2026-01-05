import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/profile_module_controller.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/select_relationship_type_screen_controller.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glassmorphic_background_widget.dart';
import '../../Common/widgets/shimmers/select_relationship_type_screen_shimmer_widget.dart';

class SelectRelationshipTypeScreen extends StatefulWidget {
  const SelectRelationshipTypeScreen({super.key});

  @override
  State<SelectRelationshipTypeScreen> createState() => _SelectRelationshipTypeScreenState();
}

class _SelectRelationshipTypeScreenState extends State<SelectRelationshipTypeScreen> {
  late SelectRelationshipTypeScreenController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<SelectRelationshipTypeScreenController>()) {
      Get.put(SelectRelationshipTypeScreenController());
    }
    controller = Get.find<SelectRelationshipTypeScreenController>();
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<SelectRelationshipTypeScreenController>()) {
        Get.delete<SelectRelationshipTypeScreenController>();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileModuleController>();

    return GetBuilder<SelectRelationshipTypeScreenController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: SelectRelationshipTypeScreenShimmerWidget(),
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
                              children: List.generate(profileController.relationshipTypes.length,
                                  (index) {
                                final relationshipType = profileController.relationshipTypes[index];
                                final isSelected = profileController.selectedRelationshipType
                                    .contains(relationshipType);
                                return GestureDetector(
                                  onTap: () {
                                    profileController.toggleRelationshipType(relationshipType);
                                    profileController.refreshScreen();
                                  },
                                  child: GlassmorphicBackgroundWidget(
                                    borderRadius: 10,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                                    border: isSelected ? 2.0 : 0.8,
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
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          profileController.relationshipTypeIconPaths[index],
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const SizedBox(width: 36, height: 36);
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          relationshipType,
                                          style: CommonTextStyle.regular14w400,
                                        ),
                                      ],
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
                    child: AppButton(
                      text: "Continue",
                      textStyle: CommonTextStyle.regular16w500,
                      onPressed: controller.isLoading
                          ? null
                          : () {
                              controller.updateRelationshipType(context);
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
