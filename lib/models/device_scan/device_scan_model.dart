// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'device_scan_model.g.dart';

@JsonSerializable()
class DeviceScan {
  final String nameDevice;
  final String typeDevice;

  DeviceScan(this.nameDevice, this.typeDevice);

  factory DeviceScan.fromJson(Map<String, dynamic> json) =>
      _$DeviceScanFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceScanToJson(this);
}

//flutter pub run build_runner build
//flutter pub run build_runner build --delete-conflicting-outputs
