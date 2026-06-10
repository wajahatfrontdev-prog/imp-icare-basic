class HealthProgram {
  final String id;
  final String name;
  final String description;
  final HealthProgramCategory category;
  final String targetCondition;
  final int durationWeeks;
  final List<ProgramModule> modules;
  final String instructorId;
  final bool isActive;
  final DateTime createdAt;

  HealthProgram({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.targetCondition,
    required this.durationWeeks,
    required this.modules,
    required this.instructorId,
    required this.isActive,
    required this.createdAt,
  });

  factory HealthProgram.fromJson(Map<String, dynamic> json) {
    return HealthProgram(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: HealthProgramCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => HealthProgramCategory.general,
      ),
      targetCondition: json['targetCondition'] ?? '',
      durationWeeks: json['durationWeeks'] ?? 0,
      modules: (json['modules'] as List?)
          ?.map((m) => ProgramModule.fromJson(m))
          .toList() ?? [],
      instructorId: json['instructorId'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'category': category.toString().split('.').last,
      'targetCondition': targetCondition,
      'durationWeeks': durationWeeks,
      'modules': modules.map((m) => m.toJson()).toList(),
      'instructorId': instructorId,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum HealthProgramCategory {
  chronicDisease,
  preventiveCare,
  postSurgery,
  mentalHealth,
  nutrition,
  fitness,
  prenatal,
  general,
}

class ProgramModule {
  final String id;
  final String title;
  final String content;
  final int orderIndex;
  final int estimatedMinutes;
  final List<String> resources;

  ProgramModule({
    required this.id,
    required this.title,
    required this.content,
    required this.orderIndex,
    required this.estimatedMinutes,
    required this.resources,
  });

  factory ProgramModule.fromJson(Map<String, dynamic> json) {
    return ProgramModule(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      orderIndex: json['orderIndex'] ?? 0,
      estimatedMinutes: json['estimatedMinutes'] ?? 0,
      resources: List<String>.from(json['resources'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'content': content,
      'orderIndex': orderIndex,
      'estimatedMinutes': estimatedMinutes,
      'resources': resources,
    };
  }
}
