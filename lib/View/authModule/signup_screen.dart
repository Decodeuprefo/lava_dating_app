import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/View/authModule/login_screen.dart';

import '../../Common/constant/color_constants.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/string_constants.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/input_formatters.dart';
import '../../Common/widgets/text_form_field_widget.dart';
import '../../Controller/signup_screen_controller.dart';

/*
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controller - create new instance each time
    // Delete existing if any to avoid conflicts and memory leaks
    if (Get.isRegistered<SignupScreenController>()) {
      try {
        Get.delete<SignupScreenController>();
      } catch (e) {
        // Controller might already be disposed, ignore
      }
    }
    Get.put(SignupScreenController(), permanent: false);
  }

  @override
  void dispose() {
    // Clean up controller when leaving the screen to prevent memory leaks
    try {
      if (Get.isRegistered<SignupScreenController>()) {
        Get.delete<SignupScreenController>();
      }
    } catch (e) {
      // Ignore errors during disposal
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Form(
          key: _formKey,
          child: GetBuilder<SignupScreenController>(
            builder: (controller) {
              return RepaintBoundary(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightSpace(80),
                      Center(
                        child: Image.asset(
                          'assets/images/app_logo.png',
                          width: 94,
                          height: 80,
                        ),
                      ),
                      heightSpace(20),
                      const Text(
                        'Create your account',
                        style: CommonTextStyle.semiBold30w600,
                      ),
                      const Text(
                        "Join our community and start connecting with people who match your vibe.",
                        style: CommonTextStyle.regular14w400,
                      ),
                      heightSpace(30),
                      TextFormFieldWidget(
                        controller: controller.firstNameController,
                        prefixIcon: Image.asset(
                          "assets/icons/user_icon.png",
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                        hint: StringConstants.firstName,
                        validator: (value) => controller.validateFieldNotEmpty(
                          value,
                          StringConstants.emptyFirstName,
                        ),
                        onFieldSubmitted: (p0) {
                          FocusScope.of(context).requestFocus(controller.lastNameFocusNode);
                        },
                        focusNode: controller.firstNameFocusNode,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                        ],
                        textInputAction: TextInputAction.next,
                      ),
                      heightSpace(20),
                      TextFormFieldWidget(
                        controller: controller.lastNameController,
                        prefixIcon: Image.asset(
                          "assets/icons/user_icon.png",
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                        hint: StringConstants.lastName,
                        validator: (value) => controller.validateFieldNotEmpty(
                          value,
                          StringConstants.emptyLastName,
                        ),
                        onFieldSubmitted: (p0) {
                          FocusScope.of(context).requestFocus(controller.mobileNumberFocusNode);
                        },
                        focusNode: controller.lastNameFocusNode,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                        ],
                        textInputAction: TextInputAction.next,
                      ),
                      heightSpace(20),
                      TextFormFieldWidget(
                        controller: controller.mobileNumberController,
                        focusNode: controller.mobileNumberFocusNode,
                        prefixIcon: Image.asset(
                          "assets/icons/phone_icon.png",
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                        hint: StringConstants.mobileNumber,
                        validator: (value) => controller.validateFieldNotEmpty(
                          value,
                          StringConstants.emptyMobileNumber,
                        ),
                        onFieldSubmitted: (p0) {
                          FocusScope.of(context).requestFocus(controller.emailFocusNode);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.phone,
                      ),
                      heightSpace(20),
                      TextFormFieldWidget(
                        controller: controller.emailController,
                        focusNode: controller.emailFocusNode,
                        prefixIcon: SvgPicture.asset(
                          "assets/icons/massage_icon.svg",
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                        hint: StringConstants.emailAddress,
                        validator: (value) => controller.validateEmail(value),
                        onFieldSubmitted: (p0) {
                          FocusScope.of(context).requestFocus(controller.passwordFocusNode);
                        },
                        inputFormatters: [
                          CustomFormatterForSpaceAndEmoji(),
                        ],
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.emailAddress,
                      ),
                      heightSpace(20),
                      TextFormFieldWidget(
                        controller: controller.passController,
                        focusNode: controller.passwordFocusNode,
                        hint: StringConstants.enterPassword,
                        prefixIcon: SvgPicture.asset(
                          "assets/icons/lock_app.svg",
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                        obscureText: !controller.isPasswordVisible,
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
                                  onPressed: () {
                                    controller.changeIsPasswordVisible();
                                  },
                                  icon: !controller.isPasswordVisible
                                      ? Image.asset(
                                          "assets/icons/close_eye.png",
                                          fit: BoxFit.fill,
                                        )
                                      : Image.asset(
                                          "assets/icons/open_eye.png",
                                          fit: BoxFit.fill,
                                        )),
                            ),
                            const SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                        validator: (value) => controller.validatePassword(value),
                        onFieldSubmitted: (p0) {
                          FocusScope.of(context).requestFocus(controller.confPasswordFocusNode);
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      heightSpace(20),
                      TextFormFieldWidget(
                        controller: controller.confPassController,
                        focusNode: controller.confPasswordFocusNode,
                        hint: StringConstants.enterConfirmPassword,
                        prefixIcon: SvgPicture.asset(
                          "assets/icons/lock_app.svg",
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                        obscureText: !controller.isConfPasswordVisible,
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
                                  onPressed: () {
                                    controller.changeIsConfPasswordVisible();
                                  },
                                  icon: !controller.isConfPasswordVisible
                                      ? Image.asset(
                                          "assets/icons/close_eye.png",
                                          fit: BoxFit.fill,
                                        )
                                      : Image.asset(
                                          "assets/icons/open_eye.png",
                                          fit: BoxFit.fill,
                                        )),
                            ),
                            const SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                        validator: (value) => controller.validateConfirmPassword(value),
                        onFieldSubmitted: (p0) {
                          controller.confPasswordFocusNode.unfocus();
                        },
                        textInputAction: TextInputAction.done,
                      ),
                      heightSpace(20),
                      AppButton(
                        text: 'Continue',
                        textStyle: CommonTextStyle.regular16w500,
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_formKey.currentState?.validate() ?? false) {
                            // Handle signup logic here
                            // You can navigate to next screen or call API
                          }
                        },
                      ),
                      heightSpace(30),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: ColorConstants.lightOrange, // line color
                              thickness: 1,
                              endIndent: 10,
                            ),
                          ),
                          Text(
                            "or continue with",
                            style: CommonTextStyle.regular14w400
                                .copyWith(color: ColorConstants.lightOrange),
                          ),
                          const Expanded(
                            child: Divider(
                              color: ColorConstants.lightOrange,
                              thickness: 1,
                              indent: 10,
                            ),
                          ),
                        ],
                      ),
                      heightSpace(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          socialButton(
                            child: Image.asset(
                              "assets/icons/facebook_icon.png",
                              fit: BoxFit.fill,
                              height: 40,
                              width: 40,
                            ),
                          ),
                          socialButton(
                            child: Image.asset(
                              "assets/icons/google_icon.png",
                              fit: BoxFit.fill,
                              height: 40,
                              width: 40,
                            ),
                          ),
                          socialButton(
                            child: Image.asset(
                              "assets/icons/apple_icon.png",
                              fit: BoxFit.fill,
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ],
                      ),
                      heightSpace(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: CommonTextStyle.regular14w400
                                .copyWith(color: ColorConstants.offGrey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const LoginScreen());
                            },
                            child: Text(
                              'Login',
                              style: CommonTextStyle.regular14w400
                                  .copyWith(color: ColorConstants.lightOrange),
                            ),
                          )
                        ],
                      ),
                      heightSpace(30),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
*/

/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/View/authModule/login_screen.dart';

import '../../Common/constant/color_constants.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/string_constants.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/input_formatters.dart';
import '../../Common/widgets/text_form_field_widget.dart';
import '../../Controller/signup_screen_controller.dart';*/

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<SignupScreenController>()) {
      try {
        Get.delete<SignupScreenController>();
      } catch (e) {}
    }
    Get.put(SignupScreenController(), permanent: false);
  }

  @override
  void dispose() {
    try {
      if (Get.isRegistered<SignupScreenController>()) {
        Get.delete<SignupScreenController>();
      }
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Form(
          key: _formKey,
          child: GetBuilder<SignupScreenController>(
            builder: (controller) {
              return RepaintBoundary(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightSpace(80),
                      Center(
                        child: Image.asset(
                          'assets/images/app_logo.png',
                          width: 94,
                          height: 80,
                        ),
                      ),
                      heightSpace(20),
                      const Text(
                        'Create your account',
                        style: CommonTextStyle.semiBold30w600,
                      ),
                      const Text(
                        "Join our community and start connecting with people who match your vibe.",
                        style: CommonTextStyle.regular14w400,
                      ),
                      heightSpace(30),
                      TextFormFieldWidget(
                        controller: controller.firstNameController,
                        prefixIcon: Image.asset(
                          "assets/icons/user_icon.png",
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                        hint: StringConstants.firstName,
                        validator: (value) => controller.validateFieldNotEmpty(
                          value,
                          StringConstants.emptyFirstName,
                        ),
                        onFieldSubmitted: (p0) {
                          FocusScope.of(context).requestFocus(controller.lastNameFocusNode);
                        },
                        focusNode: controller.firstNameFocusNode,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                        ],
                        textInputAction: TextInputAction.next,
                      ),
                      heightSpace(20),
                      TextFormFieldWidget(
                        controller: controller.lastNameController,
                        prefixIcon: Image.asset(
                          "assets/icons/user_icon.png",
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                        hint: StringConstants.lastName,
                        validator: (value) => controller.validateFieldNotEmpty(
                          value,
                          StringConstants.emptyLastName,
                        ),
                        onFieldSubmitted: (p0) {
                          FocusScope.of(context).requestFocus(controller.mobileNumberFocusNode);
                        },
                        focusNode: controller.lastNameFocusNode,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                        ],
                        textInputAction: TextInputAction.next,
                      ),
                      heightSpace(20),
                      TextFormFieldWidget(
                        controller: controller.mobileNumberController,
                        focusNode: controller.mobileNumberFocusNode,
                        prefixIcon: Image.asset(
                          "assets/icons/phone_icon.png",
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                        hint: StringConstants.mobileNumber,
                        validator: (value) => controller.validateFieldNotEmpty(
                          value,
                          StringConstants.emptyMobileNumber,
                        ),
                        onFieldSubmitted: (p0) {
                          FocusScope.of(context).requestFocus(controller.mobileNumberFocusNode);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.phone,
                      ),
                      heightSpace(20),
                      TextFormFieldWidget(
                        controller: controller.emailController,
                        focusNode: controller.emailFocusNode,
                        prefixIcon: SvgPicture.asset(
                          "assets/icons/massage_icon.svg",
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                        hint: StringConstants.emailAddress,
                        validator: (value) => controller.validateEmail(value),
                        onFieldSubmitted: (p0) {
                          FocusScope.of(context).requestFocus(controller.emailFocusNode);
                        },
                        inputFormatters: [
                          CustomFormatterForSpaceAndEmoji(),
                        ],
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.emailAddress,
                      ),
                      heightSpace(20),
                      TextFormFieldWidget(
                        controller: controller.passController,
                        focusNode: controller.passwordFocusNode,
                        hint: StringConstants.enterPassword,
                        prefixIcon: SvgPicture.asset(
                          "assets/icons/lock_app.svg",
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                        obscureText: !controller.isPasswordVisible,
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
                                  onPressed: () {
                                    controller.changeIsPasswordVisible();
                                  },
                                  icon: !controller.isPasswordVisible
                                      ? Image.asset(
                                          "assets/icons/close_eye.png",
                                          fit: BoxFit.fill,
                                        )
                                      : Image.asset(
                                          "assets/icons/open_eye.png",
                                          fit: BoxFit.fill,
                                        )),
                            ),
                            const SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                        validator: (value) => controller.validatePassword(value),
                        onFieldSubmitted: (p0) {
                          FocusScope.of(context).requestFocus(controller.confPasswordFocusNode);
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      heightSpace(20),
                      TextFormFieldWidget(
                        controller: controller.confPassController,
                        focusNode: controller.confPasswordFocusNode,
                        hint: StringConstants.enterConfirmPassword,
                        prefixIcon: SvgPicture.asset(
                          "assets/icons/lock_app.svg",
                          height: 24,
                          width: 24,
                          fit: BoxFit.fill,
                        ),
                        obscureText: !controller.isConfPasswordVisible,
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
                                  onPressed: () {
                                    controller.changeIsConfPasswordVisible();
                                  },
                                  icon: !controller.isConfPasswordVisible
                                      ? Image.asset(
                                          "assets/icons/close_eye.png",
                                          fit: BoxFit.fill,
                                        )
                                      : Image.asset(
                                          "assets/icons/open_eye.png",
                                          fit: BoxFit.fill,
                                        )),
                            ),
                            const SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                        validator: (value) => controller.validateConfirmPassword(value),
                        onFieldSubmitted: (p0) {
                          controller.confPasswordFocusNode.unfocus();
                        },
                        textInputAction: TextInputAction.done,
                      ),
                      heightSpace(20),
                      AppButton(
                        text: 'Continue',
                        textStyle: CommonTextStyle.regular16w500,
                        onPressed: () {
                          setState(() {});
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_formKey.currentState?.validate() ?? false) {
                            // Handle signup logic here
                            // You can navigate to next screen or call API
                          }
                        },
                      ),
                      heightSpace(30),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: ColorConstants.lightOrange, // line color
                              thickness: 1,
                              endIndent: 10,
                            ),
                          ),
                          Text(
                            "or continue with",
                            style: CommonTextStyle.regular14w400
                                .copyWith(color: ColorConstants.lightOrange),
                          ),
                          const Expanded(
                            child: Divider(
                              color: ColorConstants.lightOrange,
                              thickness: 1,
                              indent: 10,
                            ),
                          ),
                        ],
                      ),
                      heightSpace(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          socialButton(
                            child: Image.asset(
                              "assets/icons/facebook_icon.png",
                              fit: BoxFit.fill,
                              height: 40,
                              width: 40,
                            ),
                          ),
                          socialButton(
                            child: Image.asset(
                              "assets/icons/google_icon.png",
                              fit: BoxFit.fill,
                              height: 40,
                              width: 40,
                            ),
                          ),
                          socialButton(
                            child: Image.asset(
                              "assets/icons/apple_icon.png",
                              fit: BoxFit.fill,
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ],
                      ),
                      heightSpace(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: CommonTextStyle.regular14w400
                                .copyWith(color: ColorConstants.offGrey),
                          ),
                          InkWell(
                            onTap: () {
                              // Get.to(const LoginScreen());
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Login',
                              style: CommonTextStyle.regular14w400
                                  .copyWith(color: ColorConstants.lightOrange),
                            ),
                          )
                        ],
                      ),
                      heightSpace(30),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
