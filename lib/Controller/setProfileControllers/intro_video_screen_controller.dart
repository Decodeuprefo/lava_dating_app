import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import '../../Api/api_controller.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/services/storage_service.dart';
import '../../View/setProfileModule/about_me_screen.dart';

class IntroVideoScreenController extends GetxController {
  final ApiController _apiController = Get.find<ApiController>();
  bool isLoading = false;

  Future<void> uploadIntroVideo(BuildContext context, File videoFile) async {
    if (isLoading) return;

    if (!await videoFile.exists()) {
      showSnackBar(context, 'Video file not found. Please select a video again.',
          isErrorMessageDisplay: true);
      return;
    }

    isLoading = true;
    update();

    try {
      final formData = FormData({
        'video': MultipartFile(
          videoFile,
          filename: videoFile.path.split('/').last,
        ),
      });

      final response = await _apiController.uploadIntroVideo(formData);

      isLoading = false;
      update();

      try {
        if (response.body == null) {
          showSnackBar(context, 'Invalid response from server. Please try again.',
              isErrorMessageDisplay: true);
          return;
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          await StorageService.setProfileStep(3);
          Get.to(() => const AboutMeScreen(), transition: Transition.noTransition);
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
