import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

/// GetX 提供了一个 get_storage 插件用于离线存储，
/// 与 shared_preferences 相比，其优点是纯 Dart 编写，
/// 不依赖于原生，因此可以在安卓、iOS、Web、Linux、Mac 等多个平台使用。
/// GetStorage 是基于内存和文件存储的，当内存容器中有数据时优先从内存读取。同时在构建 GetStorage 对象到时候指定存储的文件名以及存储数据的容器。
GetStorage storage = GetStorage();

class Global {
  static BluetoothDevice? currentDevice;

  static StreamController<BluetoothDeviceState> streamController =
      StreamController<BluetoothDeviceState>();
}
