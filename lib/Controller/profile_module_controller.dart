import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Model/profile_module_model.dart';

class ProfileModuleController extends GetxController {
  TextEditingController aboutMeController = TextEditingController();
  final selectedInterests = <String>[].obs;
  final RxSet<String> _selected = <String>{}.obs;

  List<String> get selectedItems => _selected.toList();

  final selectedReligion = <String>[].obs;
  final selectedEthnicity = <String>[].obs; // Max 2 selections
  final selectedDrinking = <String>[].obs;
  final selectedSmoking = <String>[].obs;
  final selectedEducation = "".obs;
  final selectedLanguage = "".obs;
  final selectedRelationshipType = <String>[].obs;
  final preferredGender = "".obs; // "Male", "Female", "Other"
  final maritalStatus =
      "".obs; 
  final hasChildren = "".obs; // "Yes", "No"
  final preferredDistance = 22.0.obs; // Distance in km (5-500)
  final minAge = 24.obs;
  final maxAge = 29.obs;
  final minHeight = 5.obs;
  final maxHeight = 7.obs;
  final heightUnit = "ft/in".obs; // "ft/in" or "cm"
  final RxBool feetORCm = true.obs; // true = ft/in, false = cm

  final List<String> interests = [
    'Crafting',
    'Photography',
    'Speaking',
    'Surfing',
    'Designing',
    'Writing',
    'Road Trips',
    'Gardening',
    'Movies',
    'Feminism',
    'Athlete',
    'Golf',
    'Coffee',
    'Acting',
    'Cooking',
  ];

  final List<String> iconPaths = [
    'assets/icons/InterestsHobbies/cutter.png',
    'assets/icons/InterestsHobbies/camera.png',
    'assets/icons/InterestsHobbies/sound.png',
    'assets/icons/InterestsHobbies/wave.png',
    'assets/icons/InterestsHobbies/edit.png',
    'assets/icons/InterestsHobbies/pencil.png',
    'assets/icons/InterestsHobbies/safari.png',
    'assets/icons/InterestsHobbies/nature.png',
    'assets/icons/InterestsHobbies/movie.png',
    'assets/icons/InterestsHobbies/research.png',
    'assets/icons/InterestsHobbies/user_group.png',
    'assets/icons/InterestsHobbies/goal.png',
    'assets/icons/InterestsHobbies/coffee_tea.png',
    'assets/icons/InterestsHobbies/cartoon.png',
    'assets/icons/InterestsHobbies/cooking.png',
  ];

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
  }

  void refreshScreen() {
    update();
  }

  final List<String> religions = [
    'Agnostic',
    'Atheist',
    'Baptist',
    'Buddhist',
    'Catholic',
    'Christian',
    'Hindu',
    'Inter - Religion',
    'Jain',
    'Jewish',
    'Methodist',
    'Muslim',
    'Sikh',
    'Parsi',
    'Protestant',
    'Taoist',
    'Other',
  ];

  void toggleReligion(String religion) {
    if (selectedReligion.contains(religion)) {
      selectedReligion.remove(religion);
    } else {
      selectedReligion.add(religion);
    }
  }

  final List<String> ethnicities = [
    'Tonga',
    'Samoa',
    'American Samoa',
    'Hawaii',
    'Aotearoa (New Zealand)',
    'Tuvalu',
    'Tokelau',
    'Niue',
    'Cook Islands',
    'Wallis and Futuna',
    'Pitcairn Islands',
    'Tahiti',
    'Palau',
    'Marshall Islands',
    'Guam',
    'Northern Mariana Islands',
    'Nauru',
  ];

  void toggleEthnicity(String ethnicity) {
    if (selectedEthnicity.contains(ethnicity)) {
      selectedEthnicity.remove(ethnicity);
    } else {
      // Maximum 2 selections allowed
      if (selectedEthnicity.length < 2) {
        selectedEthnicity.add(ethnicity);
      }
    }
  }

  final List<String> drinkingOptions = [
    'Not for me',
    'Sober',
    'Sober curious',
    'On special occasions',
    'Socially on weekends',
    'Most Nights',
  ];

  final List<String> smokingOptions = [
    'Social smoker',
    'Smoker when drinking',
    'Non - smoker',
    'Smoker',
    'Trying to quit',
  ];

  void toggleDrinking(String option) {
    if (selectedDrinking.contains(option)) {
      selectedDrinking.remove(option);
    } else {
      selectedDrinking.add(option);
    }
  }

  void toggleSmoking(String option) {
    if (selectedSmoking.contains(option)) {
      selectedSmoking.remove(option);
    } else {
      selectedSmoking.add(option);
    }
  }

  final List<String> educationOptions = [
    'BA',
    'BCom',
    'BSc',
    'BBA',
    'BCA',
    'BTech / BE',
  ];

  final List<String> languageOptions = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese (Mandarin)',
    'Arabic',
    'Hindi',
    'Portuguese',
    'Russian',
    'Japanese',
    'Korean',
    'Italian',
    'Turkish',
    'Dutch',
    'Indonesian',
    'Bengali',
    'Urdu',
    'Vietnamese',
    'Thai',
    'Persian (Farsi)',
  ];

  final List<String> relationshipTypes = [
    'Friends',
    'Casual dating',
    'Dating for marriage',
    'Networking',
    'Not sure yet',
    'All the above',
    'Relationship',
    'Marriage',
  ];

  final List<String> relationshipTypeIconPaths = [
    'assets/icons/RelationType/friends_icon.png',
    'assets/icons/RelationType/casual_dating_icon.png',
    'assets/icons/RelationType/dating_marrige_icon.png',
    'assets/icons/RelationType/networking_icon.png',
    'assets/icons/RelationType/not_sure_icon.png',
    'assets/icons/RelationType/all_above_icon.png',
    'assets/icons/RelationType/relationship_icon.png',
    'assets/icons/RelationType/marriage_icon.png',
  ];

  void toggleRelationshipType(String type) {
    if (selectedRelationshipType.contains(type)) {
      selectedRelationshipType.remove(type);
    } else {
      selectedRelationshipType.add(type);
    }
  }

  void setPreferredGender(String gender) {
    preferredGender.value = gender;
  }

  void setMaritalStatus(String status) {
    maritalStatus.value = status;
  }

  void setHasChildren(String answer) {
    hasChildren.value = answer;
  }

  void setPreferredDistance(double distance) {
    // Keep as double for smooth sliding, round only for display
    preferredDistance.value = distance;
  }
}
