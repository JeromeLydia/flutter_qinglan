import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_qinglan/common/global.dart';
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
  var deviceNo = 0x00.obs;
  //是否正在扫描
  var isScanning = false.obs;
  //连接管理类
  late ConnectManager connectManager;

  var messageData = MessageData().obs;
  var dataBefore = MessageData();

  var deviceData = DeviceData(data: []).obs;

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
      logger.d("ble--扫描到设备：${device.device.name}");
      scanResult.add(device);
    }, onDeviceScanStop: () {
      //停止扫描
    }, onConnected: (BluetoothDevice device) {
      //连接成功回调
      logger.d("ble--连接成功：${device.name}");
      currentDevice = device;
      //字符串局部替换
      deviceNo.value = int.parse(
          currentDevice.name.replaceAll('QinLan', '').replaceAll('BLE', ''),
          radix: 16);
      bluetoothDeviceState.value = BluetoothDeviceState.connected;
      readRunData();
    }, onDisconnect: () {
      //连接关闭回调
      bluetoothDeviceState.value = BluetoothDeviceState.disconnected;
    }, onRead: (List<int> data) {
      if (data[0] == 0xFB) {
        //当前设备运行数据
        dataBefore = MessageData();
        dataBefore.data.addAll(data);
        if (dataBefore.data.length == 29) {
          dataBefore.init();
          messageData.value = dataBefore;
        }
      } else if (data[0] == 0xFD) {
        //当前设备电池容量和型号
        deviceData.value = DeviceData(data: data);
      } else if (data[0] == 0xFE) {
        // 设置写入之后 响应数据
      } else {
        //由于设备运行数据是分包发送的，所以需要拼接
        if (data.length == 9) {
          dataBefore.data.addAll(data);
          dataBefore.init();
          messageData.value = dataBefore;
        }
      }
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
    logger.d("ble--开始连接设备：${device.name}");
    connectManager.connect(device);
  }

  //断开连接
  void disconnect(BluetoothDevice device) {
    logger.d("ble--断开连接设备：${device.name}");
    connectManager.disconnect(device);
  }

  //发现服务
  discoverServices(BluetoothDevice device) async {
    logger.d("ble--开始扫描服务：${device.name}");
    connectManager.discoverServices(device);
  }

  //读取当前运行参数
  readRunData() {
    Timer.periodic(const Duration(milliseconds: 5000), (timer) {
      sendData(READ);
    });
  }

  //读取设备信息参数
  readDeviceData() {
    sendData(READ_DEVICE);
  }

  sendData(int type) {
    switch (type) {
      case READ:
        //读取设备参数
        connectManager.writeCommand([0xFB, deviceNo.value]);
        break;
      case READ_DEVICE:
        //读取设备电池容量和型号
        connectManager.writeCommand([0xFD, deviceNo.value]);
        break;
      case CHARGE:
        //充电
        var data = List.of([0xFE, deviceNo.value, 0xD1]);
        data.addAll([
          messageData.value.data[5],
          messageData.value.data[4],
          messageData.value.data[3],
          messageData.value.data[2] == 0 ? 1 : 0
        ]);
        connectManager.writeCommand(data);
        break;
      case DISCHARGE:
        //放电
        var data = List.of([0xFE, deviceNo.value, 0xD2]);
        data.addAll([
          messageData.value.data[5],
          messageData.value.data[4],
          messageData.value.data[3],
          messageData.value.data[2] == 0 ? 1 : 0
        ]);
        connectManager.writeCommand(data);
        break;
      case CLEAR_CURRENT:
        //电流清零
        var data = List.of([0xFE, deviceNo.value, 0xD3]);
        data.addAll([
          messageData.value.data[5],
          messageData.value.data[4],
          messageData.value.data[3],
          messageData.value.data[2]
        ]);
        connectManager.writeCommand(data);
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
