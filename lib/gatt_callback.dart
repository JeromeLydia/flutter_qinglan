import 'package:flutter_qinglan/device_bean.dart';

import 'message_data.dart';

typedef OnDeviceScanStop = void Function();
typedef OnDeviceFind = void Function(DeviceBean device);
typedef OnConnected = void Function();
typedef OnDisconnect = void Function();
typedef OnRead = void Function(MessageData data);

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
