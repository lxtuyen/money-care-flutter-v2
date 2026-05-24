import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/spending_plan/domain/entities/spending_plan_entity.dart';
import 'package:money_care/features/spending_plan/domain/repositories/spending_plan_repository.dart';

class GetSpendingPlansUseCase {
  final SpendingPlanRepository repository;

  GetSpendingPlansUseCase(this.repository);

  Future<Either<Failure, List<SpendingPlanEntity>>> call() =>
      repository.getPlans();
}
