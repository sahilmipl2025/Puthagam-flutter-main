import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/api/profile/get_profile_api.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/screen/dashboard/profile/redeem_code/redeem_code_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

import '../../handler/api_url.dart';

redeemCodeApi({code}) async {
  RedeemCodeController con = Get.put(RedeemCodeController());

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
          "shareCode": code,
        };

        http.Response response = await ApiHandler.post(
            url: '${ApiUrls.baseUrl}SubscriptionPlan/RedeemSubscription',
            body: body);

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          if (decoded['status'].toString().toLowerCase() == "fail") {
            con.showLoader.value = false;
            toast(decoded['message'], false);
          } else {
            await getUserProfileApi();
            con.showLoader.value = false;
            Get.back();
            toast(decoded['message'], true);
          }
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          con.showLoader.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['title'], false);
        } else {
          var decoded = jsonDecode(response.body);
          con.showLoader.value = false;
          toast(decoded['message'], false);
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
