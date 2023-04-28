import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qinglan/res/colors.dart';
import 'package:flutter_qinglan/ui/pages/blue/demo/widgets.dart';
import 'package:flutter_qinglan/ui/pages/home/home_controller.dart';
import 'package:get/get.dart';

import '../../common/global.dart';

//蓝牙扫描弹框
void scanDialog(BuildContext context, HomeController homeController) {
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

//输入弹框
void inputDialog(String title, String des1, String des2, double min, double max,
    Function ok) {
  String input = "";
  Get.defaultDialog(
    title: title,
    radius: 15.0,
    titleStyle: const TextStyle(color: Colors.white, fontSize: 18),
    backgroundColor: AppColors.gray_33,
    content: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 45,
          child: TextField(
            textAlign: TextAlign.start,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.isEmpty) return newValue;
                try {
                  final double value = double.parse(newValue.text);
                  if (value >= min && value <= max) return newValue;
                  if (value > max) {
                    return TextEditingValue(
                      text: max.toString(),
                      selection: const TextSelection.collapsed(offset: 6),
                    );
                  }
                  // ignore: empty_catches
                } catch (e) {}

                return oldValue;
              }),
            ],
            maxLines: 1,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
                hintText: title,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                filled: true,
                fillColor: AppColors.gray_66,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(style: BorderStyle.none))),
            onChanged: (value) => input = value,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Text(
          des1,
          style: const TextStyle(color: Colors.red, fontSize: 14),
        ),
        Text(
          des2,
          style: const TextStyle(color: Colors.red, fontSize: 14),
        )
      ],
    ),
    textConfirm: '确定',
    textCancel: '取消',
    confirmTextColor: Colors.white,
    cancelTextColor: Colors.blue,
    buttonColor: Colors.blue,
    onConfirm: () {
      if (input.isEmpty) {
        Get.snackbar('提示'.tr, title + '不能为空'.tr);
        return;
      }
      ok(double.parse(input));
      Get.back();
    },
    onCancel: () {
      Get.back();
    },
  );
}

//语言选择弹框
void languageDialog() {
  RxInt select = RxInt(0);
  if (Get.locale == const Locale('zh', 'CN')) {
    select.value = 0;
  } else {
    select.value = 1;
  }
  Get.defaultDialog(
    title: '选择语言'.tr,
    content: Obx(() => Column(
          children: [
            RadioListTile(
              value: 0,
              groupValue: select.value,
              onChanged: (value) {
                select.value = 0;
              },
              title: const Text('中文'),
            ),
            RadioListTile(
              value: 1,
              groupValue: select.value,
              onChanged: (value) {
                select.value = 1;
              },
              title: const Text('英文'),
            ),
          ],
        )),
    textConfirm: '确定'.tr,
    textCancel: '取消'.tr,
    confirmTextColor: Colors.white,
    cancelTextColor: Colors.blue,
    buttonColor: Colors.blue,
    onConfirm: () {
      if (select.value == 0) {
        storage.write('language', "zh_CN");
        Get.updateLocale(const Locale('zh', 'CN'));
      } else {
        storage.write('language', "en_US");
        Get.updateLocale(const Locale('en', 'US'));
      }
      Get.back();
    },
    onCancel: () {
      Get.back();
    },
  );
}
