import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Common/constant/string_constants.dart';

class LoginScreenController extends GetxController {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  String? validateEmail(String value) {
    String pattern = StringConstants.regExp;
    RegExp regex = RegExp(pattern);

    if (value.isEmpty) {
      return StringConstants.emptyEmailValidation;
    } else if (!regex.hasMatch(value)) {
      return StringConstants.wrongEmailValidation;
    } else {
      return null;
    }
  }

  void changeIsPasswordVisible() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return StringConstants.emptyPasswordValidation;
    } else {
      return null;
    }
  }
}
