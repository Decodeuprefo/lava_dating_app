import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Common/widgets/input_formatters.dart';
import 'package:lava_dating_app/Common/widgets/text_form_field_widget.dart';
import 'package:lava_dating_app/Controller/contact_us_controller.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContactUsController());
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
                          _buildTitle(),
                          heightSpace(10),
                          _buildLogo(),
                          heightSpace(10),
                          _buildIntroText(),
                          heightSpace(30),
                          _buildFullNameField(context, controller),
                          heightSpace(20),
                          _buildEmailField(context, controller),
                          heightSpace(20),
                          _buildSubjectField(context, controller),
                          heightSpace(20),
                          _buildMessageField(context, controller),
                          heightSpace(40),
                          _buildGetInTouchSection(),
                          heightSpace(40),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildSendMessageButton(controller, formKey)
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
    return Center(
      child: Text(
        "Contact Us",
        style: CommonTextStyle.regular30w600.copyWith(
          color: ColorConstants.lightOrange,
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/images/app_logo.png',
        width: 95,
        height: 80,
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

  Widget _buildIntroText() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "We'd Love to Hear From You!",
            style: CommonTextStyle.regular14w400,
            textAlign: TextAlign.center,
          ),
          heightSpace(8),
          const Text(
            "Have a question, feedback, or issue?\nReach out to us anytime",
            style: CommonTextStyle.regular14w400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFullNameField(BuildContext context, ContactUsController controller) {
    return TextFormFieldWidget(
      controller: controller.fullNameController,
      focusNode: controller.fullNameFocusNode,
      hint: "Full Name",
      inputFormatters: [
        CustomFormatterForSpaceAndEmoji(),
      ],
      validator: controller.validateFullName,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(controller.emailFocusNode);
      },
      textInputAction: TextInputAction.next,
      radius: 10,
    );
  }

  Widget _buildEmailField(BuildContext context, ContactUsController controller) {
    return TextFormFieldWidget(
      controller: controller.emailController,
      focusNode: controller.emailFocusNode,
      hint: "Email Address",
      textInputType: TextInputType.emailAddress,
      inputFormatters: [
        CustomFormatterForSpaceAndEmoji(),
      ],
      validator: controller.validateEmail,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(controller.subjectFocusNode);
      },
      textInputAction: TextInputAction.next,
      radius: 10,
    );
  }

  Widget _buildSubjectField(BuildContext context, ContactUsController controller) {
    return TextFormFieldWidget(
      controller: controller.subjectController,
      focusNode: controller.subjectFocusNode,
      hint: "Subject",
      inputFormatters: [
        CustomFormatterForSpaceAndEmoji(),
      ],
      validator: controller.validateSubject,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(controller.messageFocusNode);
      },
      textInputAction: TextInputAction.next,
      radius: 10,
    );
  }

  Widget _buildMessageField(BuildContext context, ContactUsController controller) {
    return TextFormFieldWidget(
      controller: controller.messageController,
      focusNode: controller.messageFocusNode,
      hint: "Message",
      maxLines: 4,
      minLines: 4,
      textInputType: TextInputType.multiline,
      inputFormatters: [
        CustomFormatterForSpaceAndEmoji(),
      ],
      validator: controller.validateMessage,
      onFieldSubmitted: (value) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      textInputAction: TextInputAction.newline,
      radius: 10,
    );
  }

  Widget _buildGetInTouchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Get in Touch",
          style: CommonTextStyle.regular16w600.copyWith(
            color: ColorConstants.lightOrange,
          ),
        ),
        heightSpace(20),
        _buildContactItem(
          icon: "assets/icons/doc_message.png",
          text: "support@lava.com",
          onTap: () {},
        ),
        heightSpace(15),
        _buildContactItem(
          icon: "assets/icons/duo_web.png",
          text: "www.lava.com",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required String icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(
            icon,
            height: 21,
            width: 21,
          ),
          widthSpace(10),
          Text(
            text,
            style: CommonTextStyle.regular14w400.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendMessageButton(
    ContactUsController controller,
    GlobalKey<FormState> formKey,
  ) {
    return AppButton(
      text: 'Send Message',
      textStyle: CommonTextStyle.regular16w500,
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (formKey.currentState?.validate() ?? false) {
          controller.sendMessage();
        }
      },
      borderRadius: 10,
    );
  }
}
