import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/profile_module_controller.dart';
import 'package:lava_dating_app/Controller/setProfileControllers/select_education_screen_controller.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/glassmorphic_background_widget.dart';
import '../../Common/widgets/shimmers/select_education_screen_shimmer_widget.dart';

class SelectEducationScreen extends StatefulWidget {
  const SelectEducationScreen({super.key});

  @override
  State<SelectEducationScreen> createState() => _SelectEducationScreenState();
}

class _SelectEducationScreenState extends State<SelectEducationScreen> {
  late SelectEducationScreenController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<SelectEducationScreenController>()) {
      Get.put(SelectEducationScreenController());
    }
    controller = Get.find<SelectEducationScreenController>();
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<SelectEducationScreenController>()) {
        Get.delete<SelectEducationScreenController>();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileModuleController>();

    return GetBuilder<SelectEducationScreenController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: BackgroundContainer(
              child: SafeArea(
                child: SelectEducationScreenShimmerWidget(),
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
                            text: "Education",
                            textType: TextType.head,
                          ),
                          heightSpace(20),
                          const CommonTextWidget(
                            text:
                                "Share your education background – it helps us match based on lifestyle and values.",
                            textType: TextType.des,
                          ),
                          heightSpace(55),
                          Obx(
                            () => _CustomEducationSelector(
                              selectedValue: profileController.selectedEducation.value.isEmpty
                                  ? null
                                  : profileController.selectedEducation.value,
                              items: profileController.educationOptions,
                              hint: "Select your education",
                              onItemSelected: (String value) {
                                profileController.selectedEducation.value = value;
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
                          controller.updateEducation(context);
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

class _CustomEducationSelector extends StatefulWidget {
  final String? selectedValue;
  final List<String> items;
  final String hint;
  final Function(String) onItemSelected;

  const _CustomEducationSelector({
    required this.selectedValue,
    required this.items,
    required this.hint,
    required this.onItemSelected,
  });

  @override
  State<_CustomEducationSelector> createState() => _CustomEducationSelectorState();
}

class _CustomEducationSelectorState extends State<_CustomEducationSelector>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _selectItem(String item) {
    widget.onItemSelected(item);
    _toggleExpansion();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggleExpansion,
          child: GlassmorphicBackgroundWidget(
            borderRadius: 10,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.selectedValue ?? widget.hint,
                    style: widget.selectedValue == null
                        ? CommonTextStyle.regular14w400.copyWith(
                            color: Colors.white.withOpacity(0.6),
                          )
                        : CommonTextStyle.regular14w400,
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Image.asset(
                    "assets/icons/drop_down_arrow.png",
                    fit: BoxFit.cover,
                    height: 26,
                    width: 26,
                  ),
                ),
              ],
            ),
          ),
        ),
        heightSpace(5),
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: -1.0,
          child: GlassmorphicBackgroundWidget(
            borderRadius: 10,
            padding: EdgeInsets.zero,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < widget.items.length; i++) ...[
                    InkWell(
                      onTap: () => _selectItem(widget.items[i]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.items[i],
                                style: CommonTextStyle.regular14w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (i < widget.items.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Image.asset(
                          "assets/images/border_line.png",
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
