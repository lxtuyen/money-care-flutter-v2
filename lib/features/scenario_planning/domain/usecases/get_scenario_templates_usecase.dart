import 'package:money_care/features/scenario_planning/data/models/scenario_template_model.dart';
import 'package:money_care/features/scenario_planning/domain/repositories/scenario_planning_repository.dart';

class GetScenarioTemplatesUseCase {
  final ScenarioPlanningRepository repository;

  const GetScenarioTemplatesUseCase(this.repository);

  Future<List<ScenarioTemplateModel>> call() {
    return repository.getTemplates();
  }
}
