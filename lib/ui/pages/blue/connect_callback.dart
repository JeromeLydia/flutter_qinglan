import 'package:flutter_blue_plus/flutter_blue_plus.dart';

typedef OnDeviceScanStop = void Function();
typedef OnDeviceFind = void Function(ScanResult device);
typedef OnConnected = void Function(BluetoothDevice device);
typedef OnDisconnect = void Function();
typedef OnRead = void Function(List<int> data);

class GattCallback {
  GattCallback(
      {required this.onDeviceScanStop,
      required this.onDeviceFind,
      required this.onConnected,
      required this.onDisconnect,
      required this.onRead});
  OnDeviceFind onDeviceFind;
  OnDeviceScanStop onDeviceScanStop;
  OnConnected onConnected;
  OnDisconnect onDisconnect;
  OnRead onRead;
}
