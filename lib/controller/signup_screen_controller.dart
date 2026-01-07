import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Api/api_controller.dart';
import '../Common/constant/custom_tools.dart';
import '../Common/constant/string_constants.dart';
import '../Common/services/storage_service.dart';
import '../Common/utils/profile_navigation_helper.dart';
import '../Model/signup_model.dart';
import '../View/authModule/login_screen.dart';
import '../View/setProfileModule/select_gender_screen.dart';

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

  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringConstants.firstNameRequired;
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return StringConstants.firstNameInvalidChars;
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringConstants.lastNameRequired;
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return StringConstants.lastNameInvalidChars;
    }
    return null;
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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.passwordRequired;
    }

    if (value.length < 8) {
      return StringConstants.passwordMinLength;
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return StringConstants.passwordMissingLowercase;
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return StringConstants.passwordMissingUppercase;
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_+\-=\[\]\\;\/`~]'))) {
      return StringConstants.passwordMissingSpecialChar;
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.confirmPasswordRequired;
    }
    if (value != passController.text) {
      return StringConstants.confirmPasswordMismatch;
    }
    return null;
  }

  String? validateMobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return StringConstants.mobileNumberRequired;
    }
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length < 7) {
      return StringConstants.mobileNumberMinLength;
    }
    if (digitsOnly.length > 15) {
      return StringConstants.mobileNumberInvalidFormat;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(digitsOnly)) {
      return StringConstants.mobileNumberInvalidFormat;
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
          if (signupResponse.isSuccess) {
            if (signupResponse.accessToken != null && signupResponse.refreshToken != null) {
              await StorageService.saveTokens(
                signupResponse.accessToken!,
                signupResponse.refreshToken!,
              );
            }
            Get.offAll(() => const SelectGenderScreen());
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
