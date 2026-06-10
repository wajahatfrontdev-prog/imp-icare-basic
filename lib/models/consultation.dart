class Consultation {
  final String id;
  final String patientId;
  final String doctorId;
  final String appointmentId;
  final ConsultationStatus status;
  final DateTime consultationDate;

  // Structured consultation flow
  final PatientHistory? history;
  final PhysicalExamination? examination;
  final Diagnosis? diagnosis;
  final TreatmentPlan? plan;

  // Timestamps
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  Consultation({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.appointmentId,
    required this.status,
    required this.consultationDate,
    this.history,
    this.examination,
    this.diagnosis,
    this.plan,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['_id'] ?? '',
      patientId: json['patientId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      appointmentId: json['appointmentId'] ?? '',
      status: ConsultationStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ConsultationStatus.draft,
      ),
      consultationDate: DateTime.parse(json['consultationDate']),
      history: json['history'] != null ? PatientHistory.fromJson(json['history']) : null,
      examination: json['examination'] != null ? PhysicalExamination.fromJson(json['examination']) : null,
      diagnosis: json['diagnosis'] != null ? Diagnosis.fromJson(json['diagnosis']) : null,
      plan: json['plan'] != null ? TreatmentPlan.fromJson(json['plan']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'appointmentId': appointmentId,
      'status': status.toString().split('.').last,
      'consultationDate': consultationDate.toIso8601String(),
      'history': history?.toJson(),
      'examination': examination?.toJson(),
      'diagnosis': diagnosis?.toJson(),
      'plan': plan?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

enum ConsultationStatus {
  draft,
  inProgress,
  completed,
  cancelled,
}

// Patient History
class PatientHistory {
  final String chiefComplaint;
  final String historyOfPresentIllness;
  final List<String> pastMedicalHistory;
  final List<String> medications;
  final List<String> allergies;
  final String familyHistory;
  final String socialHistory;

  PatientHistory({
    required this.chiefComplaint,
    required this.historyOfPresentIllness,
    required this.pastMedicalHistory,
    required this.medications,
    required this.allergies,
    required this.familyHistory,
    required this.socialHistory,
  });

  factory PatientHistory.fromJson(Map<String, dynamic> json) {
    return PatientHistory(
      chiefComplaint: json['chiefComplaint'] ?? '',
      historyOfPresentIllness: json['historyOfPresentIllness'] ?? '',
      pastMedicalHistory: List<String>.from(json['pastMedicalHistory'] ?? []),
      medications: List<String>.from(json['medications'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      familyHistory: json['familyHistory'] ?? '',
      socialHistory: json['socialHistory'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chiefComplaint': chiefComplaint,
      'historyOfPresentIllness': historyOfPresentIllness,
      'pastMedicalHistory': pastMedicalHistory,
      'medications': medications,
      'allergies': allergies,
      'familyHistory': familyHistory,
      'socialHistory': socialHistory,
    };
  }
}

// Physical Examination
class PhysicalExamination {
  final VitalSigns vitalSigns;
  final String generalAppearance;
  final Map<String, String> systemicExamination;
  final String notes;

  PhysicalExamination({
    required this.vitalSigns,
    required this.generalAppearance,
    required this.systemicExamination,
    required this.notes,
  });

  factory PhysicalExamination.fromJson(Map<String, dynamic> json) {
    return PhysicalExamination(
      vitalSigns: VitalSigns.fromJson(json['vitalSigns'] ?? {}),
      generalAppearance: json['generalAppearance'] ?? '',
      systemicExamination: Map<String, String>.from(json['systemicExamination'] ?? {}),
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vitalSigns': vitalSigns.toJson(),
      'generalAppearance': generalAppearance,
      'systemicExamination': systemicExamination,
      'notes': notes,
    };
  }
}

class VitalSigns {
  final double? bloodPressureSystolic;
  final double? bloodPressureDiastolic;
  final double? heartRate;
  final double? temperature;
  final double? respiratoryRate;
  final double? oxygenSaturation;
  final double? weight;
  final double? height;
  final double? bmi;

  VitalSigns({
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.heartRate,
    this.temperature,
    this.respiratoryRate,
    this.oxygenSaturation,
    this.weight,
    this.height,
    this.bmi,
  });

  factory VitalSigns.fromJson(Map<String, dynamic> json) {
    return VitalSigns(
      bloodPressureSystolic: json['bloodPressureSystolic']?.toDouble(),
      bloodPressureDiastolic: json['bloodPressureDiastolic']?.toDouble(),
      heartRate: json['heartRate']?.toDouble(),
      temperature: json['temperature']?.toDouble(),
      respiratoryRate: json['respiratoryRate']?.toDouble(),
      oxygenSaturation: json['oxygenSaturation']?.toDouble(),
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      bmi: json['bmi']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bloodPressureSystolic': bloodPressureSystolic,
      'bloodPressureDiastolic': bloodPressureDiastolic,
      'heartRate': heartRate,
      'temperature': temperature,
      'respiratoryRate': respiratoryRate,
      'oxygenSaturation': oxygenSaturation,
      'weight': weight,
      'height': height,
      'bmi': bmi,
    };
  }
}

// Diagnosis
class Diagnosis {
  final String primaryDiagnosis;
  final List<String> differentialDiagnosis;
  final String icdCode;
  final String clinicalNotes;

  Diagnosis({
    required this.primaryDiagnosis,
    required this.differentialDiagnosis,
    required this.icdCode,
    required this.clinicalNotes,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      primaryDiagnosis: json['primaryDiagnosis'] ?? '',
      differentialDiagnosis: List<String>.from(json['differentialDiagnosis'] ?? []),
      icdCode: json['icdCode'] ?? '',
      clinicalNotes: json['clinicalNotes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primaryDiagnosis': primaryDiagnosis,
      'differentialDiagnosis': differentialDiagnosis,
      'icdCode': icdCode,
      'clinicalNotes': clinicalNotes,
    };
  }
}

// Treatment Plan
class TreatmentPlan {
  final List<String> prescriptionIds;
  final List<String> labTestRequestIds;
  final List<String> healthProgramIds;
  final String? referralId;
  final String instructions;
  final String followUpInstructions;
  final DateTime? followUpDate;

  TreatmentPlan({
    required this.prescriptionIds,
    required this.labTestRequestIds,
    required this.healthProgramIds,
    this.referralId,
    required this.instructions,
    required this.followUpInstructions,
    this.followUpDate,
  });

  factory TreatmentPlan.fromJson(Map<String, dynamic> json) {
    return TreatmentPlan(
      prescriptionIds: List<String>.from(json['prescriptionIds'] ?? []),
      labTestRequestIds: List<String>.from(json['labTestRequestIds'] ?? []),
      healthProgramIds: List<String>.from(json['healthProgramIds'] ?? []),
      referralId: json['referralId'],
      instructions: json['instructions'] ?? '',
      followUpInstructions: json['followUpInstructions'] ?? '',
      followUpDate: json['followUpDate'] != null ? DateTime.parse(json['followUpDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prescriptionIds': prescriptionIds,
      'labTestRequestIds': labTestRequestIds,
      'healthProgramIds': healthProgramIds,
      'referralId': referralId,
      'instructions': instructions,
      'followUpInstructions': followUpInstructions,
      'followUpDate': followUpDate?.toIso8601String(),
    };
  }
}
