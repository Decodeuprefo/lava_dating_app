import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lava_dating_app/Api/api_controller.dart';
import 'package:lava_dating_app/View/homeModule/dashboard_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/services/storage_service.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import '../../Common/widgets/shimmers/location_permission_screen_shimmer_widget.dart';
import '../homeModule/home_screen_splash.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool _isPermissionGranted = false;
  bool _isCheckingPermission = false;
  bool _isLoading = false;
  bool _isLocationDataReady = false;
  double? _latitude;
  double? _longitude;
  String? _city;
  String? _country;
  final ApiController _apiController = Get.find<ApiController>();

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    setState(() {
      _isCheckingPermission = true;
    });

    final status = await Permission.location.status;
    setState(() {
      _isPermissionGranted = status.isGranted;
      _isCheckingPermission = false;
    });

    if (status.isGranted) {
      await _getCurrentLocation();
    }
  }

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isCheckingPermission = true;
    });

    final status = await Permission.location.request();

    setState(() {
      _isPermissionGranted = status.isGranted;
      _isCheckingPermission = false;
    });

    if (status.isPermanentlyDenied) {
      // Show dialog to open app settings
      _showPermissionDeniedDialog();
    } else if (status.isGranted) {
      await _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoading = true;
        _isLocationDataReady = false;
      });

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _isLocationDataReady = false;
        });
        showSnackBar(context, 'Location services are disabled. Please enable them.',
            isErrorMessageDisplay: true);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      if (position.latitude == null || position.longitude == null) {
        setState(() {
          _isLoading = false;
          _isLocationDataReady = false;
        });
        showSnackBar(context, 'Failed to get location coordinates. Please try again.',
            isErrorMessageDisplay: true);
        return;
      }

      _latitude = position.latitude;
      _longitude = position.longitude;

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          _city = place.locality ?? place.subAdministrativeArea ?? place.administrativeArea;
          _country = place.country;
        }
      } catch (e) {
        print('Error getting address from coordinates: $e');
      }

      if (_latitude != null && _longitude != null) {
        setState(() {
          _isLoading = false;
          _isLocationDataReady = true;
        });
      } else {
        setState(() {
          _isLoading = false;
          _isLocationDataReady = false;
        });
        showSnackBar(context, 'Location data incomplete. Please try again.',
            isErrorMessageDisplay: true);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLocationDataReady = false;
      });
      print('Error getting current location: $e');
      
      String errorMessage = 'Failed to get location. Please try again.';
      if (e.toString().contains('timeout') || e.toString().contains('TIMEOUT')) {
        errorMessage = 'Location request timed out. Please check your GPS and try again.';
      } else if (e.toString().contains('permission')) {
        errorMessage = 'Location permission denied. Please grant permission and try again.';
      }
      
      showSnackBar(context, errorMessage, isErrorMessageDisplay: true);
    }
  }

  Future<void> _updateLocation() async {
    if (!_isLocationDataReady || _latitude == null || _longitude == null) {
      showSnackBar(context, 'Location data not available. Please wait for location to load.',
          isErrorMessageDisplay: true);
      if (_isPermissionGranted && !_isLoading) {
        await _getCurrentLocation();
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final body = {
        'latitude': _latitude,
        'longitude': _longitude,
        if (_city != null) 'city': _city,
        if (_country != null) 'country': _country,
      };

      final response = await _apiController.updateUserProfile(body);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        await StorageService.setProfileComplete();
        Get.offAll(() => const DashboardScreen(), transition: Transition.noTransition);
      } else {
        final errorMessage = _apiController.getErrorMessage(response);
        showSnackBar(context, errorMessage, isErrorMessageDisplay: true);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, 'Network error. Please check your connection and try again.',
          isErrorMessageDisplay: true);
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0x752A1F3A),
          title: const Text(
            'Location Permission Required',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Please enable location permission from app settings to continue.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Open Settings', style: TextStyle(color: Color(0xffF33F02))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: BackgroundContainer(
          child: SafeArea(
            child: LocationPermissionScreenShimmerWidget(),
          ),
        ),
      );
    }

    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightSpace(13),
                      // Hide back button if this is the root/first screen
                      Builder(
                        builder: (context) {
                          final route = ModalRoute.of(context);
                          final isFirstRoute = route?.isFirst ?? false;
                          final canPop = Navigator.of(context).canPop();
                          
                          // Show back button only if:
                          // 1. This is NOT the first route in navigation stack
                          // 2. AND Navigator can pop (has previous route)
                          if (!isFirstRoute && canPop) {
                            return InkWell(
                              onTap: Get.back,
                              child: SvgPicture.asset(
                                "assets/icons/back_arrow.svg",
                                height: 30,
                                width: 30,
                                fit: BoxFit.fill,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      heightSpace(90),
                      const CommonTextWidget(
                        text: "Let's find Islanders\nnear you",
                        textType: TextType.head,
                      ),
                      heightSpace(5),
                      const CommonTextWidget(
                        text: "We use your location to show nearby connections.",
                        textType: TextType.des,
                      ),
                      heightSpace(100),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "assets/images/location_placeholder.png",
                            fit: BoxFit.contain,
                            width: 280,
                            height: 240,
                          ),
                        ),
                      ),
                      heightSpace(40),
                    ],
                  ),
                ).marginSymmetric(horizontal: 20),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                child: AppButton(
                  text: _isPermissionGranted && _isLocationDataReady
                      ? "Continue"
                      : _isPermissionGranted
                          ? "Getting Location..."
                          : "Enable Location",
                  textStyle: CommonTextStyle.regular16w500,
                  onPressed: (_isLoading || _isCheckingPermission || 
                             (_isPermissionGranted && !_isLocationDataReady))
                      ? null
                      : _isPermissionGranted && _isLocationDataReady
                          ? () {
                              _updateLocation();
                            }
                          : () {
                              _requestLocationPermission();
                            },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
