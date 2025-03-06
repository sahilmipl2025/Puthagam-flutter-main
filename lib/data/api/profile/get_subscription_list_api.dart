import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/model/book_detail/get_subscription_model.dart';
import 'package:puthagam/screen/dashboard/premium/premium_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

import '../../handler/api_url.dart';

getSubscriptionPlanList() async {
  PremiumController con = Get.put(PremiumController());
  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        con.isLoading.value = true;
        con.subscriptionList.clear();

        http.Response response = await ApiHandler.get(
            url: '${ApiUrls.baseUrl}SubscriptionPlan/SubscriptionPlans');

        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          var decoded = getSubscriptionModelFromJson(response.body);
          if (decoded.data!.isNotEmpty) {
            if ( baseController!.currentcountryone.value == "india") {
              con.subscriptionList.addAll(decoded.data!
                  .where((element) =>
                      element.item!.currency!.toLowerCase().trim() == "inr")
                  .toList());
            } else {
              con.subscriptionList.addAll(decoded.data!
                  .where((element) =>
                      element.item!.currency!.toLowerCase().trim() != "inr")
                  .toList());
            }
          }
          con.trialDays.value = decoded.trialDays ?? "5";

          con.isLoading.value = false;
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          con.isLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          con.isLoading.value = false;
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      con.isLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    con.isLoading.value = false;
    // toast(e.toString(), false);
  }
}
