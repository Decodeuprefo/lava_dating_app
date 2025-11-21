import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import '../constant/common_text_style.dart';
import '../constant/color_constants.dart';

class GlassProfileCard extends StatelessWidget {
  final String? imageUrl;
  final String firstLineText;
  final String secondLineText;
  final VoidCallback? onTap;

  const GlassProfileCard({
    Key? key,
    this.imageUrl,
    required this.firstLineText,
    required this.secondLineText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        height: 170,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: 150,
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent,
                  ),
                ),
              ),
              // Glass effect overlay with semi-transparent purple tint
              Container(
                width: 150,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2A1F3A).withOpacity(0.15),
                      const Color(0xFF2A1F3A).withOpacity(0.20),
                      const Color(0xFF2A1F3A).withOpacity(0.25),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    heightSpace(15),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: imageUrl != null && imageUrl!.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(color: Colors.black);
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    heightSpace(5),
                    Text(
                      firstLineText,
                      style: CommonTextStyle.regular10w500,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    heightSpace(12),
                    Text(
                      secondLineText,
                      style: CommonTextStyle.regular14w600,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    heightSpace(4),
                    Text(
                      "View Profile",
                      style: CommonTextStyle.regular12w400.copyWith(
                          color: ColorConstants.lightOrange,
                          decoration: TextDecoration.underline,
                          decorationColor: ColorConstants.lightOrange),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 150,
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.08),
                            Colors.white.withOpacity(0.04),
                            Colors.transparent,
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.15, 0.30, 0.50, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
