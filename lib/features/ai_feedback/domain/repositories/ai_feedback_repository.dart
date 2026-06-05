import '../../data/models/ai_feedback_dto.dart';

abstract class AiFeedbackRepository {
  Future<void> sendFeedback(AiFeedbackDto dto);
}
