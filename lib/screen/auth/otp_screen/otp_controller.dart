import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/auth/forget_pass/mixin/create_account_mixin.dart';
import 'package:puthagam/screen/auth/forget_pass/mixin/forget_password_mixin.dart';

import '../forget_pass/mixin/validate_mixin.dart';

class OtpController extends GetxController
    with ForgetPasswordMixin, CreateAccountMixin, ValidateMixin {
  // ignore: annotate_overrides
  TextEditingController otpController = TextEditingController();
  final seconds = 30.obs;

  resendOTP() {}

  timer() async {
    seconds.value = 30;
    while (seconds.value != 0) {
      await Future.delayed(const Duration(seconds: 1));
      seconds.value--;
    }
  }
}
