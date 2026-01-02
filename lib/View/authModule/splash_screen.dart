import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Api/api_controller.dart';
import 'package:lava_dating_app/Common/services/storage_service.dart';
import 'package:lava_dating_app/Common/utils/profile_navigation_helper.dart';
import 'package:lava_dating_app/View/authModule/login_screen.dart';
import 'package:lava_dating_app/View/homeModule/dashboard_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/select_gender_screen.dart';
import 'package:lava_dating_app/View/welcomeModule/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ApiController _apiController = Get.find<ApiController>();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    if (StorageService.isLoggedIn()) {
      // Call API to get current user data
      await _checkProfileCompletionAndNavigate();
    } else if (StorageService.isWelcomeCompleted()) {
      Get.off(() => const LoginScreen());
    } else {
      Get.off(() => const WelcomeScreen());
    }
  }

  Future<void> _checkProfileCompletionAndNavigate() async {
    try {
      final response = await _apiController.getCurrentUser();

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null) {
          final userData = response.body as Map<String, dynamic>;
          final user = userData['user'] as Map<String, dynamic>?;

          if (user != null) {
            // Check if profile is complete - if yes, go directly to dashboard
            final isProfileComplete = user['isProfileComplete'] as bool? ?? false;
            if (isProfileComplete) {
              Get.offAll(() => const DashboardScreen());
              return;
            }

            // If profile is not complete, check which screen to show
            final nextScreen = ProfileNavigationHelper.determineNextScreen(user);
            Get.offAll(() => nextScreen);
            return;
          }
        }
      } else if (response.statusCode == 401) {
        // Unauthorized - user token expired or invalid, redirect to login
        await StorageService.clearTokens();
        Get.offAll(() => const LoginScreen());
        return;
      }

      // If API call fails, fallback to default behavior
      Get.offAll(() => const SelectGenderScreen());
    } catch (e) {
      print('Error fetching user data: $e');
      // On error, redirect to first screen
      Get.offAll(() => const SelectGenderScreen());
    }
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
