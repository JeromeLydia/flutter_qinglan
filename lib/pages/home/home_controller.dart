import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../blue/connect_manager.dart';
import '../blue/gatt_callback.dart';
import '../blue/message_data.dart';

class HomeController extends GetxController {
  //蓝牙状态
  var bluetoothState = BluetoothState.unknown.obs;
  //设备连接状态
  var bluetoothDeviceState = BluetoothDeviceState.disconnected.obs;
  //扫描到的设备列表
  var scanResult = List<ScanResult>.empty().obs;
  //当前连接的设备
  late BluetoothDevice currentDevice;
  //设备号
  var deviceNo = 0.obs;
  //是否正在扫描
  var isScanning = false.obs;
  //连接管理类
  late ConnectManager connectManager;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  void _initData() async {
    //1.实例化连接管理类，并监听连接状态
    connectManager =
        ConnectManager(GattCallback(onDeviceFind: (ScanResult device) {
      //扫描到设备
      scanResult.add(device);
    }, onDeviceScanStop: () {
      //停止扫描
    }, onConnected: (BluetoothDevice device) {
      //连接成功回调
      currentDevice = device;
      bluetoothDeviceState = BluetoothDeviceState.connected.obs;
      update();
    }, onDisconnect: () {
      //连接关闭回调
      bluetoothDeviceState = BluetoothDeviceState.disconnected.obs;
    }, onRead: (MessageData data) {
      //设备发过来的数据
      log("收到数据：${data.toString()}");
    }));

    //监听蓝牙状态
    FlutterBluePlus.instance.state.listen((event) {
      bluetoothState.value = event;
    });
    //监听扫描状态
    FlutterBluePlus.instance.isScanning.listen((event) {
      isScanning.value = event;
    });
  }

  //2.扫描
  Future<void> startScan() async {
    if (!connectManager.isConnecting) {
      connectManager.startScan();
    }
  }

  //停止扫描
  Future<void> stopScan() async {}

  //3.连接
  void connect(BluetoothDevice device) {
    connectManager.connect(device);
  }
}
