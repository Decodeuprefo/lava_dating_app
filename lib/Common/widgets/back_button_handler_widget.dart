import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/color_constants.dart';
import '../constant/common_text_style.dart';
import 'custom_button.dart';
import 'glass_background_widget.dart';

class BackButtonHandlerWidget extends StatelessWidget {
  final Widget child;
  final bool showWarning;
  final String? warningTitle;
  final String? warningMessage;
  final VoidCallback? onConfirmExit;

  const BackButtonHandlerWidget({
    Key? key,
    required this.child,
    this.showWarning = true,
    this.warningTitle,
    this.warningMessage,
    this.onConfirmExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (showWarning) {
          // Check if this is the last route in the stack
          final canPop = Navigator.of(context).canPop();
          if (!canPop) {
            // This is the last route, show exit dialog
            _showExitDialog(context);
            return false; // Prevent default back action
          }
          // There are more routes, allow normal back navigation
          return true;
        }
        return true; // Allow back action
      },
      child: child,
    );
  }

  void _showExitDialog(BuildContext context) {
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
                  warningTitle ?? "Exit App?",
                  style: CommonTextStyle.regular18w500,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  warningMessage ?? "Are you sure you want to exit?",
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
                        borderRadius: 10,
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
                          if (onConfirmExit != null) {
                            onConfirmExit!();
                          } else {
                            Get.back();
                          }
                        },
                        borderRadius: 10,
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
}
