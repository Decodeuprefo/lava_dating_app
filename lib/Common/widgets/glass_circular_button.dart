import 'package:flutter/material.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'glassmorphic_background_widget.dart';

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
    final double circularRadius = size / 2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: ClipOval(
            child: GlassmorphicBackgroundWidget(
              width: size,
              height: size,
              borderRadius: circularRadius,
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
              child: icon != null ? Center(child: icon) : const SizedBox.shrink(),
            ),
          ),
        ),
        heightSpace(5),
        Text(
          label,
          style: CommonTextStyle.regular14w500.copyWith(fontFamily: "Poppins-Medium"),
        ),
      ],
    );
  }
}
