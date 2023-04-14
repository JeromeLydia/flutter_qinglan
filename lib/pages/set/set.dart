import 'package:flutter/material.dart';
import 'package:flutter_qinglan/pages/set/setData.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  void _showDialog1() {
    showDialog(context: context, builder: _customDialog);
  }

  Widget _initGridVideData(context, index) {
    return Container(
      color: Colors.grey,
      child: InkWell(
        onTap: () {
          _showDialog1();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${setListData[index]["title"]}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              "${setListData[index]["desc"]}",
              style: const TextStyle(
                color: Colors.blue,
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
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 2),
                padding: const EdgeInsets.all(20),
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

Dialog _customDialog(context) {
  return Dialog(
    backgroundColor: Colors.yellow.shade100, // 背景色
    elevation: 4.0, // 阴影高度
    insetAnimationDuration: const Duration(milliseconds: 300), // 动画时间
    insetAnimationCurve: Curves.decelerate, // 动画效果
    insetPadding: const EdgeInsets.all(30), // 弹框距离屏幕边缘距离
    clipBehavior: Clip.none, // 剪切方式
    child: Container(
      width: 300,
      height: 300,
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        children: [
          const Text(
            "Custom Dialog",
            style: TextStyle(color: Colors.blue, fontSize: 25),
          ),
          const Padding(padding: EdgeInsets.all(15)),
          const Text("这是一个最简单的自定义 Custom Dialog"),
          const Padding(
            padding: EdgeInsets.all(15),
          ),
          TextButton(
            onPressed: () {
              // 隐藏弹框
              Navigator.pop(context, 'SimpleDialog - Normal, 我知道了');
            },
            child: const Text("我知道了"),
          ),
        ],
      ),
    ),
  );
}
