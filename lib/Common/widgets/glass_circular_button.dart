import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';

class GlassCircularButton extends StatelessWidget {
  final Widget? icon;
  final String label;
  final VoidCallback? onTap;
  final double size;

  const GlassCircularButton({
    Key? key,
    this.icon,
    required this.label,
    this.onTap,
    this.size = 70.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: ClipOval(
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                // Glass effect overlay with semi-transparent purple tint
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        // const Color(0xFF2A1F3A).withOpacity(0.15),
                        // const Color(0xFF2A1F3A).withOpacity(0.20),
                        // const Color(0xFF2A1F3A).withOpacity(0.25),

                        const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.06),
                        const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.06),
                        const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.06),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                      width: 1.0,
                    ),
                  ),
                  child: icon != null ? Center(child: icon) : const SizedBox.shrink(),
                ),
                // Top-left shine/reflection for glass depth
                Positioned.fill(
                  child: IgnorePointer(
                    child: ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.12),
                              Colors.white.withOpacity(0.06),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.10, 0.20, 1.0],
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
        heightSpace(5),
        Text(
          label,
          style: CommonTextStyle.regular14w500,
        ),
      ],
    );
  }
}
