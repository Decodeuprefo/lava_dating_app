import 'package:flutter/material.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';

class CongratulationsScreen extends StatefulWidget {
  final String? user1ImageUrl;
  final String? user2ImageUrl;
  final VoidCallback? onSayHello;
  final VoidCallback? onKeepSwiping;

  const CongratulationsScreen({
    super.key,
    this.user1ImageUrl,
    this.user2ImageUrl,
    this.onSayHello,
    this.onKeepSwiping,
  });

  @override
  State<CongratulationsScreen> createState() => _CongratulationsScreenState();
}

class _CongratulationsScreenState extends State<CongratulationsScreen> {
  final String womanImageUrl =
      "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=688&auto=format&fit=crop";
  final String manImageUrl =
      "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=687&auto=format&fit=crop";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  heightSpace(30),
                  const Text(
                    "Congratulation",
                    style: CommonTextStyle.regular40w400,
                    textAlign: TextAlign.center,
                  ),
                  heightSpace(35),
                  _buildProfileImages(),
                  heightSpace(25),
                  Text(
                    "It's a Match",
                    style: CommonTextStyle.semiBold30w600.copyWith(
                      fontSize: 26,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  heightSpace(5),
                  const Text(
                    "Start conversation now to each other",
                    style: CommonTextStyle.regular14w400,
                    textAlign: TextAlign.center,
                  ),
                  heightSpace(25),
                  _buildButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImages() {
    final size = MediaQuery.of(context).size;
    final double availableWidth = size.width - 40;
    final double containerHeight = size.height * 0.6;

    // Card dimensions
    const double cardWidth = 160;
    const double cardHeight = 240;

    final double centerX = availableWidth / 2;
    const double overlapOffset = 35.0;

    // Use provided URLs or fallback to placeholder URLs
    final String user1Url = widget.user1ImageUrl ?? womanImageUrl;
    final String user2Url = widget.user2ImageUrl ?? manImageUrl;

    return SizedBox(
      width: double.infinity,
      height: 410,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: containerHeight * 0.10,
            left: 160,
            child: TiltedCard(
              imageUrl: user2Url,
              angle: 0.18,
              width: cardWidth,
              height: cardHeight,
              elevation: 10,
            ),
          ),

          Positioned(
            top: 0,
            left: centerX - 60,
            child: SizedBox(
              width: 130,
              height: 130,
              child: Image.asset(
                "assets/icons/cong_like1.png",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                        width: 50,
                        height: 50,
                        decoration:
                            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.favorite, color: Colors.red, size: 30)),
                  );
                },
              ),
            ),
          ),

          // --- Front Card (The Woman) ---
          // Positioned to the left of center
          Positioned(
            top: containerHeight * 0.30,
            left: centerX - overlapOffset - (cardWidth / 2),
            child: TiltedCard(
              imageUrl: user1Url,
              angle: -0.15,
              width: cardWidth,
              height: cardHeight,
              elevation: 20,
            ),
          ),

          Positioned(
            bottom: -70,
            left: 30,
            child: SizedBox(
              width: 130,
              height: 130,
              child: Image.asset(
                "assets/icons/cong_like2.png",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        AppButton(
          text: "Say Hello",
          onPressed: widget.onSayHello ?? () {},
          backgroundColor: Colors.transparent,
          borderColor: ColorConstants.lightOrange,
          borderRadius: 12,
          padding: const EdgeInsets.symmetric(vertical: 16),
          width: double.infinity,
          textStyle: CommonTextStyle.regular16w500.copyWith(
            color: Colors.white,
          ),
          elevation: 0,
        ),
        heightSpace(20),
        AppButton(
          text: "Keep Swipping",
          onPressed: widget.onKeepSwiping ?? () {},
          backgroundColor: ColorConstants.lightOrange,
          borderRadius: 12,
          padding: const EdgeInsets.symmetric(vertical: 16),
          width: double.infinity,
          textStyle: CommonTextStyle.regular16w500.copyWith(
            color: Colors.white,
          ),
          elevation: 0,
        ),
      ],
    );
  }
}

class TiltedCard extends StatelessWidget {
  final String imageUrl;
  final double angle; // In radians
  final double width;
  final double height;
  final double elevation;

  const TiltedCard({
    super.key,
    required this.imageUrl,
    required this.angle,
    required this.width,
    required this.height,
    this.elevation = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), // Large rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: 2,
              offset: const Offset(10, 20), // Shadow cast downwards
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            imageUrl,
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
                    color: Colors.white24,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade900,
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.white54, size: 40),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
