import 'package:get/get.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/scenario_planning/data/models/scenario_simulation_model.dart';
import 'package:money_care/features/scenario_planning/data/models/scenario_template_model.dart';
import 'package:money_care/features/scenario_planning/data/models/simulate_scenario_dto.dart';
import 'package:money_care/features/scenario_planning/domain/usecases/usecases.dart';

class ScenarioPlanningController extends GetxController {
  final GetScenarioTemplatesUseCase getScenarioTemplatesUseCase;
  final SimulateScenarioUseCase simulateScenarioUseCase;

  ScenarioPlanningController({
    required this.getScenarioTemplatesUseCase,
    required this.simulateScenarioUseCase,
  });

  final templates = <ScenarioTemplateModel>[].obs;
  final selectedTemplate = Rxn<ScenarioTemplateModel>();
  final simulationResult = Rxn<ScenarioSimulationModel>();
  final isLoadingTemplates = false.obs;
  final isSimulating = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    isLoadingTemplates.value = true;
    errorMessage.value = '';
    try {
      final items = await getScenarioTemplatesUseCase();
      templates.assignAll(items);
      selectedTemplate.value ??= items.isNotEmpty ? items.first : null;
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoadingTemplates.value = false;
    }
  }

  void selectTemplate(ScenarioTemplateModel template) {
    selectedTemplate.value = template;
    simulationResult.value = null;
    errorMessage.value = '';
  }

  Future<void> simulate({
    required String scenarioType,
    required Map<String, dynamic> params,
    List<int>? goalIds,
  }) async {
    isSimulating.value = true;
    errorMessage.value = '';
    try {
      final result = await simulateScenarioUseCase(
        SimulateScenarioDto(
          scenarioType: scenarioType,
          params: params,
          goalIds: goalIds,
        ),
      );
      simulationResult.value = result;
    } catch (error) {
      errorMessage.value = error.toString();
      AppHelperFunction.showErrorSnackBar(
        'Không thể mô phỏng kịch bản: $error',
      );
    } finally {
      isSimulating.value = false;
    }
  }
}
