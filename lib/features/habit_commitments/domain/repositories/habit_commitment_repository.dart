import 'package:money_care/features/habit_commitments/domain/entities/habit_commitment_entity.dart';

abstract class HabitCommitmentRepository {
  /// Tạo cam kết giảm thói quen
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
  });

  /// Lấy danh sách tiến độ cam kết theo tháng
  Future<List<HabitCommitmentEntity>> getProgress({
    required int month,
    required int year,
  });

  /// Cập nhật số lần cam kết
  Future<void> update(int id, {required int committedCount});

  /// Xóa cam kết
  Future<void> delete(int id);
}
