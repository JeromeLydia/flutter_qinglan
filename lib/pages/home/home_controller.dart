import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart';

import '../blue/cmd.dart';
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
    //实例化连接管理类，并监听连接状态
    connectManager =
        ConnectManager(GattCallback(onDeviceFind: (ScanResult device) {
      //扫描到设备
      scanResult.add(device);
    }, onDeviceScanStop: () {
      //停止扫描
    }, onConnected: (BluetoothDevice device) {
      //连接成功回调
      currentDevice = device;
      deviceNo.value = currentDevice.name
          .replaceAll('QinLan', '')
          .replaceAll('BLE', '') as int;
      //字符串局部替换
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

  //扫描
  Future<void> startScan() async {
    if (!connectManager.isConnecting) {
      connectManager.startScan();
    }
  }

  //停止扫描
  Future<void> stopScan() async {}

  //连接
  void connect(BluetoothDevice device) {
    connectManager.connect(device);
  }

  //发现服务
  discoverServices(BluetoothDevice device) async {
    connectManager.discoverServices(device);
  }

  //读取设备参数
  readDeviceData() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      log('定时发送');
      sendData(READ);
    });
  }

  sendData(int type) {
    switch (type) {
      case READ:
        //读取设备参数
        connectManager.writeCommand([0xFA, deviceNo.value]);
        break;
      case READ_DEVICE:
        //读取设备电池容量和型号
        connectManager.writeCommand([0xFD, deviceNo.value]);
        break;
      case CHARGE:
        //充电
        connectManager.writeCommand([0xFE, deviceNo.value, 0xD1]);
        break;
    }
  }

  //检查蓝牙权限
  Future<bool> checkBluetoothPermission() async {
    bool bluetoothStatus = false;
    final locationWhenInUse = await Permission.locationWhenInUse.status;
    final bluetooth = await Permission.bluetooth.status;
    final bluetoothScan = await Permission.bluetoothScan.status;
    final bluetoothConnect = await Permission.bluetoothConnect.status;
    final bluetoothAdvertise = await Permission.bluetoothAdvertise.status;
    if (Platform.isIOS) {
      bluetoothStatus = bluetooth == PermissionStatus.granted;
    } else {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      if (androidDeviceInfo.version.sdkInt < 29) {
        bluetoothStatus = locationWhenInUse == PermissionStatus.granted &&
            bluetooth == PermissionStatus.granted;
      }
      bluetoothStatus = locationWhenInUse == PermissionStatus.granted &&
          bluetoothScan == PermissionStatus.granted &&
          bluetoothConnect == PermissionStatus.granted &&
          bluetoothAdvertise == PermissionStatus.granted;
    }
    return bluetoothStatus;
  }

  //请求蓝牙权限
  Future<bool> requestBlePermissions() async {
    Location loca = Location();
    bool serviceEnabled;

    serviceEnabled = await loca.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await loca.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }
    var isLocationGranted = await Permission.locationWhenInUse.request();
    var isBleGranted = await Permission.bluetooth.request();
    var isBleScanGranted = await Permission.bluetoothScan.request();
    var isBleConnectGranted = await Permission.bluetoothConnect.request();
    var isBleAdvertiseGranted = await Permission.bluetoothAdvertise.request();

    if (Platform.isIOS) {
      return isBleGranted == PermissionStatus.granted;
    } else {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      if (androidDeviceInfo.version.sdkInt < 23) {
        return isLocationGranted == PermissionStatus.granted &&
            isBleGranted == PermissionStatus.granted;
      }
      return isLocationGranted == PermissionStatus.granted &&
          isBleScanGranted == PermissionStatus.granted &&
          isBleConnectGranted == PermissionStatus.granted &&
          isBleAdvertiseGranted == PermissionStatus.granted;
    }
  }
}
