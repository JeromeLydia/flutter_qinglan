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
    title: "连接蓝牙".tr,
    radius: 15.0,
    titleStyle: const TextStyle(color: Colors.white, fontSize: 18),
    titlePadding: const EdgeInsets.only(top: 20, left: 10, right: 10),
    backgroundColor: AppColors.gray_33,
    content: Column(
      children: [
        SizedBox(
          height: 200.0,
          child: RefreshIndicator(
            onRefresh: () => homeController.startScan(),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Obx(
                    () => homeController.scanResult.isEmpty
                        ? Container(
                            margin: const EdgeInsets.only(top: 90),
                            child: Text('暂未找到设备'.tr,
                                style: const TextStyle(color: Colors.white)),
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
        Obx(() => homeController.isScanning.value
            ? ElevatedButton(
                child: Text("停止搜索".tr),
                onPressed: () => homeController.stopScan(),
              )
            : ElevatedButton(
                child: Text("搜索".tr),
                onPressed: () => homeController.startScan()))
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
    titlePadding: const EdgeInsets.only(top: 20, left: 10, right: 10),
    backgroundColor: AppColors.gray_33,
    content: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(top: 10)),
        TextField(
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
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
              filled: true,
              fillColor: AppColors.gray_66,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(style: BorderStyle.none))),
          onChanged: (value) => input = value,
        ),
        const Padding(padding: EdgeInsets.only(top: 5)),
        Container(
          margin: const EdgeInsets.only(left: 6),
          child: Text(
            des1,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 6, bottom: 10),
          child: Text(
            des2,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    ),
    confirm: InkWell(
      onTap: () {
        if (input.isEmpty) {
          showSnackbar('提示'.tr, title + '不能为空'.tr);
          return;
        }
        ok(double.parse(input));
        Get.back();
      },
      child: Container(
        width: 80,
        height: 40,
        margin: const EdgeInsets.only(left: 10, bottom: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.contentColorBlue,
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          '确定'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ),
    cancel: InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        width: 80,
        height: 40,
        margin: const EdgeInsets.only(right: 10, bottom: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFE7C7C), Color(0xFFFF4B4B)],
            ),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          '取消'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ),
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
    radius: 15.0,
    titleStyle: const TextStyle(color: Colors.white, fontSize: 18),
    backgroundColor: AppColors.gray_33,
    titlePadding: const EdgeInsets.only(top: 20, left: 10, right: 10),
    content: Obx(() => Column(
          children: [
            ListTileTheme(
              dense: true, // 设置为 true 可以让 ListTile 更加紧凑，使其高度更小
              child: Theme(
                data: ThemeData(
                  unselectedWidgetColor: Colors.white,
                ),
                child: RadioListTile(
                  value: 0,
                  groupValue: select.value,
                  onChanged: (value) {
                    select.value = 0;
                  },
                  title:
                      const Text('中文', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            ListTileTheme(
              dense: true, // 设置为 true 可以让 ListTile 更加紧凑，使其高度更小
              child: Theme(
                data: ThemeData(
                  unselectedWidgetColor: Colors.white,
                ),
                child: RadioListTile(
                  value: 1,
                  groupValue: select.value,
                  onChanged: (value) {
                    select.value = 1;
                  },
                  title:
                      const Text('英文', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        )),
    confirm: InkWell(
      onTap: () {
        if (select.value == 0) {
          storage.write('language', "zh_CN");
          Get.updateLocale(const Locale('zh', 'CN'));
        } else {
          storage.write('language', "en_US");
          Get.updateLocale(const Locale('en', 'US'));
        }
        Get.back();
      },
      child: Container(
        width: 80,
        height: 40,
        margin: const EdgeInsets.only(left: 10, bottom: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.contentColorBlue,
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          '确定'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ),
    cancel: InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        width: 80,
        height: 40,
        margin: const EdgeInsets.only(right: 10, bottom: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFE7C7C), Color(0xFFFF4B4B)],
            ),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          '取消'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ),
  );
}

//选择弹框
void chooseDialog(String title, List<String> list, Function ok) {
  RxInt select = RxInt(0);
  List<Widget> getWidgets() {
    List<Widget> widgets = [];
    for (int i = 0; i < list.length; i++) {
      widgets.add(
        ListTileTheme(
          dense: true, // 设置为 true 可以让 ListTile 更加紧凑，使其高度更小
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.white,
            ),
            child: RadioListTile(
              value: i,
              groupValue: select.value,
              onChanged: (value) {
                select.value = value!;
              },
              // 选中时的颜色
              activeColor: AppColors.contentColorBlue,
              //未选中时的颜色
              selectedTileColor: Colors.red,
              title: Text(list[i],
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  Get.defaultDialog(
    backgroundColor: AppColors.gray_33,
    title: title,
    titleStyle: const TextStyle(color: Colors.white, fontSize: 18),
    titlePadding: const EdgeInsets.only(top: 20, left: 10, right: 10),
    content: Obx(() => Column(
          children: getWidgets(),
        )),
    confirm: InkWell(
      onTap: () {
        ok(select.value);
        Get.back();
      },
      child: Container(
        width: 80,
        height: 40,
        margin: const EdgeInsets.only(left: 10, bottom: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.contentColorBlue,
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          '确定'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ),
    cancel: InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        width: 80,
        height: 40,
        margin: const EdgeInsets.only(right: 10, bottom: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFE7C7C), Color(0xFFFF4B4B)],
            ),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          '取消'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ),
  );
}

//提醒弹框
void remindDialog(String des, Function ok) {
  Get.defaultDialog(
    title: '提示'.tr,
    titleStyle: const TextStyle(color: Colors.white, fontSize: 18),
    titlePadding: const EdgeInsets.only(top: 20, left: 10, right: 10),
    backgroundColor: AppColors.gray_33,
    content: Text(des, style: const TextStyle(color: Colors.white)),
    contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 20),
    confirm: InkWell(
      onTap: () {
        ok();
        Get.back();
      },
      child: Container(
        width: 80,
        height: 40,
        margin: const EdgeInsets.only(left: 10, top: 10, bottom: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.contentColorBlue,
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          '确定'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ),
    cancel: InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        width: 80,
        height: 40,
        margin: const EdgeInsets.only(right: 10, top: 10, bottom: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFE7C7C), Color(0xFFFF4B4B)],
            ),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          '取消'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ),
  );
}

//底部弹框
void bottomSheet(List<String> list, Function ok) {
  RxInt select = RxInt(0);
  List<Widget> getWidgets() {
    List<Widget> widgets = [];
    for (int i = 0; i < list.length; i++) {
      widgets.add(
        InkWell(
            onTap: () {
              ok(i);
              Get.back();
            },
            child: Column(
              children: [
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    list[i],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                if (i != list.length - 1)
                  Container(
                    height: 0.5,
                    color: Colors.grey,
                  ),
              ],
            )),
      );
    }
    return widgets;
  }

  Get.bottomSheet(
    Container(
      //圆角
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: 360,
      child: Column(
        children: getWidgets(),
      ),
    ),
    isDismissible: true,
  );
}

//二次选择弹框
void selectDialog(BuildContext context, String title, Function ok) {
  RxString v = RxString("");
  var count = 0;
  Get.defaultDialog(
    title: title,
    backgroundColor: AppColors.gray_33,
    titleStyle: const TextStyle(color: Colors.white, fontSize: 18),
    titlePadding: const EdgeInsets.only(top: 20, left: 10, right: 10),
    content: InkWell(
      onTap: () {
        showTimePicker(context, (DateTime d) {
          v.value =
              "${d.hour}${"时".tr}${d.minute}${"分".tr}${d.second}${"秒".tr}";
          count = d.hour * 3600 + d.minute * 60 + d.second;
          logger.d(v.value);
        });
      },
      child: Container(
        color: AppColors.gray_66,
        height: 40,
        margin: const EdgeInsets.only(
          top: 20,
          left: 10,
          right: 10,
          bottom: 10,
        ),
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => "" == v.value
                ? Text(
                    '选择日期'.tr,
                    style: const TextStyle(color: Colors.white),
                  )
                : Text(
                    v.value,
                    style: const TextStyle(color: Colors.white),
                  )),
            const Icon(Icons.arrow_right, color: Colors.white),
          ],
        ),
      ),
    ),
    confirm: InkWell(
      onTap: () {
        ok(count);
        Get.back();
      },
      child: Container(
        width: 80,
        height: 40,
        margin: const EdgeInsets.only(left: 10, bottom: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.contentColorBlue,
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          '确定'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ),
    cancel: InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        width: 80,
        height: 40,
        margin: const EdgeInsets.only(right: 10, bottom: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFE7C7C), Color(0xFFFF4B4B)],
            ),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          '取消'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ),
  );
}

void showTimePicker(BuildContext context, Function confirm) {
  DatePicker.showTimePicker(context, showTitleActions: true, onChanged: (date) {
    logger.d('change $date in time zone ${date.timeZoneOffset.inHours}');
  }, onConfirm: (date) {
    confirm(date);
  }, currentTime: DateTime.now());
}
