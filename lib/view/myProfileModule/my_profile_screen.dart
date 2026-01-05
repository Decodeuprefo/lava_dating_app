import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Common/widgets/glass_background_widget.dart';
import 'package:lava_dating_app/View/inappPurchase/membership_screen.dart';
import 'package:lava_dating_app/View/myProfileModule/edit_profile_screen.dart';
import 'package:lava_dating_app/View/myProfileModule/setting_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String? profileImageUrl;
  String userName = "Jennifer Burk";
  String aboutMe = "Music Lover and nature enthusiast";
  List<String> interests = ["Travel", "Photography", "Yoga"];
  String location = "San Francisco, CA";
  String occupation = "Software Engineer";

  int hibiscusCount = 12;
  int coconutCount = 5;
  int leiCount = 8;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    profileImageUrl = "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400";
  }

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
                  heightSpace(50),
                  _buildHeader(),
                  heightSpace(20),
                  _buildProfileSummary(),
                  heightSpace(20),
                  _buildMainContentCard(),
                  heightSpace(20),
                  _buildFlowersSection(),
                  heightSpace(20),
                  Center(child: _buildUpgradeButton()),
                  heightSpace(100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: SizedBox(),
        ),
        const Text("My Profile", style: CommonTextStyle.semiBold30w600),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight, // Push icon to the far right
            child: GestureDetector(
              onTap: () {
                Get.to(() => const SettingScreen());
              },
              child: Image.asset(
                height: 32,
                width: 32,
                'assets/icons/white_setting_icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSummary() {
    return Row(
      children: [
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
            child: profileImageUrl != null && profileImageUrl!.isNotEmpty
                ? Image.network(
                    profileImageUrl!,
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
          ).paddingAll(5),
        ),
        widthSpace(34),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userName,
                style: CommonTextStyle.regular24w600,
              ),
              heightSpace(28),
              AppButton(
                text: "Edit Profile",
                onPressed: () {
                  Get.to(() => const EditProfileScreen(), transition: Transition.noTransition);
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

  Widget _buildMainContentCard() {
    return GlassBackgroundWidget(
      borderRadius: 15,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Me Section
          const Text(
            "About Me",
            style: CommonTextStyle.regular16w600,
          ),
          heightSpace(5),
          Text(
            aboutMe,
            style: CommonTextStyle.regular14w400,
          ),
          heightSpace(20),
          const Text(
            "Interests/Hobbies",
            style: CommonTextStyle.regular16w600,
          ),
          heightSpace(5),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: interests.map((interest) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: ColorConstants.lightOrange,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: ColorConstants.lightOrange.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  interest,
                  style: CommonTextStyle.regular14w400,
                ),
              );
            }).toList(),
          ),
          heightSpace(24),
          Row(
            children: [
              // Location Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Location",
                      style: CommonTextStyle.regular16w600,
                    ),
                    heightSpace(5),
                    Text(
                      location,
                      style: CommonTextStyle.regular14w400,
                    ),
                  ],
                ),
              ),
              // Occupation Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Occupation",
                      style: CommonTextStyle.regular16w600,
                    ),
                    heightSpace(5),
                    Text(
                      occupation,
                      style: CommonTextStyle.regular14w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlowersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Flowers Received",
          style: CommonTextStyle.regular16w600,
        ),
        heightSpace(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFlowerCard(
              iconPath: "assets/images/hibiscus.png",
              count: hibiscusCount,
            ),
            widthSpace(20),
            _buildFlowerCard(
              iconPath: "assets/images/coconut.png", // Placeholder path
              count: coconutCount,
            ),
            widthSpace(20),
            _buildFlowerCard(
              iconPath: "assets/images/hawaiian.png", // Placeholder path
              count: leiCount,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFlowerCard({required String iconPath, required int count}) {
    return Expanded(
      child: Container(
        height: 108,
        width: 108,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.local_florist,
                    color: Colors.white.withOpacity(0.7),
                    size: 36,
                  );
                },
              ),
            ),
            // heightSpace(2),
            Text(
              "$count",
              style: CommonTextStyle.regular30w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeButton() {
    return AppButton(
      text: "Upgrade to Premium",
      image: const AssetImage('assets/icons/premium_quality.png'),
      onPressed: () {
        Get.to(() => const MembershipScreen());
      },
      backgroundColor: ColorConstants.lightOrange,
      borderRadius: 10,
      width: 240,
      textStyle: CommonTextStyle.regular16w600,
      elevation: 0,
    );
  }
}
