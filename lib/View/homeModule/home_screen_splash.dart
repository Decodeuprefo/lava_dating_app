import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Common/widgets/glass_background_widget.dart';
import 'package:lava_dating_app/Controller/home_screen_controller.dart';
import 'package:lava_dating_app/View/chatModule/notification_list_screen.dart';
import 'package:lava_dating_app/View/homeModule/swipe_screen.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/widgets/animated_white_button.dart';
import '../../Common/widgets/glass_circular_button.dart';
import '../../Common/widgets/glass_profile_card.dart';
import '../../Common/widgets/glass_match_card.dart';

class HomeScreenSplash extends StatefulWidget {
  const HomeScreenSplash({super.key});

  @override
  State<HomeScreenSplash> createState() => _HomeScreenSplashState();
}

class _HomeScreenSplashState extends State<HomeScreenSplash> {
  final RxInt matchesCount = 16.obs;
  final RxInt swipesLeft = 16.obs;
  final RxInt totalSwipes = 30.obs;
  final RxBool isUnlimitedSwipes = true.obs;
  final controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
          child: SafeArea(
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
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.to(() => const NotificationListScreen());
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            "assets/icons/notification_icon.png",
                            height: 30,
                            width: 30,
                          ),
                        ),
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
                  // Horizontal scrollable profile cards
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
                  heightSpace(20)
                ],
              ),
              heightSpace(100),
            ],
          ),
        ),
      )),
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
            onTap: () {
              // _showSafetyDialog(context);
              _showSafetyDialog(Navigator.of(context, rootNavigator: true).context);
            },
          ),
        );
      },
    );
  }

  void _showSafetyDialog(BuildContext context) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    showGeneralDialog(
      context: rootContext,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.5),
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final media = MediaQuery.of(context).size;
        final dialogWidth = media.width * 0.88 > 480 ? 480.0 : media.width * 0.88;
        final dialogMaxHeight = media.height * 0.72;
        return Center(
          child: FadeTransition(
            opacity: animation,
            child: Material(
              type: MaterialType.transparency,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: media.width,
                  maxHeight: dialogMaxHeight,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: GlassBackgroundWidget(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/icons/HomeSplash/warning_icon.png",
                              height: 28,
                              width: 28,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(width: 12),
                            const Text("Stay Safe", style: CommonTextStyle.regular16w500),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Be cautious about sharing personal information with strangers. Never share financial or sensitive details.",
                          style: CommonTextStyle.regular12w400,
                        ),
                        heightSpace(28),
                        Center(
                          child: AnimatedWhiteButton(
                            label: 'Got it',
                            width: 100,
                            height: 35,
                            onTap: () {
                              print('Got it tapped');
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ).marginSymmetric(horizontal: 20);
      },
    );
  }

  Widget _buildMatchesCard() {
    return Obx(() => GlassBackgroundWidget(
          borderRadius: 15,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Matches",
                style: CommonTextStyle.regular18w500,
              ),
              heightSpace(4),
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
            // Text content
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
            onTap: () {
              Get.to(() => const SwipeScreen());
            },
          ),
        );
      },
    );
  }
}
