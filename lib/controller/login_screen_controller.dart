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
    // serverClientId: 'YOUR_WEB_CLIENT_ID_HERE.apps.googleusercontent.com',
    serverClientId: '253320762898-jpssr4ina2b1oe3rl6ih62ge6aofnvop.apps.googleusercontent.com',
    scopes: ['email', 'profile', 'openid'],
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

  /// Google Social Login - common method for both Login and Signup screens
  Future<void> googleLogin(BuildContext context) async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        isLoading = false;
        update();
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      String? idToken = googleAuth.idToken;

      if (idToken == null) {
        try {
          await _googleSignIn.signOut();
          final GoogleSignInAccount? refreshedUser = await _googleSignIn.signIn();
          if (refreshedUser != null) {
            final GoogleSignInAuthentication refreshedAuth = await refreshedUser.authentication;
            idToken = refreshedAuth.idToken;
          }
        } catch (e) {}
      }

      if (idToken == null) {
        isLoading = false;
        update();
        showSnackBar(
          context,
          'Failed to get Google authentication token. Please ensure OAuth client is configured in Firebase Console.',
          isErrorMessageDisplay: true,
        );
        return;
      }

      String firstName = '';
      String lastName = '';
      if (googleUser.displayName != null && googleUser.displayName!.isNotEmpty) {
        final nameParts = googleUser.displayName!.split(' ');
        firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      }

      final body = {
        'provider': 'google',
        'idToken': idToken,
        'firstName': firstName,
        'lastName': lastName,
      };

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
          if (loginResponse.isSuccess) {
            if (loginResponse.accessToken != null && loginResponse.refreshToken != null) {
              await StorageService.saveTokens(
                loginResponse.accessToken!,
                loginResponse.refreshToken!,
              );
            }

            final responseBody = response.body as Map<String, dynamic>;
            final userData = responseBody['user'] as Map<String, dynamic>?;

            if (userData != null) {
              final isProfileComplete = userData['isProfileComplete'] as bool? ?? false;
              if (isProfileComplete) {
                Get.offAll(() => const DashboardScreen());
              } else {
                final nextScreen = ProfileNavigationHelper.determineNextScreen(userData);
                Get.offAll(() => nextScreen);
              }
            } else {
              Get.offAll(() => const SelectGenderScreen());
            }
          } else {
            final errorMessage =
                loginResponse.message ?? loginResponse.error ?? 'Something went wrong';
            showSnackBar(context, errorMessage, isErrorMessageDisplay: true);
          }
        } else {
          final errorMessage = loginResponse.message ??
              loginResponse.error ??
              _apiController.getErrorMessage(response);
          showSnackBar(context, errorMessage, isErrorMessageDisplay: true);
        }
      } catch (e) {
        final errorMessage = _apiController.getErrorMessage(response);
        showSnackBar(context, errorMessage, isErrorMessageDisplay: true);
      }
    } catch (e) {
      isLoading = false;
      update();

      String errorMessage = 'Failed to sign in with Google. Please try again.';

      if (e.toString().contains('sign_in_failed')) {
        if (e.toString().contains('ApiException: 10')) {
          errorMessage = 'Google Sign-In configuration error. Please ensure:\n'
              '1. SHA-1 fingerprint is added in Firebase Console\n'
              '2. google-services.json is up to date\n'
              '3. OAuth client is configured correctly';
        } else if (e.toString().contains('ApiException: 12500')) {
          // ApiException: 12500 = SIGN_IN_CANCELLED
          errorMessage = 'Sign-in was cancelled.';
        } else if (e.toString().contains('ApiException: 7')) {
          // ApiException: 7 = NETWORK_ERROR
          errorMessage = 'Network error. Please check your internet connection.';
        } else {
          errorMessage = 'Failed to sign in with Google: ${e.toString()}';
        }
      } else if (e.toString().contains('network') || e.toString().contains('Network')) {
        errorMessage = 'Network error. Please check your connection and try again.';
      } else {
        // Log full error for debugging
        print('Google Sign-In Error: $e');
        errorMessage = 'An error occurred during sign-in. Please try again.';
      }

      showSnackBar(context, errorMessage, isErrorMessageDisplay: true);
    }
  }
}
