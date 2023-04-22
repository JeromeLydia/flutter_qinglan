import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_qinglan/ui/dialog/dialogs.dart';
import 'package:flutter_qinglan/ui/pages/home/home_controller.dart';
import 'package:get/get.dart';

import '../../../res/colors.dart';
import '../blue/cmd.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    homeController.checkBluetoothPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: GetX<HomeController>(
          init: homeController,
          builder: (controller) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              children: [
                homeController.bluetoothDeviceState.value ==
                        BluetoothDeviceState.disconnected
                    ? Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                if (homeController.bluetoothState.value ==
                                    BluetoothState.on) {
                                  homeController
                                      .checkBluetoothPermission()
                                      .then((value) => {
                                            !value
                                                ? homeController
                                                    .requestBlePermissions()
                                                : CustomDialogs().showDialog01(
                                                    context, homeController)
                                          });
                                } else {
                                  Get.showSnackbar(const GetSnackBar(
                                    message: "请打开蓝牙",
                                    duration: Duration(seconds: 2),
                                  ));
                                }
                              },
                              child: Text(
                                "未连接".tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 50.0,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  homeController.readDeviceData();
                                },
                                child: Text(
                                  "型号:${homeController.currentDevice.name}",
                                  style: const TextStyle(color: Colors.white),
                                ),
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
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: IconItem(
                        title: "电压".tr,
                        value: ("${homeController.messageData.value.voltage}V")
                            .toString(),
                        assetName: "assets/images/ic_voltage.png",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: IconItem(
                        title: "电流",
                        value: ("${homeController.messageData.value.current}A"),
                        assetName: "assets/images/ic_current.png",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: IconItem(
                        title: "功率",
                        value: ("${homeController.messageData.value.current}W"),
                        assetName: "assets/images/ic_power.png",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: IconItem(
                        title: "温度",
                        value:
                            ("${homeController.messageData.value.temperature}°C"),
                        assetName: "assets/images/ic_temperature.png",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: IconItem(
                        title: "剩余能量",
                        value:
                            ("${homeController.messageData.value.energy}KWH"),
                      ),
                    ),
                    Expanded(
                      child: IconItem(
                        title: "剩余容量",
                        value:
                            ("${homeController.messageData.value.actualCapacity}AH"),
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
                                homeController.sendData(CLEAR_CURRENT);
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
                                homeController.sendData(CLEAR_DATE);
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
                  children: [
                    Expanded(
                      child: SwitchItem(
                        title: "充电",
                        isOpen: homeController.messageData.value.charge,
                        onChanged: (p0) => {homeController.sendData(CHARGE)},
                      ),
                    ),
                    Expanded(
                      child: SwitchItem(
                        title: "放电",
                        isOpen: homeController.messageData.value.discharge,
                        onChanged: (p0) => {homeController.sendData(DISCHARGE)},
                      ),
                    ),
                    Expanded(
                      child: SwitchItem(
                        title: "定时",
                        isOpen: false,
                        onChanged: (p0) => {},
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
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
      color: AppColors.app_main,
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
  final Function(bool) onChanged;
  const SwitchItem({
    super.key,
    this.title = "",
    this.isOpen = false,
    required this.onChanged,
  });

  @override
  State<SwitchItem> createState() => _SwitchItemState();
}

class _SwitchItemState extends State<SwitchItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.app_main,
      child: Column(
        children: [
          Switch(value: widget.isOpen, onChanged: widget.onChanged),
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.blue,
            ),
          ),
          const Divider(
            height: 10,
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
