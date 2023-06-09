import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

void showSnackbar(String title, String message) {
  Get.snackbar(title, message,
      colorText: Colors.white, backgroundColor: Colors.red);
}

void cancelSnackbar(String message) {
  Get.back();
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

void cancelToast(String message) {
  Fluttertoast.cancel();
}
