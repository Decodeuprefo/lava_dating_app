import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/glass_background_widget.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Controller/island_hop_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IslandHopScreen extends StatelessWidget {
  const IslandHopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IslandHopController());

    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heightSpace(12),
                  _buildHeader(),
                  heightSpace(30),
                  _buildCurrentLocationSection(controller),
                  heightSpace(30),
                  _buildHopToAnotherIslandSection(controller),
                  heightSpace(25),
                  _buildStartButton(controller),
                  heightSpace(25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
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
          "Island Hop",
          style: CommonTextStyle.regular30w600.copyWith(
            color: ColorConstants.lightOrange,
          ),
        ),
        heightSpace(10),
        const Text(
          "Explore Love Beyond Your Island",
          style: CommonTextStyle.regular14w400,
          textAlign: TextAlign.center,
        ),
        heightSpace(8),
        const Text(
          "Change your location to discover people across Polynesia, Micronesia & Melanesia.",
          style: CommonTextStyle.regular14w400,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCurrentLocationSection(IslandHopController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current Location",
          style: CommonTextStyle.regular16w600.copyWith(
            color: ColorConstants.lightOrange,
          ),
        ),
        heightSpace(5),
        GlassBackgroundWidget(
          borderRadius: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(controller.currentFlagAsset.value),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          // Handle error - show placeholder
                        },
                      ),
                    ),
                    child: controller.currentFlagAsset.value.isEmpty
                        ? Container(
                            color: Colors.grey.withOpacity(0.3),
                            child: const Icon(
                              Icons.flag,
                              color: Colors.white54,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  widthSpace(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            controller.currentLocation.value,
                            style: CommonTextStyle.regular22w600,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        heightSpace(4),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: ColorConstants.lightOrange,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child:
                              const Text("Active Location", style: CommonTextStyle.regular11w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              heightSpace(20),
              AppButton(
                text: "Use My Real Location",
                onPressed: () => controller.toggleRealLocation(),
                backgroundColor: ColorConstants.lightOrange,
                textStyle: CommonTextStyle.regular16w500.copyWith(
                  color: Colors.white,
                ),
                borderRadius: 10,
                width: double.infinity,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
        ),
      ],
    );
  }

  Widget _buildHopToAnotherIslandSection(IslandHopController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hop to Another Island",
          style: CommonTextStyle.regular16w600.copyWith(
            color: ColorConstants.lightOrange,
          ),
        ),
        heightSpace(10),
        Obx(
          () => GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: controller.availableIslands.length,
            itemBuilder: (context, index) {
              final island = controller.availableIslands[index];
              return _buildIslandCard(island, controller);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIslandCard(IslandLocation island, IslandHopController controller) {
    return GlassBackgroundWidget(
      borderRadius: 10,
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () => controller.selectLocation(island.name),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                island.flagAsset,
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
            widthSpace(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    island.name,
                    style: CommonTextStyle.regular14w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  heightSpace(2),
                  if (island.isPopular)
                    const Text(
                      "Popular this week",
                      style: CommonTextStyle.regular12w400,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton(IslandHopController controller) {
    return AppButton(
      text: "Start Island Hop",
      onPressed: () => controller.startIslandHop(),
      backgroundColor: ColorConstants.lightOrange,
      textStyle: CommonTextStyle.regular16w500.copyWith(
        color: Colors.white,
      ),
      borderRadius: 10,
      width: double.infinity,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 13),
    );
  }
}
