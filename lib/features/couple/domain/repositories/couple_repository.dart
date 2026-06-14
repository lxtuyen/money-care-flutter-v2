import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/couple/domain/entities/couple_entity.dart';
import 'package:money_care/features/couple/domain/entities/couple_saving_goal_entity.dart';
import 'package:money_care/features/couple/domain/entities/couple_settlement_entity.dart';
import 'package:money_care/features/couple/domain/entities/couple_report_entity.dart';
import 'package:money_care/features/couple/domain/entities/couple_message_entity.dart';

abstract class CoupleRepository {
  Future<Either<Failure, CoupleEntity?>> getCouple();
  Future<Either<Failure, CoupleEntity>> createCouple();
  Future<Either<Failure, CoupleEntity>> joinCouple(String inviteCode);
  Future<Either<Failure, void>> cancelInvite();
  Future<Either<Failure, void>> leaveCouple();
  Future<Either<Failure, CoupleEntity>> updateSettings({
    bool? sharePersonalTransactions,
    bool? allowAiShare,
  });

  Future<Either<Failure, List<CoupleSavingGoalEntity>>> getSavingGoals(
    int coupleId,
  );
  Future<Either<Failure, CoupleSavingGoalEntity>> createSavingGoal({
    required int coupleId,
    required String name,
    required double target,
    DateTime? endDate,
  });
  Future<Either<Failure, void>> contributeToSavingGoal({
    required int goalId,
    required double amount,
    int? sourceWalletId,
  });
  Future<Either<Failure, void>> deleteSavingGoal(int id);
  Future<Either<Failure, CoupleSavingGoalEntity>> updateSavingGoal({
    required int id,
    String? name,
    double? target,
    DateTime? endDate,
    String? status,
    bool? completionNotified,
  });
  Future<Either<Failure, CoupleSettlementSummaryEntity>> getSettlementSummary(
    int coupleId,
  );
  Future<Either<Failure, void>> settleUp(int coupleId);
  Future<Either<Failure, void>> settleUpSingle({
    required int coupleId,
    required int transactionId,
  });
  Future<Either<Failure, CoupleReportEntity>> getReport(
    int coupleId,
    String month,
  );
  Future<Either<Failure, CoupleSpendingAlertEntity>> markAlertRead(int alertId);
  Future<Either<Failure, CoupleSpendingAlertEntity>> updateAlert({
    required int alertId,
    String? status,
    String? feedback,
  });
  Future<Either<Failure, List<CoupleMessageEntity>>> getChatHistory(int coupleId);
}
