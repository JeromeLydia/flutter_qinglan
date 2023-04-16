import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Global {
  static BluetoothDevice? currentDevice;

  static StreamController<BluetoothDeviceState> streamController =
      StreamController<BluetoothDeviceState>();
}
