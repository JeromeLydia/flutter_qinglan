import 'package:flutter/material.dart';
import 'package:flutter_qinglan/res/colors.dart';
import 'package:flutter_qinglan/res/strings.dart';
import 'package:flutter_qinglan/ui/pages/tabs.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'common/global.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var language = storage.read("language");
    logger.d("language: $language");
    var locale = language == null
        ? Get.deviceLocale
        : Locale(language.toString().split("_")[0],
            language.toString().split("_")[1]);
    logger.d("locale: $locale");
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // 移除右上角调试横幅
      translations: Messages(), //所有的国际化文案
      locale: locale, //默认语言
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
