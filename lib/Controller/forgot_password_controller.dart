import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Api/api_controller.dart';
import '../Common/constant/custom_tools.dart';
import '../Common/constant/string_constants.dart';
import '../View/authModule/login_screen.dart';

class ForgotPasswordController extends GetxController {
  final ApiController _apiController = Get.find<ApiController>();

  final FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.emptyEmailValidation;
    }
    String pattern = StringConstants.regExp;
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return StringConstants.wrongEmailValidation;
    } else {
      return null;
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      final body = {
        'email': emailController.text.trim(),
      };

      final response = await _apiController.forgotPassword(body);

      isLoading = false;
      update();

      try {
        if (response.body == null) {
          showSnackBar(context, 'Invalid response from server. Please try again.',
              isErrorMessageDisplay: true);
          return;
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Show success message
          final responseBody = response.body as Map<String, dynamic>;
          final message = responseBody['message'] as String? ??
              'Password reset link has been sent to your email.';
          showSnackBar(context, message, isErrorMessageDisplay: false);

          // Navigate back to login screen after a short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offAll(() => const LoginScreen());
          });
        } else {
          final errorMessage = _apiController.getErrorMessage(response);
          showSnackBar(context, errorMessage, isErrorMessageDisplay: true);
        }
      } catch (e) {
        final errorMessage = _apiController.getErrorMessage(response);
        showSnackBar(context, errorMessage, isErrorMessageDisplay: true);
      }
    } catch (e) {
      isLoading = false;
      update();
      showSnackBar(context, 'Network error. Please check your connection and try again.',
          isErrorMessageDisplay: true);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.onClose();
  }
}
