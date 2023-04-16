import 'package:flutter/material.dart';
import 'package:flutter_qinglan/pages/chart/chart.dart';
import 'package:flutter_qinglan/pages/home/home.dart';
import 'package:flutter_qinglan/pages/set/set.dart';
import 'package:get/get_utils/get_utils.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  static const pages = [Home(), Chart(), Setting()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("库仑计".tr),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => {
          setState(() {
            _currentIndex = index;
          })
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: "首页".tr),
          BottomNavigationBarItem(
              icon: const Icon(Icons.home), label: "曲线图".tr),
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: "设置".tr),
        ],
      ),
    );
  }
}
