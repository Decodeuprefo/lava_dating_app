import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/glass_background_widget.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Controller/spotlight_your_profile_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lava_dating_app/View/blogsSpotlightModule/super_spotlight_screen.dart';

class SpotlightYourProfile extends StatelessWidget {
  const SpotlightYourProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SpotlightYourProfileController());

    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  heightSpace(20),
                  _buildBoostVisibilityCard(),
                  heightSpace(16),
                  _buildSpotlightAvailabilityCard(controller),
                  heightSpace(20),
                  _buildPurchaseOptionsSection(controller),
                  heightSpace(20),
                  _buildHowItWorksSection(),
                  heightSpace(20),
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
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: SvgPicture.asset(
                "assets/icons/back_arrow.svg",
                height: 30,
                width: 30,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
        Center(
          child: Text(
            "Spotlight Your\nProfile",
            style: CommonTextStyle.regular30w600.copyWith(
              color: ColorConstants.lightOrange,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildBoostVisibilityCard() {
    return GlassBackgroundWidget(
      borderRadius: 10,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text(
            "Boost Your Profile Visibility!",
            style: CommonTextStyle.regular18w600,
            textAlign: TextAlign.center,
          ),
          heightSpace(10),
          const Text(
            "Be seen first by people in your area for 30 minutes.",
            style: CommonTextStyle.regular14w400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSpotlightAvailabilityCard(SpotlightYourProfileController controller) {
    return GlassBackgroundWidget(
      borderRadius: 10,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Obx(
            () => RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "You currently have \n",
                    style: CommonTextStyle.regular14w600,
                  ),
                  TextSpan(
                    text: "${controller.availableSpotlights.value} Spotlight available.",
                    style: CommonTextStyle.regular16w600,
                  ),
                ],
              ),
            ),
          ),
          heightSpace(10),
          Obx(
            () => Text(
              "Next free Spotlight resets in: ${controller.resetDays.value} Days",
              style: CommonTextStyle.regular14w400,
              textAlign: TextAlign.center,
            ),
          ),
          heightSpace(20),
          AppButton(
            text: "Activate Spotlight Now",
            onPressed: () => Get.to(()=>const SuperSpotlightScreen()),
            backgroundColor: ColorConstants.lightOrange,
            textStyle: CommonTextStyle.regular16w500.copyWith(
              color: Colors.white,
            ),
            borderRadius: 10,
            width: double.infinity,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseOptionsSection(SpotlightYourProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Need more? Get extra Spotlights",
          style: CommonTextStyle.regular22w600,
        ),
        heightSpace(12),
        Obx(
          () => Row(
            children: controller.spotlightPackages.map((package) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _buildSpotlightPackageCard(
                    package,
                    controller,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSpotlightPackageCard(
    SpotlightPackage package,
    SpotlightYourProfileController controller,
  ) {
    return SizedBox(
      height: 150,
      child: GlassBackgroundWidget(
        borderRadius: 5,
        padding: const EdgeInsets.all(5),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (package.savingsPercentage != null)
                          const SizedBox(height: 20)
                        else
                          const SizedBox(height: 0),
                        Text(
                          "${package.quantity} Spotlight${package.quantity > 1 ? 's' : ''}",
                          style: CommonTextStyle.regular14w400,
                          textAlign: TextAlign.center,
                        ),
                        heightSpace(5),
                        Text(
                          package.price,
                          style: CommonTextStyle.regular22w600,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                AppButton(
                  text: "Buy ${package.quantity}",
                  onPressed: () => controller.buySpotlightPackage(package.quantity),
                  backgroundColor: ColorConstants.lightOrange,
                  textStyle: CommonTextStyle.regular12w600.copyWith(
                    color: Colors.white,
                  ),
                  borderRadius: 5,
                  width: double.infinity,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                ),
              ],
            ),
            if (package.savingsPercentage != null)
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Save ${package.savingsPercentage}%",
                  style: CommonTextStyle.bold12w700.copyWith(
                    color: ColorConstants.lightOrange,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorksSection() {
    return GlassBackgroundWidget(
      borderRadius: 10,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "How Spotlight Works",
            style: CommonTextStyle.regular16w600,
          ),
          heightSpace(5),
          _buildHowItWorksItem(
            imagePath: "assets/icons/calendar_icon.svg",
            text: "Your profile gets highlighted for 30 min",
          ),
          heightSpace(5),
          _buildHowItWorksItem(
            imagePath: "assets/icons/HomeSplash/location_pin_icon.png",
            text: "Seen by nearby active users",
          ),
          heightSpace(5),
          _buildHowItWorksItem(
            imagePath: "assets/icons/HomeSplash/swipe_star_button.png",
            text: "Stands out with a Spotlight tag",
          ),
          heightSpace(5),
          _buildHowItWorksItem(
            imagePath: "assets/icons/dash_heart.png",
            text: "Higher match chances",
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksItem({
    required String imagePath,
    required String text,
  }) {
    final bool isSvg = imagePath.endsWith('.svg');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isSvg
            ? SvgPicture.asset(
                imagePath,
                width: 15,
                height: 15,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              )
            : ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  imagePath,
                  width: 15,
                  height: 15,
                ),
              ),
        widthSpace(12),
        Expanded(
          child: Text(
            text,
            style: CommonTextStyle.regular14w400,
          ),
        ),
      ],
    );
  }
}
