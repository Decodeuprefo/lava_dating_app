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
import '../../Controller/login_screen_controller.dart';
import 'login_screen.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final signInScreenController = Get.find<LoginScreenController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
          child: SingleChildScrollView(
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
              'Forgot Your Password?',
              style: CommonTextStyle.semiBold30w600,
            ),
            const Text(
              "No worries! Enter your registered email address, and we’ll send you instructions to reset your password.",
              style: CommonTextStyle.regular14w400,
            ),
            Image.asset(
              "assets/images/forgot_screen_placeholder.png",
              fit: BoxFit.fill,
            ),
            TextFormFieldWidget(
              controller: signInScreenController.emailController,
              focusNode: signInScreenController.emailFocusNode,
              prefixIcon: SvgPicture.asset(
                "assets/icons/massage_icon.svg",
                height: 24,
                width: 24,
                fit: BoxFit.fill,
              ),
              hint: StringConstants.emailAddress,
              validator: (value) => signInScreenController.validateEmail(value!),
              onFieldSubmitted: (p0) {
                FocusScope.of(context).requestFocus(signInScreenController.emailFocusNode);
              },
              inputFormatters: [
                CustomFormatterForSpaceAndEmoji(),
              ],
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.emailAddress,
            ),
            heightSpace(30),
            AppButton(
              text: "Send Reset Link",
              textStyle: CommonTextStyle.regular16w500,
              onPressed: () {
                setState(() {});
                FocusManager.instance.primaryFocus?.unfocus();
                if (_formKey.currentState?.validate() ?? false) {}
              },
            ),
            heightSpace(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Back to ",
                  style: CommonTextStyle.regular14w400.copyWith(color: ColorConstants.offGrey),
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
                    style:
                        CommonTextStyle.regular14w400.copyWith(color: ColorConstants.lightOrange),
                  ),
                )
              ],
            ),
            heightSpace(30),
          ],
        ).marginSymmetric(horizontal: 20),
      )),
    );
  }
}
