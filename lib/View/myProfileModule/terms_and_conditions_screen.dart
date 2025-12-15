import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heightSpace(20),
                  _buildHeader(),
                  heightSpace(40),
                  _buildLogo(),
                  heightSpace(10),
                  _buildIntroductionText(),
                  heightSpace(30),
                  _buildTermsSection(
                    number: "1",
                    heading: "Introduction",
                    body:
                        "Welcome to lava. By using our app, you agree to these Terms & Conditions. Please read them carefully before proceeding.",
                  ),
                  heightSpace(30),
                  _buildTermsSection(
                    number: "2",
                    heading: "Account Responsibilities",
                    body:
                        "You are responsible for maintaining the confidentiality of your account details. Misuse of your profile may result in suspension.",
                  ),
                  heightSpace(30),
                  _buildTermsSection(
                    number: "3",
                    heading: "Safety and Conduct",
                    body:
                        "We encourage respectful interactions. Any harassment, spam, or fake accounts will be removed.",
                  ),
                  heightSpace(30),
                  _buildTermsSection(
                    number: "4",
                    heading: "Subscription & Payments",
                    body:
                        "Premium features are billed monthly or annually. All payments are final and non-refundable.",
                  ),
                  heightSpace(30),
                  _buildTermsSection(
                    number: "5",
                    heading: "Data & Privacy",
                    body:
                        "Your privacy is important to us. Please review our Privacy Policy to learn how we handle your data.",
                  ),
                  heightSpace(40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: Get.back,
          child: SvgPicture.asset(
            "assets/icons/back_arrow.svg",
            height: 30,
            width: 30,
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Text(
            "Terms & Conditions",
            style: CommonTextStyle.regular30w600.copyWith(
              color: ColorConstants.lightOrange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/images/app_logo.png',
        width: 95,
        height: 80,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Text(
            "Lava",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: ColorConstants.lightOrange,
              fontFamily: 'Poppins',
            ),
          );
        },
      ),
    );
  }

  Widget _buildIntroductionText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Please read our terms carefully before using the app. These terms outline your rights, responsibilities, and our policies.",
          style: CommonTextStyle.regular14w400,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTermsSection({
    required String number,
    required String heading,
    required String body,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$number. $heading",
          style: CommonTextStyle.regular20w600.copyWith(
            color: ColorConstants.lightOrange,
          ),
        ),
        heightSpace(10),
        Text(
          body,
          style: CommonTextStyle.regular14w400,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
