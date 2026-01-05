import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Api/api_controller.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/services/storage_service.dart';
import '../../View/setProfileModule/interests_and_hobbies.dart';

class SelectDobScreenController extends GetxController {
  final ApiController _apiController = Get.find<ApiController>();
  final TextEditingController dobController = TextEditingController();
  DateTime? selectedDate;
  bool isLoading = false;

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    // Format: MM/DD/YYYY for display
    dobController.text =
        "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
    update();
  }

  Future<void> updateDateOfBirth(BuildContext context) async {
    if (isLoading) return;

    final now = DateTime.now();
    final age = now.year - selectedDate!.year;
    final monthDiff = now.month - selectedDate!.month;
    final dayDiff = now.day - selectedDate!.day;

    if (age < 18 || (age == 18 && (monthDiff < 0 || (monthDiff == 0 && dayDiff < 0)))) {
      showSnackBar(context, 'You must be at least 18 years old to use Lava.',
          isErrorMessageDisplay: true);
      return;
    }

    isLoading = true;
    update();

    try {
      // Format date as YYYY-MM-DD for API
      final dateString =
          "${selectedDate!.year.toString().padLeft(4, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

      final body = {'dateOfBirth': dateString};

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
          await StorageService.setProfileStep(5);
          Get.to(() => const InterestsAndHobbies(), transition: Transition.noTransition);
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

  @override
  void onClose() {
    dobController.dispose();
    super.onClose();
  }
}
