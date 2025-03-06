import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:puthagam/utils/colors.dart';

toast(message, success) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 120,
    backgroundColor: success == false ? redColor : greenColor,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}
