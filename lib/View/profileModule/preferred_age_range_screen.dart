import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/profile_module_controller.dart';
import 'package:lava_dating_app/View/profileModule/select_height_screen.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/age_range_picker_widget.dart';
import '../../Common/widgets/height_picker_widget.dart';

class PreferredAgeRangeScreen extends StatelessWidget {
  const PreferredAgeRangeScreen({super.key});

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
                        text: "What's Your Preferred Age Range?",
                        textType: TextType.head,
                      ),
                      heightSpace(05),
                      const CommonTextWidget(
                        text:
                            "Tell us your ideal age range for connections, So we can filter matches that suit you better.",
                        textType: TextType.des,
                      ),
                      heightSpace(10),
                      Obx(
                        () => AgeRangePickerWidget(
                          minAge: controller.minAge.value,
                          maxAge: controller.maxAge.value,
                          onMinAgeChanged: (age) {
                            if (age <= controller.maxAge.value) {
                              controller.minAge.value = age;
                            }
                          },
                          onMaxAgeChanged: (age) {
                            if (age >= controller.minAge.value) {
                              controller.maxAge.value = age;
                            }
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
                    textStyle: CommonTextStyle.regular18w500,
                    onPressed: () {
                      Get.to(() => const SelectHeightScreen());
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
