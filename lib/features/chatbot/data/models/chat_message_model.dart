import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_care/features/chatbot/domain/entities/chat_entity.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

@freezed
abstract class ChatMessageModel with _$ChatMessageModel {
  const factory ChatMessageModel({
    @Default(false) bool isUser,
    @Default('') String text,
  }) = _ChatMessageModel;

  const ChatMessageModel._();

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  ChatMessageEntity toEntity() => ChatMessageEntity(
        isUser: isUser,
        text: text,
      );
}


