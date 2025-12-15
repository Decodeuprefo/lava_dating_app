import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Common/widgets/glass_background_widget.dart';
import 'package:lava_dating_app/Controller/manage_subscription_controller.dart';
import 'package:lava_dating_app/View/myProfileModule/edit_profile_screen.dart';

class ManageYourSubscription extends StatelessWidget {
  const ManageYourSubscription({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ManageSubscriptionController());

    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        heightSpace(30),
                        _buildHeader(),
                        heightSpace(10),
                        _buildProfileSection(controller),
                        heightSpace(30),
                        _buildPlansSection(controller),
                        heightSpace(10),
                        _buildActionButtonsSection(controller),
                        heightSpace(30),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildUpdateSubscriptionButton(controller),
              ),
              heightSpace(30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Text(
        "Manage Subscription",
        style: CommonTextStyle.regular30w600.copyWith(
          color: ColorConstants.lightOrange,
        ),
      ),
    );
  }

  Widget _buildProfileSection(ManageSubscriptionController controller) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -7,
              right: -5,
              child: Image.asset(
                'assets/icons/crown_icon.png',
                width: 32,
                height: 32,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 28,
                  );
                },
              ),
            ),
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorConstants.lightOrange,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Obx(
                  () => controller.profileImageUrl.value.isNotEmpty
                      ? Image.network(
                          controller.profileImageUrl.value,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey.shade900,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: ColorConstants.lightOrange,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade900,
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white54,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey.shade900,
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white54,
                          ),
                        ),
                ),
              ).paddingAll(5),
            ),
          ],
        ),
        widthSpace(25),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  controller.userName.value,
                  style: CommonTextStyle.regular24w600,
                ),
              ),
              heightSpace(20),
              AppButton(
                text: "Edit Profile",
                onPressed: () {
                  Get.to(
                    () => const EditProfileScreen(),
                    transition: Transition.noTransition,
                  );
                },
                backgroundColor: ColorConstants.lightOrange,
                borderRadius: 10,
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: CommonTextStyle.regular14w500,
                width: 130,
                elevation: 0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlansSection(ManageSubscriptionController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final itemWidth = (screenWidth - 12) / 2;
            final aspectRatio = itemWidth / 120;

            return Obx(
              () {
                final benefits = controller.benefits;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: benefits.length,
                  itemBuilder: (context, index) {
                    final benefit = benefits[index];
                    return SizedBox(
                      height: 120,
                      child: _buildBenefitCard(benefit),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBenefitCard(SubscriptionBenefit benefit) {
    return GlassBackgroundWidget(
      borderRadius: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            benefit.number,
            style: CommonTextStyle.regular35w600,
          ),
          Text(
            benefit.label,
            style: CommonTextStyle.regular16w400.copyWith(
              color: ColorConstants.lightOrange,
            ),
          ),
          if (benefit.subLabel.isNotEmpty) ...[
            heightSpace(2),
            Text(
              benefit.subLabel,
              style: CommonTextStyle.regular16w400.copyWith(
                color: ColorConstants.lightOrange,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtonsSection(ManageSubscriptionController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final itemWidth = (screenWidth - 12) / 2;
        final aspectRatio = itemWidth / 50;

        return Obx(
          () {
            final actionButtons = controller.actionButtons;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: aspectRatio,
              ),
              itemCount: actionButtons.length,
              itemBuilder: (context, index) {
                final buttonName = actionButtons[index];
                return SizedBox(
                  height: 50,
                  child: _buildActionButton(buttonName, controller),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildActionButton(String buttonName, ManageSubscriptionController controller) {
    return GlassBackgroundWidget(
      borderRadius: 10,
      child: InkWell(
        onTap: () => controller.onActionButtonTap(buttonName),
        child: Center(
          child: Text(
            buttonName,
            style: CommonTextStyle.regular14w600.copyWith(
              color: ColorConstants.lightOrange,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateSubscriptionButton(ManageSubscriptionController controller) {
    return AppButton(
      text: "Update Your Subscription",
      image: const AssetImage('assets/icons/premium_quality.png'),
      onPressed: () => controller.onUpdateSubscriptionTap(),
      backgroundColor: ColorConstants.lightOrange,
      borderRadius: 10,
      width: 280,
      textStyle: CommonTextStyle.regular16w500,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16),
    );
  }
}
