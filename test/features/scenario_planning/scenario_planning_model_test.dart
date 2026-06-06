import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_care/features/scenario_planning/data/models/scenario_simulation_model.dart';
import 'package:money_care/features/scenario_planning/data/models/simulate_scenario_dto.dart';
import 'package:money_care/features/scenario_planning/presentation/widgets/scenario_result_card.dart';

void main() {
  test('SimulateScenarioDto serializes request payload', () {
    const dto = SimulateScenarioDto(
      scenarioType: 'reduce_frequency_expense',
      params: {
        'itemName': 'Trà sữa',
        'currentFrequencyPerWeek': 5,
        'newFrequencyPerWeek': 2,
        'averageAmount': 30000,
      },
      goalIds: [1],
    );

    expect(dto.toJson(), {
      'scenarioType': 'reduce_frequency_expense',
      'params': {
        'itemName': 'Trà sữa',
        'currentFrequencyPerWeek': 5,
        'newFrequencyPerWeek': 2,
        'averageAmount': 30000,
      },
      'goalIds': [1],
    });
  });

  test('ScenarioSimulationModel parses goal impacts and actions', () {
    final model = ScenarioSimulationModel.fromJson({
      'scenarioId': 'sim_test',
      'scenarioType': 'reduce_frequency_expense',
      'title': 'Giảm trà sữa',
      'summary': 'Bạn có thể tiết kiệm khoảng 391,000 VND/tháng.',
      'monthlySaving': 391000,
      'monthlyExpenseChange': -391000,
      'monthlyIncomeChange': 0,
      'expectedSavingsAfter': 3391000,
      'budgetRiskBefore': 'medium',
      'budgetRiskAfter': 'low',
      'goalImpacts': [
        {
          'goalId': 1,
          'goalName': 'Mua điện thoại',
          'currentPredictedCompletionDate': '2026-10-18',
          'newPredictedCompletionDate': '2026-10-06',
          'impactDays': -12,
          'impactText': 'Mục tiêu có thể hoàn thành sớm hơn 12 ngày.',
        },
      ],
      'recommendedActions': [
        {
          'actionType': 'reduce_frequency',
          'message': 'Giảm trà sữa theo tần suất mới.',
          'priority': 'medium',
        },
      ],
      'confidence': 0.78,
      'reasonCodes': ['frequency_reduction'],
      'supportingData': {'baselineMonthlyIncome': 12000000},
      'createdAt': '2026-06-06T10:00:00.000Z',
    });

    expect(model.monthlySaving, 391000);
    expect(model.goalImpacts.single.impactDays, -12);
    expect(model.recommendedActions.single.actionType, 'reduce_frequency');
  });

  testWidgets('ScenarioResultCard displays monthly saving and goal impact', (
    tester,
  ) async {
    const result = ScenarioSimulationModel(
      scenarioId: 'sim_test',
      scenarioType: 'reduce_frequency_expense',
      title: 'Giảm trà sữa',
      summary: 'Bạn có thể tiết kiệm khoảng 391,000 VND/tháng.',
      monthlySaving: 391000,
      monthlyExpenseChange: -391000,
      monthlyIncomeChange: 0,
      expectedSavingsAfter: 3391000,
      budgetRiskBefore: 'medium',
      budgetRiskAfter: 'low',
      goalImpacts: [
        ScenarioGoalImpactModel(
          goalId: 1,
          goalName: 'Mua điện thoại',
          currentPredictedCompletionDate: '2026-10-18',
          newPredictedCompletionDate: '2026-10-06',
          impactDays: -12,
          impactText: 'Mục tiêu có thể hoàn thành sớm hơn 12 ngày.',
        ),
      ],
      recommendedActions: [
        ScenarioRecommendedActionModel(
          actionType: 'reduce_frequency',
          categoryName: null,
          amount: 391000,
          message: 'Giảm trà sữa theo tần suất mới.',
          priority: 'medium',
        ),
      ],
      confidence: 0.78,
      reasonCodes: ['frequency_reduction'],
      supportingData: {},
      createdAt: '2026-06-06T10:00:00.000Z',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ScenarioResultCard(result: result)),
      ),
    );

    expect(find.text('Giảm trà sữa'), findsOneWidget);
    expect(find.text('Mua điện thoại'), findsOneWidget);
    expect(
      find.text('Mục tiêu có thể hoàn thành sớm hơn 12 ngày.'),
      findsOneWidget,
    );
  });
}
