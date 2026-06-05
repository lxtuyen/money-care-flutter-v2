import '../../data/models/ai_feedback_dto.dart';
import '../repositories/ai_feedback_repository.dart';

class SendAiFeedbackUseCase {
  final AiFeedbackRepository repository;

  const SendAiFeedbackUseCase(this.repository);

  Future<void> call(AiFeedbackDto dto) {
    return repository.sendFeedback(dto);
  }
}
