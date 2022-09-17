// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messenger_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Messenger _$MessengerFromJson(Map<String, dynamic> json) => Messenger(
      json['content'] as String,
      json['seen'] as bool,
      json['title'] as String,
    );

Map<String, dynamic> _$MessengerToJson(Messenger instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'seen': instance.seen,
    };
