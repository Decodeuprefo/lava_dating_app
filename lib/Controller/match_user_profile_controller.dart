import 'package:get/get.dart';

class MatchUserProfileController extends GetxController {
  final RxString userName = 'Liam Johnson'.obs;
  final RxString location = 'New York, USA'.obs;
  final RxBool isAvailable = true.obs;
  final RxString distance = '1 km'.obs;
  final RxString? profileImageUrl =
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'.obs;

  final RxBool showPrioritizeLike = true.obs;

  final RxString aboutMe =
      'My name is Jessica Parker and I enjoy meeting new people and finding ways to help them have an uplifting experience. I enjoy reading and traveling to new places.'
          .obs;
  final RxString gender = 'Male'.obs;
  final RxString dateOfBirth = '6 Jan, 1999'.obs;
  final RxString religion = 'Christian'.obs;
  final RxString interestsHobbies = 'Photography, Designing, Road Trips'.obs;
  final RxString drink = 'On special occasions'.obs;
  final RxString smoking = 'Non - smoker'.obs;
  final RxString workout = 'Everyday'.obs;
  final RxString pets = 'Dog'.obs;
  final RxString education = "Bachelor's Degree".obs;
  final RxString preferredLanguage = 'English, Tongan, Samoan'.obs;
  final RxString relationType = 'Dating for marriage'.obs;
  final RxString ageMin = '24'.obs;
  final RxString ageMax = '29'.obs;
  final RxString height = '6 Feet 4 Inches'.obs;
  final RxString preferredGender = 'Male'.obs;
  final RxString journeyOfLove = 'Single'.obs;
  final RxString kids = "Don't Have Kids".obs;
  final RxString preferredDistance = '22 Km'.obs;
  final RxString raceFlags = 'Tonga, Tuvalu'.obs;
  
  final RxList<String> profilePhotos = [
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
  ].obs;

  // Actions
  void onMessageTap() {
    // TODO: Navigate to chat/message screen
    Get.snackbar('Message', 'Opening chat...');
  }

  void onPrioritizeLikeTap() {
    // TODO: Implement prioritize like functionality
    Get.snackbar('Prioritize Like', 'Feature coming soon...');
  }

  void onDeleteTap() {
    // TODO: Implement delete/unmatch functionality
    Get.snackbar('Delete', 'Unmatching user...');
  }

  void onBackTap() {
    Get.back();
  }

  void onMenuTap() {
    // TODO: Show menu options
    Get.snackbar('Menu', 'Menu options...');
  }
}
