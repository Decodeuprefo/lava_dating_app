import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Common/widgets/input_formatters.dart';
import 'package:lava_dating_app/Common/widgets/text_form_field_widget.dart';
import 'package:lava_dating_app/Controller/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Form(
            key: formKey,
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
                          heightSpace(50),
                          _buildTitle(),
                          _buildDescription(),
                          heightSpace(40),
                          _buildOldPasswordField(context, controller),
                          heightSpace(20),
                          _buildNewPasswordField(context, controller),
                          heightSpace(20),
                          _buildConfirmPasswordField(context, controller),
                          heightSpace(30),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildChangePasswordButton(controller, formKey)
                    .marginSymmetric(horizontal: 20, vertical: 20),
              ],
            ),
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

  Widget _buildTitle() {
    return Text(
      "Change Password",
      style: CommonTextStyle.regular30w600.copyWith(
        color: ColorConstants.lightOrange,
      ),
    );
  }

  Widget _buildDescription() {
    return const Text(
      "Lost your key to love? No problem — reset your password and unlock your matches again!",
      style: CommonTextStyle.regular14w400,
      textAlign: TextAlign.left,
    );
  }

  Widget _buildOldPasswordField(BuildContext context, ChangePasswordController controller) {
    return Obx(
      () => TextFormFieldWidget(
        controller: controller.oldPasswordController,
        focusNode: controller.oldPasswordFocusNode,
        hint: "Enter old password",
        obscureText: !controller.isOldPasswordVisible.value,
        inputFormatters: [
          CustomFormatterForSpaceAndEmoji(),
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
          NoEmojisFormatter(),
        ],
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: IconButton(
                onPressed: controller.toggleOldPasswordVisibility,
                icon: !controller.isOldPasswordVisible.value
                    ? Image.asset(
                        "assets/icons/close_eye.png",
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        "assets/icons/open_eye.png",
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
        validator: controller.validateOldPassword,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(controller.newPasswordFocusNode);
        },
        textInputAction: TextInputAction.next,
        radius: 10,
      ),
    );
  }

  Widget _buildNewPasswordField(BuildContext context, ChangePasswordController controller) {
    return Obx(
      () => TextFormFieldWidget(
        controller: controller.newPasswordController,
        focusNode: controller.newPasswordFocusNode,
        hint: "Enter new password",
        obscureText: !controller.isNewPasswordVisible.value,
        inputFormatters: [
          CustomFormatterForSpaceAndEmoji(),
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
          NoEmojisFormatter(),
        ],
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: IconButton(
                onPressed: controller.toggleNewPasswordVisibility,
                icon: !controller.isNewPasswordVisible.value
                    ? Image.asset(
                        "assets/icons/close_eye.png",
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        "assets/icons/open_eye.png",
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
        validator: controller.validateNewPassword,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(controller.confirmPasswordFocusNode);
        },
        textInputAction: TextInputAction.next,
        radius: 10,
      ),
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context, ChangePasswordController controller) {
    return Obx(
      () => TextFormFieldWidget(
        controller: controller.confirmPasswordController,
        focusNode: controller.confirmPasswordFocusNode,
        hint: "Enter confirm password",
        obscureText: !controller.isConfirmPasswordVisible.value,
        inputFormatters: [
          CustomFormatterForSpaceAndEmoji(),
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
          NoEmojisFormatter(),
        ],
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: IconButton(
                onPressed: controller.toggleConfirmPasswordVisibility,
                icon: !controller.isConfirmPasswordVisible.value
                    ? Image.asset(
                        "assets/icons/close_eye.png",
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        "assets/icons/open_eye.png",
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
        validator: controller.validateConfirmPassword,
        onFieldSubmitted: (value) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        textInputAction: TextInputAction.done,
        radius: 10,
      ),
    );
  }

  Widget _buildChangePasswordButton(
    ChangePasswordController controller,
    GlobalKey<FormState> formKey,
  ) {
    return AppButton(
      text: 'Change Password',
      textStyle: CommonTextStyle.regular16w500,
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (formKey.currentState?.validate() ?? false) {
          controller.changePassword();
        }
      },
      borderRadius: 10,
    );
  }
}
