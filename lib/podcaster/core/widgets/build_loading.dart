import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

buildLoadingIndicator({Color? bColor}) {
  return const CupertinoActivityIndicator()
      .p(10)
      .box
      .color(buttonColor)
      .roundedFull
      .make()
      .centered();
}

buildDialogLoadingIndicator({Color? bColor}) {
  return Get.dialog(buildLoadingIndicator(bColor: bColor),
      barrierDismissible: false);
}
