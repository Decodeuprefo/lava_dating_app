import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Controller/profile_module_controller.dart';
import 'package:lava_dating_app/View/profileModule/select_dob_screen.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/text_form_field_widget.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({
    super.key,
  });

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  final profileModuleController = Get.find<ProfileModuleController>();

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
                        text: 'Add Your Attractive Bio about You',
                        textType: TextType.head,
                      ),
                      const CommonTextWidget(
                        text: 'Introduce Yourself Beyond the Basics.',
                        textType: TextType.des,
                      ),
                      heightSpace(50),
                      TextFormFieldWidget(
                        controller: profileModuleController.aboutMeController,
                        hint: "Wright something about you...",
                        maxLines: 8,
                      ),
                    ],
                  ).marginSymmetric(horizontal: 20),
                ),
              ),
              AppButton(
                text: "Continue",
                textStyle: CommonTextStyle.regular16w500,
                onPressed: () {
                  Get.to(() => const SelectDobScreen());
                },
              ).marginSymmetric(horizontal: 20, vertical: 20)
            ],
          ),
        ),
      ),
    );
  }
}
