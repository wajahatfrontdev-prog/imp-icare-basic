class ClinicalAudit {
  final String id;
  final String consultationId;
  final String doctorId;
  final String patientId;
  final DateTime auditDate;
  final ConsultationQualityScore qualityScore;
  final List<QualityFlag> flags;
  final String? reviewerNotes;
  final AuditStatus status;

  ClinicalAudit({
    required this.id,
    required this.consultationId,
    required this.doctorId,
    required this.patientId,
    required this.auditDate,
    required this.qualityScore,
    required this.flags,
    this.reviewerNotes,
    required this.status,
  });

  factory ClinicalAudit.fromJson(Map<String, dynamic> json) {
    return ClinicalAudit(
      id: json['_id'] ?? '',
      consultationId: json['consultationId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      patientId: json['patientId'] ?? '',
      auditDate: DateTime.parse(json['auditDate']),
      qualityScore: ConsultationQualityScore.fromJson(json['qualityScore']),
      flags: (json['flags'] as List?)
          ?.map((f) => QualityFlag.fromJson(f))
          .toList() ?? [],
      reviewerNotes: json['reviewerNotes'],
      status: AuditStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AuditStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'consultationId': consultationId,
      'doctorId': doctorId,
      'patientId': patientId,
      'auditDate': auditDate.toIso8601String(),
      'qualityScore': qualityScore.toJson(),
      'flags': flags.map((f) => f.toJson()).toList(),
      'reviewerNotes': reviewerNotes,
      'status': status.toString().split('.').last,
    };
  }
}

class ConsultationQualityScore {
  final int documentationCompleteness; // 0-100
  final int clinicalReasoningScore; // 0-100
  final int prescriptionAppropriatenessScore; // 0-100
  final int followUpPlanScore; // 0-100
  final int overallScore; // 0-100

  ConsultationQualityScore({
    required this.documentationCompleteness,
    required this.clinicalReasoningScore,
    required this.prescriptionAppropriatenessScore,
    required this.followUpPlanScore,
    required this.overallScore,
  });

  factory ConsultationQualityScore.fromJson(Map<String, dynamic> json) {
    return ConsultationQualityScore(
      documentationCompleteness: json['documentationCompleteness'] ?? 0,
      clinicalReasoningScore: json['clinicalReasoningScore'] ?? 0,
      prescriptionAppropriatenessScore: json['prescriptionAppropriatenessScore'] ?? 0,
      followUpPlanScore: json['followUpPlanScore'] ?? 0,
      overallScore: json['overallScore'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentationCompleteness': documentationCompleteness,
      'clinicalReasoningScore': clinicalReasoningScore,
      'prescriptionAppropriatenessScore': prescriptionAppropriatenessScore,
      'followUpPlanScore': followUpPlanScore,
      'overallScore': overallScore,
    };
  }
}

class QualityFlag {
  final QualityFlagType type;
  final String description;
  final QualityFlagSeverity severity;
  final DateTime flaggedAt;

  QualityFlag({
    required this.type,
    required this.description,
    required this.severity,
    required this.flaggedAt,
  });

  factory QualityFlag.fromJson(Map<String, dynamic> json) {
    return QualityFlag(
      type: QualityFlagType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => QualityFlagType.other,
      ),
      description: json['description'] ?? '',
      severity: QualityFlagSeverity.values.firstWhere(
        (e) => e.toString().split('.').last == json['severity'],
        orElse: () => QualityFlagSeverity.low,
      ),
      flaggedAt: DateTime.parse(json['flaggedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'description': description,
      'severity': severity.toString().split('.').last,
      'flaggedAt': flaggedAt.toIso8601String(),
    };
  }
}

enum QualityFlagType {
  incompleteDocumentation,
  missingVitalSigns,
  inappropriatePrescription,
  drugInteraction,
  missingFollowUp,
  diagnosticInconsistency,
  other,
}

enum QualityFlagSeverity {
  low,
  medium,
  high,
  critical,
}

enum AuditStatus {
  pending,
  reviewed,
  flaggedForReview,
  resolved,
}
