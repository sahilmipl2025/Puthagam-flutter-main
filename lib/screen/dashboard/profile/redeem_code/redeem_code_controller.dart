import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RedeemCodeController extends GetxController {
  RxBool showLoader = false.obs;
  RxString currentText = "".obs;
  final formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  Rx<TextEditingController> textEditingController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    errorController = StreamController<ErrorAnimationType>();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    errorController!.close();
  }
}
