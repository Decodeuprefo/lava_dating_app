import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'select_island_location_controller.dart';

class SeeMapLocationController extends GetxController {
  final RxBool isPermissionGranted = false.obs;
  final RxBool isCheckingPermission = false.obs;
  final Rx<double?> latitude = Rx<double?>(null);
  final Rx<double?> longitude = Rx<double?>(null);
  
  IslandLocationItem? locationItem;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is IslandLocationItem) {
      locationItem = args;
    } else {
      // Fallback: try to get from previous screen's controller
      try {
        final selectController = Get.find<SelectIslandLocationController>();
        // This won't work as expected, so we'll rely on arguments
      } catch (e) {
        // controller not found, will use null
      }
    }
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    isCheckingPermission.value = true;
    
    final status = await Permission.location.status;
    isPermissionGranted.value = status.isGranted;
    isCheckingPermission.value = false;

    if (status.isGranted) {
      _loadLocationCoordinates();
    }
  }

  Future<void> requestLocationPermission() async {
    isCheckingPermission.value = true;
    
    final status = await Permission.location.request();
    isPermissionGranted.value = status.isGranted;
    isCheckingPermission.value = false;

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
    } else if (status.isGranted) {
      _loadLocationCoordinates();
    }
  }

  void _loadLocationCoordinates() {
    // TODO: Load coordinates from API based on locationItem
    // For now, using sample coordinates for Tonga
    if (locationItem != null) {
      // Example coordinates - replace with API call
      latitude.value = -21.178986; // Tonga coordinates
      longitude.value = -175.198242;
    }
  }

  void _showPermissionDeniedDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0x752A1F3A),
        title: const Text(
          'Location Permission Required',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Please enable location permission from app settings to view the map.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text('Open Settings', style: TextStyle(color: Color(0xffF33F02))),
          ),
        ],
      ),
    );
  }

  void onStartIslandHop() {
    // Navigate to next screen or perform action
    // Get.to(() => NextScreen(location: locationItem));
  }

  void onCancel() {
    Get.back();
  }

  // Method to update location from API
  void updateLocationFromAPI(Map<String, dynamic> apiData) {
    if (apiData.containsKey('latitude') && apiData.containsKey('longitude')) {
      latitude.value = apiData['latitude']?.toDouble();
      longitude.value = apiData['longitude']?.toDouble();
    }
  }
}
