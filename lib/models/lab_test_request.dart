class LabTestRequest {
  final String id;
  final String patientId;
  final String doctorId;
  final String consultationId;
  final String? labId;
  final List<String> testTypes;
  final LabTestRequestStatus status;
  final LabTestPriority priority;

  // Clinical context
  final String clinicalNotes;
  final String diagnosis;
  final String reasonForTest;

  // Results
  final String? reportUrl;
  final String? reportNotes;
  final DateTime? reportUploadedAt;

  // Timestamps
  final DateTime requestedAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final DateTime? rejectedAt;
  final String? rejectionReason;

  LabTestRequest({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.consultationId,
    this.labId,
    required this.testTypes,
    required this.status,
    required this.priority,
    required this.clinicalNotes,
    required this.diagnosis,
    required this.reasonForTest,
    this.reportUrl,
    this.reportNotes,
    this.reportUploadedAt,
    required this.requestedAt,
    this.acceptedAt,
    this.completedAt,
    this.rejectedAt,
    this.rejectionReason,
  });

  factory LabTestRequest.fromJson(Map<String, dynamic> json) {
    return LabTestRequest(
      id: json['_id'] ?? '',
      patientId: json['patientId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      consultationId: json['consultationId'] ?? '',
      labId: json['labId'],
      testTypes: List<String>.from(json['testTypes'] ?? []),
      status: LabTestRequestStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => LabTestRequestStatus.pending,
      ),
      priority: LabTestPriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
        orElse: () => LabTestPriority.normal,
      ),
      clinicalNotes: json['clinicalNotes'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      reasonForTest: json['reasonForTest'] ?? '',
      reportUrl: json['reportUrl'],
      reportNotes: json['reportNotes'],
      reportUploadedAt: json['reportUploadedAt'] != null
          ? DateTime.parse(json['reportUploadedAt'])
          : null,
      requestedAt: DateTime.parse(json['requestedAt']),
      acceptedAt: json['acceptedAt'] != null ? DateTime.parse(json['acceptedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      rejectedAt: json['rejectedAt'] != null ? DateTime.parse(json['rejectedAt']) : null,
      rejectionReason: json['rejectionReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'consultationId': consultationId,
      'labId': labId,
      'testTypes': testTypes,
      'status': status.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'clinicalNotes': clinicalNotes,
      'diagnosis': diagnosis,
      'reasonForTest': reasonForTest,
      'reportUrl': reportUrl,
      'reportNotes': reportNotes,
      'reportUploadedAt': reportUploadedAt?.toIso8601String(),
      'requestedAt': requestedAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'rejectedAt': rejectedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
    };
  }
}

enum LabTestRequestStatus {
  pending,
  accepted,
  inProgress,
  completed,
  rejected,
  cancelled,
}

enum LabTestPriority {
  urgent,
  normal,
  routine,
}
