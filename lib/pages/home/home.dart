import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: IconItem(
                  title: "电压".tr,
                  value: "12.23V",
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: IconItem(
                  title: "电流",
                  value: "2.92A",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Expanded(
                child: IconItem(
                  title: "功率",
                  value: "12.23V",
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: IconItem(
                  title: "温度",
                  value: "2.92A",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Expanded(
                child: IconItem(
                  title: "剩余电量",
                  value: "12.23V",
                ),
              ),
              Expanded(
                child: IconItem(
                  title: "剩余容量",
                  value: "2.92A",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const Text(
                      "充满需用时:",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: MaterialButton(
                        color: Colors.blue,
                        minWidth: double.infinity,
                        height: 50.0,
                        textColor: Colors.white,
                        child: const Text('保存设置'),
                        onPressed: () {
                          _customDialog(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: MaterialButton(
                        color: Colors.blue,
                        minWidth: double.infinity,
                        height: 50.0,
                        textColor: Colors.white,
                        child: const Text('电流清零'),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: MaterialButton(
                        color: Colors.blue,
                        minWidth: double.infinity,
                        height: 50.0,
                        textColor: Colors.white,
                        child: const Text('数据清零'),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: MaterialButton(
                        color: Colors.blue,
                        minWidth: double.infinity,
                        height: 50.0,
                        textColor: Colors.white,
                        child: const Text('余量设定'),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: MaterialButton(
                        color: Colors.blue,
                        minWidth: double.infinity,
                        height: 50.0,
                        textColor: Colors.white,
                        child: const Text('容量预设'),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Expanded(
                child: IconItem(
                  title: "累计容量",
                  value: "12.23V",
                ),
              ),
              Expanded(
                child: IconItem(
                  title: "运行时间",
                  value: "2.92A",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Expanded(
                child: SwitchItem(
                  title: "充电",
                  isOpen: false,
                ),
              ),
              Expanded(
                child: SwitchItem(
                  title: "放电",
                  isOpen: false,
                ),
              ),
              Expanded(
                child: SwitchItem(
                  title: "定时",
                  isOpen: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IconItem extends StatefulWidget {
  final String title;
  final String value;
  const IconItem({
    super.key,
    this.title = "",
    this.value = "",
  });

  @override
  State<IconItem> createState() => _IconItemState();
}

class _IconItemState extends State<IconItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.0,
      width: 300.0,
      color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.home),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                widget.value,
                style: const TextStyle(
                  color: Colors.blue,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SwitchItem extends StatefulWidget {
  final String title;
  final bool isOpen;
  const SwitchItem({
    super.key,
    this.title = "",
    this.isOpen = false,
  });

  @override
  State<SwitchItem> createState() => _SwitchItemState();
}

class _SwitchItemState extends State<SwitchItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Column(
        children: [
          Switch(
              value: widget.isOpen,
              onChanged: (value) {
                setState(() {});
              }),
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.blue,
            ),
          )
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
