import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Controller/membership_controller.dart';
import 'package:lava_dating_app/View/inappPurchase/select_plans_screen.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MembershipController());
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightSpace(20),
                    _buildHeader(),
                    heightSpace(20),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  scrollDirection: Axis.horizontal,
                  padEnds: false,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final screenWidth = MediaQuery.of(context).size.width;
                        final pageWidth = screenWidth * 0.85;
                        final sideSpace = (screenWidth - pageWidth) / 2;
                        return Container(
                          width: screenWidth,
                          padding: EdgeInsets.only(
                            left: index == 0 ? sideSpace : sideSpace * 0.2,
                            right: index == 2 ? sideSpace : sideSpace * 0.2,
                          ),
                          child: SingleChildScrollView(
                            child: _buildPageContent(controller, index),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Text(
              "Upgrade Your Experience",
              style: CommonTextStyle.regular18w500.copyWith(
                color: ColorConstants.lightOrange,
              ),
            ),
            Container()
          ],
        ),
        heightSpace(10),
        Center(
          child: Text(
            "Choose a plan that fits your vibe and unlock premium features.",
            style: CommonTextStyle.regular14w400.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildPageContent(MembershipController controller, int index) {
    switch (index) {
      case 0:
        return _buildBoombasticCard(controller);
      case 1:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFreePlanCard(controller),
              heightSpace(20),
              _buildAddOnsCard(controller),
            ],
          ),
        );
      case 2:
        return _buildMembershipCard(controller);
      default:
        return const SizedBox();
    }
  }

  Widget _buildMembershipCard(MembershipController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.09),
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.09),
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.09),
                ],
                stops: const [0.5, 0.5, 0.5],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/fire_image.png',
                  height: 50,
                  width: 50,
                ),
                heightSpace(10),
                Text(
                  'LAVA LAVA',
                  style: CommonTextStyle.regular24w700.copyWith(
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                heightSpace(8),
                Text(
                  'Go Premium',
                  style: CommonTextStyle.regular18w400.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                heightSpace(35),
                _buildFeaturesList(controller),
                heightSpace(55),
                _buildUpgradeButton(),
              ],
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.12),
                        Colors.white.withOpacity(0.06),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.10, 0.20, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(MembershipController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: controller.premiumFeatures.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/icons/check_icon.png",
                height: 14,
                width: 18,
              ).marginOnly(top: 1),
              widthSpace(17),
              Expanded(
                child: Text(
                  feature,
                  style: CommonTextStyle.regular14w400.copyWith(
                    color: const Color(0xFFCCCCCC),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUpgradeButton() {
    return AppButton(
      text: 'Upgrade to Lava Lava',
      onPressed: () {},
      backgroundColor: Colors.transparent,
      borderColor: ColorConstants.lightOrange,
      textStyle: CommonTextStyle.regular16w400.copyWith(
        color: ColorConstants.lightOrange,
      ),
      borderRadius: 10,
      width: double.infinity,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  Widget _buildBoombasticCard(MembershipController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.09),
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.09),
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.09),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/fire_image.png',
                  height: 50,
                  width: 50,
                ),
                heightSpace(10),
                Text(
                  'BOOMBASTIC',
                  style: CommonTextStyle.regular24w700.copyWith(
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                heightSpace(8),
                Text(
                  'Go All In',
                  style: CommonTextStyle.regular18w400.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                heightSpace(35),
                _buildBoombasticFeaturesList(controller),
                heightSpace(55),
                _buildUpgradeButton(),
              ],
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.12),
                        Colors.white.withOpacity(0.06),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.10, 0.20, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoombasticFeaturesList(MembershipController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: controller.boombasticFeatures.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/icons/check_icon.png",
                height: 14,
                width: 18,
              ).marginOnly(top: 1),
              widthSpace(17),
              Expanded(
                child: Text(
                  feature,
                  style: CommonTextStyle.regular14w400.copyWith(
                    color: const Color(0xFFCCCCCC),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFreePlanCard(MembershipController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.09),
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.09),
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.09),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/fire_image.png',
                  height: 50,
                  width: 50,
                ),
                heightSpace(10),
                Text(
                  'LAVA',
                  style: CommonTextStyle.regular24w700.copyWith(
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                heightSpace(8),
                Text(
                  'Free Plan',
                  style: CommonTextStyle.regular18w400.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                heightSpace(15),
                _buildFreePlanFeaturesList(controller),
                heightSpace(12),
                _buildCurrentPlanButton(),
              ],
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.12),
                        Colors.white.withOpacity(0.06),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.10, 0.20, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFreePlanFeaturesList(MembershipController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: controller.freePlanFeatures.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/icons/check_icon.png",
                height: 14,
                width: 18,
              ).marginOnly(top: 1),
              widthSpace(17),
              Expanded(
                child: Text(
                  feature,
                  style: CommonTextStyle.regular14w400.copyWith(
                    color: const Color(0xFFCCCCCC),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCurrentPlanButton() {
    return AppButton(
      text: 'Current Plan',
      onPressed: () {},
      backgroundColor: ColorConstants.lightOrange,
      textStyle: CommonTextStyle.regular16w400.copyWith(
        color: Colors.white,
      ),
      borderRadius: 10,
      width: double.infinity,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  Widget _buildAddOnsCard(MembershipController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.09),
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.09),
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.09),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add - Ons',
                  style: CommonTextStyle.regular24w700.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                heightSpace(10),
                _buildAddOnsList(controller),
                heightSpace(15),
                _buildViewAddOnsButton(),
              ],
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.12),
                        Colors.white.withOpacity(0.06),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.10, 0.20, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddOnsList(MembershipController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: controller.addOns.asMap().entries.map((entry) {
        final index = entry.key;
        final addOn = entry.value;
        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 0 : 10,
            right: index == controller.addOns.length - 1 ? 0 : 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                addOn['name']!,
                style: CommonTextStyle.regular16w600.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              heightSpace(8),
              Text(
                '${addOn['price']!}${addOn['period']!}',
                style: CommonTextStyle.regular16w600.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildViewAddOnsButton() {
    return AppButton(
      text: 'View Add-On Options',
      onPressed: () {
        Get.to(() => const SelectPlansScreen());
      },
      backgroundColor: Colors.transparent,
      borderColor: ColorConstants.lightOrange,
      textStyle: CommonTextStyle.regular16w400.copyWith(
        color: ColorConstants.lightOrange,
      ),
      borderRadius: 10,
      width: double.infinity,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16),
    );
  }
}
