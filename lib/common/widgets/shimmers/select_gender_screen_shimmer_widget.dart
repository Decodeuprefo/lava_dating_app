import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:shimmer/shimmer.dart';
import '../../constant/common_text_style.dart';
import '../../constant/custom_tools.dart';
import '../glassmorphic_background_widget.dart';

class SelectGenderScreenShimmerWidget extends StatelessWidget {
  const SelectGenderScreenShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.25),
      highlightColor: Colors.grey[300]!,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightSpace(130),
                // Title shimmer
                Container(
                  width: 250,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                heightSpace(10),
                // Description shimmer
                Container(
                  width: double.infinity,
                  height: 14,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                heightSpace(4),
                Container(
                  width: 280,
                  height: 14,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                heightSpace(50),
                // Gender tiles shimmer
                _buildShimmerGenderTile(),
                heightSpace(10),
                _buildShimmerGenderTile(),
                heightSpace(10),
                _buildShimmerGenderTile(),
                const SizedBox(height: 24),
              ],
            ).marginSymmetric(horizontal: 20),
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
                "",
                style: CommonTextStyle.regular16w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGenderTile() {
    return GlassmorphicBackgroundWidget(
      borderRadius: 10.0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      blur: 8.0,
      border: 0.8,
      child: Container(
        height: 14,
        width: 150,
        decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
