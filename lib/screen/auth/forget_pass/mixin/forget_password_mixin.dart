import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/podcaster/core/widgets/build_loading.dart';
import 'package:puthagam/screen/auth/forget_pass/mixin/validate_mixin.dart';

import '../../../../utils/app_routes.dart';

mixin ForgetPasswordMixin {
  String emaill = "";
  String passwordd = "";
  sendOTPForReset(String email, String password,
      TextEditingController otpController) async {
    try {
      emaill = email;
      passwordd = password;
      buildDialogLoadingIndicator();
      await Amplify.Auth.resetPassword(
        username: email,
      );
      Get.back();
      Get.snackbar("Success", "OTP sent to $email",
          colorText: Colors.white, backgroundColor: Colors.green);
      Get.toNamed(AppRoutes.otpScreen, arguments: {"type": "reset"});
    } on AmplifyException catch (err) {
      handleError(err);
    }
  }

  confirmReset(String otp) async {
    try {
      buildDialogLoadingIndicator();
      await Amplify.Auth.confirmResetPassword(
          username: emaill, newPassword: passwordd, confirmationCode: otp);
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
