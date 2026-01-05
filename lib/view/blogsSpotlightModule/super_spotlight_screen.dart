import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/glass_background_widget.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Controller/super_spotlight_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuperSpotlightScreen extends StatelessWidget {
  const SuperSpotlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SuperSpotlightController());

    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildHeader(),
                      heightSpace(20),
                      _buildProfileImageWithBorder(controller),
                      heightSpace(20),
                    ],
                  ),
                ),
                _buildFeatureBenefitsCard(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      heightSpace(30),
                      _buildAvailabilityText(),
                      heightSpace(30),
                      _buildActionButtons(controller),
                      heightSpace(10),
                      _buildDisclaimerText(),
                      heightSpace(20),
                    ],
                  ),
                ),
              ],
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
        Text(
          "Super Spotlight",
          style: CommonTextStyle.regular30w600.copyWith(
            color: ColorConstants.lightOrange,
          ),
        ),
        heightSpace(10),
        const Text(
          "Get 3 hours of unmatched visibility",
          style: CommonTextStyle.regular14w400,
        ),
      ],
    );
  }

  Widget _buildProfileImageWithBorder(SuperSpotlightController controller) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Obx(
              () => ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  controller.profileImageUrl.value,
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 280,
                      height: 280,
                      color: Colors.grey.withOpacity(0.3),
                      child: const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.white54,
                      ),
                    );
                  },
                ),
              ),
            ),
            Image.asset(
              "assets/images/profile_border.png",
              width: 300,
              height: 300,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ColorConstants.lightOrange,
                      width: 4,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureBenefitsCard(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: GlassBackgroundWidget(
            borderRadius: 10,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "3 Hours of Top Visibility",
                    style: CommonTextStyle.regular16w400,
                  ),
                  heightSpace(12),
                  const Text(
                    "Shows First to Nearby Users",
                    style: CommonTextStyle.regular16w400,
                  ),
                  heightSpace(12),
                  const Text(
                    "\"Super Spotlight\" Tag",
                    style: CommonTextStyle.regular16w400,
                  ),
                  heightSpace(12),
                  const Text(
                    "Highest Match Success Rate",
                    style: CommonTextStyle.regular16w400,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).marginSymmetric(horizontal: 20);
  }

  Widget _buildAvailabilityText() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "You get 1 Super Spotlight per year",
        style: CommonTextStyle.regular18w600,
      ),
    );
  }

  Widget _buildActionButtons(SuperSpotlightController controller) {
    return Column(
      children: [
        AppButton(
          text: "Activate Super Spotlight",
          onPressed: () => controller.activateSuperSpotlight(),
          backgroundColor: ColorConstants.lightOrange,
          textStyle: CommonTextStyle.regular16w500.copyWith(
            color: Colors.white,
          ),
          borderRadius: 10,
          width: double.infinity,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 13),
        ),
        heightSpace(12),
        AppButton(
          text: "Maybe Later",
          onPressed: () => Get.back(),
          backgroundColor: Colors.transparent,
          borderColor: ColorConstants.lightOrange,
          textStyle: CommonTextStyle.regular16w500.copyWith(
            color: ColorConstants.lightOrange,
          ),
          borderRadius: 10,
          width: double.infinity,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 13),
        ),
      ],
    );
  }

  Widget _buildDisclaimerText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline,
          size: 16,
          color: Colors.white,
        ),
        widthSpace(3),
        const Expanded(
          child: Text(
            "You can only activate this once per year — use it wisely",
            style: CommonTextStyle.regular12w400,
          ),
        ),
      ],
    );
  }
}
