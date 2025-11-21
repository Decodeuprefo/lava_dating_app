import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Common/constant/string_constants.dart';

class SignupScreenController extends GetxController {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confPassController = TextEditingController();
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode mobileNumberFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confPasswordFocusNode = FocusNode();
  bool isPasswordVisible = false;
  bool isConfPasswordVisible = false;

  /// To validate field is not empty
  String? validateFieldNotEmpty(String? value, String msg) {
    if (value == null || value.trim().isEmpty) {
      return msg;
    } else {
      return null;
    }
  }

  /// To validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.emptyEmailValidation;
    }
    // Email regex pattern
    String pattern = StringConstants.regExp;
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return StringConstants.wrongEmailValidation;
    } else {
      return null;
    }
  }

  void changeIsPasswordVisible() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  void changeIsConfPasswordVisible() {
    isConfPasswordVisible = !isConfPasswordVisible;
    update();
  }

  /// To validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.emptyPasswordValidation;
    } else {
      return null;
    }
  }

  /// To validate confirm password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.emptyConfPasswordValidation;
    } else if (value != passController.text) {
      return "Passwords do not match";
    } else {
      return null;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    passController.dispose();
    confPassController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    mobileNumberFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confPasswordFocusNode.dispose();
    super.onClose();
  }
}
