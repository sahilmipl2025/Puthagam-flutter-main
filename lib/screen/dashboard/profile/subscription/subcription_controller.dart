import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

class SubscriptionController extends GetxController {
  RxBool showLoader = false.obs;

  getUserProfileApi() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          http.Response response = await ApiHandler.get(
            url: ApiUrls.baseUrl + ApiUrls.editProfile + LocalStorage.userId,
          );
          var decoded = jsonDecode(response.body);
          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            LocalStorage.storedToken(decoded, false);
            if (decoded['subscriptionPlan'].toString() != "null" &&
                decoded['subscriptionPlan'].toString() != "{}" &&
                decoded['subscriptionPlan'].toString() != "") {
              if (kDebugMode) {
                print("Yes");
              }
              baseController!.isSubscribed.value = true;

              if (decoded['subscriptionPlan'] != null) {
                baseController!.premiumId.value =
                    decoded['subscriptionPlan']['id'] ?? "";
              } else {
                baseController!.premiumId.value =
                    decoded['subscriptionPlan']['id'] ?? "";
              }

              baseController!.isTried.value = decoded['isTrial'];
              baseController!.lastPlanId.value = decoded['planId'];

              Get.back();
            } else {
              var box = GetStorage();
              await box.write(Prefs.isPremium, false);
              LocalStorage.isPremium = false;
              baseController!.trialRunning.value = false;
              baseController!.isTried.value = decoded['isTrial'];
              baseController!.lastPlanId.value = decoded['planId'];
              baseController!.isSubscribed.value = false;
              baseController!.update();
            }
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      // toast(e.toString(), false);
    }
  }

  /// Delete

  deletePremiumApi() async {
    try {
      showLoader.value = true;
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        http.Response response = await http.delete(
          Uri.parse(
              '${ApiUrls.baseUrl}SubscriptionPlan/CancelSubscriptionPlan'),
          body: jsonEncode({
            "userId": LocalStorage.userId,
            "subscriptionId": baseController!.premiumId.value
          }),
          headers: {
            'Authorization': 'Bearer ${LocalStorage.token}',
            "accept": "text/plain",
            "Content-Type": "application/json",
          },
        );

        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          // LocalStorage.storedToken(decoded, false);
          await getUserProfileApi();
          Get.back();
          showLoader.value = false;
          toast(decoded['status']['message'], true);
        } else if (response.statusCode == 401) {
          showLoader.value = false;
          LocalStorage.clearData();
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['message'], false);
        } else {
          showLoader.value = false;
          toast(decoded['message'], false);
        }
      } else {
        showLoader.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      showLoader.value = false;
      // toast(e.toString(), false);
    }
  }
}
