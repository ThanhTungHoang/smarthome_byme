// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'signup_model.g.dart';

@JsonSerializable()
class SignUpParam {
  final String email;
  final String password;

  SignUpParam({required this.email, required this.password});

  factory SignUpParam.fromJson(Map<String, dynamic> json) =>
      _$SignUpParamFromJson(json);
  Map<String, dynamic> toJson() => _$SignUpParamToJson(this);
}

//flutter pub run build_runner build
//--delete-conflicting-outputs
