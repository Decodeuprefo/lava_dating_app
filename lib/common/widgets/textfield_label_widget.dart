import 'package:flutter/material.dart';
import '../constant/color_constants.dart';

class TextFieldLabelWidget extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double fontHeight;

  const TextFieldLabelWidget({super.key, required this.text, this.textColor, this.fontHeight = 20});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor ?? ColorConstants.colorTextNeutralStrong,
        fontWeight: FontWeight.w600,
        // fontFamily: FontFamily.inter,
        fontSize: 15,
        height: fontHeight / 15,
        letterSpacing: -0.3,
      ),
    );
  }
}
