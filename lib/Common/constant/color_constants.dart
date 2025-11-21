import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

class ColorConstants {
  ColorConstants._();

  static const Color neutralStrongDark = Color(0xFFFFFFFF);
  static const Color greyLight = Color(0xff777777);
  static const Color offGrey = Color(0xff7A7A7A);
  static const Color lightOrange = Color(0xffF33F02);
  static const Color circularColor = Color(0xFFD9D9D9);

  static Color get colorTextNeutralStrong => Colors.white;

  static Color get colorTextNeutralTertiary => const Color(0x66FFFFFF);

  static Color get colorTextNeutralOnSecondaryTertiary => Colors.white.withOpacity(0.6);
  static const errorTextColor = Color(0xFFC90007);

  static Color get colorBGNeutralSecondary => const Color(0x14FFFFFF);

  static Color get colorBorderDangerStrong => const Color(0xffDB1C26);

  static Color get colorIconNeutralStrong => Colors.white;

  static Color get neutralStrong => ColorConstants.neutralStrongDark;

  static Color get bottomSheetBackgroundChange => const Color(0xFF212121);
}
