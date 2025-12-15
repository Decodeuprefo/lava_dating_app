import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
                  heightSpace(10),
                  _buildLogo(),
                  heightSpace(30),
                  _buildFirstParagraph(),
                  heightSpace(30),
                  _buildSecondParagraph(),
                  heightSpace(50),
                  _buildWelcomeSection(),
                  heightSpace(50),
                  _buildGetInTouchSection(),
                  heightSpace(20),
                  _buildVersionNumber(),
                  heightSpace(30),
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
            fit: BoxFit.fill,
          ),
        ),
        const Center(
          child: Text(
            "About Us",
            style: CommonTextStyle.semiBold30w600,
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

  Widget _buildFirstParagraph() {
    return const Text(
      "Lava was created with purpose — to strengthen Pasifika connection through culture, community, and faith. It's a space for Islanders – and for those who love and respect our people, values, and traditions — to honor our roots while building meaningful relationships.",
      style: CommonTextStyle.regular14w400,
      textAlign: TextAlign.left,
    );
  }

  Widget _buildSecondParagraph() {
    return const Text(
      "Lava is grounded in authenticity, intentional matches, and respectful interactions -- designed for people seeking real, lasting connections. Inspired by the strength of our roots, the warmth of our people, and the belief that strong foundations create strong futures – Lava brings our community together.",
      style: CommonTextStyle.regular14w400,
      textAlign: TextAlign.left,
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome to Lava",
          style: CommonTextStyle.bold14w700,
        ),
        Text(
          "where culture, connection, and faith meet. 🌺🌋🙏🏽",
          style: CommonTextStyle.regular14w400.copyWith(
            color: ColorConstants.lightOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildGetInTouchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Get in Touch",
          style: CommonTextStyle.regular16w600.copyWith(
            color: ColorConstants.lightOrange,
          ),
        ),
        heightSpace(20),
        _buildContactItem(
          icon: "assets/icons/doc_message.png",
          text: "support@lava.com",
          onTap: () {},
        ),
        heightSpace(15),
        _buildContactItem(
          icon: "assets/icons/duo_web.png",
          text: "www.lava.com",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required String icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(
            icon,
            height: 21,
            width: 21,
          ),
          widthSpace(10),
          Text(
            text,
            style: CommonTextStyle.regular14w400.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionNumber() {
    return const Center(
      child: Text(
        "Ver. 1.0.1",
        style: CommonTextStyle.regular12w400,
      ),
    );
  }
}
