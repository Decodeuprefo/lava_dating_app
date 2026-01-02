import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Api/api_controller.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/services/storage_service.dart';
import '../../View/setProfileModule/select_marital_status.dart';
import 'profile_module_controller.dart';

class PreferredGenderScreenController extends GetxController {
  final ApiController _apiController = Get.find<ApiController>();
  final ProfileModuleController _profileController = Get.find<ProfileModuleController>();
  bool isLoading = false;

  // Map UI gender values to API values
  String _mapGenderToApi(String gender) {
    switch (gender) {
      case "Male":
        return "MALE";
      case "Female":
        return "FEMALE";
      case "Other":
        return "OTHER";
      default:
        return "MALE";
    }
  }

  Future<void> updatePreferredGender(BuildContext context) async {
    if (isLoading) return;

    // Validation
    if (_profileController.preferredGender.value.isEmpty) {
      showSnackBar(context, "Please select a gender preference", isErrorMessageDisplay: true);
      return;
    }

    isLoading = true;
    update();

    try {
      final apiGender = _mapGenderToApi(_profileController.preferredGender.value);
      final body = {
        'preferredGender': [apiGender],
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
          await StorageService.setProfileStep(14);
          Get.to(() => const SelectMaritalStatus(), transition: Transition.noTransition);
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
