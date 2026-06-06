import 'package:money_care/features/scenario_planning/data/datasources/scenario_planning_remote_datasource.dart';
import 'package:money_care/features/scenario_planning/data/models/scenario_simulation_model.dart';
import 'package:money_care/features/scenario_planning/data/models/scenario_template_model.dart';
import 'package:money_care/features/scenario_planning/data/models/simulate_scenario_dto.dart';
import 'package:money_care/features/scenario_planning/domain/repositories/scenario_planning_repository.dart';

class ScenarioPlanningRepositoryImpl implements ScenarioPlanningRepository {
  final ScenarioPlanningRemoteDatasource remoteDatasource;

  const ScenarioPlanningRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<ScenarioTemplateModel>> getTemplates() {
    return remoteDatasource.getTemplates();
  }

  @override
  Future<ScenarioSimulationModel> simulate(SimulateScenarioDto dto) {
    return remoteDatasource.simulate(dto);
  }
}
