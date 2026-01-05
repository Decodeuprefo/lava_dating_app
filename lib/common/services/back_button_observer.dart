import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/color_constants.dart';
import '../constant/common_text_style.dart';
import '../widgets/custom_button.dart';
import '../widgets/glass_background_widget.dart';

void showExitDialog({
  String? title,
  String? message,
  VoidCallback? onConfirm,
}) {
  Get.dialog(
    WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: GlassBackgroundWidget(
          borderRadius: 20,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title ?? "Exit App?",
                style: CommonTextStyle.regular18w500,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                message ?? "Are you sure you want to exit?",
                style: CommonTextStyle.regular14w400,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: "Cancel",
                      textStyle: CommonTextStyle.regular16w500,
                      backgroundColor: Colors.transparent,
                      borderColor: Colors.white,
                      onPressed: () {
                        Get.back();
                      },
                      borderRadius: 30,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: AppButton(
                      text: "Exit",
                      textStyle: CommonTextStyle.regular16w500,
                      backgroundColor: ColorConstants.lightOrange,
                      onPressed: () {
                        Get.back();
                        if (onConfirm != null) {
                          onConfirm();
                        } else {
                          Get.back();
                        }
                      },
                      borderRadius: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
