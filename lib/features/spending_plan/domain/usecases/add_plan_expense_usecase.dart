import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_request.dart';
import 'package:money_care/features/spending_plan/domain/repositories/spending_plan_repository.dart';

class AddPlanExpenseUseCase {
  final SpendingPlanRepository repository;

  AddPlanExpenseUseCase(this.repository);

  Future<Either<Failure, SpendingPlanEntity>> call(
    int planId,
    CreateEstimatedExpenseRequest request,
  ) => repository.addPlanExpense(planId, request);
}
