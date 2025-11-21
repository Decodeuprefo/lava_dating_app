import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Common/constant/common_text_style.dart';
import '../Common/constant/color_constants.dart';
import '../Common/constant/custom_tools.dart';
import '../Common/widgets/custom_background.dart';
import '../Common/widgets/glass_background_widget.dart';
import '../Common/widgets/glass_circular_button.dart';
import '../Common/widgets/glass_profile_card.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final RxInt matchesCount = 16.obs;
  final RxInt swipesLeft = 16.obs;
  final RxInt totalSwipes = 30.obs;
  final RxBool isUnlimitedSwipes = true.obs;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightSpace(20),
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
                heightSpace(40),
                // Circular glass buttons row
                _buildCircularGlassButtons(),
                heightSpace(30),

              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildCircularGlassButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GlassCircularButton(
          label: "Search",
          size: 70,
          onTap: () {
            // Handle search tap
          },
        ),
        GlassCircularButton(
          label: "Like",
          size: 70,
          onTap: () {
            // Handle like tap
          },
        ),
        GlassCircularButton(
          label: "Settings",
          size: 70,
          onTap: () {
            // Handle settings tap
          },
        ),
        GlassCircularButton(
          label: "Boost",
          size: 70,
          onTap: () {
            // Handle boost tap
          },
        ),
      ],
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
}
