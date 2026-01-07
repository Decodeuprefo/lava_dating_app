import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/View/homeModule/dashboard_screen.dart';
import 'package:lava_dating_app/view/authModule/splash_screen.dart';
import 'Api/api_controller.dart';
import 'Common/services/storage_service.dart';
import 'Common/services/connectivity_service.dart';
import 'Controller/login_screen_controller.dart';
import 'Controller/setProfileControllers/profile_module_controller.dart';
import 'View/setProfileModule/select_height_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await StorageService.init();
  } catch (e) {
    print('StorageService init error: $e');
  }

  try {
    Get.put(ApiController(), permanent: true);
  } catch (e) {
    print('ApiController init error: $e');
  }

  try {
    Get.put(LoginScreenController());
  } catch (e) {
    print('LoginScreenController init error: $e');
  }

  try {
    Get.put(ProfileModuleController());
  } catch (e) {
    print('ProfileModuleController init error: $e');
  }

  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e) {
    print('SystemChrome orientation error: $e');
  }

  try {
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
  } catch (e) {
    print('SystemChrome overlay error: $e');
  }

  runApp(const MyApp());

  Future.delayed(const Duration(milliseconds: 1000), () {
    try {
      if (Get.isRegistered<ConnectivityService>()) {
        return;
      }
      Get.put(ConnectivityService(), permanent: true);
    } catch (e) {
      print('ConnectivityService init error: $e');
    }
  });
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
