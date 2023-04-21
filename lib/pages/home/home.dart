import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_qinglan/dialogs.dart';
import 'package:flutter_qinglan/global.dart';
import 'package:flutter_qinglan/pages/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' hide PermissionStatus;

import '../../cmd.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _bluetoothStatus = false;

  HomeController homeController = Get.put(HomeController());

  Future<bool> _checkBluetoothPermission() async {
    final locationWhenInUse = await Permission.locationWhenInUse.status;
    final bluetooth = await Permission.bluetooth.status;
    final bluetoothScan = await Permission.bluetoothScan.status;
    final bluetoothConnect = await Permission.bluetoothConnect.status;
    final bluetoothAdvertise = await Permission.bluetoothAdvertise.status;
    if (Platform.isIOS) {
      _bluetoothStatus = bluetooth == PermissionStatus.granted;
    } else {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      if (androidDeviceInfo.version.sdkInt < 23) {
        _bluetoothStatus = locationWhenInUse == PermissionStatus.granted &&
            bluetooth == PermissionStatus.granted;
      }
      _bluetoothStatus = locationWhenInUse == PermissionStatus.granted &&
          bluetoothScan == PermissionStatus.granted &&
          bluetoothConnect == PermissionStatus.granted &&
          bluetoothAdvertise == PermissionStatus.granted;
    }
    return _bluetoothStatus;
  }

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
  void initState() {
    super.initState();
    _checkBluetoothPermission();
  }

  void bluetoothWrite(List<int> data) async {
    final currentDevice = Global.currentDevice;
    if (currentDevice != null) {
      //获取服务
      List<BluetoothService> services = await currentDevice.discoverServices();
      //获取特征
      List<BluetoothCharacteristic> characteristics =
          services.first.characteristics;
      await characteristics.first.write(
        data, //写入的数据
        withoutResponse: true, //是否需要响应
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          GetBuilder<HomeController>(
              init: homeController,
              builder: (controller) {
                if (homeController.bluetoothDeviceState.value ==
                    BluetoothDeviceState.disconnected) {
                  return Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            if (homeController.bluetoothState.value ==
                                BluetoothState.on) {
                              !_bluetoothStatus
                                  ? requestBlePermissions()
                                  : CustomDialogs()
                                      .showDialog01(context, homeController);
                            } else {
                              Get.showSnackbar(const GetSnackBar(
                                message: "请打开蓝牙",
                                duration: Duration(seconds: 2),
                              ));
                            }
                          },
                          child: const Text(
                            "未连接",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (homeController.bluetoothDeviceState.value ==
                    BluetoothDeviceState.connected) {
                  return SizedBox(
                    height: 50.0,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "型号:${homeController.currentDevice.name}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              CustomDialogs()
                                  .showDialog01(context, homeController);
                            },
                            child: const Text(
                              "已连接",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return const Text("---");
                }
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: IconItem(
                  title: "电压".tr,
                  value: "12.23V",
                  assetName: "assets/images/ic_voltage.png",
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: IconItem(
                  title: "电流",
                  value: "2.92A",
                  assetName: "assets/images/ic_current.png",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Expanded(
                child: IconItem(
                  title: "功率",
                  value: "12.23V",
                  assetName: "assets/images/ic_power.png",
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: IconItem(
                  title: "温度",
                  value: "2.92A",
                  assetName: "assets/images/ic_temperature.png",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Expanded(
                child: IconItem(
                  title: "剩余电量",
                  value: "12.23V",
                ),
              ),
              Expanded(
                child: IconItem(
                  title: "剩余容量",
                  value: "2.92A",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const Text(
                      "充满需用时:",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: MaterialButton(
                        color: Colors.blue,
                        minWidth: double.infinity,
                        height: 50.0,
                        textColor: Colors.white,
                        child: const Text('保存设置'),
                        onPressed: () {
                          _customDialog(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: MaterialButton(
                        color: Colors.blue,
                        minWidth: double.infinity,
                        height: 50.0,
                        textColor: Colors.white,
                        child: const Text('电流清零'),
                        onPressed: () {
                          bluetoothWrite(CLEAR_CURRENT);
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: MaterialButton(
                        color: Colors.blue,
                        minWidth: double.infinity,
                        height: 50.0,
                        textColor: Colors.white,
                        child: const Text('数据清零'),
                        onPressed: () {
                          bluetoothWrite(READ);
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: MaterialButton(
                        color: Colors.blue,
                        minWidth: double.infinity,
                        height: 50.0,
                        textColor: Colors.white,
                        child: const Text('余量设定'),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: MaterialButton(
                        color: Colors.blue,
                        minWidth: double.infinity,
                        height: 50.0,
                        textColor: Colors.white,
                        child: const Text('容量预设'),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Expanded(
                child: IconItem(
                  title: "累计容量",
                  value: "12.23V",
                ),
              ),
              Expanded(
                child: IconItem(
                  title: "运行时间",
                  value: "2.92A",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Expanded(
                child: SwitchItem(
                  title: "充电",
                  isOpen: false,
                ),
              ),
              Expanded(
                child: SwitchItem(
                  title: "放电",
                  isOpen: false,
                ),
              ),
              Expanded(
                child: SwitchItem(
                  title: "定时",
                  isOpen: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IconItem extends StatefulWidget {
  final String title;
  final String value;
  final String assetName;

  const IconItem({
    super.key,
    this.title = "",
    this.value = "",
    this.assetName = "",
  });

  @override
  State<IconItem> createState() => _IconItemState();
}

class _IconItemState extends State<IconItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.0,
      width: 300.0,
      color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.assetName.isNotEmpty)
            Image(
              image: AssetImage(widget.assetName),
              height: 25,
              width: 25,
            ),
          const SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                widget.value,
                style: const TextStyle(
                  color: Colors.blue,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SwitchItem extends StatefulWidget {
  final String title;
  final bool isOpen;
  const SwitchItem({
    super.key,
    this.title = "",
    this.isOpen = false,
  });

  @override
  State<SwitchItem> createState() => _SwitchItemState();
}

class _SwitchItemState extends State<SwitchItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Column(
        children: [
          Switch(
              value: widget.isOpen,
              onChanged: (value) {
                setState(() {});
              }),
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}

Dialog _customDialog(context) {
  return Dialog(
    backgroundColor: Colors.yellow.shade100, // 背景色
    elevation: 4.0, // 阴影高度
    insetAnimationDuration: const Duration(milliseconds: 300), // 动画时间
    insetAnimationCurve: Curves.decelerate, // 动画效果
    insetPadding: const EdgeInsets.all(30), // 弹框距离屏幕边缘距离
    clipBehavior: Clip.none, // 剪切方式
    child: Container(
      width: 300,
      height: 300,
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        children: [
          const Text(
            "Custom Dialog",
            style: TextStyle(color: Colors.blue, fontSize: 25),
          ),
          const Padding(padding: EdgeInsets.all(15)),
          const Text("这是一个最简单的自定义 Custom Dialog"),
          const Padding(
            padding: EdgeInsets.all(15),
          ),
          TextButton(
            onPressed: () {
              // 隐藏弹框
              Navigator.pop(context, 'SimpleDialog - Normal, 我知道了');
            },
            child: const Text("我知道了"),
          ),
        ],
      ),
    ),
  );
}
