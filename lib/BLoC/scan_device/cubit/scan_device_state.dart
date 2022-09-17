part of 'scan_device_cubit.dart';

abstract class ScanDeviceState {}

class ScanDeviceInitial extends ScanDeviceState {}

class ScanDeviceLoading extends ScanDeviceState {}

class ScanDeviceLoaded extends ScanDeviceState {
  final List<String> listDevice;

  ScanDeviceLoaded(this.listDevice);
}

class ScanDeviceError extends ScanDeviceState {
  final String error;

  ScanDeviceError(this.error);
}
