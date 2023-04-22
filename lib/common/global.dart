import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class Global {
  static BluetoothDevice? currentDevice;

  static StreamController<BluetoothDeviceState> streamController =
      StreamController<BluetoothDeviceState>();
}
