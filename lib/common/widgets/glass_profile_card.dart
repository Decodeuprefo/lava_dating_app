import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import '../constant/common_text_style.dart';
import '../constant/color_constants.dart';
import 'glassmorphic_background_widget.dart';

class GlassProfileCard extends StatelessWidget {
  final String? imageUrl;
  final String firstLineText;
  final String secondLineText;
  final VoidCallback? onTap;
  final bool showViewProfile;

  const GlassProfileCard({
    Key? key,
    this.imageUrl,
    required this.firstLineText,
    required this.secondLineText,
    this.onTap,
    this.showViewProfile = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicBackgroundWidget(
        width: 158,
        height: 180,
        borderRadius: 15.0,
        blur: 8.0,
        border: 0.8,
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
            heightSpace(15),
            SizedBox(
              width: 74,
              height: 74,
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
            heightSpace(5),
            Text(
              firstLineText,
              style: CommonTextStyle.regular10w500,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ).marginSymmetric(horizontal: 10),
            heightSpace(12),
            Text(
              secondLineText,
              style: CommonTextStyle.regular14w600,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (showViewProfile) ...[
              heightSpace(4),
              Text(
                "view Profile",
                style: CommonTextStyle.regular12w400.copyWith(
                    color: ColorConstants.lightOrange,
                    decoration: TextDecoration.underline,
                    decorationColor: ColorConstants.lightOrange),
                textAlign: TextAlign.center,
              ).marginOnly(bottom: 8),
            ] else
              heightSpace(8),
          ],
        ),
      ),
    );
  }
}
