// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    _ChatMessageModel(
      isUser: json['isUser'] as bool? ?? false,
      text: json['text'] as String? ?? '',
    );

Map<String, dynamic> _$ChatMessageModelToJson(_ChatMessageModel instance) =>
    <String, dynamic>{'isUser': instance.isUser, 'text': instance.text};
