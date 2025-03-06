import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressDialogUtils {
  static bool isProgressVisible = false;

  ///common method for showing progress dialog
  static void showProgressDialog({isCancellable = false}) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
        ),
      ),
      barrierDismissible: isCancellable,
    );
  }

  ///common method for hiding progress dialog
  static void hideProgressDialog() {
    Get.back();
  }
}
