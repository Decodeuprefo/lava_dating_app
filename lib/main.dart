import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'Controller/login_screen_controller.dart';
import 'Controller/profile_module_controller.dart';
import 'Controller/signup_screen_controller.dart';
import 'View/example.dart';
import 'View/homeModule/dashboard_screen.dart';
import 'View/homeModule/home_screen_splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
  Get.put(LoginScreenController());
  Get.put(SignupScreenController());
  Get.put(ProfileModuleController());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const DashboardScreen(),
    );
  }
}
