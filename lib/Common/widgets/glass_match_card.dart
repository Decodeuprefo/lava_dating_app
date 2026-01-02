import 'package:flutter/material.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import '../constant/common_text_style.dart';
import '../constant/color_constants.dart';
import 'glassmorphic_background_widget.dart';

/// Match card widget with glass effect - smaller size for Matches section
/// Fixed dimensions: width 100, height 140
class GlassMatchCard extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String age;
  final VoidCallback? onTap;

  const GlassMatchCard({
    Key? key,
    this.imageUrl,
    required this.name,
    required this.age,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicBackgroundWidget(
        width: 112,
        borderRadius: 10.0,
        blur: 8.0,
        border: 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        alignment: Alignment.center,
        linearGradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(255, 255, 255, 0.11),
            Color.fromRGBO(255, 255, 255, 0.11),
          ],
          stops: [0.5, 0.5],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
            const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
            const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
            const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
            const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
            const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
            const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
          ],
          stops: const [0.0, 0.5, 1.0, 0.55, 0.70, 0.85, 1.00],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: ClipOval(
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/user_placeholder.png",
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        "assets/images/user_placeholder.png",
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            heightSpace(8),
            Text(
              name,
              style: CommonTextStyle.regular10w500.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            heightSpace(5),
            Text(
              age,
              style: CommonTextStyle.regular10w500,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
