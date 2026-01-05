import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Api/api_controller.dart';
import '../Common/constant/custom_tools.dart';
import '../Common/constant/string_constants.dart';
import '../Model/signup_model.dart';
import '../View/authModule/login_screen.dart';

class SignupScreenController extends GetxController {
  final ApiController _apiController = Get.find<ApiController>();

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
  bool isLoading = false;

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

  /// To validate mobile number - must be exactly 10 digits
  String? validateMobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringConstants.emptyMobileNumber;
    }
    // Remove any non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length != 10) {
      return 'Mobile number must be exactly 10 digits';
    }
    return null;
  }

  /// Sign up API call
  Future<void> signUp(BuildContext context) async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      // Prepare request body - ensure mobile number has + prefix if not present
      String mobileNumber = mobileNumberController.text.trim();
      if (mobileNumber.isNotEmpty && !mobileNumber.startsWith('+')) {
        mobileNumber = '+$mobileNumber';
      }

      final body = {
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passController.text,
        'confirmPassword': confPassController.text,
        'mobileNumber': mobileNumber,
      };

      // Make API call
      final response = await _apiController.userSignUp(body);

      isLoading = false;
      update();

      // Parse response body
      try {
        if (response.body == null) {
          showSnackBar(context, 'Invalid response from server. Please try again.',
              isErrorMessageDisplay: true);
          return;
        }

        final signupResponse = SignupResponse.fromJson(response.body as Map<String, dynamic>);

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Success response
          if (signupResponse.isSuccess) {
            // Navigate to login screen on success
            Get.offAll(() => const LoginScreen());
          } else {
            // Handle error message in success status code
            final errorMessage =
                signupResponse.message ?? signupResponse.error ?? 'Something went wrong';
            showSnackBar(context, errorMessage, isErrorMessageDisplay: true);
          }
        } else {
          // Error response (409, 400, etc.)
          final errorMessage = signupResponse.message ??
              signupResponse.error ??
              _apiController.getErrorMessage(response);
          showSnackBar(context, errorMessage, isErrorMessageDisplay: true);
        }
      } catch (e) {
        // If parsing fails, use default error message
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
    // Unfocus all focus nodes before disposing to prevent errors
    try {
      firstNameFocusNode.unfocus();
      lastNameFocusNode.unfocus();
      mobileNumberFocusNode.unfocus();
      emailFocusNode.unfocus();
      passwordFocusNode.unfocus();
      confPasswordFocusNode.unfocus();
    } catch (e) {
      // Ignore errors if already unfocused
    }
    // Dispose text controllers
    firstNameController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    passController.dispose();
    confPassController.dispose();
    // Dispose focus nodes
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    mobileNumberFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confPasswordFocusNode.dispose();
    super.onClose();
  }
}
