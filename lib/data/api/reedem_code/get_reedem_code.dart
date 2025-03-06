import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/profile/subscription/subcription_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:share_plus/share_plus.dart';

import '../../handler/api_url.dart';

getRedeemCodeApi() async {
  SubscriptionController con = Get.put(SubscriptionController());

  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        con.showLoader.value = true;

        var body = {
          "userId": LocalStorage.userId,
          "subscriptionId": baseController?.premiumId.value,
        };

        http.Response response = await ApiHandler.post(
            url: '${ApiUrls.baseUrl}SubscriptionPlan/ShareSubscription',
            body: body);

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          con.showLoader.value = false;

          if (decoded['shareCode'].toString() == "0") {
            toast(decoded['message'], false);
          } else {
            Share.share(
                "${baseController!.userName.value} has invited you to try MagicTamil app. \n\nUse invite code ${decoded['shareCode']} for a 1  month free subscription of unlimited books and podcasts.");
          }
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          con.showLoader.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['title'], false);
        } else {
          var decoded = jsonDecode(response.body);
          con.showLoader.value = false;
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      con.showLoader.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    con.showLoader.value = false;
    // toast(e.toString(), false);
  }
}
