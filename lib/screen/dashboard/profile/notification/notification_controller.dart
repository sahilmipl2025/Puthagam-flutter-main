import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/profile/get_profile_api.dart';
import 'package:puthagam/data/api/profile/get_users_purchase_list_api.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

import '../../../../data/handler/api_url.dart';

class NotificationController extends GetxController {
  RxBool status = true.obs;
  RxBool status2 = true.obs;
  RxBool status3 = true.obs;
  RxBool savedLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    status2.value = LocalStorage.productUpdate;
    status3.value = LocalStorage.podcastNotification;
    status.value = LocalStorage.dailyReminder;
  }

  dailyNotification() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          if (connection) {
            savedLoading.value = true;

            http.Response response = await ApiHandler.patch(
              url:
                  "${ApiUrls.baseUrl}User/${LocalStorage.userId}/DailyRemindarNotification/${status.value == true ? false : true}",
            );

            if (response.statusCode == 200 ||
                response.statusCode == 201 ||
                response.statusCode == 202 ||
                response.statusCode == 203 ||
                response.statusCode == 204) {
              savedLoading.value = false;

              if (status.value == false) {
                status.value = true;
              } else {
                status.value = false;
              }
              getUserProfileApi();
              getPurchasesListApi();
              LocalStorage.dailyReminder = status.value;

              // toast(decoded['message'], true);
            } else if (response.statusCode == 401) {
              var decoded = jsonDecode(response.body);
              LocalStorage.clearData();
              savedLoading.value = false;
              Get.offAllNamed(AppRoutes.loginScreen);
              if (decoded['status']['message'] != null) {
                toast(decoded['status']['message'], false);
              } else {
                toast(decoded['message'], false);
              }
            } else {
              var decoded = jsonDecode(response.body);
              savedLoading.value = false;
              toast(decoded['message'], false);
            }
          } else {
            savedLoading.value = false;
            toast("No Internet Connection!", false);
          }
        }
      }
    } catch (e) {
      savedLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  podcastNotification() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          if (connection) {
            savedLoading.value = true;

            http.Response response = await ApiHandler.patch(
              url:
                  "${ApiUrls.baseUrl}User/${LocalStorage.userId}/PodcastNotification/${status3.value == true ? false : true}",
            );

            if (response.statusCode == 200 ||
                response.statusCode == 201 ||
                response.statusCode == 202 ||
                response.statusCode == 203 ||
                response.statusCode == 204) {
              savedLoading.value = false;
              if (status3.value == false) {
                status3.value = true;
              } else {
                status3.value = false;
              }

              getUserProfileApi();
              getPurchasesListApi();
              LocalStorage.podcastNotification = status3.value;

              // toast(decoded['message'], true);
            } else if (response.statusCode == 401) {
              var decoded = jsonDecode(response.body);
              LocalStorage.clearData();
              savedLoading.value = false;
              Get.offAllNamed(AppRoutes.loginScreen);
              if (decoded['status']['message'] != null) {
                toast(decoded['status']['message'], false);
              } else {
                toast(decoded['message'], false);
              }
            } else {
              var decoded = jsonDecode(response.body);
              savedLoading.value = false;
              if (decoded['status']['message'] != null) {
                toast(decoded['status']['message'], false);
              } else {
                toast(decoded['message'], false);
              }
            }
          }
        }
      } else {
        savedLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      savedLoading.value = false;
    }
  }
}
