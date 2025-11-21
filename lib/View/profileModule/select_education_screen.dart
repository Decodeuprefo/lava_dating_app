import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/profile_module_controller.dart';
import 'package:lava_dating_app/View/profileModule/select_languages_spoken.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/custom_dropdown_widget.dart';

class SelectEducationScreen extends StatelessWidget {
  const SelectEducationScreen({super.key});

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
                        () => CustomDropdownWidget(
                          selectedValue: controller.selectedEducation.value.isEmpty
                              ? null
                              : controller.selectedEducation.value,
                          items: controller.educationOptions,
                          hint: "Select your education",
                          onChanged: (String? value) {
                            if (value != null) {
                              controller.selectedEducation.value = value;
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
                      if (controller.selectedEducation.value.isEmpty) {
                        showSnackBar(context, "Please Select your education");
                      } else {
                        Get.to(() => const SelectLanguagesSpoken());
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
