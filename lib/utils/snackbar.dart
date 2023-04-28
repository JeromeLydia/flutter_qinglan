import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar(String title, String message) {
  Get.snackbar(title, message,
      colorText: Colors.white, backgroundColor: Colors.red);
}

void showToast(String message) {}
