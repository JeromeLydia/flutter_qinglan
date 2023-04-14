import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ListView(
        children: const [
          Text(
            "电压/温度/电流/实时曲线图",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "查看历史数据",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
