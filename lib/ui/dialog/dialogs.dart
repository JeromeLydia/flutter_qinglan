import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_qinglan/res/colors.dart';
import 'package:flutter_qinglan/ui/pages/blue/demo/widgets.dart';
import 'package:flutter_qinglan/ui/pages/home/home_controller.dart';
import 'package:get/get.dart';
import '../../common/global.dart';
import '../../utils/snackbar.dart';

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
        showSnackbar('提示'.tr, title + '不能为空'.tr);
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

//选择弹框
void chooseDialog(String title, List<String> list, Function ok) {
  RxInt select = RxInt(0);

  List<Widget> getWidgets() {
    List<Widget> widgets = [];
    for (int i = 0; i < list.length; i++) {
      widgets.add(ListTileTheme(
        dense: true, // 设置为 true 可以让 ListTile 更加紧凑，使其高度更小
        child: RadioListTile(
          value: i,
          groupValue: select.value,
          onChanged: (value) {
            select.value = value!;
          },
          title: Text(list[i]),
        ),
      ));
    }
    return widgets;
  }

  Get.defaultDialog(
    title: title,
    content: Obx(() => Column(
          children: getWidgets(),
        )),
    confirm: Container(
      width: 80,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(5)),
      child: Text(
        '确定'.tr,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
    cancel: Container(
      width: 80,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: AppColors.contentColorRed,
          borderRadius: BorderRadius.circular(5)),
      child: Text(
        '取消'.tr,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
    onConfirm: () {
      ok(select.value);
      Get.back();
    },
    onCancel: () {
      Get.back();
    },
  );
}

//提醒弹框
void remindDialog(String des, Function ok) {
  Get.defaultDialog(
    title: '提示'.tr,
    content: Text(des),
    textConfirm: '确定'.tr,
    textCancel: '取消'.tr,
    confirmTextColor: Colors.white,
    cancelTextColor: Colors.blue,
    buttonColor: Colors.blue,
    onConfirm: () {
      ok();
      Get.back();
    },
    onCancel: () {
      Get.back();
    },
  );
}

//底部弹框
void bottomSheet(String title, List<String> list, Function ok) {
  RxInt select = RxInt(0);

  List<Widget> getWidgets() {
    List<Widget> widgets = [];
    for (int i = 0; i < list.length; i++) {
      widgets.add(ListTileTheme(
        dense: true, // 设置为 true 可以让 ListTile 更加紧凑，使其高度更小
        child: RadioListTile(
          value: i,
          groupValue: select.value,
          onChanged: (value) {
            select.value = value!;
          },
          title: Text(list[i]),
        ),
      ));
    }
    return widgets;
  }

  Get.bottomSheet(
    Column(
      children: getWidgets(),
    ),
  );
}

//提醒弹框
void selectDialog(BuildContext context, String title, Function ok) {
  RxString v = RxString("");
  Get.defaultDialog(
    title: title,
    content: InkWell(
      onTap: () {
        showTimePicker(context, (DateTime d) {
          v.value = "${d.hour}:${d.minute}:${d.second}";
          logger.d(v.value);
        });
      },
      child: Container(
        color: AppColors.gray_99,
        height: 50,
        margin: const EdgeInsets.only(left: 10, right: 10),
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => "" == v.value
                ? Text('选择日期'.tr)
                : Text(
                    v.value,
                    style: const TextStyle(color: Colors.black),
                  )),
            const Icon(Icons.arrow_right),
          ],
        ),
      ),
    ),
    textConfirm: '确定'.tr,
    textCancel: '取消'.tr,
    confirmTextColor: Colors.white,
    cancelTextColor: Colors.blue,
    buttonColor: Colors.blue,
    onConfirm: () {
      ok();
      Get.back();
    },
    onCancel: () {
      Get.back();
    },
  );
}

void showTimePicker(BuildContext context, Function confirm) {
  DatePicker.showTimePicker(context, showTitleActions: true, onChanged: (date) {
    logger.d('change $date in time zone ${date.timeZoneOffset.inHours}');
  }, onConfirm: (date) {
    confirm(date);
  }, currentTime: DateTime.now());
}
