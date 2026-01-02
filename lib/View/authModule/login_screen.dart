import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/View/authModule/signup_screen.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/string_constants.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/input_formatters.dart';
import '../../Common/widgets/text_form_field_widget.dart';
import '../../Controller/login_screen_controller.dart';
import '../setProfileModule/select_gender_screen.dart';
import 'forgot_pass_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final signInScreenController = Get.find<LoginScreenController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        signInScreenController.emailFocusNode.unfocus();
        signInScreenController.passwordFocusNode.unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Check if there are any routes in the navigation stack
        if (Navigator.of(context).canPop()) {
          // If there are routes, allow normal back navigation
          return true;
        } else {
          // If no routes, exit the app
          SystemNavigator.pop();
          return false;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BackgroundContainer(
          child: SafeArea(
            child: GetBuilder<LoginScreenController>(
              builder: (controller) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                      child: Form(
                        key: _formKey,
                        child: FocusScope(
                          autofocus: false,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 90,
                              ),
                              Image.asset(
                                'assets/images/app_logo.png',
                                width: 150,
                                height: 130,
                              ),
                              heightSpace(5),
                              const Text(
                                'Meet Pasifika Islanders\nFind love rooted in faith, culture & community.',
                                style: CommonTextStyle.regular14w400,
                                textAlign: TextAlign.center,
                              ),
                              heightSpace(45),
                              TextFormFieldWidget(
                                controller: signInScreenController.emailController,
                                focusNode: signInScreenController.emailFocusNode,
                                autofocus: true,
                                prefixIcon: SvgPicture.asset(
                                  "assets/icons/massage_icon.svg",
                                  height: 24,
                                  width: 24,
                                  fit: BoxFit.fill,
                                ),
                                hint: StringConstants.emailAddress,
                                validator: (value) => signInScreenController.validateEmail(value),
                                onFieldSubmitted: (p0) {
                                  // FocusScope.of(context)
                                  //     .requestFocus(signInScreenController.emailFocusNode);
                                  // signInScreenController.emailFocusNode.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(signInScreenController.passwordFocusNode);
                                },
                                /* onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(signInScreenController.emailFocusNode);
                              },*/
                                inputFormatters: [
                                  CustomFormatterForSpaceAndEmoji(),
                                ],
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.emailAddress,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormFieldWidget(
                                controller: signInScreenController.passwordController,
                                focusNode: signInScreenController.passwordFocusNode,
                                hint: StringConstants.enterPassword,
                                prefixIcon: SvgPicture.asset(
                                  "assets/icons/lock_app.svg",
                                  height: 24,
                                  width: 24,
                                  fit: BoxFit.fill,
                                ),
                                obscureText: !signInScreenController.isPasswordVisible,
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
                                            signInScreenController.changeIsPasswordVisible();
                                            setState(() {});
                                          },
                                          icon: !signInScreenController.isPasswordVisible
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
                                    signInScreenController.validatePassword(value),
                                onFieldSubmitted: (p0) {
                                  signInScreenController.passwordFocusNode.unfocus();
                                },
                                textInputAction: TextInputAction.done,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.centerRight, // Aligns text to right side
                                child: TextButton(
                                  onPressed: () {
                                    Get.to(() => const ForgotPassScreen());
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    "Forgot Password?",
                                    style: CommonTextStyle.regular14w400.copyWith(
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white),
                                  ),
                                ),
                              ),
                              heightSpace(30),
                              AppButton(
                                text: 'Login',
                                textStyle: CommonTextStyle.regular16w500,
                                onPressed: controller.isLoading
                                    ? null
                                    : () {
                                        setState(() {});
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        if (_formKey.currentState?.validate() ?? false) {
                                          controller.login(context);
                                        }
                                      },
                              ),
                              heightSpace(65),
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
                                      controller.googleLogin(context);
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
                                      Get.to(() => const SignupScreen());
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: CommonTextStyle.regular14w400
                                          .copyWith(color: ColorConstants.lightOrange),
                                    ),
                                  )
                                ],
                              ),
                              heightSpace(30),
                            ],
                          ).marginSymmetric(horizontal: 20.0),
                        ),
                      ),
                    ),
                    // Loading overlay
                    if (controller.isLoading)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: ColorConstants.lightOrange,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
