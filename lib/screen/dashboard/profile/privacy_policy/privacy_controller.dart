import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:velocity_x/velocity_x.dart';

class PrivacyController extends GetxController {
  final privacy = "".obs;
  final args = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    getPrivacy();
  }

  getPrivacy() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          Get.dialog(const CupertinoActivityIndicator().centered());
          final response = await ApiHandler.get(
            url: ApiUrls.baseUrl +
                (args == "help"
                    ? ApiUrls.helpSupport
                    : args == "terms"
                        ? ApiUrls.termsOfUse
                        : ApiUrls.privacy),
          );
          var decoded = jsonDecode(response.body);
          Get.back();
          if (response.statusCode == 200) {
            privacy.value = decoded["content"];
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            Get.offAllNamed(AppRoutes.loginScreen);
          } else {
            Get.back();
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      Get.back();
    }
  }
}
