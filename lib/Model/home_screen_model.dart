class HomeScreenModel {
  final HomeUser? user;
  final HomeStats? stats;
  final List<Suggestion>? suggestions;
  final List<RecentMatch>? recentMatches;

  HomeScreenModel({
    this.user,
    this.stats,
    this.suggestions,
    this.recentMatches,
  });

  factory HomeScreenModel.fromJson(Map<String, dynamic> json) {
    return HomeScreenModel(
      user: json['user'] != null ? HomeUser.fromJson(json['user']) : null,
      stats: json['stats'] != null ? HomeStats.fromJson(json['stats']) : null,
      suggestions: json['suggestions'] != null
          ? (json['suggestions'] as List<dynamic>)
              .map((item) => Suggestion.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      recentMatches: json['recentMatches'] != null
          ? (json['recentMatches'] as List<dynamic>)
              .map((item) => RecentMatch.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'stats': stats?.toJson(),
      'suggestions': suggestions?.map((suggestion) => suggestion.toJson()).toList(),
      'recentMatches': recentMatches?.map((match) => match.toJson()).toList(),
    };
  }
}

class HomeUser {
  final String? firstName;
  final List<String>? photos;

  HomeUser({
    this.firstName,
    this.photos,
  });

  factory HomeUser.fromJson(Map<String, dynamic> json) {
    return HomeUser(
      firstName: json['firstName'] as String?,
      photos: json['photos'] != null
          ? (json['photos'] as List<dynamic>).map((e) => e.toString()).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'photos': photos,
    };
  }
}

class HomeStats {
  final int? matchesCount;
  final int? remainingSwipes;
  final int? totalDailySwipes;
  final bool? isUnlimitedSwipes;
  final int? likesReceivedCount;

  HomeStats({
    this.matchesCount,
    this.remainingSwipes,
    this.totalDailySwipes,
    this.isUnlimitedSwipes,
    this.likesReceivedCount,
  });

  factory HomeStats.fromJson(Map<String, dynamic> json) {
    return HomeStats(
      matchesCount: json['matchesCount'] as int?,
      remainingSwipes: json['remainingSwipes'] as int?,
      totalDailySwipes: json['totalDailySwipes'] as int?,
      isUnlimitedSwipes: json['isUnlimitedSwipes'] as bool?,
      likesReceivedCount: json['likesReceivedCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchesCount': matchesCount,
      'remainingSwipes': remainingSwipes,
      'totalDailySwipes': totalDailySwipes,
      'isUnlimitedSwipes': isUnlimitedSwipes,
      'likesReceivedCount': likesReceivedCount,
    };
  }
}

class Suggestion {
  final String? id;
  final SuggestionUser? user;
  final String? action;
  final bool? canSeeDetails;

  Suggestion({
    this.id,
    this.user,
    this.action,
    this.canSeeDetails,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      id: json['_id'] as String?,
      user: json['user'] != null ? SuggestionUser.fromJson(json['user']) : null,
      action: json['action'] as String?,
      canSeeDetails: json['canSeeDetails'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user?.toJson(),
      'action': action,
      'canSeeDetails': canSeeDetails,
    };
  }
}

class SuggestionUser {
  final String? id;
  final String? firstName;
  final List<String>? photos;

  SuggestionUser({
    this.id,
    this.firstName,
    this.photos,
  });

  factory SuggestionUser.fromJson(Map<String, dynamic> json) {
    return SuggestionUser(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      photos: json['photos'] != null
          ? (json['photos'] as List<dynamic>).map((e) => e.toString()).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'photos': photos,
    };
  }
}

class RecentMatch {
  final String? id;
  final MatchUser? user;
  final String? matchedAt;

  RecentMatch({
    this.id,
    this.user,
    this.matchedAt,
  });

  factory RecentMatch.fromJson(Map<String, dynamic> json) {
    return RecentMatch(
      id: json['_id'] as String?,
      user: json['user'] != null ? MatchUser.fromJson(json['user']) : null,
      matchedAt: json['matchedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user?.toJson(),
      'matchedAt': matchedAt,
    };
  }
}

class MatchUser {
  final String? id;
  final String? firstName;
  final int? age;
  final List<String>? photos;
  final String? city;
  final String? country;
  final bool? isActive;
  final String? lastActiveAt;
  final bool? isAvailable;

  MatchUser({
    this.id,
    this.firstName,
    this.age,
    this.photos,
    this.city,
    this.country,
    this.isActive,
    this.lastActiveAt,
    this.isAvailable,
  });

  factory MatchUser.fromJson(Map<String, dynamic> json) {
    return MatchUser(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      age: json['age'] as int?,
      photos: json['photos'] != null
          ? (json['photos'] as List<dynamic>).map((e) => e.toString()).toList()
          : null,
      city: json['city'] as String?,
      country: json['country'] as String?,
      isActive: json['isActive'] as bool?,
      lastActiveAt: json['lastActiveAt'] as String?,
      isAvailable: json['isAvailable'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'age': age,
      'photos': photos,
      'city': city,
      'country': country,
      'isActive': isActive,
      'lastActiveAt': lastActiveAt,
      'isAvailable': isAvailable,
    };
  }
}
