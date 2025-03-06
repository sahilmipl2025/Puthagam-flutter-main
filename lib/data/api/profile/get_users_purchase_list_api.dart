import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

getPurchasesListApi() async {
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
          url:
              '${ApiUrls.baseUrl}User/${LocalStorage.userId}/SubscriptionPlans',
        );

        if (response.body.toString() != "") {
          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            if (decoded['data']
                .where(
                    (p0) => p0['status'].toString().toLowerCase() == "active")
                .isNotEmpty) {
              baseController!.alreadyPremium.value = true;
            } else {
              baseController!.alreadyPremium.value = false;
            }
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            toast(decoded['status']['message'], false);
          }
        }
      }
    } else {
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    // toast(e.toString(), false);
  }
}
