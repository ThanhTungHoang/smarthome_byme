// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) => Device(
      json['ampe'] as String?,
      json['blue'] as String?,
      json['co2'] as String?,
      json['typeDevice'] as String,
      json['green'] as String?,
      json['humi'] as String?,
      json['idDevice'] as String,
      json['lock'] as String?,
      json['nameDevice'] as String,
      json['ping'] as int,
      json['red'] as String?,
      json['temp'] as String?,
      json['toggle'] as bool,
      json['voltage'] as String?,
      json['wat'] as String?,
      json['room'] as String?,
    );

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'ampe': instance.ampe,
      'blue': instance.blue,
      'co2': instance.co2,
      'typeDevice': instance.typeDevice,
      'green': instance.green,
      'humi': instance.humi,
      'idDevice': instance.idDevice,
      'lock': instance.lock,
      'nameDevice': instance.nameDevice,
      'ping': instance.ping,
      'red': instance.red,
      'temp': instance.temp,
      'toggle': instance.toggle,
      'voltage': instance.voltage,
      'room': instance.room,
      'wat': instance.wat,
    };
