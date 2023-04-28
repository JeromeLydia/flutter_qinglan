import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_qinglan/common/global.dart';
import 'package:flutter_qinglan/utils/tools.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart';

import '../blue/cmd.dart';
import '../blue/connect_manager.dart';
import '../blue/connect_callback.dart';
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

  Timer? _timer;

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
      if (scanResult.contains(device)) {
        return;
      }
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
      if (_timer != null && _timer!.isActive) {
        _timer!.cancel();
      }
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
    _timer = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      sendData(READ);
    });
    Future.delayed(const Duration(milliseconds: 3000), () {
      readDeviceData();
    });
  }

  //读取设备信息参数
  readDeviceData() {
    sendData(READ_DEVICE);
  }

  sendData(int type, {double input = 0.0}) {
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
        data.addAll([0, 0, 0, input.toInt()]);
        connectManager.writeCommand(data);
        break;
      case DISCHARGE:
        //放电
        var data = List.of([0xFE, deviceNo.value, 0xD2]);
        data.addAll([0, 0, 0, input.toInt()]);
        connectManager.writeCommand(data);
        break;
      case CLEAR_CURRENT:
        //电流清零
        var data = List.of([0xFE, deviceNo.value, 0xD3]);
        data.addAll([0, 0, 0, 1]);
        connectManager.writeCommand(data);
        break;
      case TIME_CONTROL:
        //定时控制开关
        var data = List.of([0xFE, deviceNo.value, 0xD4]);
        data.addAll([0, 0, 0, input.toInt()]);
        connectManager.writeCommand(data);
        break;
      case SET_SURPLUS:
        //设置电池余量
        var data = List.of([0xFE, deviceNo.value, 0xE6]);
        List<int> hexArray = intToByte((input * 10).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_CAPACITY:
        //设置电池容量
        var data = List.of([0xFE, deviceNo.value, 0xE7]);
        List<int> hexArray = intToByte((input * 10).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        Future.delayed(const Duration(milliseconds: 1000), () {
          readDeviceData();
        });
        break;
      case SET_OVP: // 充电过压值
        var data = List.of([0xFE, deviceNo.value, 0xE6]);
        List<int> hexArray = intToByte((input * 10).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_LVP: // 放电欠压值
        var data = List.of([0xFE, deviceNo.value, 0xD7]);
        List<int> hexArray = intToByte((input * 10).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_OCP: // 充电过流值
        var data = List.of([0xFE, deviceNo.value, 0xD9]);
        List<int> hexArray = intToByte((input * 10).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_NCP: // 放电过流值
        var data = List.of([0xFE, deviceNo.value, 0xD8]);
        List<int> hexArray = intToByte((input * 10).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_STV: // 充电启动值
        var data = List.of([0xFE, deviceNo.value, 0xDA]);
        List<int> hexArray = intToByte((input * 10).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_OTP: // 过温度保护值
        var data = List.of([0xFE, deviceNo.value, 0xDB]);
        List<int> hexArray = intToByte((input).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_LTP: // 低温恢复值
        var data = List.of([0xFE, deviceNo.value, 0xDC]);
        List<int> hexArray = intToByte((input).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_DEL: // 继电器延时
        var data = List.of([0xFE, deviceNo.value, 0xE1]);
        List<int> hexArray = intToByte((input).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_TTL: // 上电默认输出
        break;
      case SET_PTM: // 温控模式
        var data = List.of([0xFE, deviceNo.value, 0xE3]);
        List<int> hexArray = intToByte((input).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_LAG: // 语言
        break;
      case SET_STE: // 定时时间值
        var data = List.of([0xFE, deviceNo.value, 0xD5]);
        List<int> hexArray = intToByte((input).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_ETM: // 定时模式
        var data = List.of([0xFE, deviceNo.value, 0xE4]);
        List<int> hexArray = intToByte((input).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_OKI: // 充电电流系数微调
        var data = List.of([0xFE, deviceNo.value, 0xEB]);
        List<int> hexArray = intToByte((input * 100).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_NKI: // 放电电流系数微调
        var data = List.of([0xFE, deviceNo.value, 0xEC]);
        List<int> hexArray = intToByte((input * 100).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_SAVE: // 保存设置
        var data = List.of([0xFE, deviceNo.value, 0xEA]);
        List<int> hexArray = intToByte((1).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_DWM: // 继电器工作模式
        var data = List.of([0xFE, deviceNo.value, 0xE2]);
        List<int> hexArray = intToByte((input).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_ADC: // 通讯地址码
        var data = List.of([0xFE, deviceNo.value, 0xE9]);
        List<int> hexArray = intToByte((input).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_PAI: // 电流归0值设置
        var data = List.of([0xFE, deviceNo.value, 0xED]);
        List<int> hexArray = intToByte((input * 10).round(), 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SAVE_HOME: // 首页保存设置
        var data = List.of([0xFE, deviceNo.value, 0xEE]);
        List<int> hexArray = intToByte(1, 4);
        data.addAll(hexArray);
        connectManager.writeCommand(data);
        break;
      case SET_RELAY: // 折线页设置
        var data = List.of([0xFE, deviceNo.value, 0xEF]);
        List<int> hexArray = intToByte((input).round(), 4);
        data.addAll(hexArray);
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

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    super.dispose();
  }
}
