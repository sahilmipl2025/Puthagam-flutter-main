import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ResetController extends GetxController {
  Rx<TextEditingController> oldPass = TextEditingController().obs;
  Rx<TextEditingController> newPass = TextEditingController().obs;
  Rx<TextEditingController> cPass = TextEditingController().obs;

  RxBool showOldPass = false.obs;
  RxBool showNewPass = false.obs;
  RxBool showCNewPass = false.obs;
  RxBool oldValid = true.obs;
  RxBool newValid = true.obs;
  RxBool cValid = true.obs;
  RxBool isLoading = false.obs;
}
