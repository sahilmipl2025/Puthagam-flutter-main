import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/notification/notification_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

readNotificationApi({required String notificationId}) async {
  NotificationListController con = Get.put(NotificationListController());

  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        // con.showLoading.value = true;

        http.Response response = await ApiHandler.patch(
          url:
              "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Notification/$notificationId/false",
        );

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          con.notificationList
              .firstWhere((element) => element.id == notificationId)
              .isRead!
              .value = true;
          baseController!.notificationCount.value =
              baseController!.notificationCount.value - 1;
          con.update();
          // con.showLoading.value = false;
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          // con.showLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['message'], false);
        } else {
          // con.showLoading.value = false;
          toast(decoded['message'], false);
        }
      }
    } else {
      // con.showLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    con.showLoading.value = false;
  } finally {
    con.showLoading.value = false;
  }
}
