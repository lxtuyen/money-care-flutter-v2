import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/scenario_planning/data/models/scenario_simulation_model.dart';
import 'package:money_care/features/scenario_planning/data/models/scenario_template_model.dart';
import 'package:money_care/features/scenario_planning/data/models/simulate_scenario_dto.dart';

abstract class ScenarioPlanningRemoteDatasource {
  Future<List<ScenarioTemplateModel>> getTemplates();
  Future<ScenarioSimulationModel> simulate(SimulateScenarioDto dto);
}

class ScenarioPlanningRemoteDatasourceImpl
    implements ScenarioPlanningRemoteDatasource {
  final ApiClient api;

  const ScenarioPlanningRemoteDatasourceImpl({required this.api});

  @override
  Future<List<ScenarioTemplateModel>> getTemplates() async {
    final res = await api.get<List<ScenarioTemplateModel>>(
      ApiRoutes.scenarioPlanningTemplates,
      fromJsonT: (json) {
        final items = json is Map<String, dynamic> ? json['items'] : null;
        if (items is! List) return const <ScenarioTemplateModel>[];
        return items
            .whereType<Map<String, dynamic>>()
            .map(ScenarioTemplateModel.fromJson)
            .toList();
      },
    );
    return res.unwrap();
  }

  @override
  Future<ScenarioSimulationModel> simulate(SimulateScenarioDto dto) async {
    final res = await api.post<ScenarioSimulationModel>(
      ApiRoutes.scenarioPlanningSimulate,
      body: dto.toJson(),
      fromJsonT: (json) =>
          ScenarioSimulationModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }
}
