import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../data/handler/api_handler.dart';
import '../../../data/handler/api_url.dart';
import '../../../utils/network_info.dart';

class ResetPassController extends GetxController {
  RxBool hidePassword = false.obs;
  RxBool hidePassword1 = false.obs;

  Rx<TextEditingController> passwordController1 =
      TextEditingController(text: kDebugMode ? "" : "").obs;

  Rx<TextEditingController> passwordController2 =
      TextEditingController(text: kDebugMode ? "" : "").obs;
  late final String email;
  late final String otp;
  @override
  void onInit() {
    super.onInit();
    email = Get.arguments["email"];
    otp = Get.arguments["otp"];
    log("otp $otp");

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  resetPassword() async {
    try {
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
          confirmationCode: otp);

      var body = {
        "name": "",
        "emailOrPhone": email,
        "dateofBirth": "",
        "password": passwordController1.value.text,
        "googleId": "",
        "facebookId": "",
        "deviceToken": "",
        "deviceType": ""
      };

      final response = await ApiHandler.post(
          url: ApiUrls.baseUrl + ApiUrls.resetPassword, body: body);

      Get.back();
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 203 ||
          response.statusCode == 204) {
        Get.snackbar("Success", "Password reset successfully");
        Get.offAllNamed(AppRoutes.loginScreen);
      } else {
        Get.snackbar(
          "Error",
          "Something went wrong. Please try again",
        );
      }
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
