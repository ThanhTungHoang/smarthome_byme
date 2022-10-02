part of 'scan_device_bloc.dart';

abstract class ScanDeviceState extends Equatable {
  const ScanDeviceState();

  @override
  List<Object> get props => [];
}

class ScanDeviceInitial extends ScanDeviceState {}

class ScanDevicePremission extends ScanDeviceState {
  final String status;

  const ScanDevicePremission(this.status);
}

class ScanDeviceLoading extends ScanDeviceState {}

class ScanDeviceLoaded extends ScanDeviceState {
  final List<DeviceScan> listDevice;

  const ScanDeviceLoaded(this.listDevice);
}

class ScanDeviceLoadedNull extends ScanDeviceState {}

class ScanDeviceSetupDevice extends ScanDeviceState {
  final String nameDevice;
  final List<String> listWifi;

  const ScanDeviceSetupDevice(this.nameDevice, this.listWifi);
}

class ScanDeviceSetupDeviceStatus extends ScanDeviceState {
  final String statusDeviceResponse;

  const ScanDeviceSetupDeviceStatus(this.statusDeviceResponse);
}

class ScanDeviceSetupDeviceStatusSuccsec extends ScanDeviceState {
  const ScanDeviceSetupDeviceStatusSuccsec();
}

class ScanDeviceSetupDeviceStatusFails extends ScanDeviceState {
  const ScanDeviceSetupDeviceStatusFails();
}

class ScanDeviceError extends ScanDeviceState {
  final String result;

  const ScanDeviceError(this.result);
}
