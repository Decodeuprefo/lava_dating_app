import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:shimmer/shimmer.dart';
import '../../constant/common_text_style.dart';
import '../../constant/custom_tools.dart';
import '../glassmorphic_background_widget.dart';

class AboutMeScreenShimmerWidget extends StatelessWidget {
  const AboutMeScreenShimmerWidget({Key? key}) : super(key: key);

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
                    width: 280,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  heightSpace(10),
                  // Description shimmer
                  Container(
                    width: double.infinity,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  heightSpace(50),
                  // TextFormField shimmer
                  _buildShimmerTextField(),
                  heightSpace(8),
                  // Character count shimmer
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 60,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ).marginSymmetric(horizontal: 20),
            ),
          ),
          // Continue button shimmer
          Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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

  Widget _buildShimmerTextField() {
    return GlassmorphicBackgroundWidget(
      borderRadius: 8.0,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      blur: 8.0,
      border: 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          heightSpace(8),
          Container(
            width: double.infinity,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          heightSpace(8),
          Container(
            width: 250,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
