import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/spending_plan/domain/repositories/spending_plan_repository.dart';

class DeleteSpendingPlanUseCase {
  final SpendingPlanRepository repository;

  DeleteSpendingPlanUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int id) => repository.deletePlan(id);
}
