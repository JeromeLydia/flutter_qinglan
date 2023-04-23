import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_qinglan/res/colors.dart';
import 'package:flutter_qinglan/ui/dialog/dialogs.dart';
import 'package:flutter_qinglan/ui/pages/set/setData.dart';
import 'package:get/get.dart';

import '../blue/cmd.dart';
import '../home/home_controller.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  HomeController homeController = Get.put(HomeController());
  Widget _initGridVideData(context, index) {
    return Container(
      color: AppColors.app_main,
      height: 200.0,
      child: InkWell(
        onTap: () {
          onItemClick(homeController, index);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${setListData[index]["title"]}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Text(
              setListData[index]["desc"].toString().tr,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: GridView.builder(
                itemCount: setListData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 2),
                padding: const EdgeInsets.all(10),
                itemBuilder: _initGridVideData),
          ),
          Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: MaterialButton(
                  color: Colors.blue,
                  minWidth: double.infinity,
                  height: 30.0,
                  textColor: Colors.white,
                  child: const Text('保存设置'),
                  onPressed: () {},
                ),
              )),
        ],
      ),
    );
  }
}

void onItemClick(HomeController homeController, int index) {
  switch (index) {
    case 0:
      if (homeController.bluetoothDeviceState.value !=
          BluetoothDeviceState.connected) {
        Get.snackbar('提示'.tr, '请先连接蓝牙'.tr);
        return;
      }
      inputDialog("请输入充电过压值", "数值范围:0.0-500.0", "单位:V", 0.0, 500.0,
          (double input) {
        homeController.sendData(SET_OVP, input: input);
      });
      break;
    case 1:
      if (homeController.bluetoothDeviceState.value !=
          BluetoothDeviceState.connected) {
        Get.snackbar('提示'.tr, '请先连接蓝牙'.tr);
        return;
      }
      inputDialog("请输入放电欠压值", "数值范围:0.0-500.0", "单位:V", 0.0, 500.0,
          (double input) {
        homeController.sendData(SET_LVP, input: input);
      });
      break;
    case 2:
      if (homeController.bluetoothDeviceState.value !=
          BluetoothDeviceState.connected) {
        Get.snackbar('提示'.tr, '请先连接蓝牙'.tr);
        return;
      }
      inputDialog("请输入充电过流值", "数值范围:0.0-500.0", "单位:A", 0.0, 500.0,
          (double input) {
        homeController.sendData(SET_OCP, input: input);
      });
      break;
    case 3:
      if (homeController.bluetoothDeviceState.value !=
          BluetoothDeviceState.connected) {
        Get.snackbar('提示'.tr, '请先连接蓝牙'.tr);
        return;
      }
      inputDialog("请输入放电过流值", "数值范围:0.0-500.0", "单位:A", 0.0, 500.0,
          (double input) {
        homeController.sendData(SET_NCP, input: input);
      });
      break;
    case 4:
      if (homeController.bluetoothDeviceState.value !=
          BluetoothDeviceState.connected) {
        Get.snackbar('提示'.tr, '请先连接蓝牙'.tr);
        return;
      }
      inputDialog("请输入放电启动值", "数值范围:0.0-500.0", "单位:V", 0.0, 500.0,
          (double input) {
        homeController.sendData(SET_STV, input: input);
      });
      break;
    case 5:
      if (homeController.bluetoothDeviceState.value !=
          BluetoothDeviceState.connected) {
        Get.snackbar('提示'.tr, '请先连接蓝牙'.tr);
        return;
      }
      inputDialog("请输入过温度保护值", "数值范围:0.0-150.0", "单位:°C", 0.0, 150.0,
          (double input) {
        homeController.sendData(SET_OTP, input: input);
      });
      break;
    case 6:
      if (homeController.bluetoothDeviceState.value !=
          BluetoothDeviceState.connected) {
        Get.snackbar('提示'.tr, '请先连接蓝牙'.tr);
        return;
      }
      inputDialog("请输入低温恢复值", "数值范围:0.0-150.0", "单位:°C", 0.0, 150.0,
          (double input) {
        homeController.sendData(SET_LTP, input: input);
      });
      break;
    case 7:
      if (homeController.bluetoothDeviceState.value !=
          BluetoothDeviceState.connected) {
        Get.snackbar('提示'.tr, '请先连接蓝牙'.tr);
        return;
      }
      inputDialog("请输入继电器延时", "数值范围:0-200", "单位:秒", 0, 200, (double input) {
        homeController.sendData(SET_DEL, input: input);
      });
      break;
    case 8:
      break;
    case 9:
      break;
    case 10:
      break;
    case 11:
      languageDialog();
      break;
    case 12:
      break;
    case 13:
      break;
    case 14:
      if (homeController.bluetoothDeviceState.value !=
          BluetoothDeviceState.connected) {
        Get.snackbar('提示'.tr, '请先连接蓝牙'.tr);
        return;
      }
      inputDialog("请输入放电电流系数微调", "数值范围:0.50-1.50", "单位:倍", 0.50, 1.50,
          (double input) {
        homeController.sendData(SET_DEL, input: input);
      });
      break;
    case 15:
      if (homeController.bluetoothDeviceState.value !=
          BluetoothDeviceState.connected) {
        Get.snackbar('提示'.tr, '请先连接蓝牙'.tr);
        return;
      }
      inputDialog("请输入放电电流系数微调", "数值范围:0.50-1.50", "单位:秒", 0.50, 1.50,
          (double input) {
        homeController.sendData(SET_DEL, input: input);
      });
      break;
    case 16:
      if (homeController.bluetoothDeviceState.value !=
          BluetoothDeviceState.connected) {
        Get.snackbar('提示'.tr, '请先连接蓝牙'.tr);
        return;
      }
      inputDialog("请输入通讯地址码", "数值范围:0-40", "单位:秒", 0, 40, (double input) {
        homeController.sendData(SET_ADC, input: input);
      });
      break;
    case 17:
      if (homeController.bluetoothDeviceState.value !=
          BluetoothDeviceState.connected) {
        Get.snackbar('提示'.tr, '请先连接蓝牙'.tr);
        return;
      }
      inputDialog("请输入电流归零值", "数值范围:0.0-2.0", "单位:A", 0.0, 2.0, (double input) {
        homeController.sendData(SET_PAI, input: input);
      });
      break;
  }
}

void showDialog01() {
  Get.defaultDialog(
    title: '请输入充电过压值'.tr,
    content: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: '请输入充电过压值'.tr,
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Text("数值范围:0.0-500.0".tr),
        Text("单位:V".tr)
      ],
    ),
    textConfirm: '确定',
    textCancel: '取消',
    confirmTextColor: Colors.white,
    cancelTextColor: Colors.blue,
    buttonColor: Colors.blue,
    onConfirm: () {
      Get.back();
    },
    onCancel: () {
      Get.back();
    },
  );
}
