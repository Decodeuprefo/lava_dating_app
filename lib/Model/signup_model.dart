class SignupResponse {
  final User? user;
  final String? accessToken;
  final String? refreshToken;
  final String? message;
  final String? error;
  final int? statusCode;

  SignupResponse({
    this.user,
    this.accessToken,
    this.refreshToken,
    this.message,
    this.error,
    this.statusCode,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      message: json['message'] as String?,
      error: json['error'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }

  bool get isSuccess => user != null && accessToken != null;
  bool get isError => message != null || error != null;
}

class User {
  final String? email;
  final bool? isEmailVerified;
  final String? firstName;
  final String? lastName;
  final String? mobileNumber;
  final List<dynamic>? photos;
  final List<dynamic>? interests;
  final List<dynamic>? languagesSpoken;
  final List<dynamic>? ethnicity;
  final Location? location;
  final List<dynamic>? preferredGender;
  final int? preferredAgeMin;
  final int? preferredAgeMax;
  final int? preferredDistance;
  final String? subscriptionTier;
  final int? dailySwipesUsed;
  final int? dailyLikesUsed;
  final int? dailyMessagesUsed;
  final int? dailyMessageUsersCount;
  final bool? isProfileComplete;
  final int? profileCompletionStep;
  final bool? isActive;
  final bool? isBlocked;
  final List<dynamic>? fcmTokens;
  final List<dynamic>? apnsTokens;
  final List<dynamic>? blockedUsers;
  final bool? showAge;
  final bool? showDistance;
  final bool? notificationsEnabled;
  final bool? incognitoMode;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  // Additional fields from login response
  final String? lastActiveAt;
  final String? gender;
  final int? age;
  final String? dateOfBirth;
  final String? bio;
  final String? religion;
  final String? alcoholUse;
  final String? smokingStatus;
  final String? education;
  final String? relationshipType;
  final int? heightCm;
  final int? heightFeet;
  final int? heightInches;
  final String? maritalStatus;
  final String? kidsStatus;
  final String? city;
  final String? country;

  User({
    this.email,
    this.isEmailVerified,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.photos,
    this.interests,
    this.languagesSpoken,
    this.ethnicity,
    this.location,
    this.preferredGender,
    this.preferredAgeMin,
    this.preferredAgeMax,
    this.preferredDistance,
    this.subscriptionTier,
    this.dailySwipesUsed,
    this.dailyLikesUsed,
    this.dailyMessagesUsed,
    this.dailyMessageUsersCount,
    this.isProfileComplete,
    this.profileCompletionStep,
    this.isActive,
    this.isBlocked,
    this.fcmTokens,
    this.apnsTokens,
    this.blockedUsers,
    this.showAge,
    this.showDistance,
    this.notificationsEnabled,
    this.incognitoMode,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lastActiveAt,
    this.gender,
    this.age,
    this.dateOfBirth,
    this.bio,
    this.religion,
    this.alcoholUse,
    this.smokingStatus,
    this.education,
    this.relationshipType,
    this.heightCm,
    this.heightFeet,
    this.heightInches,
    this.maritalStatus,
    this.kidsStatus,
    this.city,
    this.country,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      photos: json['photos'] as List<dynamic>?,
      interests: json['interests'] as List<dynamic>?,
      languagesSpoken: json['languagesSpoken'] as List<dynamic>?,
      ethnicity: json['ethnicity'] as List<dynamic>?,
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      preferredGender: json['preferredGender'] as List<dynamic>?,
      preferredAgeMin: json['preferredAgeMin'] as int?,
      preferredAgeMax: json['preferredAgeMax'] as int?,
      preferredDistance: json['preferredDistance'] as int?,
      subscriptionTier: json['subscriptionTier'] as String?,
      dailySwipesUsed: json['dailySwipesUsed'] as int?,
      dailyLikesUsed: json['dailyLikesUsed'] as int?,
      dailyMessagesUsed: json['dailyMessagesUsed'] as int?,
      dailyMessageUsersCount: json['dailyMessageUsersCount'] as int?,
      isProfileComplete: json['isProfileComplete'] as bool?,
      profileCompletionStep: json['profileCompletionStep'] as int?,
      isActive: json['isActive'] as bool?,
      isBlocked: json['isBlocked'] as bool?,
      fcmTokens: json['fcmTokens'] as List<dynamic>?,
      apnsTokens: json['apnsTokens'] as List<dynamic>?,
      blockedUsers: json['blockedUsers'] as List<dynamic>?,
      showAge: json['showAge'] as bool?,
      showDistance: json['showDistance'] as bool?,
      notificationsEnabled: json['notificationsEnabled'] as bool?,
      incognitoMode: json['incognitoMode'] as bool?,
      id: json['_id'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      lastActiveAt: json['lastActiveAt'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      dateOfBirth: json['dateOfBirth'] as String?,
      bio: json['bio'] as String?,
      religion: json['religion'] as String?,
      alcoholUse: json['alcoholUse'] as String?,
      smokingStatus: json['smokingStatus'] as String?,
      education: json['education'] as String?,
      relationshipType: json['relationshipType'] as String?,
      heightCm: json['heightCm'] as int?,
      heightFeet: json['heightFeet'] as int?,
      heightInches: json['heightInches'] as int?,
      maritalStatus: json['maritalStatus'] as String?,
      kidsStatus: json['kidsStatus'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
    );
  }
}

class Location {
  final String? type;
  final List<dynamic>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] as String?,
      coordinates: json['coordinates'] as List<dynamic>?,
    );
  }
}
