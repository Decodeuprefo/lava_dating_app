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
import 'package:lava_dating_app/View/inappPurchase/payment_success_screen.dart';

class SelectPlansScreen extends StatelessWidget {
  const SelectPlansScreen({super.key});

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
                    heightSpace(30),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildPlanDurationsList(controller),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildDisclaimer(),
                    heightSpace(15),
                    _buildContinueButton(),
                    heightSpace(20),
                  ],
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
              "Choose Your Plan Duration",
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
            "Select how long you'd like to enjoy\nLava Lava Premium.",
            style: CommonTextStyle.regular14w400.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanDurationsList(MembershipController controller) {
    return Obx(
      () => Column(
        children: controller.planDurations.asMap().entries.map((entry) {
          final index = entry.key;
          final planDuration = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: index < controller.planDurations.length - 1 ? 15 : 0),
            child: _buildPlanDurationCard(controller, planDuration, index),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlanDurationCard(
    MembershipController controller,
    PlanDuration planDuration,
    int index,
  ) {
    return Obx(
      () => InkWell(
        onTap: () {
          controller.selectedDurationIndex.value = index;
        },
        child: ClipRRect(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10).copyWith(right: 0),
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
                    color: controller.selectedDurationIndex.value == index
                        ? ColorConstants.lightOrange
                        : Colors.white.withOpacity(0.25),
                    width: controller.selectedDurationIndex.value == index ? 3 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            planDuration.duration,
                            style: CommonTextStyle.regular24w700.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          heightSpace(8),
                          Text(
                            planDuration.price,
                            style: CommonTextStyle.regular18w400.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (planDuration.showSaveBadge)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: ColorConstants.lightOrange,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                        ),
                        child: Text(
                          planDuration.saveText,
                          style: CommonTextStyle.regular12w600.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (planDuration.showBestValueBadge)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: ColorConstants.lightOrange,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                        ),
                        child: Text(
                          'BEST VALUE',
                          style: CommonTextStyle.regular12w600.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
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
        ),
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Text(
      "Subscriptions auto-renew. You can cancel anytime from your store settings.",
      style: CommonTextStyle.regular14w400.copyWith(color: Colors.grey),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContinueButton() {
    return AppButton(
      text: 'Continue to Payment',
      onPressed: () {
        Get.to(() => const PaymentSuccessScreen());
      },
      backgroundColor: ColorConstants.lightOrange,
      textStyle: CommonTextStyle.regular16w600.copyWith(
        color: Colors.white,
      ),
      borderRadius: 10,
      width: double.infinity,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16),
    );
  }
}
