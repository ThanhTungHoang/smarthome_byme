// ignore_for_file: depend_on_referenced_packages

import 'package:json_annotation/json_annotation.dart';
part 'messenger_model.g.dart';

@JsonSerializable()
class Messenger {
  final String content;
  final bool seen;

  Messenger(this.content, this.seen);
  factory Messenger.fromJson(Map<String, dynamic> json) =>
      _$MessengerFromJson(json);
  Map<String, dynamic> toJson() => _$MessengerToJson(this);
}

//flutter pub run build_runner build
//flutter pub run build_runner build --delete-conflicting-outputs
