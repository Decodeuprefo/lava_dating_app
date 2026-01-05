import 'package:get/get.dart';
import '../View/blogsSpotlightModule/select_Island_location_screen.dart';
import 'select_island_location_controller.dart';

class TravelVisaCountry {
  final String id;
  final String name;
  final String flagAsset;
  final bool isActive;

  TravelVisaCountry({
    required this.id,
    required this.name,
    required this.flagAsset,
    this.isActive = true,
  });
}

class TravelVisaController extends GetxController {
  final RxString baseLocation = "Samoa".obs;
  final RxString baseFlagAsset = "assets/images/flag_example.png".obs;

  final RxList<TravelVisaCountry> visaCountries = <TravelVisaCountry>[
    TravelVisaCountry(
      id: '1',
      name: 'Tuvalu',
      flagAsset: 'assets/images/flag_example.png',
      isActive: true,
    ),
  ].obs;

  final RxInt maxVisaSlots = 3.obs;

  int get usedVisaSlots => visaCountries.length;

  int get availableVisaSlots => maxVisaSlots.value - usedVisaSlots;

  void addVisaCountry(IslandLocationItem location) {
    if (visaCountries.length < maxVisaSlots.value) {
      visaCountries.add(
        TravelVisaCountry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: location.name,
          flagAsset: location.flagAsset,
          isActive: true,
        ),
      );
    }
  }

  void removeVisaCountry(String id) {
    visaCountries.removeWhere((country) => country.id == id);
  }

  void saveAndActivateVisa() {
    // Handle save and activate action
    // Get.back();
  }

  void onAddCountryTap() async {
    final result = await Get.to(
      () => const SelectIslandLocationScreen(),
      arguments: 'travelVisa',
    );
    if (result != null && result is IslandLocationItem) {
      addVisaCountry(result);
    }
  }
}
