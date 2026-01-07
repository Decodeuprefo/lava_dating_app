import 'package:flutter/material.dart';
import 'package:lava_dating_app/View/homeModule/dashboard_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/about_me_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/add_profile_photos_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/interests_and_hobbies.dart';
import 'package:lava_dating_app/View/setProfileModule/intro_video_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/kids_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/location_permission_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/preferred_age_range_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/preferred_distance_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/preferred_gender_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/race_flags_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/select_dob_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/select_education_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/select_gender_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/select_height_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/select_languages_spoken.dart';
import 'package:lava_dating_app/View/setProfileModule/select_lifestyle_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/select_marital_status.dart';
import 'package:lava_dating_app/View/setProfileModule/select_relationship_type_screen.dart';
import 'package:lava_dating_app/View/setProfileModule/select_religion_screen.dart';

class ProfileNavigationHelper {
  static Widget determineNextScreen(Map<String, dynamic> user) {
    // 1. Select Gender
    final gender = user['gender'] as String?;
    if (gender == null || gender.isEmpty) {
      return const SelectGenderScreen();
    }

    // 2. Add Profile Photos
    final photos = user['photos'] as List<dynamic>?;
    if (photos == null || photos.isEmpty) {
      return const AddProfilePhotosScreen();
    }

    // 3. Intro Video
    final introVideo = user['introVideo'] as String?;
    if (introVideo == null || introVideo.isEmpty) {
      return const IntroVideoScreen();
    }

    // 4. About Me
    final bio = user['bio'] as String?;
    if (bio == null || bio.isEmpty) {
      return const AboutMeScreen();
    }

    // 5. Select DOB
    final dateOfBirth = user['dateOfBirth'] as String?;
    if (dateOfBirth == null || dateOfBirth.isEmpty) {
      return const SelectDobScreen();
    }

    // 6. Interests & Hobbies
    final interests = user['interests'] as List<dynamic>?;
    if (interests == null || interests.isEmpty) {
      return const InterestsAndHobbies();
    }

    // 7. Religion
    final religion = user['religion'] as String?;
    if (religion == null || religion.isEmpty) {
      return const ReligionScreen();
    }

    // 8. Lifestyle (check smokingStatus)
    final smokingStatus = user['smokingStatus'] as String?;
    if (smokingStatus == null || smokingStatus.isEmpty) {
      return const LifestyleScreen();
    }

    // 9. Education
    final education = user['education'] as String?;
    if (education == null || education.isEmpty) {
      return const SelectEducationScreen();
    }

    // 10. Languages Spoken
    final languagesSpoken = user['languagesSpoken'] as List<dynamic>?;
    if (languagesSpoken == null || languagesSpoken.isEmpty) {
      return const SelectLanguagesSpoken();
    }

    // 11. Relationship Type
    final relationshipType = user['relationshipType'] as String?;
    if (relationshipType == null || relationshipType.isEmpty) {
      return const SelectRelationshipTypeScreen();
    }

    // 12. Preferred Age Range
    if (user['preferredAgeMin'] == null || user['preferredAgeMax'] == null) {
      return const PreferredAgeRangeScreen();
    }

    // 13. Height
    if (user['heightCm'] == null && (user['heightFeet'] == null || user['heightInches'] == null)) {
      return const SelectHeightScreen();
    }

    // 14. Preferred Gender
    final preferredGender = user['preferredGender'] as List<dynamic>?;
    if (preferredGender == null || preferredGender.isEmpty) {
      return const PreferredGenderScreen();
    }

    // 15. Marital Status
    final maritalStatus = user['maritalStatus'] as String?;
    if (maritalStatus == null || maritalStatus.isEmpty) {
      return const SelectMaritalStatus();
    }

    // 16. Kids Screen
    final kidsStatus = user['kidsStatus'] as String?;
    if (kidsStatus == null || kidsStatus.isEmpty) {
      return const KidsScreen();
    }

    // 17. Preferred Distance
    if (user['preferredDistance'] == null) {
      return const PreferredDistanceScreen();
    }

    // 18. Race Flags
    final ethnicity = user['ethnicity'] as List<dynamic>?;
    if (ethnicity == null || ethnicity.isEmpty) {
      return const RaceFlagsScreen();
    }

    final location = user['location'] as Map<String, dynamic>?;
    print(">>>>>>>>>${location}");
    if (location == null) {
      return const LocationPermissionScreen();
    }

    final coordinates = location['coordinates'] as List<dynamic>?;
    print(">>>>>>>>>${coordinates}");
    if (coordinates == null || coordinates.length < 2) {
      return const LocationPermissionScreen();
    }

    final lat = coordinates[0] is num ? coordinates[0].toDouble() : null;
    final lng = coordinates[1] is num ? coordinates[1].toDouble() : null;
    print(">>>>>>>>>${lat}${lng}");
    if (lat == null || lng == null || (lat == 0.0 && lng == 0.0)) {
      return const LocationPermissionScreen();
    }

    // All fields are complete - navigate to Dashboard
    return const DashboardScreen();
  }
}
