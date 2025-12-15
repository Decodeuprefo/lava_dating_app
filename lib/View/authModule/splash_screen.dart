import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/View/authModule/login_screen.dart';
import 'package:lava_dating_app/View/welcomeModule/welcome_one_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => const WelcomeOneScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/app_background.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Image.asset(
              'assets/images/app_logo.png',
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
