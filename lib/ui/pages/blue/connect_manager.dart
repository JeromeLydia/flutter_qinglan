import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_qinglan/common/global.dart';
import 'package:flutter_qinglan/ui/pages/blue/scan_callback.dart';
import 'package:flutter_qinglan/ui/pages/blue/scan_device.dart';

import 'gatt_callback.dart';
import 'message_data.dart';

class ConnectManager {
  final Guid SET_MODE_SERVICE_UUID =
      Guid("0000FFE0-0000-1000-8000-00805F9B34FB"); //服务UUID
  final Guid SET_MODE_CHARACTERISTIC_UUID =
      Guid("0000FFE1-0000-1000-8000-00805F9B34FB"); //特征值UUID
  final Guid SET_MODE_DESCRIPTOR_UUID =
      Guid("00002902-0000-1000-8000-00805f9b34fb"); //特征值描述UUID(固定不变)

  final List<int> ENABLE_NOTIFICATION_VALUE = [0x01, 0x00]; //启用Notification模式
  final List<int> DISABLE_NOTIFICATION_VALUE = [0x00, 0x00]; //停用Notification模式
  final List<int> ENABLE_INDICATION_VALUE = [0x02, 0x00]; //启用Indication模式

  static const int CON_TIMEOUT = 10000;
  final GattCallback _gattCallback;
  late BluetoothCharacteristic? _writeCharacteristic;
  late ScanDevice? _scanDevice = null;
  late BluetoothDevice? _device;
  bool isConnecting = false;
  ConnectManager(this._gattCallback);
  //1.扫描
  Future<void> startScan({int timeout = ScanDevice.SCAN_TIMEOUT}) async {
    _scanDevice ??= ScanDevice(ScanCallback(onFind: (ScanResult device) {
      //扫描到设备 回调通知外部
      logger.d("ble--扫描到设备2 >>>>>>name: ${device.device.name}");
      _gattCallback.onDeviceFind(device);
    }, onStop: () {
      //停止扫描 回调通知外部
      _gattCallback.onDeviceScanStop();
    }));

    _scanDevice?.startScan(timeout: timeout);
    isConnecting = false;
  }

  //2.连接
  Future<void> connect(BluetoothDevice device) async {
    isConnecting = true;
    _scanDevice?.stopScan(); //停止扫描
    logger.d("ble--2.开始连接 >>>>>>name: ${device.name}");
    await device.connect(
        timeout: const Duration(milliseconds: CON_TIMEOUT), autoConnect: false);
    _device = device;
    logger.d("ble--连接成功 >>>>>>name: ${device.name}");
    _gattCallback.onConnected(device); //连接成功 回调通知外部
    discoverServices(device); //发现服务
  }

  //3.发现服务
  Future<void> discoverServices(BluetoothDevice device) async {
    logger.d("ble--3.开始发现服务 >>>>>>name: ${device.name}");
    List<BluetoothService> services = await device.discoverServices();
    logger.d("ble--发现服务成功 >>>>>>name: ${device.name}");
    _handlerServices(device, services); //遍历服务列表，找出指定服务
    isConnecting = false;
  }

  //3.1遍历服务列表，找出指定服务
  void _handlerServices(
      BluetoothDevice device, List<BluetoothService> services) {
    for (var sItem in services) {
      String sUuid = sItem.uuid.toString();
      if (sUuid == SET_MODE_SERVICE_UUID.toString()) {
        //找到设置模式的服务
        logger.d(
            "4.找到设置模式的服务 >>>>>>name: ${device.name}  serviceGuid: ${SET_MODE_SERVICE_UUID.toString()}");
        _readCharacteristics(device, sItem); //读取特征值
      }
    }
  }

  //4.读取特征值(读出设置模式与写数据的特征值)
  Future<void> _readCharacteristics(
      BluetoothDevice device, BluetoothService service) async {
    var characteristics = service.characteristics;
    for (BluetoothCharacteristic cItem in characteristics) {
      String cUuid = cItem.uuid.toString();
      if (cUuid == SET_MODE_CHARACTERISTIC_UUID.toString()) {
        //找到设置模式的特征值
        logger.d(
            "4.0.找到设置模式的特征值 >>>>>>name: ${device.name}  characteristicUUID: ${SET_MODE_CHARACTERISTIC_UUID.toString()}");
        _requestMtu(device); //设置MTU
        _setNotificationMode(device, cItem); //设置为Notification模式(设备主动给手机发数据)
        _writeCharacteristic = cItem; //保存写数据的征值
      }
    }
  }

  //4.1.设置MTU
  Future<void> _requestMtu(BluetoothDevice device) async {
    final mtu = await device.mtu.first;
    logger.d("ble--4.1.当前mtu: $mtu 请求设置mtu为512 >>>>>>name: ${device.name}");
    await device.requestMtu(512);
  }

  //4.2.设置为Notification模式(设备主动给手机发数据)，Indication模式需要手机读设备的数据
  Future<void> _setNotificationMode(
      BluetoothDevice device, BluetoothCharacteristic cItem) async {
    logger.d("ble--4.2.设置为通知模式 >>>>>>name: ${device.name}");
    await cItem.setNotifyValue(true); //为指定特征的值设置通知
    cItem.value.listen((value) {
      if (value.isEmpty) return;
      logger.d("ble--接收数据 >>>>>>name: ${device.name}  value: $value");
      //...省略解析设备数据的逻辑
      _gattCallback.onRead(value); //回调外部，返回设备发送的数据
    });
    var descriptors = cItem.descriptors;
    for (BluetoothDescriptor dItem in descriptors) {
      if (dItem.uuid.toString() == SET_MODE_DESCRIPTOR_UUID.toString()) {
        //找到设置模式的descriptor
        logger.d("ble--发送Notification模式给设备 >>>>>>name: ${device.name}");
        dItem.write(ENABLE_NOTIFICATION_VALUE); //发送Notification模式给设备
        return;
      }
    }
  }

  //发送指令到设备
  Future<void> writeCommand(List<int> data) async {
    logger.d("ble--发送指令 >>>>>> data: $data");
    await _writeCharacteristic?.write(data);
  }

  //断开连接
  void disconnect(BluetoothDevice device) {
    logger.d("ble--断开连接 >>>>>>name: ${device.name}");
    device.disconnect(); //关闭连接
    _gattCallback.onDisconnect(); //连接失败回调
  }
}
