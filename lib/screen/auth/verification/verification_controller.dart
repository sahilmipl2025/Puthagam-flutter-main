import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../utils/app_routes.dart';
import '../../../utils/network_info.dart';

class VerificationController extends GetxController {
  RxBool hidePassword = false.obs;
  RxBool hidePassword1 = false.obs;

  Rx<TextEditingController> passwordController1 =
      TextEditingController(text: kDebugMode ? "" : "").obs;

  Rx<TextEditingController> passwordController2 =
      TextEditingController(text: kDebugMode ? "" : "").obs;

  TextEditingController otpController = TextEditingController();
  late final String email;
  @override
  void onInit() {
    super.onInit();
    email = Get.arguments;
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  resetPassword() async {
    try {
      if (otpController.text.isEmpty) {
        Get.snackbar(
          "Error",
          "OTP required",
        );
        return;
      }
      if (passwordController1.value.text.isBlank == true ||
          passwordController2.value.text.isBlank == true) {
        Get.snackbar(
          "Error",
          "Fields required",
        );
        return;
      }
      if (passwordController1.value.text != passwordController2.value.text) {
        Get.snackbar(
          "Error",
          "Password doesn't match",
        );
        return;
      }
      if (passwordController1.value.text.length < 10) {
        Get.snackbar(
          "Error",
          "Password is not long enough min 10 characters is required",
          backgroundColor: Colors.red,
        );
        return;
      }
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (!connection) {
        Get.snackbar(
          "Error",
          "You're not connected to interent",
        );
        return;
      }
      Get.dialog(
          const CupertinoActivityIndicator()
              .p(10)
              .box
              .white
              .roundedFull
              .make()
              .centered(),
          barrierDismissible: false);
      await Amplify.Auth.confirmResetPassword(
          username: email,
          newPassword: passwordController1.value.text,
          confirmationCode: otpController.text);

      Get.back();
      Get.snackbar("Success", "Password reset successfully");
      Get.offAllNamed(AppRoutes.loginScreen);
    } on AmplifyException catch (err) {
      Get.back();
      Get.snackbar(
        "Error",
        err.message,
      );
      log("err $err");
    } catch (err) {
      Get.back();
      log("err $err");
    }
  }
}
