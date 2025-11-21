import 'package:flutter/material.dart';
import '../../Common/constant/common_text_style.dart';
import 'color_constants.dart';

Widget heightSpace(double value) => SizedBox(height: value);

Widget widthSpace(double value) => SizedBox(width: value);

Widget socialButton({Widget? child}) {
  return Container(
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

void showSnackBar(BuildContext context, String? message, {bool isErrorMessageDisplay = false}) {
  if (message == null ||
      (!isErrorMessageDisplay && message.toLowerCase().contains('something went'))) {
    return;
  }

  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 15,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: ColorConstants.lightOrange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  message,
                  style: CommonTextStyle.regular16w500,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: () {
                  overlayEntry.remove();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  // Auto remove after duration
  Future.delayed(const Duration(milliseconds: 2500), () {
    try {
      overlayEntry.remove();
    } catch (e) {
      // Overlay entry already removed
    }
  });
}
