import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../Model/profile_module_model.dart';

class ProfileModuleController extends GetxController {
  TextEditingController aboutMeController = TextEditingController();
  final selectedInterests = <String>[].obs;
  final RxSet<String> _selected = <String>{}.obs;

  List<String> get selectedItems => _selected.toList();

  final selectedReligion = <String>[].obs;
  final selectedEthnicity = <String>[].obs; // Max 2 selections
  final selectedDrinking = <String>[].obs;
  final selectedSmoking = <String>[].obs;
  final selectedWorkout = <String>[].obs;
  final selectedPets = <String>[].obs;
  final selectedEducation = "".obs;
  final selectedLanguages = <String>[].obs;
  final selectedRelationshipType = <String>[].obs;
  final preferredGender = "".obs; // "Male", "Female", "Other"
  final maritalStatus = "".obs;
  final hasChildren = "".obs; // "Yes", "No"
  final preferredDistance = 100.0.obs; // Distance in km (5-500)
  final minAge = 24.obs;
  final maxAge = 29.obs;
  final minHeight = 5.obs;
  final maxHeight = 7.obs;
  final heightUnit = "ft/in".obs; // "ft/in" or "cm"
  final RxBool feetORCm = true.obs; // true = ft/in, false = cm

  final List<String> interests = [
    // Image 1 items
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
    // Image 2 items
    'Dancing',
    'Comedy',
    'Yoga',
    'Travel',
    'Skiing',
    'Blogging',
    'Singing',
    'Painting',
    'Snowboarding',
    'Ice Skating',
    'Cheerleading',
    'Sports',
    'Faith',
    'Foodie',
    'Family',
    // Image 3 items
    'Education',
    'Community',
    'Music',
    'Beach',
    'Hiking',
    'Volunteering',
    'Bible',
    'Self-care',
    'Reading',
    'Entrepreneurship',
    'Culture',
    'Rugby',
    'American Football',
    // Image 4 items
    'Cars',
    'Motorcycles',
    'Makeup',
    'Concerts',
  ];

  final List<String> iconPaths = [
    // Image 1 icons
    'assets/icons/InterestsHobbies/cutter.png', // Crafting
    'assets/icons/InterestsHobbies/camera.png', // Photography
    'assets/icons/InterestsHobbies/sound.png', // Speaking
    'assets/icons/InterestsHobbies/wave.png', // Surfing
    'assets/icons/InterestsHobbies/edit.png', // Designing
    'assets/icons/InterestsHobbies/pencil.png', // Writing
    'assets/icons/InterestsHobbies/safari.png', // Road Trips
    'assets/icons/InterestsHobbies/nature.png', // Gardening
    'assets/icons/InterestsHobbies/movie.png', // Movies
    'assets/icons/InterestsHobbies/research.png', // Feminism
    'assets/icons/InterestsHobbies/user_group.png', // Athlete
    'assets/icons/InterestsHobbies/goal.png', // Golf
    'assets/icons/InterestsHobbies/coffee_tea.png', // Coffee
    'assets/icons/InterestsHobbies/cartoon.png', // Acting
    'assets/icons/InterestsHobbies/cooking.png', // Cooking
    // Image 2 icons
    'assets/icons/InterestsHobbies/lighting.png', // Dancing (icon not found, using placeholder)
    'assets/icons/InterestsHobbies/comedy.png', // Comedy
    'assets/icons/InterestsHobbies/yoga.png', // Yoga
    'assets/icons/InterestsHobbies/tour.png', // Travel
    'assets/icons/InterestsHobbies/skating.png', // Skiing
    'assets/icons/InterestsHobbies/blogging.png', // Blogging
    'assets/icons/InterestsHobbies/singing.png', // Singing
    'assets/icons/InterestsHobbies/painting.png', // Painting
    'assets/icons/InterestsHobbies/snowboarding.png', // Snowboarding
    'assets/icons/InterestsHobbies/ice_skating.png', // Ice Skating
    'assets/icons/InterestsHobbies/cheerleading.png', // Cheerleading
    'assets/icons/InterestsHobbies/sports.png', // Sports
    'assets/icons/InterestsHobbies/faith.png', // Faith
    'assets/icons/InterestsHobbies/foodie.png', // Foodie
    'assets/icons/InterestsHobbies/family.png', // Family
    // Image 3 icons
    'assets/icons/InterestsHobbies/education.png', // Education
    'assets/icons/InterestsHobbies/community.png', // Community
    'assets/icons/InterestsHobbies/music.png', // Music
    'assets/icons/InterestsHobbies/beach.png', // Beach
    'assets/icons/InterestsHobbies/hiking.png', // Hiking
    'assets/icons/InterestsHobbies/volunteering.png', // Volunteering
    'assets/icons/InterestsHobbies/bible.png', // Bible
    'assets/icons/InterestsHobbies/self_care.png', // Self-care
    'assets/icons/InterestsHobbies/reading.png', // Reading
    'assets/icons/InterestsHobbies/entrepreneurship.png', // Entrepreneurship
    'assets/icons/InterestsHobbies/culture.png', // Culture
    'assets/icons/InterestsHobbies/rugby.png', // Rugby
    'assets/icons/InterestsHobbies/american_football.png', // American Football
    // Image 4 icons
    'assets/icons/InterestsHobbies/car.png', // Cars
    'assets/icons/InterestsHobbies/motorcycles.png', // Motorcycles
    'assets/icons/InterestsHobbies/makeup.png', // Makeup
    'assets/icons/InterestsHobbies/concerts.png', // Concerts
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
      selectedReligion.clear();
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
    'Papua New Guinea',
    'Solomon Islands',
    'Vanuatu',
    'New Caledonia',
    'Rapa Nui',
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

  final List<String> workoutOptions = [
    'Every day',
    'Often',
    'Sometimes',
    'Never',
  ];

  final List<String> petsOptions = [
    'Dog',
    'Cat',
    'Reptile',
    'Amphibian',
    'Bird',
    'Fish',
    'Don\'t have but love',
    'Other',
    'Turtle',
  ];

  void toggleDrinking(String option) {
    if (selectedDrinking.contains(option)) {
      selectedDrinking.remove(option);
    } else {
      selectedDrinking.clear();
      selectedDrinking.add(option);
    }
  }

  void toggleSmoking(String option) {
    if (selectedSmoking.contains(option)) {
      selectedSmoking.remove(option);
    } else {
      selectedSmoking.clear();
      selectedSmoking.add(option);
    }
  }

  void toggleWorkout(String option) {
    if (selectedWorkout.contains(option)) {
      selectedWorkout.remove(option);
    } else {
      selectedWorkout.clear();
      selectedWorkout.add(option);
    }
  }

  void togglePets(String option) {
    if (selectedPets.contains(option)) {
      selectedPets.remove(option);
    } else {
      selectedPets.clear();
      selectedPets.add(option);
    }
  }

  final List<String> educationOptions = [
    'High School',
    'Some College',
    'Associate Degree',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'Doctorate (PhD, MD, etc.)',
  ];

  final List<String> languageOptions = [
    'Tonga',
    'Samoan',
    'Hawaiian',
    'Maori',
    'Fijian',
    'Tuvaluan',
    'Tahitian',
    'Niuean',
    'Tokelauan',
    'Rarotongan',
    'Marquesan',
    'Uvean',
    'Futunan',
    'Mangarevan',
    'Papuan',
    'Palauan',
    'Nauruan',
    'Rapa Nui',
    'Chamorro',
  ];

  void toggleLanguage(String language) {
    if (selectedLanguages.contains(language)) {
      selectedLanguages.remove(language);
    } else {
      selectedLanguages.add(language);
    }
  }

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
      selectedRelationshipType.clear();
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
