import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

class PaymentController extends GetxController {
  RxInt timer = 0.obs;
  Timer? timer1;

  checkPremiumOrNot() {
    timer1 = Timer.periodic(
      const Duration(seconds: 1),
      (timer1) {
        timer.value++;
        if (timer.value == 3) {
          timer.value = 0;
          getPremiumApi();
        }
      },
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkPremiumOrNot();
  }

  getPremiumApi() async {
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
                '${ApiUrls.baseUrl}User/${LocalStorage.userId}/SubscriptionPlans/${Get.arguments[1]}',
          );

          if (response.body.toString() != "") {
            var decoded = jsonDecode(response.body);

            if (response.statusCode == 200 ||
                response.statusCode == 201 ||
                response.statusCode == 202 ||
                response.statusCode == 203 ||
                response.statusCode == 204) {
              if (decoded['status'].toString() != "null" &&
                  decoded['status'].toString() != "" &&
                  decoded['status'].toString().toLowerCase() == "active") {
                getUserProfileApi();
              } else if (decoded['status'].toString() != "null" &&
                  decoded['status'].toString() != "" &&
                  decoded['status'].toString().toLowerCase() ==
                      "paymentFailed") {
                Get.toNamed(AppRoutes.failedScreen);
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
              timer1!.cancel();
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

              Get.toNamed(AppRoutes.successScreen);
            } else {
              baseController!.isSubscribed.value = false;
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
}
