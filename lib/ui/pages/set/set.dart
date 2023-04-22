import 'package:flutter/material.dart';
import 'package:flutter_qinglan/res/colors.dart';
import 'package:flutter_qinglan/ui/pages/set/setData.dart';
import 'package:get/get.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Widget _initGridVideData(context, index) {
    return Container(
      color: AppColors.app_main,
      height: 200.0,
      child: InkWell(
        onTap: () {
          onItemClick(index);
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

void onItemClick(int index) {
  switch (index) {
    case 0:
      showDialog01();
      break;
    case 1:
      break;
    case 2:
      break;
    case 3:
      break;
    case 4:
      break;
    case 5:
      break;
    case 6:
      break;
    case 7:
      break;
    case 8:
      break;
    case 9:
      break;
    case 10:
      break;
    case 11:
      showLanguageDialog();
      break;
    case 12:
      break;
    case 13:
      break;
    case 14:
      break;
    case 15:
      break;
    case 16:
      break;
    case 17:
      break;
    case 18:
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

void showLanguageDialog() {
  RxInt select = RxInt(0);
  Get.defaultDialog(
    title: '选择语言',
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
    textConfirm: '确定',
    textCancel: '取消',
    confirmTextColor: Colors.white,
    cancelTextColor: Colors.blue,
    buttonColor: Colors.blue,
    onConfirm: () {
      if (select.value == 0) {
        Get.updateLocale(const Locale('zh', 'CN'));
      } else {
        Get.updateLocale(const Locale('en', 'US'));
      }
      Get.back();
    },
    onCancel: () {
      Get.back();
    },
  );
}
