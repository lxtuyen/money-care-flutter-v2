import 'package:money_care/features/scenario_planning/data/models/scenario_simulation_model.dart';
import 'package:money_care/features/scenario_planning/data/models/scenario_template_model.dart';
import 'package:money_care/features/scenario_planning/data/models/simulate_scenario_dto.dart';

abstract class ScenarioPlanningRepository {
  Future<List<ScenarioTemplateModel>> getTemplates();
  Future<ScenarioSimulationModel> simulate(SimulateScenarioDto dto);
}
