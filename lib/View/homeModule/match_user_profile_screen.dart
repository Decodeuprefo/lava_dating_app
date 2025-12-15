import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/custom_button.dart';
import 'package:lava_dating_app/Controller/match_user_profile_controller.dart';

class MatchUserProfileScreen extends StatefulWidget {
  const MatchUserProfileScreen({super.key});

  @override
  State<MatchUserProfileScreen> createState() => _MatchUserProfileScreenState();
}

class _MatchUserProfileScreenState extends State<MatchUserProfileScreen> {
  bool _isAboutMeExpanded = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MatchUserProfileController());

    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Obx(() => SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 490,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildProfileImage(controller),
                          _buildGradientOverlay(),
                          _buildTopNavigation(controller),
                          _buildBottomInfo(controller),
                          _buildActionButtons(controller),
                        ],
                      ),
                    ),
                    _userProfileDetails(),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget _userProfileDetails() {
    final controller = Get.find<MatchUserProfileController>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You liked this profile. 💖",
                style: CommonTextStyle.bold14w700.copyWith(color: Colors.white),
              ),
              heightSpace(30),
              Text(
                'About Me',
                style: CommonTextStyle.regular14w600.copyWith(
                  color: ColorConstants.lightOrange,
                ),
              ),
              heightSpace(10),
              _buildAboutMeText(controller),
              heightSpace(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem('Gender', controller.gender.value, CrossAxisAlignment.start),
                  _buildDetailItem(
                      'Date of Birth', controller.dateOfBirth.value, CrossAxisAlignment.center),
                  _buildDetailItem('Religion', controller.religion.value, CrossAxisAlignment.end),
                ],
              ),
              heightSpace(30),
              _buildSingleDetail('Interests & Hobbies', controller.interestsHobbies.value),
              heightSpace(30),
              Text(
                'Lifestyle Compatibility',
                style: CommonTextStyle.regular14w600.copyWith(
                  color: ColorConstants.lightOrange,
                ),
              ),
              heightSpace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSingleDetail('Drink', controller.drink.value,
                            titleStyle: CommonTextStyle.regular14w500
                                .copyWith(color: ColorConstants.lightOrange)),
                        heightSpace(20),
                        _buildSingleDetail('Workout', controller.workout.value,
                            titleStyle: CommonTextStyle.regular14w500
                                .copyWith(color: ColorConstants.lightOrange)),
                      ],
                    ),
                  ),
                  widthSpace(20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSingleDetail('Smoking', controller.smoking.value,
                            titleStyle: CommonTextStyle.regular14w500
                                .copyWith(color: ColorConstants.lightOrange)),
                        heightSpace(20),
                        _buildSingleDetail('Pets', controller.pets.value,
                            titleStyle: CommonTextStyle.regular14w500
                                .copyWith(color: ColorConstants.lightOrange)),
                      ],
                    ),
                  ),
                ],
              ),
              heightSpace(30),
              _buildSingleDetail('Education Compatibility', controller.education.value),
              heightSpace(30),
              _buildSingleDetail('Preferred Language', controller.preferredLanguage.value),
              heightSpace(30),
              _buildSingleDetail('Relation Type', controller.relationType.value),
              heightSpace(30),
              Text(
                'Preferred Age Range',
                style: CommonTextStyle.regular14w600.copyWith(
                  color: ColorConstants.lightOrange,
                ),
              ),
              heightSpace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Min',
                          style: CommonTextStyle.regular14w400,
                        ),
                        heightSpace(5),
                        Text(
                          controller.ageMin.value,
                          style: CommonTextStyle.regular14w400,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Max',
                          style: CommonTextStyle.regular14w400,
                        ),
                        heightSpace(5),
                        Text(
                          controller.ageMax.value,
                          style: CommonTextStyle.regular14w400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              heightSpace(30),
              _buildSingleDetail('Height', controller.height.value),
              heightSpace(30),
              _buildSingleDetail('Preferred Gender', controller.preferredGender.value),
              heightSpace(30),
              _buildSingleDetail('Your Journey of love', controller.journeyOfLove.value),
              heightSpace(30),
              _buildSingleDetail('Kids', controller.kids.value),
              heightSpace(30),
              _buildSingleDetail('Preferred Distance', controller.preferredDistance.value),
              heightSpace(30),
              _buildSingleDetail('Race Flags', controller.raceFlags.value),
              heightSpace(30),
              _buildPhotoGallery(controller),
              heightSpace(30),
            ],
          )),
    );
  }

  Widget _buildAboutMeText(MatchUserProfileController controller) {
    final text = controller.aboutMe.value;

    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: text,
            style: CommonTextStyle.regular14w400,
          ),
          maxLines: 3,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);
        final hasMoreThan3Lines = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: CommonTextStyle.regular14w400,
              maxLines: _isAboutMeExpanded ? null : 3,
              overflow: _isAboutMeExpanded ? null : TextOverflow.ellipsis,
            ),
            if (hasMoreThan3Lines) ...[
              heightSpace(5),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isAboutMeExpanded = !_isAboutMeExpanded;
                  });
                },
                child: Text(
                  _isAboutMeExpanded ? 'Read less' : 'Read more',
                  style: CommonTextStyle.regular14w400.copyWith(
                    color: ColorConstants.lightOrange,
                    decoration: _isAboutMeExpanded ? TextDecoration.none : TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(String title, String value, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: CommonTextStyle.regular14w600.copyWith(
            color: ColorConstants.lightOrange,
          ),
        ),
        Text(
          value,
          style: CommonTextStyle.regular14w400,
        ),
      ],
    );
  }

  Widget _buildSingleDetail(String title, String value,
      {TextStyle? titleStyle, TextStyle? valueStyle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle ??
              CommonTextStyle.regular14w600.copyWith(
                color: ColorConstants.lightOrange,
              ),
        ),
        heightSpace(5),
        Text(
          value,
          style: valueStyle ?? CommonTextStyle.regular18w400,
        ),
      ],
    );
  }

  Widget _buildPhotoGallery(MatchUserProfileController controller) {
    return Obx(() {
      if (controller.profilePhotos.isEmpty) {
        return const SizedBox.shrink();
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          const spacing = 8.0;
          final topRowImageWidth = (screenWidth - spacing) / 2;
          final topRowImageHeight = topRowImageWidth * 1.3;
          final bottomRowImageWidth = (screenWidth - (spacing * 2)) / 3;
          final bottomRowImageHeight = bottomRowImageWidth * 1.1;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  controller.profilePhotos.isNotEmpty
                      ? _buildPhotoItem(
                          controller.profilePhotos[0],
                          topRowImageWidth,
                          topRowImageHeight,
                        )
                      : _buildEmptyPhotoSlot(topRowImageWidth, topRowImageHeight),
                  widthSpace(spacing),
                  controller.profilePhotos.length > 1
                      ? _buildPhotoItem(
                          controller.profilePhotos[1],
                          topRowImageWidth,
                          topRowImageHeight,
                        )
                      : _buildEmptyPhotoSlot(topRowImageWidth, topRowImageHeight),
                ],
              ),
              heightSpace(spacing),
              Row(
                children: [
                  controller.profilePhotos.length > 2
                      ? _buildPhotoItem(
                          controller.profilePhotos[2],
                          bottomRowImageWidth,
                          bottomRowImageHeight,
                        )
                      : _buildEmptyPhotoSlot(bottomRowImageWidth, bottomRowImageHeight),
                  widthSpace(spacing),
                  controller.profilePhotos.length > 3
                      ? _buildPhotoItem(
                          controller.profilePhotos[3],
                          bottomRowImageWidth,
                          bottomRowImageHeight,
                        )
                      : _buildEmptyPhotoSlot(bottomRowImageWidth, bottomRowImageHeight),
                  widthSpace(spacing),
                  controller.profilePhotos.length > 4
                      ? _buildPhotoItem(
                          controller.profilePhotos[4],
                          bottomRowImageWidth,
                          bottomRowImageHeight,
                        )
                      : _buildEmptyPhotoSlot(bottomRowImageWidth, bottomRowImageHeight),
                ],
              ),
            ],
          );
        },
      );
    });
  }

  Widget _buildPhotoItem(String imageUrl, double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: width,
              height: height,
              color: Colors.grey.shade900,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  color: ColorConstants.lightOrange,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: width,
              height: height,
              color: Colors.grey.shade900,
              child: const Icon(
                Icons.image,
                size: 50,
                color: Colors.white54,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyPhotoSlot(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade900.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildProfileImage(MatchUserProfileController controller) {
    return controller.profileImageUrl != null && controller.profileImageUrl!.isNotEmpty
        ? Image.network(
            controller.profileImageUrl.toString(),
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey.shade900,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: ColorConstants.lightOrange,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade900,
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.white54,
                  ),
                ),
              );
            },
          )
        : Container(
            color: Colors.grey.shade900,
            child: const Center(
              child: Icon(
                Icons.person,
                size: 100,
                color: Colors.white54,
              ),
            ),
          );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.5),
              Colors.black.withOpacity(0.85),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavigation(MatchUserProfileController controller) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: controller.onBackTap,
            child: SvgPicture.asset(
              "assets/icons/back_arrow.svg",
              height: 32,
              width: 32,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
          GestureDetector(
            onTap: controller.onMenuTap,
            child: Image.asset(
              "assets/icons/more_icon.png",
              height: 30,
              width: 30,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo(MatchUserProfileController controller) {
    return Positioned(
      bottom: 100,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  controller.userName.value,
                  overflow: TextOverflow.ellipsis,
                  style: CommonTextStyle.regular24w600.copyWith(fontSize: 21),
                ),
              ),
              widthSpace(10),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.isAvailable.value ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  widthSpace(6),
                  const Text(
                    "Available",
                    style: CommonTextStyle.regular14w400,
                  ),
                ],
              ),
            ],
          ),
          heightSpace(10),
          Row(
            children: [
              Image.asset(
                "assets/icons/HomeSplash/location_pin_icon.png",
                height: 20,
                width: 20,
                fit: BoxFit.contain,
              ),
              widthSpace(10),
              Text(
                controller.location.value,
                style: CommonTextStyle.regular14w400,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/icons/HomeSplash/location_pin_icon.png",
                      height: 14,
                      width: 14,
                      fit: BoxFit.contain,
                    ),
                    widthSpace(6),
                    Text(
                      controller.distance.value,
                      style: CommonTextStyle.bold12w700,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(MatchUserProfileController controller) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Obx(() {
        if (!controller.showPrioritizeLike.value) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: ColorConstants.lightOrange,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: controller.onMessageTap,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/message_icon.png",
                              height: 28,
                              width: 28,
                              fit: BoxFit.contain,
                              color: ColorConstants.lightOrange,
                            ),
                            widthSpace(8),
                            Text(
                              'Message',
                              style: CommonTextStyle.regular16w400
                                  .copyWith(color: ColorConstants.lightOrange),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              widthSpace(10),
              Expanded(
                child: AppButton(
                  text: 'Prioritize Like',
                  textStyle: CommonTextStyle.regular16w400,
                  backgroundColor: ColorConstants.lightOrange,
                  onPressed: controller.onPrioritizeLikeTap,
                  borderRadius: 10,
                  height: 50,
                ),
              ),
              widthSpace(12),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: ColorConstants.lightOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: controller.onDeleteTap,
                    borderRadius: BorderRadius.circular(10),
                    child: Center(
                      child: Image.asset(
                        "assets/icons/white_trash.png",
                        height: 24,
                        width: 24,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  color: ColorConstants.lightOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: controller.onMessageTap,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/message_icon.png",
                            height: 28,
                            width: 28,
                            fit: BoxFit.contain,
                          ),
                          widthSpace(8),
                          const Text(
                            'Message',
                            style: CommonTextStyle.regular16w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              widthSpace(12),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: ColorConstants.lightOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: controller.onDeleteTap,
                    borderRadius: BorderRadius.circular(10),
                    child: Center(
                      child: Image.asset(
                        "assets/icons/white_trash.png",
                        height: 24,
                        width: 24,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
