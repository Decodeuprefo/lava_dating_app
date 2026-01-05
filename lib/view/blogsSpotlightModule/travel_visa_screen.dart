import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/glass_background_widget.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Controller/travel_visa_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TravelVisaScreen extends StatelessWidget {
  const TravelVisaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TravelVisaController());

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
                  _buildAddTravelVisaSection(controller),
                  heightSpace(20),
                  _buildVisaActiveItems(controller),
                  heightSpace(20),
                  _buildVisaSlotsInfo(controller),
                  heightSpace(10),
                  _buildInfoTextSection(),
                  heightSpace(10),
                  _buildSaveButton(controller),
                  heightSpace(22),
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
          "Travel Visa",
          style: CommonTextStyle.regular30w600.copyWith(
            color: ColorConstants.lightOrange,
          ),
          textAlign: TextAlign.center,
        ),
        heightSpace(10),
        const Text(
          "Add up to 3 extra countries and see matches from around the world.",
          style: CommonTextStyle.regular14w400,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCurrentLocationSection(TravelVisaController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Current Location",
          style: CommonTextStyle.regular16w600.copyWith(
            color: ColorConstants.lightOrange,
          ),
        ),
        heightSpace(5),
        GlassBackgroundWidget(
          borderRadius: 10,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Obx(
                  () => Image.asset(
                    controller.baseFlagAsset.value,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
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
              ),
              widthSpace(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        controller.baseLocation.value,
                        style: CommonTextStyle.regular22w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    heightSpace(4),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: ColorConstants.lightOrange,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Text(
                        "Your Base Location",
                        style: CommonTextStyle.regular11w400,
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                "assets/icons/lock_app.svg",
                width: 25,
                height: 25,
                colorFilter: const ColorFilter.mode(
                  ColorConstants.lightOrange,
                  BlendMode.srcIn,
                ),
              ),
              widthSpace(18)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddTravelVisaSection(TravelVisaController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add Travel Visa Countries",
          style: CommonTextStyle.regular16w600.copyWith(
            color: ColorConstants.lightOrange,
          ),
        ),
        heightSpace(5),
        Obx(
          () {
            final usedSlots = controller.visaCountries.length;
            final maxSlots = controller.maxVisaSlots.value;
            final availableSlots = maxSlots - usedSlots;
            if (availableSlots <= 0) {
              return const SizedBox.shrink();
            }
            return Row(
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: _buildAddCountryCard(controller),
                ),
                if (availableSlots > 1) widthSpace(12),
                if (availableSlots > 1)
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: _buildAddCountryCard(controller),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAddCountryCard(TravelVisaController controller) {
    return GlassBackgroundWidget(
      borderRadius: 10,
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTap: () => controller.onAddCountryTap(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/add_item.svg",
              height: 38,
              width: 38,
              fit: BoxFit.fill,
            ),
            heightSpace(10),
            const Text(
              "Add Country",
              style: CommonTextStyle.regular12w600,
              textAlign: TextAlign.center,
            ),
            heightSpace(5),
            const Text(
              "Choose a location for global matches",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisaActiveItems(TravelVisaController controller) {
    return Obx(
      () {
        if (controller.visaCountries.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            ...controller.visaCountries.map(
              (country) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildVisaActiveItem(country, controller),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVisaActiveItem(TravelVisaCountry country, TravelVisaController controller) {
    return GlassBackgroundWidget(
      borderRadius: 10,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              country.flagAsset,
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
          widthSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  country.name,
                  style: CommonTextStyle.regular16w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  "Visa Active",
                  style: CommonTextStyle.regular12w400,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => controller.removeVisaCountry(country.id),
            child: Image.asset(
              "assets/icons/white_trash.png",
              width: 24,
              height: 24,
              color: ColorConstants.lightOrange,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.delete_outline,
                  color: ColorConstants.lightOrange,
                  size: 24,
                );
              },
            ),
          ),
          widthSpace(10)
        ],
      ),
    );
  }

  Widget _buildVisaSlotsInfo(TravelVisaController controller) {
    return Obx(
      () {
        final usedSlots = controller.visaCountries.length;
        final maxSlots = controller.maxVisaSlots.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You are using $usedSlots out of $maxSlots Travel Visa slots.",
              style: CommonTextStyle.regular16w600,
            ),
            heightSpace(12),
            Row(
              children: List.generate(
                maxSlots,
                (index) => Container(
                  width: 20,
                  height: 20,
                  margin: EdgeInsets.only(
                    right: index < maxSlots - 1 ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: index < usedSlots ? ColorConstants.lightOrange : Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoTextSection() {
    return GlassBackgroundWidget(
      borderRadius: 10,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBulletPoint(
            "You can add up to 3 Travel Visa countries.",
          ),
          heightSpace(12),
          _buildBulletPoint(
            "You will receive swipe suggestions from all selected countries.",
          ),
          heightSpace(12),
          _buildBulletPoint(
            "You can change countries anytime.",
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6, right: 8),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: CommonTextStyle.regular14w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(TravelVisaController controller) {
    return AppButton(
      text: "Save & Activate Visa",
      onPressed: () => controller.saveAndActivateVisa(),
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
