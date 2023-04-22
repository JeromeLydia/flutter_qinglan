import 'package:flutter/material.dart';
import 'package:flutter_qinglan/ui/pages/blue/demo/widgets.dart';
import 'package:flutter_qinglan/ui/pages/home/home_controller.dart';
import 'package:get/get.dart';

class CustomDialogs {
  void showDialog01(BuildContext context, HomeController homeController) {
    Get.defaultDialog(
      title: "连接蓝牙",
      content: Column(
        children: [
          Stack(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("连接蓝牙"),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GetBuilder<HomeController>(
                  builder: (homeController) {
                    if (homeController.isScanning.value) {
                      return IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: () => homeController.stopScan(),
                      );
                    } else {
                      return IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => homeController.startScan());
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 200.0,
            child: RefreshIndicator(
              onRefresh: () => homeController.startScan(),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Obx(
                      () => homeController.scanResult.isEmpty
                          ? const Center(
                              child: Text('No devices found'),
                            )
                          : Column(
                              children: homeController.scanResult
                                  .map(
                                    (r) => ScanResultTile(
                                      result: r,
                                      connect: () =>
                                          homeController.connect(r.device),
                                      disconnect: () =>
                                          homeController.disconnect(r.device),
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
