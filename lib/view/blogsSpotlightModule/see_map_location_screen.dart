import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Controller/see_map_location_controller.dart';
import 'package:lava_dating_app/Controller/select_island_location_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SeeMapLocationScreen extends StatelessWidget {
  const SeeMapLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SeeMapLocationController());

    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            children: [
              heightSpace(12),
              _buildHeader(controller),
              Obx(
                () => controller.isPermissionGranted.value
                    ? _buildMapSection(controller)
                    : _buildPermissionRequestSection(controller),
              ),
              const Spacer(),
              _buildActionButtons(controller),
              heightSpace(20)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(SeeMapLocationController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: SvgPicture.asset(
                  "assets/icons/back_arrow.svg",
                  height: 30,
                  width: 30,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          Text(
            controller.locationItem?.name ?? 'Location',
            style: CommonTextStyle.regular30w600.copyWith(
              color: ColorConstants.lightOrange,
            ),
            textAlign: TextAlign.center,
          ),
          heightSpace(10),
          if (controller.locationItem?.isPopular == true)
            const Text(
              "Popular this week",
              style: CommonTextStyle.regular14w400,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildMapSection(SeeMapLocationController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        height: 450,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Obx(
            () => controller.latitude.value != null && controller.longitude.value != null
                ? _buildMapWidget(controller)
                : _buildMapPlaceholder(controller),
          ),
        ),
      ),
    );
  }

  Widget _buildMapWidget(SeeMapLocationController controller) {
    // TODO: Replace with actual Google Maps widget when google_maps_flutter is added
    // For now, showing a placeholder with marker
    return SizedBox.expand(
        child: Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.blue.shade100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on,
                  size: 60,
                  color: ColorConstants.lightOrange,
                ),
                heightSpace(10),
                Text(
                  controller.locationItem?.name ?? 'Location',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                heightSpace(5),
                const Text(
                  'Map will be displayed here',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                controller.locationItem?.name ?? 'Location',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildMapPlaceholder(SeeMapLocationController controller) {
    return SizedBox.expand(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey.shade800,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: ColorConstants.lightOrange,
              ),
              heightSpace(16),
              Text(
                'Loading map...',
                style: CommonTextStyle.regular16w400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionRequestSection(SeeMapLocationController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 80,
              color: Colors.white.withOpacity(0.5),
            ),
            heightSpace(20),
            Text(
              'Location Permission Required',
              style: CommonTextStyle.regular18w600,
              textAlign: TextAlign.center,
            ),
            heightSpace(10),
            Text(
              'Please enable location permission to view the map.',
              style: CommonTextStyle.regular14w400,
              textAlign: TextAlign.center,
            ),
            heightSpace(30),
            Obx(
              () => controller.isCheckingPermission.value
                  ? const CircularProgressIndicator(
                      color: ColorConstants.lightOrange,
                    )
                  : AppButton(
                      text: 'Enable Location',
                      onPressed: () => controller.requestLocationPermission(),
                      backgroundColor: ColorConstants.lightOrange,
                      textStyle: CommonTextStyle.regular16w500.copyWith(
                        color: Colors.white,
                      ),
                      borderRadius: 10,
                      width: double.infinity,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(SeeMapLocationController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          AppButton(
            text: "Start Island Hop",
            onPressed: () => controller.onStartIslandHop(),
            backgroundColor: ColorConstants.lightOrange,
            textStyle: CommonTextStyle.regular16w500.copyWith(
              color: Colors.white,
            ),
            borderRadius: 10,
            width: double.infinity,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          heightSpace(12),
          AppButton(
            text: "Cancel",
            onPressed: () => controller.onCancel(),
            backgroundColor: Colors.transparent,
            borderColor: ColorConstants.lightOrange,
            textStyle: CommonTextStyle.regular16w500.copyWith(
              color: ColorConstants.lightOrange,
            ),
            borderRadius: 10,
            width: double.infinity,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
        ],
      ),
    );
  }
}
