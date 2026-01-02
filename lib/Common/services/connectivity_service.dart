import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/color_constants.dart';
import '../constant/common_text_style.dart';
import '../constant/custom_tools.dart';
import '../widgets/custom_button.dart';
import '../widgets/glassmorphic_background_widget.dart';

class ConnectivityService extends GetxController {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  final RxBool isConnected = true.obs;
  final RxBool isDialogShowing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _startListening();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      print('Error checking connectivity: $e');
    }
  }

  void _startListening() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> result) {
        _updateConnectionStatus(result);
      },
      onError: (error) {
        print('Connectivity error: $error');
      },
    );
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Check if any connection type is available
    final hasConnection = results.any((result) => result != ConnectivityResult.none);

    final wasConnected = isConnected.value;
    isConnected.value = hasConnection;

    // Show dialog when connection is lost
    if (!hasConnection && wasConnected && !isDialogShowing.value) {
      _showNoInternetDialog();
    }

    // Hide dialog when connection is restored
    if (hasConnection && !wasConnected && isDialogShowing.value) {
      _hideNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    if (isDialogShowing.value) return;

    isDialogShowing.value = true;

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent closing by back button
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: GlassmorphicBackgroundWidget(
            borderRadius: 20,
            blur: 15,
            border: 1.5,
            padding: const EdgeInsets.all(24),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
                const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
                const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
                const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
                const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
                const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
                const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
              ],
              stops: const [0.0, 0.5, 1.0, 0.55, 0.70, 0.85, 1.00],
            ),
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.08),
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.08),
                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.08),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: ColorConstants.lightOrange.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wifi_off_rounded,
                    size: 40,
                    color: ColorConstants.lightOrange,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'No Internet Connection',
                  style: CommonTextStyle.semiBold30w600.copyWith(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Message
                Text(
                  'Please check your internet connection and try again.',
                  style: CommonTextStyle.regular14w400.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Retry Button
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: 'Retry',
                    onPressed: () {
                      _checkConnectionAndRetry();
                    },
                    backgroundColor: ColorConstants.lightOrange,
                    borderRadius: 12,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: CommonTextStyle.regular16w500.copyWith(
                      color: Colors.white,
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
    );
  }

  void _hideNoInternetDialog() {
    if (!isDialogShowing.value) return;

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    isDialogShowing.value = false;

    // Show success message
    Get.snackbar(
      'Connection Restored',
      'Internet connection is back online.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
      icon: const Icon(
        Icons.wifi,
        color: Colors.white,
      ),
    );
  }

  Future<void> _checkConnectionAndRetry() async {
    try {
      final result = await _connectivity.checkConnectivity();
      final hasConnection = result.any((r) => r != ConnectivityResult.none);

      if (hasConnection) {
        isConnected.value = true;
        _hideNoInternetDialog();
      } else {
        // Still no connection, show message
        final context = Get.context;
        if (context != null) {
          showSnackBar(
            context,
            'Still no internet connection. Please check your network settings.',
            isErrorMessageDisplay: true,
          );
        }
      }
    } catch (e) {
      print('Error checking connection: $e');
    }
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}
