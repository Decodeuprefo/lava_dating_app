import 'package:get/get.dart';
import 'package:lava_dating_app/View/blogsSpotlightModule/see_map_location_screen.dart';

class IslandLocationItem {
  final String id;
  final String name;
  final String flagAsset;
  final String distance;
  final bool isPopular;

  IslandLocationItem({
    required this.id,
    required this.name,
    required this.flagAsset,
    required this.distance,
    this.isPopular = false,
  });
}

class SelectIslandLocationController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxList<IslandLocationItem> allLocations = <IslandLocationItem>[
    IslandLocationItem(
      id: '1',
      name: 'Tonga',
      flagAsset: 'assets/images/flag_example.png',
      distance: '1,200 km',
      isPopular: true,
    ),
    IslandLocationItem(
      id: '2',
      name: 'Am. Samoa',
      flagAsset: 'assets/images/flag_example.png',
      distance: '1,200 km',
      isPopular: true,
    ),
    IslandLocationItem(
      id: '3',
      name: 'Hawaii',
      flagAsset: 'assets/images/flag_example.png',
      distance: '1,200 km',
      isPopular: true,
    ),
    IslandLocationItem(
      id: '4',
      name: 'Aotearoa',
      flagAsset: 'assets/images/flag_example.png',
      distance: '1,200 km',
      isPopular: true,
    ),
    IslandLocationItem(
      id: '5',
      name: 'Tuvalu',
      flagAsset: 'assets/images/flag_example.png',
      distance: '1,200 km',
      isPopular: true,
    ),
    IslandLocationItem(
      id: '6',
      name: 'Tokelau',
      flagAsset: 'assets/images/flag_example.png',
      distance: '1,200 km',
      isPopular: true,
    ),
    IslandLocationItem(
      id: '7',
      name: 'Niue',
      flagAsset: 'assets/images/flag_example.png',
      distance: '1,200 km',
      isPopular: true,
    ),
    IslandLocationItem(
      id: '8',
      name: 'Cook Islands',
      flagAsset: 'assets/images/flag_example.png',
      distance: '1,200 km',
      isPopular: true,
    ),
    IslandLocationItem(
      id: '9',
      name: 'Wallis and Futuna',
      flagAsset: 'assets/images/flag_example.png',
      distance: '1,200 km',
      isPopular: false,
    ),
    IslandLocationItem(
      id: '10',
      name: 'Pitcairn Islands',
      flagAsset: 'assets/images/flag_example.png',
      distance: '1,200 km',
      isPopular: false,
    ),
  ].obs;

  final RxList<IslandLocationItem> filteredLocations = <IslandLocationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredLocations.value = allLocations;
    ever(searchQuery, (_) => _filterLocations());
  }

  void _filterLocations() {
    if (searchQuery.value.isEmpty) {
      filteredLocations.value = allLocations;
    } else {
      filteredLocations.value = allLocations
          .where(
              (location) => location.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void onLocationTap(IslandLocationItem location) {
    // Check if we came from TravelVisaScreen
    if (Get.previousRoute == '/travelVisa' || Get.arguments == 'travelVisa') {
      Get.back(result: location);
    } else {
      Get.to(() => const SeeMapLocationScreen(), arguments: location);
    }
  }

  // Method to update locations from API (for future use)
  void updateLocationsFromAPI(List<Map<String, dynamic>> apiData) {
    allLocations.value = apiData.map((data) {
      return IslandLocationItem(
        id: data['id']?.toString() ?? '',
        name: data['name'] ?? '',
        flagAsset: data['flagAsset'] ?? 'assets/images/flag_example.png',
        distance: data['distance'] ?? '',
        isPopular: data['isPopular'] ?? false,
      );
    }).toList();
  }
}
