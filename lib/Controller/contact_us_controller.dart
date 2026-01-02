import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Common/constant/string_constants.dart';

class ContactUsController extends GetxController {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final FocusNode fullNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode subjectFocusNode = FocusNode();
  final FocusNode messageFocusNode = FocusNode();

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your full name";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.emptyEmailValidation;
    }
    String pattern = StringConstants.regExp;
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return StringConstants.wrongEmailValidation;
    }
    return null;
  }

  String? validateSubject(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a subject";
    }
    return null;
  }

  String? validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your message";
    }
    return null;
  }

  void sendMessage() {
    Get.back();
    Get.snackbar(
      "Success",
      "Message sent successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    fullNameFocusNode.dispose();
    emailFocusNode.dispose();
    subjectFocusNode.dispose();
    messageFocusNode.dispose();
    super.onClose();
  }
}

















































