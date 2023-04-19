import 'package:get/get.dart';

import '../../connect_manager.dart';
import '../../device_bean.dart';
import '../../gatt_callback.dart';
import '../../message_data.dart';

class HomeController extends GetxController {
  var scanResult = List<DeviceBean>.empty().obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() async {}

  //1.实例化连接管理类，并监听连接状态
  void startScan() {
    ConnectManager connectManager = ConnectManager(GattCallback(
        //1.实例化连接管理类，并监听连接状态
        onDeviceFind: (DeviceBean device) {
      //扫描到设备
      scanResult.add(device);
    }, onDeviceScanStop: () {
      //停止扫描
    }, onConnected: () {
      //连接成功回调
    }, onDisconnect: () {
      //连接关闭回调
    }, onRead: (MessageData data) {
      //设备发过来的数据
    }));
    if (!connectManager.isConnecting) {
      connectManager.startScan();
    }
  }
}
