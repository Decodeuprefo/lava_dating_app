import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Api/api_controller.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/services/storage_service.dart';
import '../../View/setProfileModule/select_languages_spoken.dart';
import 'profile_module_controller.dart';

class SelectEducationScreenController extends GetxController {
  final ApiController _apiController = Get.find<ApiController>();
  final ProfileModuleController _profileController = Get.find<ProfileModuleController>();
  bool isLoading = false;

  Future<void> updateEducation(BuildContext context) async {
    if (isLoading) return;

    if (_profileController.selectedEducation.value.isEmpty) {
      showSnackBar(context, 'Please select your education.', isErrorMessageDisplay: true);
      return;
    }

    isLoading = true;
    update();

    try {
      final body = {
        'education': _profileController.selectedEducation.value,
      };

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
          await StorageService.setProfileStep(9);
          Get.to(() => const SelectLanguagesSpoken(), transition: Transition.noTransition);
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
