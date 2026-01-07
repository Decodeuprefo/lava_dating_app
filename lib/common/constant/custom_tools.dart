import 'package:flutter/material.dart';
import '../../Common/constant/common_text_style.dart';
import 'color_constants.dart';

Widget heightSpace(double value) => SizedBox(height: value);

Widget widthSpace(double value) => SizedBox(width: value);

Widget socialButton({Widget? child, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Center(child: child),
    ),
  );
}

enum TextType { head, des }

class CommonTextWidget extends StatelessWidget {
  final String text;
  final TextType textType;
  final TextAlign textAlign;

  const CommonTextWidget({
    Key? key,
    required this.text,
    required this.textType,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style;

    switch (textType) {
      case TextType.head:
        style = CommonTextStyle.semiBold30w600;
        break;
      case TextType.des:
        style = CommonTextStyle.regular14w400;
        break;
    }

    return Text(
      text,
      style: style,
      textAlign: textAlign,
    );
  }
}

void showSnackBar(
  BuildContext context,
  String? message, {
  bool isErrorMessageDisplay = false,
  String? iconPath,
}) {
  if (message == null ||
      (!isErrorMessageDisplay && message.toLowerCase().contains('something went'))) {
    return;
  }

  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  // Default icon path, can be overridden
  final String defaultIconPath = iconPath ?? "assets/icons/alert_icon.png";

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 15,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20).copyWith(right: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Alert icon on the left
              Image.asset(
                defaultIconPath,
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to default icon if custom icon fails to load
                  return Image.asset(
                    "assets/icons/alert_icon.png",
                    width: 24,
                    height: 24,
                  );
                },
              ),
              widthSpace(12),
              Expanded(
                child: Text(
                  message,
                  style: CommonTextStyle.regular16w500.copyWith(
                    color: ColorConstants.lightOrange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  // Auto remove after duration
  Future.delayed(const Duration(seconds: 3), () {
    try {
      overlayEntry.remove();
    } catch (e) {
      // Overlay entry already removed
    }
  });
}

class FullWidthRangeSliderTrackShape extends RoundedRectRangeSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width; // Yahan full width set ho rahi hai
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class FullWidthSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class BorderedRangeSliderThumbShape extends RangeSliderThumbShape {
  final double enabledThumbRadius;
  final double borderWidth;

  const BorderedRangeSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.borderWidth = 1.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = true,
    bool isOnTop = false,
    TextDirection textDirection = TextDirection.ltr,
    required SliderThemeData sliderTheme,
    Thumb thumb = Thumb.start,
    bool isPressed = false,
  }) {
    final Canvas canvas = context.canvas;

    // Draw border (light orange)
    final Paint borderPaint = Paint()
      ..color = ColorConstants.lightOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Draw thumb (white)
    final Paint thumbPaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.white
      ..style = PaintingStyle.fill;

    // Draw white thumb circle
    canvas.drawCircle(center, enabledThumbRadius, thumbPaint);

    // Draw light orange border circle
    canvas.drawCircle(center, enabledThumbRadius, borderPaint);
  }
}

class BorderedSliderThumbShape extends SliderComponentShape {
  final double enabledThumbRadius;
  final double borderWidth;

  const BorderedSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.borderWidth = 1.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Draw border (light orange)
    final Paint borderPaint = Paint()
      ..color = ColorConstants.lightOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Draw thumb (white)
    final Paint thumbPaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.white
      ..style = PaintingStyle.fill;

    // Draw white thumb circle
    canvas.drawCircle(center, enabledThumbRadius, thumbPaint);

    // Draw light orange border circle
    canvas.drawCircle(center, enabledThumbRadius, borderPaint);
  }
}

class CustomSliderThumb extends SliderComponentShape {
  final double enabledThumbRadius;

  const CustomSliderThumb({
    this.enabledThumbRadius = 12.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Paint thumbPaint = Paint()
      ..color = ColorConstants.lightOrange
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = ColorConstants.neutralStrongDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawCircle(center, enabledThumbRadius, thumbPaint);
    canvas.drawCircle(center, enabledThumbRadius, borderPaint);
  }
}
