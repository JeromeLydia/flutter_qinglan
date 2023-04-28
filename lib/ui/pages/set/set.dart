import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_qinglan/res/colors.dart';
import 'package:flutter_qinglan/ui/dialog/dialogs.dart';
import 'package:flutter_qinglan/ui/pages/set/setData.dart';
import 'package:flutter_qinglan/utils/snackbar.dart';
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
          onItemClick(context, homeController, index);
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
    var count = 3;
    if (Get.locale == const Locale('zh', 'CN')) {
      count = 3;
    } else {
      count = 2;
    }
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: GridView.builder(
                itemCount: setListData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: count,
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
                  child: Text('保存设置'.tr),
                  onPressed: () {
                    if (homeController.bluetoothDeviceState.value !=
                        BluetoothDeviceState.connected) {
                      showSnackbar('提示'.tr, '请先连接蓝牙'.tr);
                      return;
                    }
                    homeController.sendData(SET_SAVE);
                  },
                ),
              )),
        ],
      ),
    );
  }
}

void onItemClick(
    BuildContext context, HomeController homeController, int index) {
  if (index == 11) {
    languageDialog();
  } else {
    // if (homeController.bluetoothDeviceState.value !=
    //     BluetoothDeviceState.connected) {
    //   showSnackbar('提示'.tr, '请先连接蓝牙'.tr);
    //   return;
    // }
    switch (index) {
      case 0:
        inputDialog(
            "请输入充电过压值".tr, "${"数值范围".tr}:0.0-500.0", "${"单位".tr}:V", 0.0, 500.0,
            (double input) {
          homeController.sendData(SET_OVP, input: input);
        });
        break;
      case 1:
        inputDialog(
            "请输入放电欠压值".tr, "${"数值范围".tr}:0.0-500.0", "${"单位".tr}:V", 0.0, 500.0,
            (double input) {
          homeController.sendData(SET_LVP, input: input);
        });
        break;
      case 2:
        inputDialog(
            "请输入充电过流值".tr, "${"数值范围".tr}:0.0-500.0", "${"单位".tr}:A", 0.0, 500.0,
            (double input) {
          homeController.sendData(SET_OCP, input: input);
        });
        break;
      case 3:
        inputDialog(
            "请输入放电过流值".tr, "${"数值范围".tr}:0.0-500.0", "${"单位".tr}:A", 0.0, 500.0,
            (double input) {
          homeController.sendData(SET_NCP, input: input);
        });
        break;
      case 4:
        inputDialog(
            "请输入放电启动值".tr, "${"数值范围".tr}:0.0-500.0", "${"单位".tr}:V", 0.0, 500.0,
            (double input) {
          homeController.sendData(SET_STV, input: input);
        });
        break;
      case 5:
        inputDialog("请输入过温度保护值".tr, "${"数值范围".tr}:0.0-150.0", "${"单位".tr}:°C",
            0.0, 150.0, (double input) {
          homeController.sendData(SET_OTP, input: input);
        });
        break;
      case 6:
        inputDialog("请输入低温恢复值".tr, "${"数值范围".tr}:0.0-150.0", "${"单位".tr}:°C",
            0.0, 150.0, (double input) {
          homeController.sendData(SET_LTP, input: input);
        });
        break;
      case 7:
        inputDialog("请输入继电器延时".tr, "${"数值范围".tr}:0-200", "${"单位".tr}:秒", 0, 200,
            (double input) {
          homeController.sendData(SET_DEL, input: input);
        });
        break;
      case 8:
        chooseDialog(
            "请选择继电器模式".tr,
            ["工作模式一".tr, "工作模式二".tr, "工作模式三".tr, "工作模式四".tr, "工作模式五".tr],
            (int index) {});
        break;
      case 9:
        chooseDialog("请选择继电器模式".tr, ["常开".tr, "常闭".tr], (int index) {});
        break;
      case 10:
        chooseDialog("请选择继电器模式".tr, ["常开".tr, "常闭".tr], (int index) {});
        break;
      case 12:
        selectDialog(context, "请选择定时时间".tr, (int index) {});
        break;
      case 13:
        chooseDialog("请选择定时模式".tr, ["常开".tr, "常闭".tr], (int index) {});
        break;
      case 14:
        inputDialog("请输入放电电流系数微调".tr, "${"数值范围".tr}:0.50-1.50", "${"单位".tr}:倍",
            0.50, 1.50, (double input) {
          homeController.sendData(SET_DEL, input: input);
        });
        break;
      case 15:
        inputDialog("请输入放电电流系数微调".tr, "${"数值范围".tr}:0.50-1.50", "${"单位".tr}:秒",
            0.50, 1.50, (double input) {
          homeController.sendData(SET_DEL, input: input);
        });
        break;
      case 16:
        inputDialog("请输入通讯地址码".tr, "${"数值范围".tr}:0-40", "${"单位".tr}:秒", 0, 40,
            (double input) {
          homeController.sendData(SET_ADC, input: input);
        });
        break;
      case 17:
        inputDialog(
            "请输入电流归零值".tr, "${"数值范围".tr}:0.0-2.0", "${"单位".tr}:A", 0.0, 2.0,
            (double input) {
          homeController.sendData(SET_PAI, input: input);
        });
        break;
    }
  }
}
