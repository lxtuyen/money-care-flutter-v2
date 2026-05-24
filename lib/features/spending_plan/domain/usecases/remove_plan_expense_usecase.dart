import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/domain/repositories/spending_plan_repository.dart';

class RemovePlanExpenseUseCase {
  final SpendingPlanRepository repository;

  RemovePlanExpenseUseCase(this.repository);

  Future<Either<Failure, SpendingPlanEntity>> call(int planId, int expenseId) =>
      repository.removePlanExpense(planId, expenseId);
}
