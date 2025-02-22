import 'package:collection/collection.dart';

import '../../services.dart';
import 'connect_model.dart';
import 'network_model.dart';

/// "Use wired connection"
class EthernetModel extends NetworkModel<EthernetDevice> {
  EthernetModel(super.service, [super.udev]);

  @override
  bool get canConnect => false;

  @override
  bool get isConnected => hasActiveConnection;

  @override
  bool get isConnecting => false;

  @override
  bool get hasActiveConnection => devices.any((device) => device.isActive);

  @override
  bool get isEnabled => devices.any((device) => !device.isDisconnected);

  @override
  ConnectMode get connectMode => ConnectMode.ethernet;

  @override
  void onSelected() async {}

  @override
  void onDeselected() async {}

  @override
  Future<void> enable() async {
    log.debug('Enable wired networking');
    devices.where((device) => device.isDisconnected).forEach((device) {
      if (device.availableConnections.isNotEmpty) {
        service.activateConnection(device: device.device);
      } else if (!device.isUnmanaged) {
        service.addAndActivateConnection(device: device.device);
      }
    });
  }

  @override
  Future<void> connect() async {
    assert(false);
  }

  @override
  List<NetworkManagerDevice> getDevices() => service.wiredDevices;

  @override
  EthernetDevice createDevice(NetworkManagerDevice device) {
    return EthernetDevice(device, udev);
  }

  @override
  EthernetDevice? findActiveDevice() {
    return devices.firstWhereOrNull((device) => device.isActive);
  }
}

class EthernetDevice extends NetworkDevice {
  EthernetDevice(super.device, super.udev);
}
