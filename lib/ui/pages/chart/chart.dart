import 'package:flutter/material.dart';
import 'package:flutter_qinglan/ui/pages/chart/line_chart.dart';
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
                      'assets/images/ic-start.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("启动记录".tr),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  ElevatedButton(
                    onPressed: () {},
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
                      bottomSheet(
                        [
                          "半小时",
                          "1小时",
                          "2小时",
                          "3小时",
                          "5小时",
                          "10小时",
                          "取消",
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
                                ? "半小时"
                                : _currentIndex.value == 1
                                    ? "1小时"
                                    : _currentIndex.value == 2
                                        ? "2小时"
                                        : _currentIndex.value == 3
                                            ? "3小时"
                                            : _currentIndex.value == 4
                                                ? "5小时"
                                                : _currentIndex.value == 5
                                                    ? "10小时"
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
