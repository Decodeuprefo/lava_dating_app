import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/constant/string_constants.dart';
import '../../Common/widgets/input_formatters.dart';
import '../../Common/widgets/text_form_field_widget.dart';
import '../../Controller/forgot_password_controller.dart';
import 'login_screen.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  late final ForgotPasswordController forgotPasswordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    forgotPasswordController = Get.put(ForgotPasswordController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              BackgroundContainer(
                child: SafeArea(
                  child: SingleChildScrollView(
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
                          'Forgot Your Password?',
                          style: CommonTextStyle.semiBold30w600,
                        ),
                        const Text(
                          "No worries! Enter your registered email address, and we'll send you instructions to reset your password.",
                          style: CommonTextStyle.regular14w400,
                        ),
                        heightSpace(60),
                        centerImagePlaceHolder(),
                        heightSpace(50),
                        Form(
                          key: _formKey,
                          child: TextFormFieldWidget(
                            controller: forgotPasswordController.emailController,
                            focusNode: forgotPasswordController.emailFocusNode,
                            prefixIcon: SvgPicture.asset(
                              "assets/icons/massage_icon.svg",
                              height: 24,
                              width: 24,
                              fit: BoxFit.fill,
                            ),
                            hint: StringConstants.emailAddress,
                            validator: (value) => forgotPasswordController.validateEmail(value),
                            autofocus: true,
                            onFieldSubmitted: (p0) {
                              FocusScope.of(context)
                                  .requestFocus(forgotPasswordController.emailFocusNode);
                            },
                            inputFormatters: [
                              CustomFormatterForSpaceAndEmoji(),
                            ],
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.emailAddress,
                          ),
                        ),
                        heightSpace(30),
                        AppButton(
                          text: "Send Reset Link",
                          textStyle: CommonTextStyle.regular16w500,
                          onPressed: controller.isLoading
                              ? null
                              : () {
                                  setState(() {});
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (_formKey.currentState?.validate() ?? false) {
                                    controller.forgotPassword(context);
                                  }
                                },
                        ),
                        heightSpace(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Back to ",
                              style: CommonTextStyle.regular14w400
                                  .copyWith(color: ColorConstants.offGrey),
                            ),
                            InkWell(
                              onTap: () {
                                Get.back();
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
                    ).marginSymmetric(horizontal: 20),
                  ),
                ),
              ),
              if (controller.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF4A00)),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  centerImagePlaceHolder() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.topLeft,
                colors: [
                  Color.fromRGBO(255, 186, 120, 1),
                  Color.fromRGBO(243, 63, 2, 1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(243, 63, 2, 0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/forgot_screen_placeholder.png",
              fit: BoxFit.cover,
              height: 100,
              width: 103,
            ),
          ),
        ],
      ),
    );
  }
}
