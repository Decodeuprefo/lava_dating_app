import 'package:get/get.dart';

class SpotlightPackage {
  final int quantity;
  final String price;
  final String? savingsPercentage;

  SpotlightPackage({
    required this.quantity,
    required this.price,
    this.savingsPercentage,
  });
}

class SpotlightYourProfileController extends GetxController {
  final RxInt availableSpotlights = 1.obs;
  final RxInt resetDays = 6.obs;

  final RxList<SpotlightPackage> spotlightPackages = <SpotlightPackage>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSpotlightPackages();
  }

  void _loadSpotlightPackages() {
    spotlightPackages.value = [
      SpotlightPackage(
        quantity: 1,
        price: '\$3.99',
      ),
      SpotlightPackage(
        quantity: 5,
        price: '\$16.99',
        savingsPercentage: '15',
      ),
      SpotlightPackage(
        quantity: 10,
        price: '\$29.99',
        savingsPercentage: '25',
      ),
    ];
  }

  void activateSpotlight() {
    if (availableSpotlights.value > 0) {
      availableSpotlights.value--;
    }
  }

  void buySpotlightPackage(int quantity) {
    availableSpotlights.value += quantity;
  }
}
