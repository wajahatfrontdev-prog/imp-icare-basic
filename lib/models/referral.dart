class Referral {
  final String id;
  final String patientId;
  final String referringDoctorId;
  final String? specialistDoctorId;
  final String consultationId;
  final ReferralStatus status;

  // Referral details
  final String specialtyRequired;
  final String reasonForReferral;
  final String clinicalSummary;
  final String urgency;

  // Documents
  final List<String> attachedDocuments;

  // Specialist response
  final String? specialistNotes;
  final DateTime? specialistAcceptedAt;
  final DateTime? specialistRejectedAt;
  final String? rejectionReason;

  // Appointment
  final String? appointmentId;
  final DateTime? appointmentDate;

  // Timestamps
  final DateTime createdAt;
  final DateTime? completedAt;

  Referral({
    required this.id,
    required this.patientId,
    required this.referringDoctorId,
    this.specialistDoctorId,
    required this.consultationId,
    required this.status,
    required this.specialtyRequired,
    required this.reasonForReferral,
    required this.clinicalSummary,
    required this.urgency,
    required this.attachedDocuments,
    this.specialistNotes,
    this.specialistAcceptedAt,
    this.specialistRejectedAt,
    this.rejectionReason,
    this.appointmentId,
    this.appointmentDate,
    required this.createdAt,
    this.completedAt,
  });

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      id: json['_id'] ?? '',
      patientId: json['patientId'] ?? '',
      referringDoctorId: json['referringDoctorId'] ?? '',
      specialistDoctorId: json['specialistDoctorId'],
      consultationId: json['consultationId'] ?? '',
      status: ReferralStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ReferralStatus.pending,
      ),
      specialtyRequired: json['specialtyRequired'] ?? '',
      reasonForReferral: json['reasonForReferral'] ?? '',
      clinicalSummary: json['clinicalSummary'] ?? '',
      urgency: json['urgency'] ?? 'normal',
      attachedDocuments: List<String>.from(json['attachedDocuments'] ?? []),
      specialistNotes: json['specialistNotes'],
      specialistAcceptedAt: json['specialistAcceptedAt'] != null
          ? DateTime.parse(json['specialistAcceptedAt'])
          : null,
      specialistRejectedAt: json['specialistRejectedAt'] != null
          ? DateTime.parse(json['specialistRejectedAt'])
          : null,
      rejectionReason: json['rejectionReason'],
      appointmentId: json['appointmentId'],
      appointmentDate: json['appointmentDate'] != null
          ? DateTime.parse(json['appointmentDate'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'referringDoctorId': referringDoctorId,
      'specialistDoctorId': specialistDoctorId,
      'consultationId': consultationId,
      'status': status.toString().split('.').last,
      'specialtyRequired': specialtyRequired,
      'reasonForReferral': reasonForReferral,
      'clinicalSummary': clinicalSummary,
      'urgency': urgency,
      'attachedDocuments': attachedDocuments,
      'specialistNotes': specialistNotes,
      'specialistAcceptedAt': specialistAcceptedAt?.toIso8601String(),
      'specialistRejectedAt': specialistRejectedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
      'appointmentId': appointmentId,
      'appointmentDate': appointmentDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

enum ReferralStatus {
  pending,
  accepted,
  rejected,
  appointmentScheduled,
  completed,
  cancelled,
}
