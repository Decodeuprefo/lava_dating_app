import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/glass_background_widget.dart';
import 'package:lava_dating_app/Controller/select_island_location_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectIslandLocationScreen extends StatelessWidget {
  const SelectIslandLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SelectIslandLocationController());

    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    heightSpace(12),
                    _buildHeader(),
                    heightSpace(13),
                    _buildSearchBar(controller),
                  ],
                ),
              ),
              heightSpace(20),
              Expanded(
                child: Obx(
                  () => controller.filteredLocations.isEmpty
                      ? const Center(
                          child: Text(
                            'No locations found',
                            style: CommonTextStyle.regular16w400,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: controller.filteredLocations.length,
                          itemBuilder: (context, index) {
                            final location = controller.filteredLocations[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildLocationItem(location, controller),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
    );
  }

  Widget _buildSearchBar(SelectIslandLocationController controller) {
    return SizedBox(
      height: 50,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Image.asset(
              "assets/icons/HomeSplash/white_search_icon.png",
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                onChanged: (value) => controller.updateSearchQuery(value),
                decoration: InputDecoration(
                  hintText: "Search Country / island",
                  hintStyle: CommonTextStyle.regular14w400.copyWith(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationItem(
      IslandLocationItem location, SelectIslandLocationController controller) {
    return GlassBackgroundWidget(
      borderRadius: 10,
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () => controller.onLocationTap(location),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                location.flagAsset,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey.withOpacity(0.3),
                    child: const Icon(
                      Icons.flag,
                      color: Colors.white54,
                      size: 20,
                    ),
                  );
                },
              ),
            ),
            widthSpace(15),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      location.name,
                      style: CommonTextStyle.regular16w600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        location.distance,
                        style: CommonTextStyle.regular14w400,
                      ),
                      widthSpace(10),
                      Transform.rotate(
                        angle: -90 * 3.1415926535 / 180,
                        child: Image.asset(
                          "assets/icons/drop_down_arrow.png",
                          fit: BoxFit.contain,
                          width: 23,
                          height: 23,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
