import 'package:money_care/features/auth/domain/repositories/auth_repository.dart';

class ConnectGmailUseCase {
  final AuthRepository repository;

  ConnectGmailUseCase(this.repository);

  Future<void> call() {
    return repository.connectGmail();
  }
}
