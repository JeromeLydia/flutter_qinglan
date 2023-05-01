import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qinglan/res/colors.dart';
import 'package:flutter_qinglan/res/strings.dart';
import 'package:flutter_qinglan/ui/pages/tabs.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          primaryColorDark: Colors.blue,
          accentColor: Colors.blue,
          cardColor: Colors.white,
          backgroundColor: AppColors.pageBackground,
          errorColor: Colors.red,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.pageBackground,
          foregroundColor: AppColors.mainTextColor1,
          systemOverlayStyle: SystemUiOverlayStyle.light, // 状态栏文字颜色为白色
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          unselectedItemColor: AppColors.mainTextColor1,
          backgroundColor: AppColors.pageBackground,
        ),
        textTheme: GoogleFonts.assistantTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: AppColors.mainTextColor1,
              ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(AppColors.mainTextColor1),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.app_btn;
            }
            return Colors.grey; // 关闭时的背景颜色
          }),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
          overlayColor: MaterialStateProperty.all(AppColors.mainTextColor1),
          splashRadius: 10,
          thumbIcon: MaterialStateProperty.all(
            const Icon(
              Icons.circle,
              size: 16,
              color: AppColors.mainTextColor1,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.app_btn),
            foregroundColor:
                MaterialStateProperty.all(AppColors.mainTextColor1),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.borderColor,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: const Tabs(),
    );
  }
}
