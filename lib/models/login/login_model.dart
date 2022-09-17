// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'login_model.g.dart';

@JsonSerializable()
class LoginParam {
  final String email;
  final String password;

  LoginParam({required this.email, required this.password});

  factory LoginParam.fromJson(Map<String, dynamic> json) =>
      _$LoginParamFromJson(json);
  Map<String, dynamic> toJson() => _$LoginParamToJson(this);
}

//flutter pub run build_runner build