import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/couple/domain/entities/couple_entity.dart';
import 'package:money_care/features/couple/domain/entities/couple_saving_goal_entity.dart';
import 'package:money_care/features/couple/domain/entities/couple_settlement_entity.dart';
import 'package:money_care/features/couple/domain/entities/couple_report_entity.dart';
import 'package:money_care/features/couple/domain/repositories/couple_repository.dart';

class GetCoupleInfoUseCase {
  final CoupleRepository repository;
  GetCoupleInfoUseCase(this.repository);
  Future<Either<Failure, CoupleEntity?>> call() => repository.getCouple();
}

class CreateCoupleUseCase {
  final CoupleRepository repository;
  CreateCoupleUseCase(this.repository);
  Future<Either<Failure, CoupleEntity>> call() => repository.createCouple();
}

class JoinCoupleUseCase {
  final CoupleRepository repository;
  JoinCoupleUseCase(this.repository);
  Future<Either<Failure, CoupleEntity>> call(String inviteCode) =>
      repository.joinCouple(inviteCode);
}

class CancelCoupleInviteUseCase {
  final CoupleRepository repository;
  CancelCoupleInviteUseCase(this.repository);
  Future<Either<Failure, void>> call() => repository.cancelInvite();
}

class LeaveCoupleUseCase {
  final CoupleRepository repository;
  LeaveCoupleUseCase(this.repository);
  Future<Either<Failure, void>> call() => repository.leaveCouple();
}

class UpdateCoupleSettingsUseCase {
  final CoupleRepository repository;
  UpdateCoupleSettingsUseCase(this.repository);
  Future<Either<Failure, CoupleEntity>> call({
    bool? sharePersonalTransactions,
    bool? allowAiShare,
  }) => repository.updateSettings(
    sharePersonalTransactions: sharePersonalTransactions,
    allowAiShare: allowAiShare,
  );
}



class GetCoupleSavingGoalsUseCase {
  final CoupleRepository repository;
  GetCoupleSavingGoalsUseCase(this.repository);
  Future<Either<Failure, List<CoupleSavingGoalEntity>>> call(int coupleId) =>
      repository.getSavingGoals(coupleId);
}

class CreateCoupleSavingGoalUseCase {
  final CoupleRepository repository;
  CreateCoupleSavingGoalUseCase(this.repository);
  Future<Either<Failure, CoupleSavingGoalEntity>> call({
    required int coupleId,
    required String name,
    required double target,
    DateTime? endDate,
  }) => repository.createSavingGoal(
    coupleId: coupleId,
    name: name,
    target: target,
    endDate: endDate,
  );
}

class ContributeToCoupleSavingGoalUseCase {
  final CoupleRepository repository;
  ContributeToCoupleSavingGoalUseCase(this.repository);
  Future<Either<Failure, void>> call({
    required int goalId,
    required double amount,
    int? sourceWalletId,
  }) => repository.contributeToSavingGoal(
        goalId: goalId,
        amount: amount,
        sourceWalletId: sourceWalletId,
      );
}

class DeleteCoupleSavingGoalUseCase {
  final CoupleRepository repository;
  DeleteCoupleSavingGoalUseCase(this.repository);
  Future<Either<Failure, void>> call(int id) => repository.deleteSavingGoal(id);
}

class UpdateCoupleSavingGoalUseCase {
  final CoupleRepository repository;
  UpdateCoupleSavingGoalUseCase(this.repository);
  Future<Either<Failure, CoupleSavingGoalEntity>> call({
    required int id,
    String? name,
    double? target,
    DateTime? endDate,
  }) =>
      repository.updateSavingGoal(
        id: id,
        name: name,
        target: target,
        endDate: endDate,
      );
}

class GetCoupleSettlementSummaryUseCase {
  final CoupleRepository repository;
  GetCoupleSettlementSummaryUseCase(this.repository);
  Future<Either<Failure, CoupleSettlementSummaryEntity>> call(int coupleId) =>
      repository.getSettlementSummary(coupleId);
}

class SettleUpCoupleUseCase {
  final CoupleRepository repository;
  SettleUpCoupleUseCase(this.repository);
  Future<Either<Failure, void>> call(int coupleId) =>
      repository.settleUp(coupleId);
}

class SettleUpSingleCoupleUseCase {
  final CoupleRepository repository;
  SettleUpSingleCoupleUseCase(this.repository);
  Future<Either<Failure, void>> call({
    required int coupleId,
    required int transactionId,
  }) => repository.settleUpSingle(
        coupleId: coupleId,
        transactionId: transactionId,
      );
}

class GetCoupleReportUseCase {
  final CoupleRepository repository;
  GetCoupleReportUseCase(this.repository);
  Future<Either<Failure, CoupleReportEntity>> call(
    int coupleId,
    String month,
  ) => repository.getReport(coupleId, month);
}

class MarkCoupleAlertReadUseCase {
  final CoupleRepository repository;
  MarkCoupleAlertReadUseCase(this.repository);
  Future<Either<Failure, CoupleSpendingAlertEntity>> call(int alertId) =>
      repository.markAlertRead(alertId);
}

class UpdateCoupleAlertUseCase {
  final CoupleRepository repository;
  UpdateCoupleAlertUseCase(this.repository);
  Future<Either<Failure, CoupleSpendingAlertEntity>> call({
    required int alertId,
    String? status,
    String? feedback,
  }) => repository.updateAlert(
    alertId: alertId,
    status: status,
    feedback: feedback,
  );
}
