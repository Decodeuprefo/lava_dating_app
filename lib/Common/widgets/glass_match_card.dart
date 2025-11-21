import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import '../constant/common_text_style.dart';
import '../constant/color_constants.dart';

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
      child: SizedBox(
        width: 100,
        height: 140,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: 100,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent,
                  ),
                ),
              ),
              // Glass effect overlay with semi-transparent purple tint
              Container(
                width: 100,
                height: 140,
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
                    heightSpace(12),
                    // Profile picture placeholder
                    Container(
                      width: 55,
                      height: 55,
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
                    heightSpace(8),
                    // Name text
                    Text(
                      name,
                      style: CommonTextStyle.regular10w500,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    heightSpace(4),
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
              // Top-left shine/reflection for glass depth
              Positioned.fill(
                child: IgnorePointer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 100,
                      height: 140,
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

