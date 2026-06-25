import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/habit_commitments/domain/entities/habit_commitment_entity.dart';
import 'package:money_care/features/habit_commitments/domain/repositories/habit_commitment_repository.dart';

class HabitCommitmentRepositoryImpl implements HabitCommitmentRepository {
  final ApiClient api;

  HabitCommitmentRepositoryImpl({required this.api});

  @override
  Future<HabitCommitmentEntity> create({
    required String habitName,
    required String subcategoryName,
    required int committedCount,
    required int month,
    required int year,
    double potentialSavings = 0.0,
    double avgPerTransaction = 0.0,
    int projectedCount = 0,
    int? goalId,
  }) async {
    final res = await api.post<HabitCommitmentEntity>(
      ApiRoutes.habitCommitments,
      body: {
        'habitName': habitName,
        'subcategoryName': subcategoryName,
        'committedCount': committedCount,
        'potentialSavings': potentialSavings,
        'avgPerTransaction': avgPerTransaction,
        'projectedCount': projectedCount,
        'month': month,
        'year': year,
        if (goalId != null) 'goalId': goalId,
      },
      fromJsonT: (json) =>
          HabitCommitmentEntity.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }

  @override
  Future<List<HabitCommitmentEntity>> getProgress({
    required int month,
    required int year,
  }) async {
    final res = await api.get<List<HabitCommitmentEntity>>(
      '${ApiRoutes.habitCommitmentsProgress}?month=$month&year=$year',
      fromJsonT: (json) {
        final list = json as List<dynamic>;
        return list
            .map((e) =>
                HabitCommitmentEntity.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
    return res.unwrap();
  }

  @override
  Future<void> update(int id, {required int committedCount}) async {
    await api.patch(
      ApiRoutes.habitCommitmentUpdate(id),
      body: {'committedCount': committedCount},
    );
  }

  @override
  Future<void> delete(int id) async {
    await api.delete(ApiRoutes.habitCommitmentDelete(id));
  }
}
