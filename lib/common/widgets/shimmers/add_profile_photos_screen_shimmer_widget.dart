import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:shimmer/shimmer.dart';
import '../../constant/common_text_style.dart';
import '../../constant/custom_tools.dart';
import '../glassmorphic_background_widget.dart';

class AddProfilePhotosScreenShimmerWidget extends StatelessWidget {
  const AddProfilePhotosScreenShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white12,
      highlightColor: Colors.grey[700]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
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
                  width: 200,
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
                heightSpace(4),
                Container(
                  width: 300,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                heightSpace(4),
                Container(
                  width: 280,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                heightSpace(50),
                // Photo grid shimmer
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 30,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return _buildShimmerPhotoCard();
                    },
                  ),
                ),
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
                "Continue",
                style: CommonTextStyle.regular16w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerPhotoCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          Positioned(
            bottom: -15,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
