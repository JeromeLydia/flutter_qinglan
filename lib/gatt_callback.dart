import 'message_data.dart';

typedef OnDeviceNotFind = void Function();
typedef OnConnected = void Function();
typedef OnDisconnect = void Function();
typedef OnRead = void Function(MessageData data);

class GattCallback {
  GattCallback(
      {required this.onDeviceNotFind,
      required this.onConnected,
      required this.onDisconnect,
      required this.onRead});
  OnDeviceNotFind onDeviceNotFind;
  OnConnected onConnected;
  OnDisconnect onDisconnect;
  OnRead onRead;
}
