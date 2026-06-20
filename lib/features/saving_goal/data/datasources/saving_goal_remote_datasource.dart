import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/saving_goal/data/models/models.dart';

abstract class SavingGoalRemoteDatasource {
  Future<SavingGoalModel> createSavingGoal(SavingGoalDto dto);
  Future<List<SavingGoalModel>> getSavingGoalsByUser(int userId);
  Future<SavingGoalModel> getSavingGoal(int id);
  Future<SavingGoalModel> updateSavingGoal(SavingGoalDto dto);
  Future<bool> deleteSavingGoal(int id);
  Future<SavingGoalModel?> selectSavingGoal(int userId, int id);
  Future<ExpiredGoalCheckModel> checkExpiredSavingGoal(int userId);
  Future<bool> markAsNotified(int id);
  Future<SavingGoalModel> extendSavingGoal(
    int id,
    DateTime newEndDate, {
    DateTime? newStartDate,
  });
  Future<SavingGoalReportModel> getSavingGoalReport(int id);
  Future<GoalAchievementPredictionModel> getGoalPrediction(int id);
  Future<GoalAchievementPredictionSummaryModel> getGoalPredictions();
  Future<BudgetSuggestionModel> getBudgetSuggestion({
    double? target,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<SavingGoalModel> activateGoal(int goalId);
  Future<SavingGoalModel> pauseGoal(int goalId);
}

class SavingGoalRemoteDatasourceImpl implements SavingGoalRemoteDatasource {
  final ApiClient api;

  SavingGoalRemoteDatasourceImpl({required this.api});

  @override
  Future<SavingGoalModel> createSavingGoal(SavingGoalDto dto) async {
    final res = await api.post<SavingGoalModel>(
      ApiRoutes.savingGoal,
      body: dto.toJsonCreate(),
      fromJsonT: (json) => SavingGoalModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<List<SavingGoalModel>> getSavingGoalsByUser(int userId) async {
    final res = await api.get<List<SavingGoalModel>>(
      '${ApiRoutes.getSavingGoals}/$userId',
      fromJsonT: (json) {
        final list = json as List;
        return list.map((e) => SavingGoalModel.fromJson(e)).toList();
      },
    );
    return res.unwrap();
  }

  @override
  Future<SavingGoalModel> getSavingGoal(int id) async {
    final res = await api.get<SavingGoalModel>(
      '${ApiRoutes.savingGoal}/$id',
      fromJsonT: (json) => SavingGoalModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<SavingGoalModel> updateSavingGoal(SavingGoalDto dto) async {
    final res = await api.patch<SavingGoalModel>(
      '${ApiRoutes.savingGoal}/${dto.id}',
      body: dto.toJsonUpdate(),
      fromJsonT: (json) => SavingGoalModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<bool> deleteSavingGoal(int id) async {
    final res = await api.delete<void>('${ApiRoutes.savingGoal}/$id');
    res.unwrap();
    return true;
  }

  @override
  Future<SavingGoalModel?> selectSavingGoal(int userId, int id) async {
    final res = await api.patch<SavingGoalModel?>(
      '${ApiRoutes.selectSavingGoal}/$id',
      body: {'userId': userId},
      fromJsonT: (json) => json == null ? null : SavingGoalModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<ExpiredGoalCheckModel> checkExpiredSavingGoal(int userId) async {
    final res = await api.get<ExpiredGoalCheckModel>(
      '${ApiRoutes.checkExpiredSavingGoal}/$userId',
      fromJsonT: (json) => ExpiredGoalCheckModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<bool> markAsNotified(int id) async {
    final res = await api.patch<void>(
      '${ApiRoutes.savingGoal}/$id/mark-notified',
    );
    res.unwrap();
    return true;
  }

  String _formatDateOnly(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  Future<SavingGoalModel> extendSavingGoal(
    int id,
    DateTime newEndDate, {
    DateTime? newStartDate,
  }) async {
    final body = <String, dynamic>{
      'new_end_date': _formatDateOnly(newEndDate),
      if (newStartDate != null)
        'new_start_date': _formatDateOnly(newStartDate),
    };
    final res = await api.patch<SavingGoalModel>(
      '${ApiRoutes.savingGoal}/$id/extend',
      body: body,
      fromJsonT: (json) => SavingGoalModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<SavingGoalReportModel> getSavingGoalReport(int id) async {
    final res = await api.get<SavingGoalReportModel>(
      '${ApiRoutes.savingGoal}/$id/report',
      fromJsonT: (json) => SavingGoalReportModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<GoalAchievementPredictionModel> getGoalPrediction(int id) async {
    final res = await api.get<GoalAchievementPredictionModel>(
      '${ApiRoutes.savingGoal}/$id/prediction',
      fromJsonT: (json) => GoalAchievementPredictionModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<GoalAchievementPredictionSummaryModel> getGoalPredictions() async {
    final res = await api.get<GoalAchievementPredictionSummaryModel>(
      ApiRoutes.savingGoalPredictions,
      fromJsonT: (json) => GoalAchievementPredictionSummaryModel.fromJson(
        json as Map<String, dynamic>,
      ),
    );
    return res.unwrap();
  }

  @override
  Future<BudgetSuggestionModel> getBudgetSuggestion({
    double? target,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, String>{};
    if (target != null) {
      queryParams['target'] = target.toString();
    }
    if (startDate != null) {
      queryParams['startDate'] = _formatDateOnly(startDate);
    }
    if (endDate != null) {
      queryParams['endDate'] = _formatDateOnly(endDate);
    }

    final res = await api.get<BudgetSuggestionModel>(
      ApiRoutes.savingGoalBudgetSuggestion,
      queryParameters: queryParams,
      fromJsonT: (json) => BudgetSuggestionModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<SavingGoalModel> activateGoal(int goalId) async {
    final res = await api.patch<SavingGoalModel>(
      ApiRoutes.activateSavingGoal(goalId),
      fromJsonT: (json) => SavingGoalModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<SavingGoalModel> pauseGoal(int goalId) async {
    final res = await api.patch<SavingGoalModel>(
      ApiRoutes.pauseSavingGoal(goalId),
      fromJsonT: (json) => SavingGoalModel.fromJson(json),
    );
    return res.unwrap();
  }
}
