class SwipeDeckModel {
  final List<DeckProfile>? profiles;
  final int? total;
  final bool? hasMore;

  SwipeDeckModel({
    this.profiles,
    this.total,
    this.hasMore,
  });

  factory SwipeDeckModel.fromJson(Map<String, dynamic> json) {
    return SwipeDeckModel(
      profiles: json['profiles'] != null
          ? (json['profiles'] as List<dynamic>)
              .map((item) => DeckProfile.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      total: json['total'] as int?,
      hasMore: json['hasMore'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profiles': profiles?.map((profile) => profile.toJson()).toList(),
      'total': total,
      'hasMore': hasMore,
    };
  }
}

class DeckProfile {
  final String? id;
  final String? firstName;
  final String? gender;
  final String? bio;
  final List<String>? photos;
  final List<String>? interests;
  final String? religion;
  final String? city;
  final String? country;
  final String? education;
  final String? relationshipType;
  final int? age;
  final int? distance;
  final ProfileHeight? height;

  DeckProfile({
    this.id,
    this.firstName,
    this.gender,
    this.bio,
    this.photos,
    this.interests,
    this.religion,
    this.city,
    this.country,
    this.education,
    this.relationshipType,
    this.age,
    this.distance,
    this.height,
  });

  factory DeckProfile.fromJson(Map<String, dynamic> json) {
    return DeckProfile(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      gender: json['gender'] as String?,
      bio: json['bio'] as String?,
      photos: json['photos'] != null
          ? (json['photos'] as List<dynamic>).map((e) => e.toString()).toList()
          : null,
      interests: json['interests'] != null
          ? (json['interests'] as List<dynamic>).map((e) => e.toString()).toList()
          : null,
      religion: json['religion'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      education: json['education'] as String?,
      relationshipType: json['relationshipType'] as String?,
      age: json['age'] as int?,
      distance: json['distance'] as int?,
      height: json['height'] != null ? ProfileHeight.fromJson(json['height']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'gender': gender,
      'bio': bio,
      'photos': photos,
      'interests': interests,
      'religion': religion,
      'city': city,
      'country': country,
      'education': education,
      'relationshipType': relationshipType,
      'age': age,
      'distance': distance,
      'height': height?.toJson(),
    };
  }
}

class ProfileHeight {
  final int? feet;
  final int? inches;
  final int? cm;

  ProfileHeight({
    this.feet,
    this.inches,
    this.cm,
  });

  factory ProfileHeight.fromJson(Map<String, dynamic> json) {
    return ProfileHeight(
      feet: json['feet'] as int?,
      inches: json['inches'] as int?,
      cm: json['cm'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feet': feet,
      'inches': inches,
      'cm': cm,
    };
  }
}
