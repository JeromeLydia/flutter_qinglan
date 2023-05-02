import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_qinglan/ui/pages/chart/line_chart.dart';
import 'package:flutter_qinglan/utils/snackbar.dart';
import 'package:get/get.dart';

import '../../dialog/dialogs.dart';
import '../home/home_controller.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  HomeController homeController = Get.put(HomeController());
  final RxInt _currentIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: Colors.black,
        child: ListView(
          children: [
            const Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/ic-fly-left.png'),
                const Padding(padding: EdgeInsets.only(left: 5)),
                Text("电压/温度/电流 实时曲线图".tr,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const Padding(padding: EdgeInsets.only(left: 5)),
                Image.asset('assets/images/ic-fly-right.png'),
              ],
            ),
            Container(
              height: 250,
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              child: ChartItem(),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset('assets/images/ic-divider.png'),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Text("${homeController.messageData.value.voltage}V",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset('assets/images/ic-divider.png'),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                                ("${homeController.messageData.value.currentDirection == 0 ? "-" : "+"}${homeController.messageData.value.current}A"),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset('assets/images/ic-divider.png'),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                                ("${homeController.messageData.value.energy}KWH"),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset('assets/images/ic-divider.png'),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                                ("${homeController.messageData.value.actualCapacity}AH"),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset('assets/images/ic-divider.png'),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                                ("${homeController.messageData.value.temperature}°C"),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Image.asset('assets/images/ic-divider.png'),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                                homeController.formatSeconds(
                                    homeController.messageData.value.runTime),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      homeController.isRecording.value
                          ? 'assets/images/ic-stop.png'
                          : 'assets/images/ic-start.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  ElevatedButton(
                    onPressed: () {
                      if (homeController.bluetoothDeviceState.value !=
                          BluetoothDeviceState.connected) {
                        showToast('请先连接蓝牙'.tr);
                        return;
                      }
                      if (homeController.isRecording.value) {
                        homeController.isRecording.value = false;
                      } else {
                        remindDialog("是否先删除历史数据?".tr, () {
                          homeController.isRecording.value = true;
                        });
                      }
                    },
                    child: Text(
                      homeController.isRecording.value ? "停止记录".tr : "启动记录".tr,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  ElevatedButton(
                    onPressed: () {
                      if (homeController.bluetoothDeviceState.value !=
                          BluetoothDeviceState.connected) {
                        showToast('请先连接蓝牙'.tr);
                        return;
                      }
                      if (homeController.isRecording.value) {
                        showToast("正在记录数据，请停止记录之后再导出...".tr);
                      } else {
                        showToast("导出成功".tr);
                      }
                    },
                    child: Text("导出数据".tr),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/ic-fly-left.png'),
                      const Padding(padding: EdgeInsets.only(left: 5)),
                      Text("查看历史数据".tr,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const Padding(padding: EdgeInsets.only(left: 5)),
                      Image.asset('assets/images/ic-fly-right.png'),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 2,
                  child: InkWell(
                    onTap: () {
                      if (homeController.bluetoothDeviceState.value !=
                          BluetoothDeviceState.connected) {
                        showToast('请先连接蓝牙'.tr);
                        return;
                      }
                      bottomSheet(
                        [
                          "半小时".tr,
                          "1小时".tr,
                          "2小时".tr,
                          "3小时".tr,
                          "5小时".tr,
                          "10小时".tr,
                          "取消".tr,
                        ],
                        (int index) {
                          _currentIndex.value = index;
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                            _currentIndex.value == 0
                                ? "半小时".tr
                                : _currentIndex.value == 1
                                    ? "1小时".tr
                                    : _currentIndex.value == 2
                                        ? "2小时".tr
                                        : _currentIndex.value == 3
                                            ? "3小时".tr
                                            : _currentIndex.value == 4
                                                ? "5小时".tr
                                                : _currentIndex.value == 5
                                                    ? "10小时".tr
                                                    : "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        Image.asset(
                          'assets/images/ic-drop-down.png',
                          width: 16,
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 250,
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              child: ChartItem(),
            ),
          ],
        ),
      ),
    );
  }
}
