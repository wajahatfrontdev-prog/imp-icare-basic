class Vital {
  final String? id;
  final String type;
  final String value;
  final String unit;
  final String status;
  final DateTime? createdAt;
  final String? note;

  Vital({
    this.id,
    required this.type,
    required this.value,
    required this.unit,
    required this.status,
    this.createdAt,
    this.note,
  });

  factory Vital.fromJson(Map<String, dynamic> json) {
    return Vital(
      id: json['_id'],
      type: json['type'],
      value: json['value'],
      unit: json['unit'],
      status: json['status'] ?? 'Normal',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'unit': unit,
      'status': status,
      'note': note,
    };
  }
}
