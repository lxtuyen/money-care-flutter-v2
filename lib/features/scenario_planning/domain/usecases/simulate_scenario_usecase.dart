import 'package:money_care/features/scenario_planning/data/models/scenario_simulation_model.dart';
import 'package:money_care/features/scenario_planning/data/models/simulate_scenario_dto.dart';
import 'package:money_care/features/scenario_planning/domain/repositories/scenario_planning_repository.dart';

class SimulateScenarioUseCase {
  final ScenarioPlanningRepository repository;

  const SimulateScenarioUseCase(this.repository);

  Future<ScenarioSimulationModel> call(SimulateScenarioDto dto) {
    return repository.simulate(dto);
  }
}
