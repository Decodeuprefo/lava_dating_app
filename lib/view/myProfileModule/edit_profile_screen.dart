import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';
import 'package:lava_dating_app/Common/widgets/text_form_field_widget.dart';
import 'package:lava_dating_app/View/setProfileModule/about_me_screen.dart';

import '../../Common/widgets/custom_button.dart';
import '../setProfileModule/select_dob_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/select_gender_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/select_height_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/interests_and_hobbies.dart';
import 'package:lava_dating_app/View/setProfileModule/select_religion_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/select_lifestyle_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/select_education_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/select_languages_spoken.dart';
import 'package:lava_dating_app/View/setProfileModule/select_relationship_type_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/preferred_age_range_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/preferred_gender_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/select_marital_status.dart';
import 'package:lava_dating_app/View/setProfileModule/kids_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/preferred_distance_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/race_flags_screen.dart';
import '../../Common/widgets/shimmers/edit_profile_screen_shimmer_widget.dart';
import '../../Common/widgets/video_thumbnail_widget.dart';
import '../../controller/edit_profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final EditProfileController controller = Get.put(EditProfileController());

  String? profileImageUrl;
  String userName = "Jennifer Burk";
  String location = "New York, USA";

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController interestsHobbiesController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController drinkingController = TextEditingController();
  final TextEditingController smokingController = TextEditingController();
  final TextEditingController workoutController = TextEditingController();
  final TextEditingController petsController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController preferredLanguagesController = TextEditingController();
  final TextEditingController relationshipTypeController = TextEditingController();
  final TextEditingController preferredAgeRangeController = TextEditingController();
  final TextEditingController preferredGenderController = TextEditingController();
  final TextEditingController journeyOfLoveController = TextEditingController();
  final TextEditingController kidsController = TextEditingController();
  final TextEditingController preferredDistanceController = TextEditingController();
  final TextEditingController raceFlagsController = TextEditingController();

  final List<String> profilePhotos = [
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    profileImageUrl = "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400";
    firstNameController.text = "Jennifer";
    lastNameController.text = "Burk";
    dateOfBirthController.text = "18 June 1998";
    mobileController.text = "+1 (555) 222-3344";
    genderController.text = "Female";
    heightController.text = "5'8";
    interestsHobbiesController.text = "Photography, Reading, Travelling";
    religionController.text = "Christian";
    drinkingController.text = "On special occasions";
    smokingController.text = "Non - smoker";
    workoutController.text = "Everyday";
    petsController.text = "Dog";
    educationController.text = "Bachelor's Degree";
    preferredLanguagesController.text = "English, Spanish, French";
    relationshipTypeController.text = "Long - term";
    preferredAgeRangeController.text = "22";
    preferredGenderController.text = "Female";
    journeyOfLoveController.text = "Single";
    kidsController.text = "Don't Have Kids";
    preferredDistanceController.text = "22 Km";
    raceFlagsController.text = "Tonga, Tuvalu";
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    aboutMeController.dispose();
    dateOfBirthController.dispose();
    mobileController.dispose();
    genderController.dispose();
    heightController.dispose();
    interestsHobbiesController.dispose();
    religionController.dispose();
    drinkingController.dispose();
    smokingController.dispose();
    workoutController.dispose();
    petsController.dispose();
    educationController.dispose();
    preferredLanguagesController.dispose();
    relationshipTypeController.dispose();
    preferredAgeRangeController.dispose();
    preferredGenderController.dispose();
    journeyOfLoveController.dispose();
    kidsController.dispose();
    preferredDistanceController.dispose();
    raceFlagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<EditProfileController>(builder: (controller) {
                        return controller.isLoading
                            ? const EditProfileScreenShimmerWidget()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  heightSpace(20),
                                  _buildBackButton(),
                                  _buildProfileSection(),
                                  heightSpace(30),
                                  _buildPhotosSection(),
                                  heightSpace(30),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Intro Video",
                                        style: CommonTextStyle.regular18w600
                                            .copyWith(color: ColorConstants.lightOrange),
                                      ),
                                      heightSpace(10),
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          SizedBox(
                                            height: 200,
                                            width: double.infinity,
                                            child: (controller
                                                            .userProfile?.introVideo !=
                                                        null &&
                                                    controller.userProfile!.introVideo!
                                                        .isNotEmpty)
                                                ? VideoThumbnailWidget(
                                                    videoUrl: controller
                                                        .userProfile!.introVideo!)
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(10),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(Icons.videocam_off,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                          ),
                                          Positioned.fill(
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: Image.asset(
                                                  "assets/icons/video_play_icon.png",
                                                  height: 50,
                                                  width: 50,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      heightSpace(30),
                                      Text(
                                        "Personal Information",
                                        style: CommonTextStyle.regular18w600
                                            .copyWith(color: ColorConstants.lightOrange),
                                      ),
                                      heightSpace(20),
                                      _buildPersonalInfoForm(),
                                    ],
                                  ).paddingSymmetric(horizontal: 20),
                                ],
                              );
                      }),
                    ],
                  ),
                ),
              ),
              GetBuilder<EditProfileController>(builder: (controller) {
                return controller.isLoading
                    ? const SizedBox()
                    : AppButton(
                        text: "Save",
                        textStyle: CommonTextStyle.regular16w500,
                        onPressed: () {},
                      ).marginSymmetric(vertical: 10, horizontal: 20);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () => Get.back(),
      child: SvgPicture.asset(
        "assets/icons/back_arrow.svg",
        height: 30,
        width: 30,
        fit: BoxFit.fill,
      ),
    ).paddingOnly(left: 18);
  }

  Widget _buildProfileSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorConstants.lightOrange,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: (controller.userProfile?.photos != null &&
                          controller.userProfile!.photos!.isNotEmpty)
                      ? Image.network(
                          controller.userProfile!.photos![0],
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
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white54,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey.shade900,
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white54,
                          ),
                        ),
                ).paddingAll(5),
              ),
              Positioned(
                bottom: 5,
                right: 0,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: ColorConstants.lightOrange,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/edit_profile_icon.png',
                        width: 22,
                        height: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          heightSpace(20),
          Text(
            "${controller.userProfile?.firstName ?? ""} ${controller.userProfile?.lastName ?? ""}",
            style: CommonTextStyle.regular18w600,
          ),
          heightSpace(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/HomeSplash/location_pin_icon.png",
                height: 20,
                width: 20,
                fit: BoxFit.contain,
              ),
              widthSpace(6),
              Text(
                "${controller.userProfile?.city ?? ""}, ${controller.userProfile?.country ?? ""}",
                style: CommonTextStyle.regular14w400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosSection() {
    final photos = controller.userProfile?.photos ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            GestureDetector(
              onTap: () {},
              child: Text(
                'See All',
                style: CommonTextStyle.regular12w600.copyWith(
                    color: ColorConstants.lightOrange,
                    decoration: TextDecoration.underline,
                    decorationThickness: 1,
                    decorationColor: ColorConstants.lightOrange),
              ).paddingOnly(right: 20),
            ),
          ],
        ),
        heightSpace(5),
        SizedBox(
          height: 165,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index < photos.length - 1 ? 10 : 0,
                ),
                child: _buildImageCard(photos[index].toString()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: 115,
              height: 150,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 115,
                  height: 150,
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
                  width: 140,
                  height: 200,
                  color: Colors.grey.shade900,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white54,
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: -3,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {},
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/add_item.svg",
                  height: 36,
                  width: 36,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "First Name",
          style: CommonTextStyle.regular14w400,
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: firstNameController,
          hint: "",
          titleLabelName: "",
        ),
        heightSpace(20),
        const Text(
          "Last Name",
          style: CommonTextStyle.regular14w400,
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: lastNameController,
          hint: "",
          titleLabelName: "",
        ),
        heightSpace(20),
        const Text(
          "About Me",
          style: CommonTextStyle.regular14w400,
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: aboutMeController,
          hint: "Describe About Your Self...",
          titleLabelName: "",
          maxLines: 4,
          minLines: 4,
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const AboutMeScreen(
                  fromEdit: true,
                ));
          },
        ),
        heightSpace(20),
        const Text(
          "Date of Birth",
          style: CommonTextStyle.regular14w400,
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: dateOfBirthController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const SelectDobScreen(
                  fromEdit: true,
                ));
          },
        ),
        heightSpace(20),
        const Text(
          "Mobile",
          style: CommonTextStyle.regular14w400,
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: mobileController,
          hint: "",
          titleLabelName: "",
        ),
        heightSpace(20),
        const Text(
          "Gender",
          style: CommonTextStyle.regular14w400,
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: genderController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const SelectGenderScreen());
          },
        ),
        heightSpace(20),
        const Text(
          "Height",
          style: CommonTextStyle.regular14w400,
        ),
        heightSpace(8),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: TextFormFieldWidget(
                controller: heightController,
                hint: "",
                titleLabelName: "",
                readOnly: true,
                showCursor: false,
                onTap: () {
                  Get.to(() => const SelectHeightScreen());
                },
              ),
            ),
            widthSpace(20),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ),
        heightSpace(30),
        Text(
          "Interest & Hobbies",
          style: CommonTextStyle.regular18w600.copyWith(color: ColorConstants.lightOrange),
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: interestsHobbiesController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const InterestsAndHobbies());
          },
        ),
        heightSpace(20),
        Text(
          "Religion or Spiritual",
          style: CommonTextStyle.regular18w600.copyWith(color: ColorConstants.lightOrange),
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: religionController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const ReligionScreen());
          },
        ),
        heightSpace(20),
        Text(
          "Lifestyle",
          style: CommonTextStyle.regular18w600.copyWith(color: ColorConstants.lightOrange),
        ),
        heightSpace(20),
        const Text(
          "Drinking",
          style: CommonTextStyle.regular14w400,
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: drinkingController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const LifestyleScreen());
          },
        ),
        heightSpace(20),
        const Text(
          "Smoking",
          style: CommonTextStyle.regular14w400,
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: smokingController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const LifestyleScreen());
          },
        ),
        heightSpace(20),
        const Text(
          "Workout",
          style: CommonTextStyle.regular14w400,
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: workoutController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const LifestyleScreen());
          },
        ),
        heightSpace(20),
        const Text(
          "Pets",
          style: CommonTextStyle.regular14w400,
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: petsController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const LifestyleScreen());
          },
        ),
        heightSpace(20),
        Text(
          "Education",
          style: CommonTextStyle.regular18w600.copyWith(color: ColorConstants.lightOrange),
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: educationController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const SelectEducationScreen());
          },
        ),
        heightSpace(20),
        Text(
          "Preferred Languages",
          style: CommonTextStyle.regular18w600.copyWith(color: ColorConstants.lightOrange),
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: preferredLanguagesController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const SelectLanguagesSpoken());
          },
        ),
        heightSpace(20),
        Text(
          "Relationship Type",
          style: CommonTextStyle.regular18w600.copyWith(color: ColorConstants.lightOrange),
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: relationshipTypeController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const SelectRelationshipTypeScreen());
          },
        ),
        heightSpace(20),
        Text(
          "Preferred Age Range",
          style: CommonTextStyle.regular18w600.copyWith(color: ColorConstants.lightOrange),
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: preferredAgeRangeController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const PreferredAgeRangeScreen());
          },
        ),
        heightSpace(20),
        Text(
          "Preferred Gender",
          style: CommonTextStyle.regular18w600.copyWith(color: ColorConstants.lightOrange),
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: preferredGenderController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const PreferredGenderScreen());
          },
        ),
        heightSpace(20),
        Text(
          "Your Journey of love",
          style: CommonTextStyle.regular18w600.copyWith(color: ColorConstants.lightOrange),
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: journeyOfLoveController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const SelectMaritalStatus());
          },
        ),
        heightSpace(20),
        Text(
          "Kids",
          style: CommonTextStyle.regular18w600.copyWith(color: ColorConstants.lightOrange),
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: kidsController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const KidsScreen());
          },
        ),
        heightSpace(20),
        Text(
          "Preferred Distance",
          style: CommonTextStyle.regular18w600.copyWith(color: ColorConstants.lightOrange),
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: preferredDistanceController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const PreferredDistanceScreen());
          },
        ),
        heightSpace(20),
        Text(
          "Race Flags",
          style: CommonTextStyle.regular18w600.copyWith(color: ColorConstants.lightOrange),
        ),
        heightSpace(8),
        TextFormFieldWidget(
          controller: raceFlagsController,
          hint: "",
          titleLabelName: "",
          readOnly: true,
          showCursor: false,
          onTap: () {
            Get.to(() => const RaceFlagsScreen());
          },
        ),
        heightSpace(20),
      ],
    );
  }
}
