import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/chatbot/data/models/models.dart';

abstract class ChatRepository {
  Future<Either<Failure, String>> sendToChatbot(ChatDto dto, {String? filePath});
}
