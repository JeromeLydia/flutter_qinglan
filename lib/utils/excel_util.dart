import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter_qinglan/common/global.dart';
import 'package:flutter_qinglan/ui/pages/blue/message_data.dart';
import 'package:path_provider/path_provider.dart';

Future<void> excel_export(Map<DateTime, MessageData> mapList) async {
  var excel = Excel.createExcel(); // 创建Excel对象
  var sheet = excel['Sheet1']; // 获取第一个sheet
  sheet.appendRow(['时间', '电压', "电流", "温度"]); // 添加表头
  mapList.forEach((key, value) {
    // 添加数据行
    sheet.appendRow([key, value.voltage, value.current, value.temperature]);
  });
  sheet.appendRow([]);
  // 创建文件对象
  var file = await _getLocalDocumentFile("qingdan.xlsx");
  logger.d("文件路径file: ${file.path}");
  // 将Excel数据写入文件
  var data = await file.writeAsBytes(excel.encode()!);
  logger.d("文件路径data: ${data.path}");
}

/// 获取文档目录文件
Future<File> _getLocalDocumentFile(String name) async {
  if (Platform.isIOS) {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$name');
  } else {
    final dir = await getExternalStorageDirectory();
    if (dir == null) {
      final dir = await getApplicationDocumentsDirectory();
      return File('${dir.path}/$name');
    }
    return File('${dir.path}/$name');
  }
}
