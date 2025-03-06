import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/model/notification/get_notification_model.dart';
import 'package:puthagam/screen/dashboard/notification/notification_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

getNotificationsApi({pagination}) async {
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
        con.isConnected.value = true;
        if (pagination == true) {
          con.paginationLoading.value = true;
        } else {
          con.isLoading.value = true;
          con.notificationList.clear();
          con.page.value = 0;
          con.nextPageStop.value = false;
        }

        http.Response response = await ApiHandler.get(
          url:
              "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Notification/${con.page.value}/15",
        );

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          var decoded = getNotificationModelFromJson(response.body);

          if (decoded.data!.isNotEmpty) {
            for (var element in decoded.data!) {
              con.notificationList.add(element);
            }
            con.page.value++;
          }

          if (con.notificationList.length.toString() ==
              decoded.status!.totalRecords.toString()) {
            con.nextPageStop.value = true;
          }

          con.paginationLoading.value = false;
          con.isLoading.value = false;
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          con.paginationLoading.value = false;
          con.isLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          con.paginationLoading.value = false;
          con.isLoading.value = false;
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      con.isConnected.value = false;
      con.paginationLoading.value = false;
      con.isLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    con.paginationLoading.value = false;
    con.isLoading.value = false;
    // toast(e.toString(), false);
  }
}
