// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'device_model.g.dart';

// hehe
//ok
@JsonSerializable()
class Device {
  final String? ampe;
  final String? blue;
  final String? co2;
  final String typeDevice;
  final String? green;
  final String? humi;
  final String idDevice;
  final String? lock;
  final String nameDevice;
  final int ping;
  final String? red;
  final String? temp;
  final bool toggle;
  final String? voltage;
  final String? room;
  final String? wat;
  Device(
    this.ampe,
    this.blue,
    this.co2,
    this.typeDevice,
    this.green,
    this.humi,
    this.idDevice,
    this.lock,
    this.nameDevice,
    this.ping,
    this.red,
    this.temp,
    this.toggle,
    this.voltage,
    this.wat,
    this.room,
  );
  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}

//flutter pub run build_runner build
//flutter pub run build_runner build --delete-conflicting-outputs
