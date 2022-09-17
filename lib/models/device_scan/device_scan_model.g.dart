// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_scan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceScan _$DeviceScanFromJson(Map<String, dynamic> json) => DeviceScan(
      json['typeDevice'] as String,
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
    );

Map<String, dynamic> _$DeviceScanToJson(DeviceScan instance) =>
    <String, dynamic>{
      'typeDevice': instance.typeDevice,
      'x': instance.x,
      'y': instance.y,
    };
