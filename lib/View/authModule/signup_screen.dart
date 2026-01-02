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
import '../../Controller/login_screen_controller.dart';
import '../../Controller/signup_screen_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final SignupScreenController signupScreenController;

  @override
  void initState() {
    super.initState();
    signupScreenController = Get.put(SignupScreenController());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupScreenController>(builder: (controller) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          body: BackgroundContainer(
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heightSpace(35),
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
                            controller: signupScreenController.firstNameController,
                            prefixIcon: Image.asset(
                              "assets/icons/user_icon.png",
                              height: 24,
                              width: 24,
                              fit: BoxFit.fill,
                            ),
                            hint: StringConstants.firstName,
                            validator: (value) => signupScreenController.validateFieldNotEmpty(
                              value,
                              StringConstants.emptyFirstName,
                            ),
                            autofocus: true,
                            onFieldSubmitted: (p0) {
                              FocusScope.of(context)
                                  .requestFocus(signupScreenController.lastNameFocusNode);
                            },
                            focusNode: signupScreenController.firstNameFocusNode,
                            textInputAction: TextInputAction.next,
                          ),
                          heightSpace(20),
                          TextFormFieldWidget(
                            controller: signupScreenController.lastNameController,
                            prefixIcon: Image.asset(
                              "assets/icons/user_icon.png",
                              height: 24,
                              width: 24,
                              fit: BoxFit.fill,
                            ),
                            hint: StringConstants.lastName,
                            validator: (value) => signupScreenController.validateFieldNotEmpty(
                              value,
                              StringConstants.emptyLastName,
                            ),
                            onFieldSubmitted: (p0) {
                              FocusScope.of(context)
                                  .requestFocus(signupScreenController.mobileNumberFocusNode);
                            },
                            focusNode: signupScreenController.lastNameFocusNode,
                            textInputAction: TextInputAction.next,
                          ),
                          heightSpace(20),
                          TextFormFieldWidget(
                            controller: signupScreenController.mobileNumberController,
                            focusNode: signupScreenController.mobileNumberFocusNode,
                            prefixIcon: Image.asset(
                              "assets/icons/phone_icon.png",
                              height: 24,
                              width: 24,
                              fit: BoxFit.fill,
                            ),
                            hint: StringConstants.mobileNumber,
                            validator: (value) =>
                                signupScreenController.validateMobileNumber(value),
                            onFieldSubmitted: (p0) {
                              FocusScope.of(context)
                                  .requestFocus(signupScreenController.emailFocusNode);
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.phone,
                          ),
                          heightSpace(20),
                          TextFormFieldWidget(
                            controller: signupScreenController.emailController,
                            focusNode: signupScreenController.emailFocusNode,
                            prefixIcon: SvgPicture.asset(
                              "assets/icons/massage_icon.svg",
                              height: 24,
                              width: 24,
                              fit: BoxFit.fill,
                            ),
                            hint: StringConstants.emailAddress,
                            validator: (value) => signupScreenController.validateEmail(value),
                            onFieldSubmitted: (p0) {
                              FocusScope.of(context)
                                  .requestFocus(signupScreenController.passwordFocusNode);
                            },
                            inputFormatters: [
                              CustomFormatterForSpaceAndEmoji(),
                            ],
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.emailAddress,
                          ),
                          heightSpace(20),
                          TextFormFieldWidget(
                            controller: signupScreenController.passController,
                            focusNode: signupScreenController.passwordFocusNode,
                            hint: StringConstants.enterPassword,
                            prefixIcon: SvgPicture.asset(
                              "assets/icons/lock_app.svg",
                              height: 24,
                              width: 24,
                              fit: BoxFit.fill,
                            ),
                            obscureText: !signupScreenController.isPasswordVisible,
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
                                        signupScreenController.changeIsPasswordVisible();
                                        setState(() {});
                                      },
                                      icon: !signupScreenController.isPasswordVisible
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
                            validator: (value) => signupScreenController.validatePassword(value),
                            onFieldSubmitted: (p0) {
                              FocusScope.of(context)
                                  .requestFocus(signupScreenController.confPasswordFocusNode);
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          heightSpace(20),
                          TextFormFieldWidget(
                            controller: signupScreenController.confPassController,
                            focusNode: signupScreenController.confPasswordFocusNode,
                            hint: StringConstants.enterConfirmPassword,
                            prefixIcon: SvgPicture.asset(
                              "assets/icons/lock_app.svg",
                              height: 24,
                              width: 24,
                              fit: BoxFit.fill,
                            ),
                            obscureText: !signupScreenController.isConfPasswordVisible,
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
                                        signupScreenController.changeIsConfPasswordVisible();
                                        setState(() {});
                                      },
                                      icon: !signupScreenController.isConfPasswordVisible
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
                            validator: (value) =>
                                signupScreenController.validateConfirmPassword(value),
                            onFieldSubmitted: (p0) {
                              signupScreenController.confPasswordFocusNode.unfocus();
                            },
                            textInputAction: TextInputAction.done,
                          ),
                          heightSpace(20),
                          AppButton(
                            text: 'Continue',
                            textStyle: CommonTextStyle.regular16w500,
                            onPressed: signupScreenController.isLoading
                                ? null
                                : () {
                                    setState(() {});
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    if (_formKey.currentState?.validate() ?? false) {
                                      signupScreenController.signUp(context);
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
                                onTap: () {
                                  final loginCtrl = Get.find<LoginScreenController>();
                                  loginCtrl.googleLogin(context);
                                },
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
                    // Loading overlay
                    if (signupScreenController.isLoading ||
                        (Get.isRegistered<LoginScreenController>()
                            ? Get.find<LoginScreenController>().isLoading
                            : false))
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: ColorConstants.lightOrange,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
