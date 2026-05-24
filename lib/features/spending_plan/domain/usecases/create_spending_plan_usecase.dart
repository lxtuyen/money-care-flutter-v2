import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_request.dart';
import 'package:money_care/features/spending_plan/domain/repositories/spending_plan_repository.dart';

class CreateSpendingPlanUseCase {
  final SpendingPlanRepository repository;

  CreateSpendingPlanUseCase(this.repository);

  Future<Either<Failure, SpendingPlanEntity>> call(
    CreateSpendingPlanRequest request,
  ) => repository.createPlan(request);
}
