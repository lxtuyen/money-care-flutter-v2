class SimulateScenarioDto {
  final String scenarioType;
  final Map<String, dynamic> params;
  final List<int>? goalIds;

  const SimulateScenarioDto({
    required this.scenarioType,
    required this.params,
    this.goalIds,
  });

  Map<String, dynamic> toJson() => {
    'scenarioType': scenarioType,
    'params': params,
    if (goalIds != null && goalIds!.isNotEmpty) 'goalIds': goalIds,
  };
}
