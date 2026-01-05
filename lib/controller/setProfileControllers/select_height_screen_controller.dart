import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Api/api_controller.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/services/storage_service.dart';
import '../../View/setProfileModule/preferred_gender_screen.dart';
import 'profile_module_controller.dart';

class SelectHeightScreenController extends GetxController {
  final ApiController _apiController = Get.find<ApiController>();
  final ProfileModuleController _profileController = Get.find<ProfileModuleController>();
  bool isLoading = false;

  Future<void> updateHeight(BuildContext context) async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      final Map<String, dynamic> body;

      if (_profileController.feetORCm.value) {
        // Feet/Inches mode
        body = {
          'heightFeet': _profileController.minHeight.value,
          'heightInches': _profileController.maxHeight.value,
        };
      } else {
        // Centimeter mode
        body = {
          'heightCm': _profileController.minHeight.value,
        };
      }

      final response = await _apiController.updateUserProfile(body);

      isLoading = false;
      update();

      try {
        if (response.body == null) {
          showSnackBar(context, 'Invalid response from server. Please try again.',
              isErrorMessageDisplay: true);
          return;
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          await StorageService.setProfileStep(13);
          Get.to(() => const PreferredGenderScreen(), transition: Transition.noTransition);
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
}
