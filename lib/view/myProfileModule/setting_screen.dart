import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/glass_background_widget.dart';
import 'package:lava_dating_app/Common/widgets/custom_toggle_switch.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/View/inappPurchase/membership_screen.dart';
import 'package:lava_dating_app/View/myProfileModule/push_notification_screen.dart';
import 'package:lava_dating_app/View/myProfileModule/about_us_screen.dart';
import 'package:lava_dating_app/View/myProfileModule/terms_and_conditions_screen.dart';
import 'package:lava_dating_app/View/myProfileModule/change_password_screen.dart';
import 'package:lava_dating_app/View/myProfileModule/contact_us_screen.dart';
import 'package:lava_dating_app/View/myProfileModule/delete_account_screen.dart';
import 'package:lava_dating_app/Api/api_controller.dart';
import 'package:lava_dating_app/Common/services/storage_service.dart';
import 'package:lava_dating_app/View/authModule/login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool outTheWayMode = true;
  final TextEditingController _shareMessageController = TextEditingController(
    text: "Hey! I'm using LAVA. Join me here and explore amazing profiles!",
  );

  List<Map<String, dynamic>> get settingsItems => [
        {
          'title': 'Membership',
          'iconPath': 'assets/icons/settings/membership_icon.png',
          'onTap': () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const MembershipScreen(),
              ),
            );
          },
        },
        {
          'title': 'Change Password',
          'iconPath': 'assets/icons/settings/change_password_icon.png',
          'onTap': () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const ChangePasswordScreen(),
              ),
            );
          },
        },
        {
          'title': 'Push Notification',
          'iconPath': 'assets/icons/settings/push_notification_icon.png',
          'onTap': () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const PushNotificationScreen(),
              ),
            );
          },
        },
        {
          'title': 'About Us',
          'iconPath': 'assets/icons/settings/about_us_icon.png',
          'onTap': () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const AboutUsScreen(),
              ),
            );

            // Get.to(()=> const AboutUsScreen(),  transition: Transition.noTransition,);
          },
        },
        {
          'title': 'Contact Us',
          'iconPath': 'assets/icons/settings/contact_us_icon.png',
          'onTap': () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const ContactUsScreen(),
              ),
            );
          },
        },
        {
          'title': 'Terms & Conditions',
          'iconPath': 'assets/icons/settings/terms_conditions_icon.png',
          'onTap': () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const TermsAndConditionsScreen(),
              ),
            );
          },
        },
        {
          'title': 'Privacy Policy',
          'iconPath': 'assets/icons/settings/privacy_policy_icon.png',
          'onTap': () {},
        },
        {
          'title': 'Block User',
          'iconPath': 'assets/icons/settings/block_user_icon.png',
          'onTap': () {},
        },
        {
          'title': 'Share LAVA',
          'iconPath': 'assets/icons/settings/share_lava_icon.png',
          'onTap': null,
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heightSpace(20),
                  _buildHeader(),
                  heightSpace(30),
                  _buildSettingsList(),
                  heightSpace(20),
                  _buildToggleSection(),
                  heightSpace(20),
                  _buildDeleteAccountSection(),
                  heightSpace(30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: Get.back,
          child: SvgPicture.asset(
            "assets/icons/back_arrow.svg",
            height: 30,
            width: 30,
            fit: BoxFit.fill,
          ),
        ),
        heightSpace(20),
        const Center(
          child: Text(
            "Setting",
            style: CommonTextStyle.semiBold30w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsList() {
    return GlassBackgroundWidget(
      borderRadius: 10,
      padding: EdgeInsets.zero,
      child: Column(
        children: List.generate(settingsItems.length, (index) {
          final item = settingsItems[index];
          final bool isLast = index == settingsItems.length - 1;
          return Column(
            children: [
              _buildSettingItem(
                iconPath: item['iconPath'] as String,
                title: item['title'] as String,
                onTap: item['onTap'] as VoidCallback?,
              ),
              if (!isLast) _buildDivider(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSettingItem({
    required String iconPath,
    required String title,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (title == 'Share LAVA') {
              _showShareLavaBottomSheet(context);
            }
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.warning,
                    color: ColorConstants.lightOrange,
                    size: 22,
                  );
                },
              ),
            ),
            widthSpace(16),
            Expanded(
              child: Text(
                title,
                style: CommonTextStyle.regular14w400,
              ),
            ),
            Transform.rotate(
              angle: -90 * 3.1415926535 / 180,
              child: Image.asset(
                "assets/icons/drop_down_arrow.png",
                fit: BoxFit.contain,
                width: 21,
                height: 21,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Image.asset(
        "assets/images/border_line.png",
        height: 1,
        width: double.infinity,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 1,
            color: ColorConstants.lightOrange.withOpacity(0.3),
          );
        },
      ),
    );
  }

  Widget _buildToggleSection() {
    return GlassBackgroundWidget(
      borderRadius: 15,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Out The Way Mode",
              style: CommonTextStyle.regular14w400,
            ),
          ),
          CustomToggleSwitch(
            value: outTheWayMode,
            onChanged: (value) {
              setState(() {
                outTheWayMode = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteAccountSection() {
    return GlassBackgroundWidget(
      borderRadius: 15,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const DeleteAccountScreen(),
                ),
              );
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/settings/delete_outline.png',
                  fit: BoxFit.contain,
                  width: 21,
                  height: 21,
                ),
                widthSpace(16),
                const Expanded(
                  child: Text(
                    "Delete Account",
                    style: CommonTextStyle.regular14w400,
                  ),
                ),
                Transform.rotate(
                  angle: -90 * 3.1415926535 / 180,
                  child: Image.asset(
                    "assets/icons/drop_down_arrow.png",
                    fit: BoxFit.contain,
                    width: 21,
                    height: 21,
                  ),
                )
              ],
            ),
          ),
          heightSpace(15),
          _buildDivider(),
          heightSpace(15),
          GestureDetector(
            onTap: () {
              _showLogoutDialog(context);
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/settings/logout.png',
                  fit: BoxFit.contain,
                  width: 21,
                  height: 21,
                ),
                widthSpace(16),
                const Expanded(
                  child: Text(
                    "Logout",
                    style: CommonTextStyle.regular14w400,
                  ),
                ),
                Transform.rotate(
                  angle: -90 * 3.1415926535 / 180,
                  child: Image.asset(
                    "assets/icons/drop_down_arrow.png",
                    fit: BoxFit.contain,
                    width: 21,
                    height: 21,
                  ),
                )
              ],
            ),
          ),
        ],
      ).paddingAll(20),
    );
  }

  void _showShareLavaBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildShareLavaBottomSheet(),
    );
  }

  Widget _buildShareLavaBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.8),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 8),
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Share LAVA",
                  style: CommonTextStyle.semiBold30w600,
                ),
              ),
              heightSpace(30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Write Your Message",
                    style: CommonTextStyle.regular20w600,
                  ),
                ),
              ),
              heightSpace(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: ColorConstants.lightOrange,
                          width: 1.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          TextField(
                            controller: _shareMessageController,
                            maxLength: 200,
                            maxLines: 6,
                            minLines: 4,
                            style: CommonTextStyle.regular12w400,
                            decoration: InputDecoration(
                              hintText: "Write your message here...",
                              hintStyle: CommonTextStyle.regular14w400.copyWith(
                                color: Colors.white.withOpacity(0.5),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                              counterText: "",
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 12,
                            child: ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _shareMessageController,
                              builder: (context, value, child) {
                                return Text(
                                  "${value.text.length}/200",
                                  style: CommonTextStyle.regular12w400.copyWith(fontSize: 10),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).marginSymmetric(horizontal: 20),
              ),

              Padding(
                padding:
                    EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
                child: AppButton(
                  text: "Share Now",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: ColorConstants.lightOrange,
                  textStyle: CommonTextStyle.regular16w500,
                  width: double.infinity,
                  height: 50,
                  borderRadius: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.5),
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      useRootNavigator: true,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
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
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: ColorConstants.lightOrange,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "assets/icons/logout_icon.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Logout?",
                        style: CommonTextStyle.regular20w600,
                        textAlign: TextAlign.center,
                      ),
                      heightSpace(10),
                      const Text(
                        "Are you sure you want to logout? You will need to login again to access your account.",
                        style: CommonTextStyle.regular14w400,
                        textAlign: TextAlign.center,
                      ),
                      heightSpace(30),
                      Row(
                        children: [
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
                          Expanded(
                            child: AppButton(
                              text: 'Logout',
                              textStyle: CommonTextStyle.regular16w500,
                              backgroundColor: ColorConstants.lightOrange,
                              onPressed: () {
                                Navigator.of(context).pop();
                                _performLogout(context);
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

  Future<void> _performLogout(BuildContext context) async {
    try {
      final apiController = Get.find<ApiController>();
      final response = await apiController.logout();

      if (response.statusCode == 200 || response.statusCode == 201) {
        await StorageService.clearTokens();

        if (context.mounted) {
          showSnackBar(
            context,
            "Logged out successfully",
            isErrorMessageDisplay: false,
            iconPath: "assets/icons/check_icon.png",
          );

          Future.delayed(const Duration(milliseconds: 200), () {
            Get.offAll(() => const LoginScreen());
          });
        }
      } else {
        if (context.mounted) {
          final errorMessage = apiController.getErrorMessage(response);
          showSnackBar(context, errorMessage, isErrorMessageDisplay: true);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context,
          'Network error. Please check your connection and try again.',
          isErrorMessageDisplay: true,
        );
      }
    }
  }

  @override
  void dispose() {
    _shareMessageController.dispose();
    super.dispose();
  }
}
