import 'package:flutter/material.dart';
import 'package:flutter_qinglan/res/colors.dart';
import 'package:flutter_qinglan/res/strings.dart';
import 'package:flutter_qinglan/ui/pages/tabs.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Get.deviceLocale, //跟随手机系统语言
      translations: Messages(), //所有的国际化文案
      fallbackLocale: const Locale("en", "US"), //默认语言
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: AppColors.app_main,
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          unselectedItemColor: Colors.white,
        ),
      ),
      home: const Tabs(),
    );
  }
}
