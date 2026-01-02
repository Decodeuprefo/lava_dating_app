import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Api/api_controller.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/services/storage_service.dart';
import '../../View/setProfileModule/select_lifestyle_screen.dart';
import 'profile_module_controller.dart';

class SelectReligionScreenController extends GetxController {
  final ApiController _apiController = Get.find<ApiController>();
  final ProfileModuleController _profileController = Get.find<ProfileModuleController>();
  bool isLoading = false;

  String _mapReligionToApiValue(String uiValue) {
    final Map<String, String> religionMap = {
      'Agnostic': 'AGNOSTIC',
      'Atheist': 'ATHEIST',
      'Baptist': 'BAPTIST',
      'Buddhist': 'BUDDHIST',
      'Catholic': 'CATHOLIC',
      'Christian': 'CHRISTIAN',
      'Hindu': 'HINDU',
      'Inter - Religion': 'INTER_RELIGION',
      'Jain': 'JAIN',
      'Jewish': 'JEWISH',
      'Methodist': 'METHODIST',
      'Muslim': 'MUSLIM',
      'Sikh': 'SIKH',
      'Parsi': 'PARSI',
      'Protestant': 'PROTESTANT',
      'Taoist': 'TAOIST',
      'Other': 'OTHER',
    };
    return religionMap[uiValue] ?? uiValue.toUpperCase();
  }

  Future<void> updateReligion(BuildContext context) async {
    if (isLoading) return;

    if (_profileController.selectedReligion.isEmpty) {
      showSnackBar(context, 'Please select a religion.', isErrorMessageDisplay: true);
      return;
    }

    isLoading = true;
    update();

    try {
      final selectedReligionUi = _profileController.selectedReligion.first;
      final religionApiValue = _mapReligionToApiValue(selectedReligionUi);
      final body = {
        'religion': religionApiValue,
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
          await StorageService.setProfileStep(7);
          Get.to(() => const LifestyleScreen(), transition: Transition.noTransition);
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
