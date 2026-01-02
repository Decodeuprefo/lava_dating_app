import 'package:get/get.dart';

class IslandLocation {
  final String name;
  final String flagAsset;
  final bool isActive;
  final bool isPopular;

  IslandLocation({
    required this.name,
    required this.flagAsset,
    this.isActive = false,
    this.isPopular = false,
  });
}

class IslandHopController extends GetxController {
  final RxString currentLocation = "Samoa".obs;
  final RxString currentFlagAsset = "assets/images/flag_example.png".obs;
  final RxBool useRealLocation = false.obs;

  final RxList<IslandLocation> availableIslands = <IslandLocation>[
    IslandLocation(
      name: "Tonga",
      flagAsset: "assets/flags/tonga.png",
      isPopular: true,
    ),
    IslandLocation(
      name: "Am. Samoa",
      flagAsset: "assets/flags/american_samoa.png",
      isPopular: true,
    ),
    IslandLocation(
      name: "Hawaii",
      flagAsset: "assets/flags/hawaii.png",
      isPopular: true,
    ),
    IslandLocation(
      name: "Aotearoa",
      flagAsset: "assets/flags/aotearoa.png",
      isPopular: true,
    ),
    IslandLocation(
      name: "Tuvalu",
      flagAsset: "assets/flags/tuvalu.png",
      isPopular: true,
    ),
    IslandLocation(
      name: "Tokelau",
      flagAsset: "assets/flags/tokelau.png",
      isPopular: true,
    ),
    IslandLocation(
      name: "Niue",
      flagAsset: "assets/flags/niue.png",
      isPopular: true,
    ),
    IslandLocation(
      name: "Cook Islands",
      flagAsset: "assets/flags/cook_islands.png",
      isPopular: true,
    ),
  ].obs;

  void selectLocation(String locationName) {
    currentLocation.value = locationName;
  }

  void toggleRealLocation() {
    useRealLocation.value = !useRealLocation.value;
  }

  void startIslandHop() {
    // Handle island hop action
  }
}
