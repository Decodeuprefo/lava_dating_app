import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Api/api_controller.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/services/storage_service.dart';
import '../../View/setProfileModule/add_profile_photos_screen.dart';

class SelectGenderScreenController extends GetxController {
  final ApiController _apiController = Get.find<ApiController>();

  bool isLoading = false;

  Future<void> updateGender(BuildContext context, String gender) async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      final body = {
        'gender': gender.toUpperCase(),
      };

      // Make API call
      final response = await _apiController.updateUserProfile(body);

      isLoading = false;
      update();

      // Parse response body
      try {
        if (response.body == null) {
          showSnackBar(context, 'Invalid response from server. Please try again.',
              isErrorMessageDisplay: true);
          return;
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          await StorageService.setProfileStep(1);
          Get.to(() => const AddProfilePhotosScreen());
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
