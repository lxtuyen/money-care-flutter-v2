import 'package:image_picker/image_picker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/errors/failure.dart';
import 'package:money_care/features/chatbot/data/datasources/chat_remote_datasource.dart';
import 'package:money_care/features/chatbot/data/models/models.dart';
import 'package:money_care/features/chatbot/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource remoteDatasource;

  ChatRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, String>> sendToChatbot(ChatDto dto, {String? filePath}) async {
    try {
      final reply = await remoteDatasource.sendToChatbot(
        dto,
        file: filePath != null ? XFile(filePath) : null,
      );
      return Right(reply);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
