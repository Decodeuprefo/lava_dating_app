import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Api/api_controller.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/services/storage_service.dart';
import '../../View/setProfileModule/select_education_screen.dart';
import 'profile_module_controller.dart';

class SelectLifestyleScreenController extends GetxController {
  final ApiController _apiController = Get.find<ApiController>();
  final ProfileModuleController _profileController = Get.find<ProfileModuleController>();
  bool isLoading = false;

  String _mapDrinkingToApi(String drinkingOption) {
    final Map<String, String> mapping = {
      'Not for me': 'NOT_FOR_ME',
      'Sober': 'SOBER',
      'Sober curious': 'SOBER_CURIOUS',
      'On special occasions': 'ON_SPECIAL_OCCASIONS',
      'Socially on weekends': 'SOCIALLY_ON_WEEKENDS',
      'Most Nights': 'MOST_NIGHTS',
    };
    return mapping[drinkingOption] ?? drinkingOption.toUpperCase().replaceAll(' ', '_');
  }

  String _mapSmokingToApi(String smokingOption) {
    final Map<String, String> mapping = {
      'Social smoker': 'SOCIAL_SMOKER',
      'Smoker when drinking': 'SMOKER_WHEN_DRINKING',
      'Non - smoker': 'NON_SMOKER',
      'Smoker': 'SMOKER',
      'Trying to quit': 'TRYING_TO_QUIT',
    };
    return mapping[smokingOption] ??
        smokingOption.toUpperCase().replaceAll(' ', '_').replaceAll('-', '');
  }

  String _mapWorkoutToApi(String workoutOption) {
    final Map<String, String> mapping = {
      'Every day': 'EVERYDAY',
      'Often': 'OFTEN',
      'Sometimes': 'SOMETIMES',
      'Never': 'NEVER',
    };
    return mapping[workoutOption] ?? workoutOption.toUpperCase().replaceAll(' ', '_');
  }

  String _mapPetsToApi(String petsOption) {
    final Map<String, String> mapping = {
      'Dog': 'DOG',
      'Cat': 'CAT',
      'Reptile': 'REPTILE',
      'Amphibian': 'AMPHIBIAN',
      'Bird': 'BIRD',
      'Fish': 'FISH',
      'Don\'t have but love': 'DONT_HAVE_BUT_LOVE',
      'Other': 'OTHER',
      'Turtle': 'TURTLE',
    };
    return mapping[petsOption] ??
        petsOption.toUpperCase().replaceAll(' ', '_').replaceAll('\'', '').replaceAll(',', '');
  }

  Future<void> updateLifestyle(BuildContext context) async {
    if (isLoading) return;

    if (_profileController.selectedDrinking.isEmpty ||
        _profileController.selectedSmoking.isEmpty ||
        _profileController.selectedWorkout.isEmpty ||
        _profileController.selectedPets.isEmpty) {
      showSnackBar(context, 'Please select options for all lifestyle questions.',
          isErrorMessageDisplay: true);
      return;
    }

    isLoading = true;
    update();

    try {
      final body = {
        'alcoholUse': _mapDrinkingToApi(_profileController.selectedDrinking.first),
        'smokingStatus': _mapSmokingToApi(_profileController.selectedSmoking.first),
        'workout': _mapWorkoutToApi(_profileController.selectedWorkout.first),
        'pets': _mapPetsToApi(_profileController.selectedPets.first),
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
          await StorageService.setProfileStep(8);
          Get.to(() => const SelectEducationScreen(), transition: Transition.noTransition);
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
