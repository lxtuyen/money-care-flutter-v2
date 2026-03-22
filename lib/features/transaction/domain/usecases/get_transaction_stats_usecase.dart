import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:money_care/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_care/features/transaction/domain/repositories/transaction_repository.dart';

class GetTotalByTypeUseCase {
  final TransactionRepository repository;
  GetTotalByTypeUseCase(this.repository);

  Future<TotalByTypeEntity> call(int userId, TransactionTotalsDto dto) {
    return repository.getTotalByType(userId, dto);
  }
}

class GetTotalByCateUseCase {
  final TransactionRepository repository;
  GetTotalByCateUseCase(this.repository);

  Future<List<TotalByCategoryEntity>> call(int userId, TransactionTotalsDto dto) {
    return repository.getTotalByCate(userId, dto);
  }
}

class GetTotalByDateEntityUseCase {
  final TransactionRepository repository;
  GetTotalByDateEntityUseCase(this.repository);

  Future<TotalsByDateEntity> call(int userId, TransactionTotalsDto dto) {
    return repository.getTotalByDateEntity(userId, dto);
  }
}
