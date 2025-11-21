import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../homeModule/home_screen_splash.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool _isPermissionGranted = false;
  bool _isCheckingPermission = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    setState(() {
      _isCheckingPermission = true;
    });

    final status = await Permission.location.status;
    setState(() {
      _isPermissionGranted = status.isGranted;
      _isCheckingPermission = false;
    });
  }

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isCheckingPermission = true;
    });

    final status = await Permission.location.request();

    setState(() {
      _isPermissionGranted = status.isGranted;
      _isCheckingPermission = false;
    });

    if (status.isPermanentlyDenied) {
      // Show dialog to open app settings
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0x752A1F3A),
          title: const Text(
            'Location Permission Required',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Please enable location permission from app settings to continue.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Open Settings', style: TextStyle(color: Color(0xffF33F02))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightSpace(13),
                      InkWell(
                        onTap: Get.back,
                        child: SvgPicture.asset(
                          "assets/icons/back_arrow.svg",
                          height: 30,
                          width: 30,
                          fit: BoxFit.fill,
                        ),
                      ),
                      heightSpace(90),
                      const CommonTextWidget(
                        text: "Let's find Islanders\nnear you",
                        textType: TextType.head,
                      ),
                      heightSpace(5),
                      const CommonTextWidget(
                        text: "We use your location to show nearby connections.",
                        textType: TextType.des,
                      ),
                      heightSpace(100),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "assets/images/location_placeholder.png",
                            fit: BoxFit.contain,
                            width: 280,
                            height: 240,
                          ),
                        ),
                      ),
                      heightSpace(40),
                    ],
                  ),
                ).marginSymmetric(horizontal: 20),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                child: AppButton(
                  text: _isPermissionGranted ? "Continue" : "Enable Continue",
                  textStyle: CommonTextStyle.regular18w500,
                  onPressed: _isPermissionGranted
                      ? () {
                          Get.to(() => const HomeScreenSplash());
                        }
                      : _isCheckingPermission
                          ? null
                          : () {
                              _requestLocationPermission();
                            },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
