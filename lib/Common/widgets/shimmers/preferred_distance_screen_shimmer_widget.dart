import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:shimmer/shimmer.dart';
import '../../constant/common_text_style.dart';
import '../../constant/custom_tools.dart';
import '../glassmorphic_background_widget.dart';

class PreferredDistanceScreenShimmerWidget extends StatelessWidget {
  const PreferredDistanceScreenShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white12,
      highlightColor: Colors.grey[700]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heightSpace(13),
                  // Back arrow shimmer
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  heightSpace(90),
                  // Title shimmer
                  Container(
                    width: 320,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  heightSpace(5),
                  // Description shimmer
                  Container(
                    width: 280,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  heightSpace(30),
                  // Map image shimmer
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  heightSpace(30),
                  // "Preferred Distance" label shimmer
                  Container(
                    width: 180,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  heightSpace(20),
                  // Slider shimmer
                  _buildShimmerSlider(),
                  heightSpace(30),
                  // Info text shimmer
                  GlassmorphicBackgroundWidget(
                    borderRadius: 10.0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                    blur: 8.0,
                    border: 0.8,
                    child: Container(
                      width: double.infinity,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  heightSpace(40),
                ],
              ).marginSymmetric(horizontal: 20),
            ),
          ),
          // Continue button shimmer
          Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                "Continue",
                style: CommonTextStyle.regular16w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Slider track shimmer
        Container(
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        heightSpace(10),
        // Min/Max labels shimmer
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 50,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

