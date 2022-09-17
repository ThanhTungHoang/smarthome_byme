// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'device_scan_model.g.dart';

@JsonSerializable()
class DeviceScan {
  final String typeDevice;
  final double x;
  final double y;

  DeviceScan(this.typeDevice, this.x, this.y);

  factory DeviceScan.fromJson(Map<String, dynamic> json) =>
      _$DeviceScanFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceScanToJson(this);
}

//flutter pub run build_runner build
