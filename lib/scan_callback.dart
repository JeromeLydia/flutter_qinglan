import 'device_bean.dart';

typedef OnFind = void Function(DeviceBean device);
typedef OnStop = void Function();

class ScanCallback {
  ScanCallback({required this.onFind, required this.onStop});
  OnFind onFind;
  OnStop onStop;
}
