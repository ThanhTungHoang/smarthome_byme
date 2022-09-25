// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'text_field_select_wifi_model.g.dart';

@JsonSerializable()
class TextFieldSelectWifi {
  final String name;
  final String value;

  TextFieldSelectWifi(this.name, this.value);

  factory TextFieldSelectWifi.fromJson(Map<String, dynamic> json) =>
      _$TextFieldSelectWifiFromJson(json);
  Map<String, dynamic> toJson() => _$TextFieldSelectWifiToJson(this);
}

//flutter pub run build_runner build
//flutter pub run build_runner build --delete-conflicting-outputs
