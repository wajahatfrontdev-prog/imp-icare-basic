class HealthProgramAssignment {
  final String id;
  final String patientId;
  final String doctorId;
  final String programId;
  final String consultationId;
  final HealthProgramAssignmentStatus status;

  // Program details
  final String programName;
  final String programDescription;
  final String reasonForAssignment;

  // Progress tracking
  final int totalModules;
  final int completedModules;
  final double progressPercentage;

  // Timestamps
  final DateTime assignedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? dueDate;

  HealthProgramAssignment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.programId,
    required this.consultationId,
    required this.status,
    required this.programName,
    required this.programDescription,
    required this.reasonForAssignment,
    required this.totalModules,
    required this.completedModules,
    required this.progressPercentage,
    required this.assignedAt,
    this.startedAt,
    this.completedAt,
    this.dueDate,
  });

  factory HealthProgramAssignment.fromJson(Map<String, dynamic> json) {
    return HealthProgramAssignment(
      id: json['_id'] ?? '',
      patientId: json['patientId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      programId: json['programId'] ?? '',
      consultationId: json['consultationId'] ?? '',
      status: HealthProgramAssignmentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => HealthProgramAssignmentStatus.assigned,
      ),
      programName: json['programName'] ?? '',
      programDescription: json['programDescription'] ?? '',
      reasonForAssignment: json['reasonForAssignment'] ?? '',
      totalModules: json['totalModules'] ?? 0,
      completedModules: json['completedModules'] ?? 0,
      progressPercentage: (json['progressPercentage'] ?? 0).toDouble(),
      assignedAt: DateTime.parse(json['assignedAt']),
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'programId': programId,
      'consultationId': consultationId,
      'status': status.toString().split('.').last,
      'programName': programName,
      'programDescription': programDescription,
      'reasonForAssignment': reasonForAssignment,
      'totalModules': totalModules,
      'completedModules': completedModules,
      'progressPercentage': progressPercentage,
      'assignedAt': assignedAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
    };
  }
}

enum HealthProgramAssignmentStatus {
  assigned,
  inProgress,
  completed,
  cancelled,
}
