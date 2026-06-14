import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/couple/data/models/couple_model.dart';
import 'package:money_care/features/couple/domain/entities/couple_saving_goal_entity.dart';
import 'package:money_care/features/couple/domain/entities/couple_settlement_entity.dart';
import 'package:money_care/features/couple/domain/entities/couple_report_entity.dart';

abstract class CoupleRemoteDatasource {
  Future<CoupleModel?> getCouple();
  Future<CoupleModel> createCouple();
  Future<CoupleModel> joinCouple(String inviteCode);
  Future<void> cancelInvite();
  Future<void> leaveCouple();
  Future<CoupleModel> updateSettings({
    bool? sharePersonalTransactions,
    bool? allowAiShare,
  });

  Future<List<CoupleSavingGoalEntity>> getSavingGoals(int coupleId);
  Future<CoupleSavingGoalEntity> createSavingGoal({
    required int coupleId,
    required String name,
    required double target,
    DateTime? endDate,
  });
  Future<void> contributeToSavingGoal({
    required int goalId,
    required double amount,
    int? sourceWalletId,
  });
  Future<void> deleteSavingGoal(int id);
  Future<CoupleSavingGoalEntity> updateSavingGoal({
    required int id,
    String? name,
    double? target,
    DateTime? endDate,
    String? status,
    bool? completionNotified,
  });
  Future<CoupleSettlementSummaryEntity> getSettlementSummary(int coupleId);
  Future<void> settleUp(int coupleId);
  Future<void> settleUpSingle({
    required int coupleId,
    required int transactionId,
  });
  Future<CoupleReportEntity> getReport(int coupleId, String month);
  Future<CoupleSpendingAlertEntity> markAlertRead(int alertId);
  Future<CoupleSpendingAlertEntity> updateAlert({
    required int alertId,
    String? status,
    String? feedback,
  });
}

class CoupleRemoteDatasourceImpl implements CoupleRemoteDatasource {
  final ApiClient api;

  CoupleRemoteDatasourceImpl({required this.api});

  @override
  Future<CoupleModel?> getCouple() async {
    final res = await api.get<CoupleModel?>(
      '${ApiRoutes.couples}/me',
      fromJsonT: (json) {
        if (json == null) return null;
        return CoupleModel.fromJson(json);
      },
    );
    return res.unwrap();
  }

  @override
  Future<CoupleModel> createCouple() async {
    final res = await api.post<CoupleModel>(
      ApiRoutes.couples,
      fromJsonT: (json) => CoupleModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<CoupleModel> joinCouple(String inviteCode) async {
    final res = await api.post<CoupleModel>(
      '${ApiRoutes.couples}/join',
      body: {'inviteCode': inviteCode},
      fromJsonT: (json) => CoupleModel.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<void> cancelInvite() async {
    final res = await api.post<void>('${ApiRoutes.couples}/cancel');
    if (!res.success) {
      throw Exception(
        res.message.isNotEmpty ? res.message : 'Hủy lời mời thất bại',
      );
    }
  }

  @override
  Future<void> leaveCouple() async {
    final res = await api.post<void>('${ApiRoutes.couples}/leave');
    if (!res.success) {
      throw Exception(
        res.message.isNotEmpty ? res.message : 'Rời nhóm thất bại',
      );
    }
  }

  @override
  Future<CoupleModel> updateSettings({
    bool? sharePersonalTransactions,
    bool? allowAiShare,
  }) async {
    final Map<String, dynamic> body = {};
    if (sharePersonalTransactions != null) {
      body['sharePersonalTransactions'] = sharePersonalTransactions;
    }
    if (allowAiShare != null) {
      body['allowAiShare'] = allowAiShare;
    }

    final res = await api.patch<CoupleModel>(
      '${ApiRoutes.couples}/settings',
      body: body,
      fromJsonT: (json) => CoupleModel.fromJson(json),
    );
    return res.unwrap();
  }


  @override
  Future<List<CoupleSavingGoalEntity>> getSavingGoals(int coupleId) async {
    final res = await api.get<List<CoupleSavingGoalEntity>>(
      '${ApiRoutes.couples}/savings?coupleId=$coupleId',
      fromJsonT: (json) {
        final list = json as List<dynamic>;
        return list.map((e) => CoupleSavingGoalEntity.fromJson(e)).toList();
      },
    );
    return res.unwrap();
  }

  @override
  Future<CoupleSavingGoalEntity> createSavingGoal({
    required int coupleId,
    required String name,
    required double target,
    DateTime? endDate,
  }) async {
    final res = await api.post<CoupleSavingGoalEntity>(
      '${ApiRoutes.couples}/savings',
      body: {
        'coupleId': coupleId,
        'name': name,
        'target': target,
        'end_date': ?endDate?.toIso8601String(),
      },
      fromJsonT: (json) => CoupleSavingGoalEntity.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<void> contributeToSavingGoal({
    required int goalId,
    required double amount,
    int? sourceWalletId,
  }) async {
    final res = await api.post<void>(
      '${ApiRoutes.couples}/savings/$goalId/contribute',
      body: {
        'amount': amount,
        'sourceWalletId': ?sourceWalletId,
      },
    );
    if (!res.success) {
      throw Exception(
        res.message.isNotEmpty ? res.message : 'Đóng góp thất bại',
      );
    }
  }

  @override
  Future<void> deleteSavingGoal(int id) async {
    final res = await api.delete<void>('${ApiRoutes.couples}/savings/$id');
    res.unwrap();
  }

  @override
  Future<CoupleSavingGoalEntity> updateSavingGoal({
    required int id,
    String? name,
    double? target,
    DateTime? endDate,
    String? status,
    bool? completionNotified,
  }) async {
    final res = await api.patch<CoupleSavingGoalEntity>(
      '${ApiRoutes.couples}/savings/$id',
      body: {
        'name': ?name,
        'target': ?target,
        'end_date': ?endDate?.toIso8601String(),
        'status': ?status,
        'completion_notified': ?completionNotified,
      },
      fromJsonT: (json) => CoupleSavingGoalEntity.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<CoupleSettlementSummaryEntity> getSettlementSummary(
    int coupleId,
  ) async {
    final res = await api.get<CoupleSettlementSummaryEntity>(
      '${ApiRoutes.couples}/settlement/summary?coupleId=$coupleId',
      fromJsonT: (json) => CoupleSettlementSummaryEntity.fromJson(json),
    );
    return res.unwrap();
  }

  @override
  Future<void> settleUp(int coupleId) async {
    final res = await api.post<void>(
      '${ApiRoutes.couples}/settlement/settle-up?coupleId=$coupleId',
    );
    if (!res.success) {
      throw Exception(
        res.message.isNotEmpty ? res.message : 'Quyết toán thất bại',
      );
    }
  }

  @override
  Future<void> settleUpSingle({
    required int coupleId,
    required int transactionId,
  }) async {
    final res = await api.post<void>(
      '${ApiRoutes.couples}/settlement/settle-up-single?coupleId=$coupleId&transactionId=$transactionId',
    );
    if (!res.success) {
      throw Exception(
        res.message.isNotEmpty ? res.message : 'Quyết toán thất bại',
      );
    }
  }

  @override
  Future<CoupleReportEntity> getReport(int coupleId, String month) async {
    final res = await api.get<CoupleReportEntity>(
      '${ApiRoutes.couples}/reports/summary?coupleId=$coupleId&month=$month',
      fromJsonT: (json) =>
          CoupleReportEntity.fromJson(Map<String, dynamic>.from(json as Map)),
    );
    return res.unwrap();
  }

  @override
  Future<CoupleSpendingAlertEntity> markAlertRead(int alertId) async {
    final res = await api.patch<CoupleSpendingAlertEntity>(
      '${ApiRoutes.couples}/reports/alerts/$alertId/read',
      fromJsonT: (json) => CoupleSpendingAlertEntity.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
    return res.unwrap();
  }

  @override
  Future<CoupleSpendingAlertEntity> updateAlert({
    required int alertId,
    String? status,
    String? feedback,
  }) async {
    final body = <String, dynamic>{
      'status': ?status,
      'feedback': ?feedback,
    };
    final res = await api.patch<CoupleSpendingAlertEntity>(
      '${ApiRoutes.couples}/reports/alerts/$alertId',
      body: body,
      fromJsonT: (json) => CoupleSpendingAlertEntity.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
    return res.unwrap();
  }
}
