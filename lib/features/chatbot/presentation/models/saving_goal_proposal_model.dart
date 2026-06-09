import 'package:money_care/core/utils/helper/helper_functions.dart';

class SavingGoalProposal {
  final String name;
  final double target;
  final int months;
  final int daysEstimate;
  final double capacity;
  final double suggestedMonthlySaving;
  final double suggestedDailySaving;
  final double suggestedDailySpending;
  final List<SavingGoalDurationOption> durationOptions;
  final String aiMessage;
  final DateTime? endDate;
  final bool hasPlan;
  final bool isImpossible;
  final bool isWarning;
  final bool isFinalized;
  final String finalizedLabel;
  final double initFund;
  final int sourceWalletId;
  final double remainingTarget;
  final double totalAmount;
  final List<SavingGoalBudgetItem> budgetItems;
  final bool preserveCurrentBudget;
  final bool isRequestedDuration;
  final String analyticsSource;
  final double projectedMonthlySavings;
  final double confidence;
  final String goalReadinessStatus;
  final bool goalReadinessFeasible;
  final String budgetStrategy;

  bool get hasAnalyticsInsight =>
      analyticsSource == 'analytics-service' ||
      projectedMonthlySavings > 0 ||
      confidence > 0;

  SavingGoalProposal({
    required this.name,
    required this.target,
    required this.months,
    required this.daysEstimate,
    required this.capacity,
    required this.suggestedMonthlySaving,
    required this.suggestedDailySaving,
    required this.suggestedDailySpending,
    required this.durationOptions,
    required this.aiMessage,
    this.endDate,
    required this.hasPlan,
    required this.isImpossible,
    required this.isWarning,
    required this.isFinalized,
    required this.finalizedLabel,
    required this.initFund,
    required this.sourceWalletId,
    required this.remainingTarget,
    required this.totalAmount,
    required this.budgetItems,
    required this.preserveCurrentBudget,
    required this.isRequestedDuration,
    required this.analyticsSource,
    required this.projectedMonthlySavings,
    required this.confidence,
    required this.goalReadinessStatus,
    required this.goalReadinessFeasible,
    required this.budgetStrategy,
  });

  factory SavingGoalProposal.fromMap(Map<String, dynamic> map) {
    final months = (map['monthsEstimate'] as num?)?.toInt() ?? 0;
    final daysEstimate =
        (map['daysEstimate'] as num?)?.toInt() ??
        (months > 0 ? months * 30 : 0);
    final target = (map['target'] as num?)?.toDouble() ?? 0;
    final endDateStr = map['endDate'];
    final rawOptions = map['durationOptions'];
    final initFund = (map['initFund'] as num?)?.toDouble() ?? 0;
    final sourceWalletId = (map['sourceWalletId'] as num?)?.toInt() ?? 0;
    final remainingTarget =
        (map['remainingTarget'] as num?)?.toDouble() ?? target;
    final rawBudgetItems = map['budgetItems'];
    final isRequestedDuration = map['isRequestedDuration'] == true;
    final goalReadiness = map['goalReadiness'];
    final goalReadinessMap =
        goalReadiness is Map ? Map<String, dynamic>.from(goalReadiness) : null;

    List<SavingGoalDurationOption> parsedOptions = [];
    if (rawOptions is List && rawOptions.isNotEmpty) {
      parsedOptions = rawOptions
          .whereType<Map>()
          .map(
            (option) => SavingGoalDurationOption.fromMap(
              Map<String, dynamic>.from(option),
              remainingTarget,
              months,
              daysEstimate,
            ),
          )
          .toList();
    } else if (!isRequestedDuration && remainingTarget > 0 && months > 0) {
      final optionDays = <int>{
        if (daysEstimate > 1) daysEstimate - 1,
        daysEstimate,
        daysEstimate + 7,
      }.toList();

      parsedOptions = optionDays.map((days) {
        final type = days < daysEstimate
            ? 'faster'
            : days == daysEstimate
            ? 'recommended'
            : 'relaxed';
        final dailySaving = AppHelperFunction.roundVndUp(remainingTarget / days);
        final optionMonths = (days / 30).ceil();
        final monthlySaving = AppHelperFunction.roundVndUp(remainingTarget / (days / 30));

        return SavingGoalDurationOption(
          type: type,
          label: type == 'faster'
              ? 'Gấp'
              : type == 'recommended'
              ? 'Khuyến nghị'
              : 'Thoải mái',
          months: optionMonths,
          days: days,
          durationText: _formatDuration(days),
          monthlySaving: monthlySaving,
          dailySaving: dailySaving,
          isRecommended: type == 'recommended',
          preserveCurrentBudget: false,
        );
      }).toList();
    }

    final totalAmount = (map['totalAmount'] as num?)?.toDouble() ?? 0;
    final suggestedMonthlySaving = AppHelperFunction.roundVndUp(
      (map['suggestedMonthlySaving'] as num?)?.toDouble() ??
          (months > 0 ? remainingTarget / months : 0),
    );
    final suggestedDailySaving = AppHelperFunction.roundVndUp(
      (map['suggestedDailySaving'] as num?)?.toDouble() ??
          (daysEstimate > 0 ? remainingTarget / daysEstimate : 0),
    );
    final suggestedDailySpending = AppHelperFunction.roundVndUp(
      (map['suggestedDailySpending'] as num?)?.toDouble() ??
          (totalAmount > 0
              ? (totalAmount - suggestedMonthlySaving).clamp(
                      0,
                      double.infinity,
                    ) /
                    30
              : suggestedDailySaving),
    );

    return SavingGoalProposal(
      name: map['name'] ?? 'Mục tiêu',
      target: target,
      months: months,
      daysEstimate: daysEstimate,
      capacity: (map['monthlySavingCapacity'] as num?)?.toDouble() ?? 0,
      suggestedMonthlySaving: suggestedMonthlySaving,
      suggestedDailySaving: suggestedDailySaving,
      suggestedDailySpending: suggestedDailySpending,
      durationOptions: parsedOptions,
      aiMessage: map['aiMessage'] ?? '',
      endDate: endDateStr != null ? DateTime.tryParse(endDateStr) : null,
      hasPlan: map['hasPlan'] ?? false,
      isImpossible: map['isImpossible'] ?? false,
      isWarning: map['isWarning'] == true,
      isFinalized: map['isFinalized'] == true,
      finalizedLabel:
          map['finalizedLabel']?.toString() ?? 'Mục tiêu này đã được tạo',
      initFund: initFund,
      sourceWalletId: sourceWalletId,
      remainingTarget: remainingTarget,
      totalAmount: totalAmount,
      budgetItems: rawBudgetItems is List
          ? rawBudgetItems
                .whereType<Map>()
                .map(
                  (item) => SavingGoalBudgetItem.fromMap(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
      preserveCurrentBudget: map['preserveCurrentBudget'] == true,
      isRequestedDuration: isRequestedDuration,
      analyticsSource: map['analyticsSource']?.toString() ?? '',
      projectedMonthlySavings:
          (map['projectedMonthlySavings'] as num?)?.toDouble() ?? 0,
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0,
      goalReadinessStatus:
          goalReadinessMap?['status']?.toString() ?? '',
      goalReadinessFeasible: goalReadinessMap?['isFeasible'] == true,
      budgetStrategy: map['budgetStrategy']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toConfirmPayload({
    List<SavingGoalBudgetItem>? budgetItems,
    double? totalAmount,
  }) {
    final selectedBudgetItems = budgetItems ?? this.budgetItems;

    return {
      'name': name,
      'target': target,
      'months': months,
      'days': daysEstimate,
      'initFund': initFund,
      'sourceWalletId': sourceWalletId,
      'totalAmount': totalAmount ?? this.totalAmount,
      'budgetItems': selectedBudgetItems.map((item) => item.toJson()).toList(),
      'preserveCurrentBudget': preserveCurrentBudget,
    };
  }

  String get durationLabel => _formatDuration(daysEstimate);

  static String _formatDuration(int daysValue) {
    final days = daysValue <= 0 ? 0 : daysValue;
    if (days <= 0) return '0 ngày';
    if (days < 30) return '$days ngày';

    final months = days ~/ 30;
    final remainingDays = days % 30;
    if (remainingDays == 0) return '$months tháng';
    return '$months tháng $remainingDays ngày';
  }
}

class SavingGoalBudgetItem {
  final int? categoryId;
  final String categoryName;
  final double amount;
  final double monthlyLimit;
  final String frequencyType;
  final int frequencyValue;

  const SavingGoalBudgetItem({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.monthlyLimit,
    required this.frequencyType,
    required this.frequencyValue,
  });

  factory SavingGoalBudgetItem.fromMap(Map<String, dynamic> map) {
    return SavingGoalBudgetItem(
      categoryId: (map['categoryId'] as num?)?.toInt(),
      categoryName: map['categoryName']?.toString() ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      monthlyLimit:
          (map['monthlyLimit'] as num?)?.toDouble() ??
          (map['amount'] as num?)?.toDouble() ??
          0,
      frequencyType: map['frequencyType']?.toString() ?? 'monthly',
      frequencyValue: (map['frequencyValue'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (categoryId != null) 'categoryId': categoryId,
      'categoryName': categoryName,
      'amount': amount,
      'monthlyLimit': monthlyLimit,
      'frequencyType': frequencyType,
      'frequencyValue': frequencyValue,
    };
  }

  SavingGoalBudgetItem copyWith({
    int? categoryId,
    String? categoryName,
    double? amount,
    double? monthlyLimit,
    String? frequencyType,
    int? frequencyValue,
  }) {
    return SavingGoalBudgetItem(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      frequencyType: frequencyType ?? this.frequencyType,
      frequencyValue: frequencyValue ?? this.frequencyValue,
    );
  }
}

class SavingGoalDurationOption {
  final String type;
  final String label;
  final int months;
  final int days;
  final String durationText;
  final double monthlySaving;
  final double dailySaving;
  final bool isRecommended;
  final bool preserveCurrentBudget;

  SavingGoalDurationOption({
    required this.type,
    required this.label,
    required this.months,
    required this.days,
    required this.durationText,
    required this.monthlySaving,
    required this.dailySaving,
    required this.isRecommended,
    required this.preserveCurrentBudget,
  });

  factory SavingGoalDurationOption.fromMap(
    Map<String, dynamic> map,
    double fallbackTarget,
    int fallbackMonths,
    int fallbackDays,
  ) {
    final m = (map['months'] as num?)?.toInt() ?? fallbackMonths;
    final days =
        (map['days'] as num?)?.toInt() ??
        (map['daysEstimate'] as num?)?.toInt() ??
        (m > 0 ? m * 30 : fallbackDays);
    final dailySaving = AppHelperFunction.roundVndUp(
      (map['dailySaving'] as num?)?.toDouble() ??
          (days > 0 ? fallbackTarget / days : 0),
    );
    final type = map['type']?.toString() ?? 'recommended';
    final label = map['label']?.toString() ?? 'Khuyến nghị';
    final normalizedLabel = label.toLowerCase();
    final isKeepBudgetOption =
        normalizedLabel.contains('giữ ngân sách') ||
        normalizedLabel.contains('giu ngan sach');
    final isRecommended =
        map['isRecommended'] == true ||
        type == 'recommended' ||
        days == fallbackDays;

    return SavingGoalDurationOption(
      type: type,
      label: label,
      months: m,
      days: days,
      durationText:
          map['durationText']?.toString() ??
          SavingGoalProposal._formatDuration(days),
      monthlySaving: AppHelperFunction.roundVndUp(
        (map['monthlySaving'] as num?)?.toDouble() ??
            (days > 0 ? fallbackTarget / (days / 30) : 0),
      ),
      dailySaving: dailySaving,
      isRecommended: isRecommended,
      preserveCurrentBudget:
          map['preserveCurrentBudget'] == true || isKeepBudgetOption,
    );
  }
}
