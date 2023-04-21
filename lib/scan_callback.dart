import 'package:flutter_blue_plus/flutter_blue_plus.dart';

typedef OnFind = void Function(ScanResult device);
typedef OnStop = void Function();

class ScanCallback {
  ScanCallback({required this.onFind, required this.onStop});
  OnFind onFind;
  OnStop onStop;
}
