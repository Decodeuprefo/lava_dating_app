import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Api/api_controller.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/services/storage_service.dart';
import '../../View/setProfileModule/preferred_age_range_screen.dart';
import 'profile_module_controller.dart';

class SelectRelationshipTypeScreenController extends GetxController {
  final ApiController _apiController = Get.find<ApiController>();
  final ProfileModuleController _profileController = Get.find<ProfileModuleController>();
  bool isLoading = false;

  String _mapRelationshipTypeToApiValue(String uiValue) {
    final Map<String, String> relationshipTypeMap = {
      'Friends': 'FRIENDS',
      'Casual dating': 'CASUAL_DATING',
      'Dating for marriage': 'DATING_FOR_MARRIAGE',
      'Networking': 'NETWORKING',
      'Not sure yet': 'NOT_SURE',
      'All the above': 'ALL_ABOVE',
      'Relationship': 'RELATIONSHIP',
      'Marriage': 'MARRIAGE',
    };
    return relationshipTypeMap[uiValue] ?? uiValue.toUpperCase().replaceAll(' ', '_');
  }

  Future<void> updateRelationshipType(BuildContext context) async {
    if (isLoading) return;

    if (_profileController.selectedRelationshipType.isEmpty) {
      showSnackBar(context, 'Please select a relationship type.', isErrorMessageDisplay: true);
      return;
    }

    isLoading = true;
    update();

    try {
      final selectedRelationshipTypeUi = _profileController.selectedRelationshipType.first;
      final relationshipTypeApiValue = _mapRelationshipTypeToApiValue(selectedRelationshipTypeUi);

      final body = {
        'relationshipType': relationshipTypeApiValue,
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
          await StorageService.setProfileStep(11);
          Get.to(() => const PreferredAgeRangeScreen(), transition: Transition.noTransition);
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
