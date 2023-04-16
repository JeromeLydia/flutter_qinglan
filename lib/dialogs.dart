import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_qinglan/pages/blue/widgets.dart';
import 'package:get/get.dart';

class CustomDialogs {
  void showDialog01(BuildContext context) {
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
                child: StreamBuilder<bool>(
                  stream: FlutterBluePlus.instance.isScanning,
                  initialData: false,
                  builder: (c, snapshot) {
                    if (snapshot.data!) {
                      return IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: () => FlutterBluePlus.instance.stopScan(),
                      );
                    } else {
                      return IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => FlutterBluePlus.instance
                              .startScan(timeout: const Duration(seconds: 4)));
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 200.0,
            child: RefreshIndicator(
              onRefresh: () => FlutterBluePlus.instance
                  .startScan(timeout: const Duration(seconds: 4)),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    StreamBuilder<List<ScanResult>>(
                      stream: FlutterBluePlus.instance.scanResults,
                      initialData: const [],
                      builder: (c, snapshot) => Column(
                        children: snapshot.data!
                            .map(
                              (r) => ScanResultTile(
                                result: r,
                                onTap: () => {},
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
