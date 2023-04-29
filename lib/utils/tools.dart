import 'package:flutter_qinglan/common/global.dart';

List<int> intToByte(int integer, int len) {
  List<int> arr = str2Bytes(toHex(integer));
  int arrLen = arr.length;
  if (arrLen < len) {
    for (int i = 0; i < len - arrLen; i++) {
      arr.insert(0, 0);
    }
  }
  return arr;
}

String toHex(int num) {
  if (num <= 255) {
    String hex = num.toRadixString(16).padLeft(2, '0');
    return hex.substring(hex.length - 2).toUpperCase();
  } else {
    String str = num.toRadixString(16);
    if (str.length == 3 ||
        str.length == 5 ||
        str.length == 7 ||
        str.length == 9) {
      return '0$str';
    } else {
      return str;
    }
  }
}

List<int> str2Bytes(String str) {
  int pos = 0;
  int len = str.length;
  if (len % 2 != 0) {
    return [];
  }
  len ~/= 2;
  List<int> hexA = [];
  for (int i = 0; i < len; i++) {
    String s = str.substring(pos, pos + 2);
    int v = int.parse(s, radix: 16);
    hexA.add(v);
    pos += 2;
  }
  return hexA;
}
