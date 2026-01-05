import 'package:flutter/material.dart';
import '../constant/color_constants.dart';
import '../constant/common_text_style.dart';
import 'glassmorphic_background_widget.dart';

class GlassContainerWidget extends StatelessWidget {
  final String text;
  final String? imagePath;
  final String? emoji;
  final bool isSelected;
  final VoidCallback? onTap;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double? imageWidth;
  final double? imageHeight;

  const GlassContainerWidget({
    Key? key,
    required this.text,
    this.imagePath,
    this.emoji,
    this.isSelected = false,
    this.onTap,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.imageWidth,
    this.imageHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? 10.0;
    final EdgeInsetsGeometry containerPadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 14);

    final LinearGradient borderGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isSelected
          ? [
              ColorConstants.lightOrange,
              ColorConstants.lightOrange,
              ColorConstants.lightOrange,
              ColorConstants.lightOrange,
              ColorConstants.lightOrange,
              ColorConstants.lightOrange,
              ColorConstants.lightOrange,
            ]
          : [
              const Color(0x66A898B8),
              const Color(0x66A898B8),
              const Color(0x66A898B8),
              const Color(0x66A898B8),
              const Color(0x66A898B8),
              const Color(0x66A898B8),
              const Color(0x66A898B8),
            ],
      stops: const [0.0, 0.5, 1.0, 0.55, 0.70, 0.85, 1.00],
    );

    Widget content = Stack(
      children: [
        GlassmorphicBackgroundWidget(
          borderRadius: radius,
          padding: containerPadding,
          blur: 8.0,
          border: isSelected ? 2.0 : 0.8,
          borderGradient: borderGradient,
          child: _buildContent(),
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Color(0x66BBA8A8),
              // Color(0x55AFA0A0),
              const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.1),
              const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.1),
              const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.1),
            ],
            // stops: [0.0, 1.0],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        // Subtle top-left shine for depth
        /* Positioned.fill(
          child: IgnorePointer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.08), // Subtle shine on top-left
                      Colors.white.withOpacity(0.04), // Fading
                      Colors.transparent, // Transparent in middle
                      Colors.transparent, // Transparent on bottom-right
                    ],
                    stops: const [0.0, 0.25, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ),*/
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }

  Widget _buildContent() {
    if (imagePath != null && imagePath!.isNotEmpty) {
      final double imgWidth = imageWidth ?? 24.0;
      final double imgHeight = imageHeight ?? 24.0;
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath!,
            width: imgWidth,
            height: imgHeight,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _buildFallbackContent();
            },
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: textStyle ?? CommonTextStyle.regular14w400,
          ),
        ],
      );
    }

    if (emoji != null && emoji!.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji!,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: textStyle ??
                const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
          ),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: textStyle ?? CommonTextStyle.regular14w400,
        ),
      ],
    );
  }

  Widget _buildFallbackContent() {
    // Fallback when image fails to load
    if (emoji != null && emoji!.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji!,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: textStyle ?? CommonTextStyle.regular14w400,
          ),
        ],
      );
    }

    // Just text if no emoji fallback
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: textStyle ?? CommonTextStyle.regular14w400,
        ),
      ],
    );
  }
}
