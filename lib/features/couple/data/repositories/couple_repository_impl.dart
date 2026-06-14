import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/couple/data/datasources/couple_remote_datasource.dart';
import 'package:money_care/features/couple/domain/entities/couple_entity.dart';
import 'package:money_care/features/couple/domain/entities/couple_saving_goal_entity.dart';
import 'package:money_care/features/couple/domain/entities/couple_settlement_entity.dart';
import 'package:money_care/features/couple/domain/entities/couple_report_entity.dart';
import 'package:money_care/features/couple/domain/entities/couple_message_entity.dart';
import 'package:money_care/features/couple/domain/repositories/couple_repository.dart';

class CoupleRepositoryImpl implements CoupleRepository {
  final CoupleRemoteDatasource remoteDatasource;

  CoupleRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, CoupleEntity?>> getCouple() async {
    try {
      final model = await remoteDatasource.getCouple();
      return Right(model?.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CoupleEntity>> createCouple() async {
    try {
      final model = await remoteDatasource.createCouple();
      return Right(model.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CoupleEntity>> joinCouple(String inviteCode) async {
    try {
      final model = await remoteDatasource.joinCouple(inviteCode);
      return Right(model.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelInvite() async {
    try {
      await remoteDatasource.cancelInvite();
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveCouple() async {
    try {
      await remoteDatasource.leaveCouple();
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CoupleEntity>> updateSettings({
    bool? sharePersonalTransactions,
    bool? allowAiShare,
  }) async {
    try {
      final model = await remoteDatasource.updateSettings(
        sharePersonalTransactions: sharePersonalTransactions,
        allowAiShare: allowAiShare,
      );
      return Right(model.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }



  @override
  Future<Either<Failure, List<CoupleSavingGoalEntity>>> getSavingGoals(
    int coupleId,
  ) async {
    try {
      final list = await remoteDatasource.getSavingGoals(coupleId);
      return Right(list);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CoupleSavingGoalEntity>> createSavingGoal({
    required int coupleId,
    required String name,
    required double target,
    DateTime? endDate,
  }) async {
    try {
      final goal = await remoteDatasource.createSavingGoal(
        coupleId: coupleId,
        name: name,
        target: target,
        endDate: endDate,
      );
      return Right(goal);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> contributeToSavingGoal({
    required int goalId,
    required double amount,
    int? sourceWalletId,
  }) async {
    try {
      await remoteDatasource.contributeToSavingGoal(
        goalId: goalId,
        amount: amount,
        sourceWalletId: sourceWalletId,
      );
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSavingGoal(int id) async {
    try {
      await remoteDatasource.deleteSavingGoal(id);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CoupleSavingGoalEntity>> updateSavingGoal({
    required int id,
    String? name,
    double? target,
    DateTime? endDate,
    String? status,
    bool? completionNotified,
  }) async {
    try {
      final goal = await remoteDatasource.updateSavingGoal(
        id: id,
        name: name,
        target: target,
        endDate: endDate,
        status: status,
        completionNotified: completionNotified,
      );
      return Right(goal);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CoupleSettlementSummaryEntity>> getSettlementSummary(
    int coupleId,
  ) async {
    try {
      final summary = await remoteDatasource.getSettlementSummary(coupleId);
      return Right(summary);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> settleUp(int coupleId) async {
    try {
      await remoteDatasource.settleUp(coupleId);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> settleUpSingle({
    required int coupleId,
    required int transactionId,
  }) async {
    try {
      await remoteDatasource.settleUpSingle(
        coupleId: coupleId,
        transactionId: transactionId,
      );
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CoupleReportEntity>> getReport(
    int coupleId,
    String month,
  ) async {
    try {
      final report = await remoteDatasource.getReport(coupleId, month);
      return Right(report);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CoupleSpendingAlertEntity>> markAlertRead(
    int alertId,
  ) async {
    try {
      final alert = await remoteDatasource.markAlertRead(alertId);
      return Right(alert);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CoupleSpendingAlertEntity>> updateAlert({
    required int alertId,
    String? status,
    String? feedback,
  }) async {
    try {
      final alert = await remoteDatasource.updateAlert(
        alertId: alertId,
        status: status,
        feedback: feedback,
      );
      return Right(alert);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CoupleMessageEntity>>> getChatHistory(
    int coupleId,
  ) async {
    try {
      final list = await remoteDatasource.getChatHistory(coupleId);
      return Right(list);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
