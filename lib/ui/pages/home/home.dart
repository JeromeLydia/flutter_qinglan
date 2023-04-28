import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_qinglan/ui/dialog/dialogs.dart';
import 'package:flutter_qinglan/ui/pages/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
                                                : scanDialog(
                                                    context, homeController)
                                          });
                                } else {
                                  Get.showSnackbar(GetSnackBar(
                                    message: "请打开蓝牙".tr,
                                    duration: const Duration(seconds: 2),
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
                                  "${"型号".tr}:${homeController.currentDevice.name}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  scanDialog(context, homeController);
                                },
                                child: Text(
                                  "已连接".tr,
                                  style: const TextStyle(color: Colors.white),
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
                        title: "电流".tr,
                        value:
                            ("${homeController.messageData.value.currentDirection == 0 ? "-" : "+"}${homeController.messageData.value.current}A"),
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
                        title: "功率".tr,
                        value: ("${homeController.messageData.value.current}W"),
                        assetName: "assets/images/ic_power.png",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: IconItem(
                        title: "温度".tr,
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
                        title: "剩余能量".tr,
                        value:
                            ("${homeController.messageData.value.energy}KWH"),
                      ),
                    ),
                    Expanded(
                      child: IconItem(
                        title: "剩余容量".tr,
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
                          CircularPercentIndicator(
                            radius: 80.0,
                            lineWidth: 20.0,
                            animation: true,
                            percent: homeController.messageData.value
                                    .remainingCapacityPercentage /
                                100,
                            center: Text(
                              "${homeController.messageData.value.remainingCapacityPercentage}%",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.white),
                            ),
                            footer: Text(
                              "充满需用时:".tr,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.blue,
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: MaterialButton(
                              color: Colors.blue,
                              minWidth: double.infinity,
                              height: 50.0,
                              textColor: Colors.white,
                              child: Text('保存设置'.tr),
                              onPressed: () {},
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
                              child: Text("电流清零".tr),
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
                              child: Text('数据清零'.tr),
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
                              child: Text('余量设定'.tr),
                              onPressed: () {
                                if (homeController.bluetoothDeviceState.value !=
                                    BluetoothDeviceState.connected) {
                                  Get.snackbar('提示'.tr, '请先连接蓝牙'.tr);
                                  return;
                                }
                                inputDialog("请输入电池余量".tr, "${"数值范围".tr}:0-100",
                                    "${"单位".tr}:%", 0, 100, (double input) {
                                  homeController.sendData(SET_SURPLUS,
                                      input: input);
                                });
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
                              child: Text('容量预设'.tr),
                              onPressed: () {
                                if (homeController.bluetoothDeviceState.value !=
                                    BluetoothDeviceState.connected) {
                                  Get.snackbar('提示'.tr, '请先连接蓝牙'.tr);
                                  return;
                                }
                                inputDialog(
                                    "请输入电池容量".tr,
                                    "${"数值范围".tr}:0.0-6500.0",
                                    "${"单位".tr}:AH",
                                    0,
                                    6500, (double input) {
                                  homeController.sendData(SET_CAPACITY,
                                      input: input);
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              ("${homeController.deviceData.value.totalCapacity}AH"),
                              style: const TextStyle(color: Colors.white),
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
                  children: [
                    Expanded(
                      child: IconItem(
                        title: "累计容量".tr,
                        value:
                            ("${homeController.messageData.value.accumulatedCapacity}AH"),
                      ),
                    ),
                    Expanded(
                      child: IconItem(
                        title: "运行时间".tr,
                        value: ("${homeController.messageData.value.runTime}"),
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
                        title: "充电".tr,
                        isOpen: homeController.messageData.value.charge,
                        onChanged: (p0) => {
                          homeController.sendData(CHARGE, input: p0 ? 1 : 0)
                        },
                      ),
                    ),
                    Expanded(
                      child: SwitchItem(
                        title: "放电".tr,
                        isOpen: homeController.messageData.value.discharge,
                        onChanged: (p0) => {
                          homeController.sendData(DISCHARGE, input: p0 ? 1 : 0)
                        },
                      ),
                    ),
                    Expanded(
                      child: SwitchItem(
                        title: "定时".tr,
                        isOpen: homeController.messageData.value.timeSwitch,
                        onChanged: (p0) => {
                          homeController.sendData(TIME_CONTROL,
                              input: p0 ? 1 : 0)
                        },
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
