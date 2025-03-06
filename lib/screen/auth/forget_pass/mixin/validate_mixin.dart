import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../signup/signup_screen.dart';

void handleError(AmplifyException err) {
  if (Get.isDialogOpen == true) {
    Get.back();
  }
  log("err $err");
  Get.snackbar("Error", err.message, backgroundColor: Colors.red);
}

mixin ValidateMixin {
  Rx<TextEditingController> emailController = TextEditingController().obs;
  RxBool emailValid = false.obs;
  RxBool emailValid1 = false.obs;
  RxBool passValid = false.obs;
  RxBool passValid1 = false.obs;

  RxBool cPassValid = false.obs;
  RxBool cPassValid1 = false.obs;

  RxBool hidePassword = false.obs;
  RxBool hidePassword1 = false.obs;

  Rx<TextEditingController> passwordController1 = TextEditingController().obs;

  Rx<TextEditingController> passwordController2 = TextEditingController().obs;
  final TextEditingController otpController = TextEditingController();

  Future<bool> validateInput() async {
    if (emailController.value.text.isBlank == true) {
      emailValid.value = true;
      return false;
    } else {
      emailValid.value = false;
    }

    if (!GetUtils.isEmail(emailController.value.text.trim())) {
      emailValid1.value = true;
      return false;
    } else {
      emailValid1.value = false;
    }

    if (passwordController1.value.text.isBlank == true) {
      passValid.value = true;
      return false;
    } else {
      passValid.value = false;
    }

    if (passwordController1.value.text.length < 10) {
      passValid1.value = true;
      return false;
    } else {
      passValid1.value = false;
    }

    if (passwordController2.value.text.isBlank == true) {
      cPassValid.value = true;
      return false;
    } else {
      cPassValid.value = false;
    }

    if (passwordController1.value.text != passwordController2.value.text) {
      cPassValid1.value = true;
      return false;
    } else {
      cPassValid1.value = false;
    }

    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (!connection) {
      Get.snackbar(
        "Error",
        "You're not connected to interent",
      );
      return false;
    }
    return true;
  }
}

void askForOTP(TextEditingController otpController, Function(String) onDone) {
  Get.bottomSheet(
    BuildBottomSheet(
      onPressed: ((p0) {
        onDone(p0);
      }),
      otpController: otpController,
    ),
    backgroundColor: Get.isDarkMode == false ? Vx.white : Vx.black,
  );
}
