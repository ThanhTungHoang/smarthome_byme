part of 'scan_device_bloc.dart';

abstract class ScanDeviceEvent extends Equatable {
  const ScanDeviceEvent();

  @override
  List<Object> get props => [];
}

class ScanDeviceResetState extends ScanDeviceEvent {}

class ScanDeviceReturnState extends ScanDeviceEvent {
  final String stateReturn;

  const ScanDeviceReturnState(this.stateReturn);
}

class ScanDeviceRequestPremission extends ScanDeviceEvent {}

class ScanDeviceSetup extends ScanDeviceEvent {
  final String nameDevice;

  const ScanDeviceSetup(this.nameDevice);
}

class ScanDeviceConnect extends ScanDeviceEvent {
  final String pathEmailRequest;
  final String nameDevice;
  final String ssidWifi;
  final String? passWifi;

  const ScanDeviceConnect(
      this.pathEmailRequest, this.nameDevice, this.ssidWifi, this.passWifi);
}

class ScanDeviceGetStatusDevice extends ScanDeviceEvent {
  final String value;

  const ScanDeviceGetStatusDevice(this.value);
}
