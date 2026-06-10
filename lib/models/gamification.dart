enum AchievementType {
  firstConsultation,
  weekStreak,
  monthStreak,
  yearStreak,
  medicationAdherence,
  healthProgramComplete,
  bloodPressureTracking,
  bloodSugarTracking,
  sleepTracking,
  exerciseGoal,
  weightGoal,
  labTestComplete,
  prescriptionFilled,
}

enum AchievementTier {
  bronze,
  silver,
  gold,
  platinum,
}

class Achievement {
  final String id;
  final AchievementType type;
  final String name;
  final String description;
  final String iconName;
  final AchievementTier tier;
  final int pointsAwarded;
  final DateTime? unlockedAt;
  final bool isUnlocked;

  Achievement({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.iconName,
    required this.tier,
    required this.pointsAwarded,
    this.unlockedAt,
    required this.isUnlocked,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['_id'] ?? '',
      type: AchievementType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => AchievementType.firstConsultation,
      ),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      iconName: json['iconName'] ?? '',
      tier: AchievementTier.values.firstWhere(
        (e) => e.toString().split('.').last == json['tier'],
        orElse: () => AchievementTier.bronze,
      ),
      pointsAwarded: json['pointsAwarded'] ?? 0,
      unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt']) : null,
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type.toString().split('.').last,
      'name': name,
      'description': description,
      'iconName': iconName,
      'tier': tier.toString().split('.').last,
      'pointsAwarded': pointsAwarded,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'isUnlocked': isUnlocked,
    };
  }
}

class HealthStreak {
  final String id;
  final String userId;
  final String streakType; // 'daily_checkin', 'medication', 'exercise', 'sleep'
  final int currentStreak;
  final int longestStreak;
  final DateTime lastActivityDate;
  final DateTime streakStartDate;

  HealthStreak({
    required this.id,
    required this.userId,
    required this.streakType,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActivityDate,
    required this.streakStartDate,
  });

  factory HealthStreak.fromJson(Map<String, dynamic> json) {
    return HealthStreak(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      streakType: json['streakType'] ?? '',
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastActivityDate: DateTime.parse(json['lastActivityDate']),
      streakStartDate: DateTime.parse(json['streakStartDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'streakType': streakType,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActivityDate': lastActivityDate.toIso8601String(),
      'streakStartDate': streakStartDate.toIso8601String(),
    };
  }
}

class HealthMetricEntry {
  final String id;
  final String userId;
  final String metricType; // 'blood_pressure', 'blood_sugar', 'weight', 'sleep', 'exercise'
  final DateTime recordedAt;
  final Map<String, dynamic> values;
  final String? notes;

  HealthMetricEntry({
    required this.id,
    required this.userId,
    required this.metricType,
    required this.recordedAt,
    required this.values,
    this.notes,
  });

  factory HealthMetricEntry.fromJson(Map<String, dynamic> json) {
    return HealthMetricEntry(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      metricType: json['metricType'] ?? '',
      recordedAt: DateTime.parse(json['recordedAt']),
      values: Map<String, dynamic>.from(json['values'] ?? {}),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'metricType': metricType,
      'recordedAt': recordedAt.toIso8601String(),
      'values': values,
      'notes': notes,
    };
  }

  // Helper constructors for specific metric types
  static HealthMetricEntry bloodPressure({
    required String userId,
    required int systolic,
    required int diastolic,
    required int heartRate,
    String? notes,
  }) {
    return HealthMetricEntry(
      id: 'bp_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      metricType: 'blood_pressure',
      recordedAt: DateTime.now(),
      values: {
        'systolic': systolic,
        'diastolic': diastolic,
        'heartRate': heartRate,
      },
      notes: notes,
    );
  }

  static HealthMetricEntry bloodSugar({
    required String userId,
    required double glucose,
    required String measurementType, // 'fasting', 'post_meal', 'random'
    String? notes,
  }) {
    return HealthMetricEntry(
      id: 'bs_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      metricType: 'blood_sugar',
      recordedAt: DateTime.now(),
      values: {
        'glucose': glucose,
        'measurementType': measurementType,
      },
      notes: notes,
    );
  }

  static HealthMetricEntry weight({
    required String userId,
    required double weightKg,
    double? bmi,
    String? notes,
  }) {
    return HealthMetricEntry(
      id: 'wt_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      metricType: 'weight',
      recordedAt: DateTime.now(),
      values: {
        'weightKg': weightKg,
        if (bmi != null) 'bmi': bmi,
      },
      notes: notes,
    );
  }

  static HealthMetricEntry sleep({
    required String userId,
    required double hoursSlept,
    required String quality, // 'poor', 'fair', 'good', 'excellent'
    String? notes,
  }) {
    return HealthMetricEntry(
      id: 'sleep_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      metricType: 'sleep',
      recordedAt: DateTime.now(),
      values: {
        'hoursSlept': hoursSlept,
        'quality': quality,
      },
      notes: notes,
    );
  }

  static HealthMetricEntry exercise({
    required String userId,
    required String activityType,
    required int durationMinutes,
    int? caloriesBurned,
    String? notes,
  }) {
    return HealthMetricEntry(
      id: 'ex_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      metricType: 'exercise',
      recordedAt: DateTime.now(),
      values: {
        'activityType': activityType,
        'durationMinutes': durationMinutes,
        if (caloriesBurned != null) 'caloriesBurned': caloriesBurned,
      },
      notes: notes,
    );
  }
}

class UserGamificationProfile {
  final String userId;
  final int totalPoints;
  final int level;
  final List<Achievement> achievements;
  final List<HealthStreak> streaks;
  final int consultationsCompleted;
  final int healthProgramsCompleted;
  final int daysActive;

  UserGamificationProfile({
    required this.userId,
    required this.totalPoints,
    required this.level,
    required this.achievements,
    required this.streaks,
    required this.consultationsCompleted,
    required this.healthProgramsCompleted,
    required this.daysActive,
  });

  factory UserGamificationProfile.fromJson(Map<String, dynamic> json) {
    return UserGamificationProfile(
      userId: json['userId'] ?? '',
      totalPoints: json['totalPoints'] ?? 0,
      level: json['level'] ?? 1,
      achievements: (json['achievements'] as List?)
          ?.map((a) => Achievement.fromJson(a))
          .toList() ?? [],
      streaks: (json['streaks'] as List?)
          ?.map((s) => HealthStreak.fromJson(s))
          .toList() ?? [],
      consultationsCompleted: json['consultationsCompleted'] ?? 0,
      healthProgramsCompleted: json['healthProgramsCompleted'] ?? 0,
      daysActive: json['daysActive'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalPoints': totalPoints,
      'level': level,
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'streaks': streaks.map((s) => s.toJson()).toList(),
      'consultationsCompleted': consultationsCompleted,
      'healthProgramsCompleted': healthProgramsCompleted,
      'daysActive': daysActive,
    };
  }

  int get pointsToNextLevel {
    return (level * 100) - (totalPoints % (level * 100));
  }

  double get progressToNextLevel {
    final pointsInCurrentLevel = totalPoints % (level * 100);
    return pointsInCurrentLevel / (level * 100);
  }
}
