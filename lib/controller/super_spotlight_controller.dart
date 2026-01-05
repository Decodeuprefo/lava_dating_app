import 'package:get/get.dart';

class SuperSpotlightController extends GetxController {
  final RxBool hasSuperSpotlight = true.obs;
  final RxString profileImageUrl = 'assets/images/example_image.jpg'.obs;

  void activateSuperSpotlight() {
    if (hasSuperSpotlight.value) {
      hasSuperSpotlight.value = false;
    }
  }
}
