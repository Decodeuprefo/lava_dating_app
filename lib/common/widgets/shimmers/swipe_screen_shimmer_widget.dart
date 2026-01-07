import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:shimmer/shimmer.dart';
import '../../constant/color_constants.dart';
import '../../constant/custom_tools.dart';

class SwipeScreenShimmerWidget extends StatelessWidget {
  const SwipeScreenShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.25),
      highlightColor: Colors.grey[300]!,
        child: Column(
          children: [
            // Search Bar Shimmer (with filter icon)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                // Filter icon shimmer
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(right: 20, top: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            heightSpace(20),
            // "Suggested Match" Text Shimmer
            Container(
              width: 150,
              height: 22,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            heightSpace(20),
            // Card Stack Area Shimmer
            Container(
              height: 495,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  // Card content placeholder (image area)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  // Bottom gradient overlay placeholder
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name placeholder
                          Container(
                            width: 200,
                            height: 24,
                            margin: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          // Location placeholder
                          Container(
                            width: 150,
                            height: 16,
                            margin: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          // Bio placeholder
                          Container(
                            width: double.infinity,
                            height: 14,
                            margin: const EdgeInsets.only(bottom: 4, left: 20, right: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            width: 250,
                            height: 14,
                            margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Action Buttons Shimmer
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildShimmerActionButton(),
                        widthSpace(20),
                        _buildShimmerActionButton(size: 70),
                        widthSpace(20),
                        _buildShimmerActionButton(),
                      ],
                    ).marginSymmetric(horizontal: 20, vertical: 20),
                  ),
                ],
              ),
            ),
            heightSpace(25),
            // Progress Bar Shimmer
            Container(
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            heightSpace(50),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerActionButton({double size = 60}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
    );
  }
}
