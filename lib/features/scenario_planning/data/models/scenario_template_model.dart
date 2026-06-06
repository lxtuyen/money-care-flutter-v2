class ScenarioTemplateFieldModel {
  final String name;
  final String type;
  final String label;
  final bool required;

  const ScenarioTemplateFieldModel({
    required this.name,
    required this.type,
    required this.label,
    required this.required,
  });

  factory ScenarioTemplateFieldModel.fromJson(Map<String, dynamic> json) {
    return ScenarioTemplateFieldModel(
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'text',
      label: json['label']?.toString() ?? '',
      required: json['required'] == true,
    );
  }
}

class ScenarioTemplateModel {
  final String scenarioType;
  final String title;
  final String description;
  final List<ScenarioTemplateFieldModel> fields;

  const ScenarioTemplateModel({
    required this.scenarioType,
    required this.title,
    required this.description,
    required this.fields,
  });

  factory ScenarioTemplateModel.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return ScenarioTemplateModel(
      scenarioType: json['scenarioType']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      fields: rawFields is List
          ? rawFields
                .whereType<Map<String, dynamic>>()
                .map(ScenarioTemplateFieldModel.fromJson)
                .toList()
          : const [],
    );
  }
}
