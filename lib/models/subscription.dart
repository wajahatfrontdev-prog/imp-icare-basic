enum SubscriptionTier {
  free,
  basic,
  premium,
  enterprise,
}

enum SubscriptionStatus {
  active,
  expired,
  cancelled,
  suspended,
}

class Subscription {
  final String id;
  final String userId;
  final SubscriptionTier tier;
  final SubscriptionStatus status;
  final DateTime startDate;
  final DateTime? endDate;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> features;
  final int consultationsPerMonth;
  final bool prioritySupport;
  final bool familySharing;
  final int maxFamilyMembers;
  final double labTestDiscount;
  final double prescriptionDiscount;
  final bool chronicCareProgramsIncluded;

  Subscription({
    required this.id,
    required this.userId,
    required this.tier,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.features,
    required this.consultationsPerMonth,
    required this.prioritySupport,
    required this.familySharing,
    required this.maxFamilyMembers,
    required this.labTestDiscount,
    required this.prescriptionDiscount,
    required this.chronicCareProgramsIncluded,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      tier: SubscriptionTier.values.firstWhere(
        (e) => e.toString().split('.').last == json['tier'],
        orElse: () => SubscriptionTier.free,
      ),
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => SubscriptionStatus.active,
      ),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      monthlyPrice: (json['monthlyPrice'] ?? 0).toDouble(),
      yearlyPrice: (json['yearlyPrice'] ?? 0).toDouble(),
      features: List<String>.from(json['features'] ?? []),
      consultationsPerMonth: json['consultationsPerMonth'] ?? 0,
      prioritySupport: json['prioritySupport'] ?? false,
      familySharing: json['familySharing'] ?? false,
      maxFamilyMembers: json['maxFamilyMembers'] ?? 0,
      labTestDiscount: (json['labTestDiscount'] ?? 0).toDouble(),
      prescriptionDiscount: (json['prescriptionDiscount'] ?? 0).toDouble(),
      chronicCareProgramsIncluded: json['chronicCareProgramsIncluded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'tier': tier.toString().split('.').last,
      'status': status.toString().split('.').last,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'monthlyPrice': monthlyPrice,
      'yearlyPrice': yearlyPrice,
      'features': features,
      'consultationsPerMonth': consultationsPerMonth,
      'prioritySupport': prioritySupport,
      'familySharing': familySharing,
      'maxFamilyMembers': maxFamilyMembers,
      'labTestDiscount': labTestDiscount,
      'prescriptionDiscount': prescriptionDiscount,
      'chronicCareProgramsIncluded': chronicCareProgramsIncluded,
    };
  }

  static Subscription getFreeSubscription(String userId) {
    return Subscription(
      id: 'free_$userId',
      userId: userId,
      tier: SubscriptionTier.free,
      status: SubscriptionStatus.active,
      startDate: DateTime.now(),
      monthlyPrice: 0,
      yearlyPrice: 0,
      features: [
        '1 consultation per month',
        'Basic health programs',
        'Standard support',
      ],
      consultationsPerMonth: 1,
      prioritySupport: false,
      familySharing: false,
      maxFamilyMembers: 0,
      labTestDiscount: 0,
      prescriptionDiscount: 0,
      chronicCareProgramsIncluded: false,
    );
  }

  static Subscription getBasicSubscription(String userId) {
    return Subscription(
      id: 'basic_$userId',
      userId: userId,
      tier: SubscriptionTier.basic,
      status: SubscriptionStatus.active,
      startDate: DateTime.now(),
      monthlyPrice: 29.99,
      yearlyPrice: 299.99,
      features: [
        '5 consultations per month',
        'All health programs',
        'Priority support',
        '10% discount on lab tests',
        '10% discount on prescriptions',
      ],
      consultationsPerMonth: 5,
      prioritySupport: true,
      familySharing: false,
      maxFamilyMembers: 0,
      labTestDiscount: 10,
      prescriptionDiscount: 10,
      chronicCareProgramsIncluded: false,
    );
  }

  static Subscription getPremiumSubscription(String userId) {
    return Subscription(
      id: 'premium_$userId',
      userId: userId,
      tier: SubscriptionTier.premium,
      status: SubscriptionStatus.active,
      startDate: DateTime.now(),
      monthlyPrice: 59.99,
      yearlyPrice: 599.99,
      features: [
        'Unlimited consultations',
        'All health programs',
        '24/7 priority support',
        'Family sharing (up to 4 members)',
        '20% discount on lab tests',
        '20% discount on prescriptions',
        'Chronic care programs included',
        'Free home delivery',
      ],
      consultationsPerMonth: -1, // unlimited
      prioritySupport: true,
      familySharing: true,
      maxFamilyMembers: 4,
      labTestDiscount: 20,
      prescriptionDiscount: 20,
      chronicCareProgramsIncluded: true,
    );
  }

  static Subscription getEnterpriseSubscription(String userId) {
    return Subscription(
      id: 'enterprise_$userId',
      userId: userId,
      tier: SubscriptionTier.enterprise,
      status: SubscriptionStatus.active,
      startDate: DateTime.now(),
      monthlyPrice: 199.99,
      yearlyPrice: 1999.99,
      features: [
        'Unlimited consultations',
        'All health programs',
        'Dedicated account manager',
        'Family sharing (up to 10 members)',
        '30% discount on lab tests',
        '30% discount on prescriptions',
        'All chronic care programs',
        'Free home delivery',
        'Annual health checkup',
        'Wellness coaching',
      ],
      consultationsPerMonth: -1, // unlimited
      prioritySupport: true,
      familySharing: true,
      maxFamilyMembers: 10,
      labTestDiscount: 30,
      prescriptionDiscount: 30,
      chronicCareProgramsIncluded: true,
    );
  }
}

class ChronicCarePackage {
  final String id;
  final String name;
  final String description;
  final String targetCondition;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> includedServices;
  final int consultationsPerMonth;
  final int labTestsPerYear;
  final bool medicationManagement;
  final bool nutritionCounseling;
  final bool lifestyleCoaching;
  final List<String> healthProgramIds;

  ChronicCarePackage({
    required this.id,
    required this.name,
    required this.description,
    required this.targetCondition,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.includedServices,
    required this.consultationsPerMonth,
    required this.labTestsPerYear,
    required this.medicationManagement,
    required this.nutritionCounseling,
    required this.lifestyleCoaching,
    required this.healthProgramIds,
  });

  factory ChronicCarePackage.fromJson(Map<String, dynamic> json) {
    return ChronicCarePackage(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      targetCondition: json['targetCondition'] ?? '',
      monthlyPrice: (json['monthlyPrice'] ?? 0).toDouble(),
      yearlyPrice: (json['yearlyPrice'] ?? 0).toDouble(),
      includedServices: List<String>.from(json['includedServices'] ?? []),
      consultationsPerMonth: json['consultationsPerMonth'] ?? 0,
      labTestsPerYear: json['labTestsPerYear'] ?? 0,
      medicationManagement: json['medicationManagement'] ?? false,
      nutritionCounseling: json['nutritionCounseling'] ?? false,
      lifestyleCoaching: json['lifestyleCoaching'] ?? false,
      healthProgramIds: List<String>.from(json['healthProgramIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'targetCondition': targetCondition,
      'monthlyPrice': monthlyPrice,
      'yearlyPrice': yearlyPrice,
      'includedServices': includedServices,
      'consultationsPerMonth': consultationsPerMonth,
      'labTestsPerYear': labTestsPerYear,
      'medicationManagement': medicationManagement,
      'nutritionCounseling': nutritionCounseling,
      'lifestyleCoaching': lifestyleCoaching,
      'healthProgramIds': healthProgramIds,
    };
  }

  static ChronicCarePackage getDiabetesCarePackage() {
    return ChronicCarePackage(
      id: 'chronic_diabetes',
      name: 'Diabetes Care Package',
      description: 'Comprehensive diabetes management with regular monitoring and support',
      targetCondition: 'Type 2 Diabetes',
      monthlyPrice: 79.99,
      yearlyPrice: 799.99,
      includedServices: [
        'Monthly doctor consultations',
        'Quarterly HbA1c tests',
        'Annual comprehensive metabolic panel',
        'Medication management',
        'Nutrition counseling',
        'Diabetes education program',
        'Blood glucose monitor',
      ],
      consultationsPerMonth: 1,
      labTestsPerYear: 6,
      medicationManagement: true,
      nutritionCounseling: true,
      lifestyleCoaching: true,
      healthProgramIds: ['program_001'],
    );
  }

  static ChronicCarePackage getHypertensionCarePackage() {
    return ChronicCarePackage(
      id: 'chronic_hypertension',
      name: 'Hypertension Care Package',
      description: 'Blood pressure management with regular monitoring and lifestyle support',
      targetCondition: 'Hypertension',
      monthlyPrice: 59.99,
      yearlyPrice: 599.99,
      includedServices: [
        'Monthly doctor consultations',
        'Quarterly blood pressure monitoring',
        'Annual lipid panel',
        'Medication management',
        'DASH diet counseling',
        'Hypertension control program',
        'Home BP monitor',
      ],
      consultationsPerMonth: 1,
      labTestsPerYear: 4,
      medicationManagement: true,
      nutritionCounseling: true,
      lifestyleCoaching: true,
      healthProgramIds: ['program_002'],
    );
  }

  static ChronicCarePackage getHeartCarePackage() {
    return ChronicCarePackage(
      id: 'chronic_heart',
      name: 'Heart Health Package',
      description: 'Cardiovascular disease management and prevention',
      targetCondition: 'Cardiovascular Disease',
      monthlyPrice: 99.99,
      yearlyPrice: 999.99,
      includedServices: [
        'Monthly cardiology consultations',
        'Quarterly ECG',
        'Annual stress test',
        'Annual echocardiogram',
        'Medication management',
        'Cardiac rehabilitation program',
        'Nutrition counseling',
      ],
      consultationsPerMonth: 1,
      labTestsPerYear: 8,
      medicationManagement: true,
      nutritionCounseling: true,
      lifestyleCoaching: true,
      healthProgramIds: ['program_003'],
    );
  }
}
