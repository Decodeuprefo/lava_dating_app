import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Common/widgets/glass_background_widget.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        heightSpace(20),
                        _buildHeader(),
                        heightSpace(30),
                        _buildLogo(),
                        heightSpace(40),
                        _buildQuestion(),
                        heightSpace(20),
                        _buildFirstParagraph(),
                        heightSpace(20),
                        _buildSecondParagraph(),
                        heightSpace(20),
                        _buildThirdParagraph(),
                        heightSpace(30),
                      ],
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (context) => _buildDeleteAccountButton(context)
                    .marginSymmetric(horizontal: 20, vertical: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: Get.back,
      child: SvgPicture.asset(
        "assets/icons/back_arrow.svg",
        height: 30,
        width: 30,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/images/app_logo.png',
        width: 200,
        height: 150,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Text(
            "Lava",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: ColorConstants.lightOrange,
              fontFamily: 'Poppins',
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestion() {
    return Text(
      "Are you sure you want to delete this account?",
      style: CommonTextStyle.regular20w600.copyWith(
        color: ColorConstants.lightOrange,
      ),
    );
  }

  Widget _buildFirstParagraph() {
    return const Text(
      "Deleting your account will permanently remove all your data, including your profile, matches, messages, and activity history.",
      style: CommonTextStyle.regular14w400,
      textAlign: TextAlign.left,
    );
  }

  Widget _buildSecondParagraph() {
    return const Text(
      "Once your account is deleted, it cannot be recovered, and you will lose access to any saved information or ongoing conversations. If you simply wish to take a break, consider deactivating your account instead, so you can return later without losing your data.",
      style: CommonTextStyle.regular14w400,
      textAlign: TextAlign.left,
    );
  }

  Widget _buildThirdParagraph() {
    return const Text(
      "Make sure to back up any important information before proceeding, as this action is final and irreversible.",
      style: CommonTextStyle.regular14w400,
      textAlign: TextAlign.left,
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return AppButton(
      text: 'Delete Account',
      textStyle: CommonTextStyle.regular16w500,
      onPressed: () {
        _showDeleteAccountDialog(context);
      },
      borderRadius: 10,
    );
  }

  static void _showDeleteAccountDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.5),
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      // 1. Add this to ensure the dialog ignores nested navigators/bottom sheets
      useRootNavigator: true,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        // 2. Use a Column with MainAxisAlignment.center
        // This forces the child to sit in the vertical center of the screen
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Material(
              type: MaterialType.transparency,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassBackgroundWidget(
                  borderRadius: 20,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon
                      Container(
                          padding: const EdgeInsets.all(12),
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: ColorConstants.lightOrange,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            "assets/icons/white_trash.png",
                            fit: BoxFit.contain,
                          )),
                      const SizedBox(height: 20),
                      // Title
                      const Text(
                        "Delete Account?",
                        style: CommonTextStyle.regular20w600,
                        textAlign: TextAlign.center,
                      ),
                      heightSpace(10),

                      const Text(
                        "Are you sure you want to delete your account? If you delete your account, you will permanently lose your profile, messages, and photos.",
                        style: CommonTextStyle.regular14w400,
                        textAlign: TextAlign.center,
                      ),
                      heightSpace(30),
                      Row(
                        children: [
                          // Cancel Button
                          Expanded(
                            child: AppButton(
                              text: 'Cancel',
                              textStyle: CommonTextStyle.regular16w500,
                              backgroundColor: Colors.transparent,
                              borderColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              borderRadius: 30,
                            ),
                          ),
                          widthSpace(30),
                          // Delete Button
                          Expanded(
                            child: AppButton(
                              text: 'Delete',
                              textStyle: CommonTextStyle.regular16w500,
                              backgroundColor: ColorConstants.lightOrange,
                              onPressed: () {
                                Navigator.of(context).pop();
                                Get.back();
                                // TODO: Implement delete account logic
                                Get.snackbar(
                                  "Account Deleted",
                                  "Your account has been deleted successfully",
                                  snackPosition: SnackPosition.BOTTOM,
                                );
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
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
