import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/ai_feedback/data/models/ai_feedback_dto.dart';
import 'package:money_care/features/ai_feedback/domain/repositories/ai_feedback_repository.dart';

class AiFeedbackRepositoryImpl implements AiFeedbackRepository {
  final ApiClient api;

  const AiFeedbackRepositoryImpl({required this.api});

  @override
  Future<void> sendFeedback(AiFeedbackDto dto) async {
    final res = await api.post<Map<String, dynamic>>(
      ApiRoutes.aiFeedback,
      body: dto.toJson(),
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
    if (!res.success) {
      throw ServerException(res.message);
    }
  }
}
