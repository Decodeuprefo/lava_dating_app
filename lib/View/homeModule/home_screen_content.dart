import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/widgets/glass_background_widget.dart';
import 'package:lava_dating_app/Controller/home_screen_controller.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/widgets/glass_circular_button.dart';
import '../../Common/widgets/glass_profile_card.dart';
import '../../Common/widgets/glass_match_card.dart';

/// Home screen content without BackgroundContainer
/// Used in DashboardScreen where background is handled separately
class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  final RxInt matchesCount = 16.obs;
  final RxInt swipesLeft = 16.obs;
  final RxInt totalSwipes = 30.obs;
  final RxBool isUnlimitedSwipes = true.obs;
  final controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        heightSpace(22),
                        const Text(
                          "Hi Jennifer",
                          style: CommonTextStyle.regular14w500,
                        ),
                        const Text(
                          "Welcome back!",
                          style: CommonTextStyle.regular22w600,
                        ),
                      ],
                    ),
                    Image.asset(
                      "assets/icons/notification_icon.png",
                      height: 30,
                      width: 30,
                    )
                  ],
                ),
                heightSpace(24),
                Row(
                  children: [
                    _buildMatchesCard(),
                    widthSpace(15),
                    Flexible(
                      flex: 3,
                      child: _buildSwipesCard(),
                    ),
                  ],
                ),
                heightSpace(30),
                _buildCircularGlassButtons(),
                heightSpace(30),
                const Text(
                  "Suggestion",
                  style: CommonTextStyle.regular18w500,
                ),
                heightSpace(10),
              ],
            ).marginSymmetric(horizontal: 20),
            SizedBox(
              height: 170,
              child: _buildSuggestionsList(),
            ),
            heightSpace(30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Matches",
                  style: CommonTextStyle.regular18w500,
                ).marginSymmetric(horizontal: 20),
                heightSpace(10),
                SizedBox(
                  height: 140,
                  child: _buildMatchesList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchesList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.matches.length,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 20,
      ),
      itemBuilder: (context, index) {
        final match = controller.matches[index];
        return Padding(
          padding: const EdgeInsets.only(
            right: 10,
          ),
          child: GlassMatchCard(
            name: match['name'] ?? '',
            age: match['age'] ?? '',
            imageUrl: match['imageUrl'],
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildMatchesCard() {
    return Obx(() => GlassBackgroundWidget(
          borderRadius: 15,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Matches",
                style: CommonTextStyle.regular18w500,
              ),
              heightSpace(8),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/matches_heart_icon.png",
                    height: 30,
                    width: 30,
                  ),
                  widthSpace(12),
                  Text(
                    "${matchesCount.value}",
                    style: CommonTextStyle.bold24w700,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildSwipesCard() {
    return Obx(() {
      final progress = swipesLeft.value / totalSwipes.value;
      return GlassBackgroundWidget(
        borderRadius: 15,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.grey.withOpacity(0.3),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        ColorConstants.lightOrange,
                      ),
                      backgroundColor: ColorConstants.circularColor,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ],
              ),
            ),
            widthSpace(15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Swipes Left: ${swipesLeft.value}/${totalSwipes.value}",
                    style: CommonTextStyle.regular18w500,
                  ),
                  heightSpace(5),
                  Text(
                    isUnlimitedSwipes.value ? "Unlimited Swipes" : "",
                    style: CommonTextStyle.regular14w500,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCircularGlassButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GlassCircularButton(
          label: "Search",
          size: 60,
          icon: Image.asset(
            "assets/icons/HomeSplash/home_search_icon.png",
            height: 36,
            width: 36,
          ),
          onTap: () {},
        ),
        GlassCircularButton(
          label: "Like",
          size: 60,
          icon: Image.asset(
            "assets/icons/HomeSplash/home_heart.png",
            height: 36,
            width: 36,
          ),
          onTap: () {},
        ),
        GlassCircularButton(
          label: "Settings",
          size: 60,
          icon: Image.asset(
            "assets/icons/HomeSplash/home_setting.png",
            height: 36,
            width: 36,
          ),
          onTap: () {},
        ),
        GlassCircularButton(
          label: "Boost",
          size: 60,
          icon: Image.asset(
            "assets/icons/HomeSplash/home_boost.png",
            height: 36,
            width: 36,
          ),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.suggestions.length,
      padding: const EdgeInsetsDirectional.only(start: 20),
      itemBuilder: (context, index) {
        final suggestion = controller.suggestions[index];
        return Padding(
          padding: const EdgeInsets.only(
            right: 16,
          ),
          child: GlassProfileCard(
            firstLineText: suggestion['firstLine'] ?? '',
            secondLineText: suggestion['secondLine'] ?? '',
            onTap: () {},
          ),
        );
      },
    );
  }
}

