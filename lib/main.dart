import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/View/authModule/splash_screen.dart';
import 'package:lava_dating_app/View/homeModule/dashboard_screen.dart';
import 'Api/api_controller.dart';
import 'Common/services/storage_service.dart';
import 'Common/widgets/back_button_handler_widget.dart';
import 'Controller/login_screen_controller.dart';
import 'Controller/setProfileControllers/profile_module_controller.dart';
import 'Controller/signup_screen_controller.dart';
import 'View/authModule/forgot_pass_screen.dart';
import 'View/authModule/login_screen.dart';
import 'View/homeModule/congratulations_screen.dart';
import 'View/setProfileModule/interests_and_hobbies.dart';
import 'View/setProfileModule/kids_screen.dart';
import 'View/setProfileModule/preferred_age_range_screen.dart';
import 'View/setProfileModule/preferred_distance_screen.dart';
import 'View/setProfileModule/preferred_gender_screen.dart';
import 'View/setProfileModule/race_flags_screen.dart';
import 'View/setProfileModule/select_education_screen.dart';
import 'View/setProfileModule/select_height_screen.dart';
import 'View/setProfileModule/select_languages_spoken.dart';
import 'View/setProfileModule/select_lifestyle_screen.dart';
import 'View/setProfileModule/select_relationship_type_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
  Get.put(ApiController(), permanent: true);
  Get.put(LoginScreenController());
  // Get.put(SignupScreenController());
  Get.put(ProfileModuleController());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        routingCallback: (routing) {},
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light,
            ),
          ),
        ),
        builder: (context, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.light,
              systemNavigationBarDividerColor: Colors.transparent,
            ),
            child: child!,
          );
        },
        home: const SplashScreen(),
      ),
    );
  }
}
