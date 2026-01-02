import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Api/api_controller.dart';
import '../Common/constant/custom_tools.dart';
import '../Common/constant/string_constants.dart';
import '../Common/services/storage_service.dart';
import '../Common/utils/profile_navigation_helper.dart';
import '../Model/signup_model.dart';
import '../View/authModule/login_screen.dart';
import '../View/homeModule/dashboard_screen.dart';
import '../View/setProfileModule/select_gender_screen.dart';

class LoginScreenController extends GetxController {
  final ApiController _apiController = Get.find<ApiController>();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Use explicit clientId - make sure this matches Firebase Console OAuth client
    clientId: '253320762898-jpssr4ina2b1oe3rl6ih62ge6aofnvop.apps.googleusercontent.com',
  );

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
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

  void changeIsPasswordVisible() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.emptyPasswordValidation;
    } else {
      return null;
    }
  }

  /// Login API call
  Future<void> login(BuildContext context) async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      final body = {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      final response = await _apiController.userLoginIn(body);

      isLoading = false;
      update();

      // Parse response body
      try {
        if (response.body == null) {
          showSnackBar(context, 'Invalid response from server. Please try again.',
              isErrorMessageDisplay: true);
          return;
        }

        final loginResponse = SignupResponse.fromJson(response.body as Map<String, dynamic>);

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Success response
          if (loginResponse.isSuccess) {
            // Save tokens to local storage
            if (loginResponse.accessToken != null && loginResponse.refreshToken != null) {
              await StorageService.saveTokens(
                loginResponse.accessToken!,
                loginResponse.refreshToken!,
              );
            }

            // Check profile completion and navigate accordingly
            final responseBody = response.body as Map<String, dynamic>;
            final userData = responseBody['user'] as Map<String, dynamic>?;
            
            if (userData != null) {
              // Check if profile is complete
              final isProfileComplete = userData['isProfileComplete'] as bool? ?? false;
              if (isProfileComplete) {
                Get.offAll(() => const DashboardScreen());
              } else {
                // Determine next screen based on incomplete fields
                final nextScreen = ProfileNavigationHelper.determineNextScreen(userData);
                Get.offAll(() => nextScreen);
              }
            } else {
              // Fallback to first screen if user data is not available
              Get.offAll(() => const SelectGenderScreen());
            }
          } else {
            // Handle error message in success status code
            final errorMessage =
                loginResponse.message ?? loginResponse.error ?? 'Something went wrong';
            showSnackBar(context, errorMessage, isErrorMessageDisplay: true);
          }
        } else {
          // Error response (401, 400, etc.)
          final errorMessage = loginResponse.message ??
              loginResponse.error ??
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

  /// Google Social Login - Common method for both Login and Signup screens
  Future<void> googleLogin(BuildContext context) async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        isLoading = false;
        update();
        return;
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        isLoading = false;
        update();
        showSnackBar(context, 'Failed to get Google authentication token.',
            isErrorMessageDisplay: true);
        return;
      }

      // Extract first and last name from display name
      String firstName = '';
      String lastName = '';
      if (googleUser.displayName != null && googleUser.displayName!.isNotEmpty) {
        final nameParts = googleUser.displayName!.split(' ');
        firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      }

      // Prepare API request body
      final body = {
        'provider': 'google',
        'idToken': googleAuth.idToken,
        'firstName': firstName,
        'lastName': lastName,
      };

      // Call social login API
      final response = await _apiController.socialLogin(body);

      isLoading = false;
      update();

      try {
        if (response.body == null) {
          showSnackBar(context, 'Invalid response from server. Please try again.',
              isErrorMessageDisplay: true);
          return;
        }

        final loginResponse = SignupResponse.fromJson(response.body as Map<String, dynamic>);

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Success response
          if (loginResponse.isSuccess) {
            // Save tokens to local storage
            if (loginResponse.accessToken != null && loginResponse.refreshToken != null) {
              await StorageService.saveTokens(
                loginResponse.accessToken!,
                loginResponse.refreshToken!,
              );
            }

            // Check profile completion and navigate accordingly
            final responseBody = response.body as Map<String, dynamic>;
            final userData = responseBody['user'] as Map<String, dynamic>?;
            
            if (userData != null) {
              // Check if profile is complete
              final isProfileComplete = userData['isProfileComplete'] as bool? ?? false;
              if (isProfileComplete) {
                Get.offAll(() => const DashboardScreen());
              } else {
                // Determine next screen based on incomplete fields
                final nextScreen = ProfileNavigationHelper.determineNextScreen(userData);
                Get.offAll(() => nextScreen);
              }
            } else {
              // Fallback to first screen if user data is not available
              Get.offAll(() => const SelectGenderScreen());
            }
          } else {
            // Handle error message in success status code
            final errorMessage =
                loginResponse.message ?? loginResponse.error ?? 'Something went wrong';
            showSnackBar(context, errorMessage, isErrorMessageDisplay: true);
          }
        } else {
          // Error response (401, 400, etc.)
          final errorMessage = loginResponse.message ??
              loginResponse.error ??
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

      String errorMessage = 'Network error. Please check your connection and try again.';
      if (e.toString().contains('sign_in_failed') || e.toString().contains('network')) {
        errorMessage = 'Failed to sign in with Google. Please try again.';
      }

      showSnackBar(context, errorMessage, isErrorMessageDisplay: true);
    }
  }


}
