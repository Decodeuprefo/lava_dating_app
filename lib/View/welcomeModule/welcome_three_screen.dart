import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/View/welcomeModule/welcome_four_screen.dart';

class WelcomeThreeScreen extends StatelessWidget {
  const WelcomeThreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                heightSpace(100),
                _buildTitle(),
                heightSpace(33),
                _buildCenterImage(),
                heightSpace(33),
                Expanded(child: _buildDescriptionText()),
                const Spacer(),
                Column(
                  children: [
                    _buildNextButton(),
                    heightSpace(20),
                    _buildStepper(),
                  ],
                ),
                heightSpace(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "FAITH-fully Yours",
      style: CommonTextStyle.regular30w600.copyWith(
        color: ColorConstants.lightOrange,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildCenterImage() {
    return SizedBox(
      width: 235,
      height: 352,
      child: Image.asset(
        "assets/images/welcome3.png",
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 235,
            height: 352,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.image,
              size: 100,
              color: Colors.white54,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDescriptionText() {
    return const Center(
      child: Text(
        "🙏🏽 Faithful to God first so we can be faithful to the one we’re blessed 😇 to love.",
        style: CommonTextStyle.regular14w400,
      ),
    );
  }

  Widget _buildNextButton() {
    return AppButton(
      text: 'Next',
      onPressed: () {
        Get.to(
          () => const WelcomeFourScreen(),
          transition: Transition.rightToLeftWithFade,
          duration: const Duration(milliseconds: 500),
        );
      },
      backgroundColor: ColorConstants.lightOrange,
      textStyle: CommonTextStyle.regular16w500.copyWith(
        color: Colors.white,
      ),
      borderRadius: 10,
      width: double.infinity,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  Widget _buildStepper() {
    const int currentStep = 2;
    const int totalSteps = 4;
    const double totalWidth = 100.0;
    const double height = 5.0;
    const double gap = 2.0;

    const double totalGapWidth = (totalSteps - 1) * gap;
    const double availableWidth = totalWidth - totalGapWidth;
    const double singleStepWidth = availableWidth / totalSteps;

    List<Widget> children = [];

    if (currentStep > 0) {
      int count = currentStep;
      double width = (count * singleStepWidth) + ((count - 1) * gap);

      children.add(_buildSegment(
        color: const Color.fromRGBO(217, 217, 217, 1),
        height: height,
        width: width,
      ));
      children.add(const SizedBox(width: gap));
    }

    children.add(_buildSegment(
      color: ColorConstants.lightOrange,
      height: height,
      width: singleStepWidth,
    ));

    if (currentStep < totalSteps - 1) {
      children.add(const SizedBox(width: gap));

      int count = totalSteps - 1 - currentStep;
      double width = (count * singleStepWidth) + ((count - 1) * gap);

      children.add(_buildSegment(
        color: const Color.fromRGBO(217, 217, 217, 1),
        height: height,
        width: width,
      ));
    }

    return SizedBox(
      width: totalWidth,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget _buildSegment({required Color color, required double height, required double width}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height),
      ),
    );
  }
}
