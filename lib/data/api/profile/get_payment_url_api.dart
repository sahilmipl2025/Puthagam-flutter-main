import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/api/profile/get_profile_api.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/premium/premium_controller.dart';
import 'package:puthagam/screen/dashboard/profile/premium_ios/premium_ios_controller.dart';
import 'package:puthagam/screen/dashboard/profile/profile_page/profile_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

import '../../handler/api_url.dart';

getPaymentUrlApi({
  planId,
  required bool isTrial,
  required bool isBeta,
  required bool fromPlay,
  String? coupon = "",
}) async {
  ProfileController profileCon = Get.put(ProfileController());
  PremiumController con = Get.put(PremiumController());
  PremiumIOSController iosCon = Get.put(PremiumIOSController());

  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        con.showLoading.value = true;
        profileCon.deleteLoader.value = true;

        http.Response response = await ApiHandler.post(
            url: '${ApiUrls.baseUrl}SubscriptionPlan/SubscriptionPlan',
            body: {
              "userId": LocalStorage.userId,
              "subscriptionPlanId": isTrial
                  ? 'TRIAL'
                  : isBeta
                      ? 'BETA'
                      : planId,
              "paymentGatewayType": isTrial
                  ? 'TRIAL'
                  : isBeta
                      ? 'BETA'
                      : Platform.isIOS || fromPlay
                          ? 'AP'
                          : 'RP',
              "couponCode": coupon,
              "timeZone": 0,
            });
        var decoded = jsonDecode(response.body);
        con.showLoading.value = false;

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          if (Platform.isIOS) {
            if (isBeta == true) {
              await getUserProfileApi();
              toast("Your beta trial has been activated", true);
            } else {
              if (decoded['short_url'].toString() == "null" &&
                  decoded['isTrial'] == true) {
                getUserProfileApi();
                baseController!.isTried.value = true;
                baseController!.trialRunning.value = true;
                Get.back();
                toast("Your trial has been started", true);
              } else {
                iosCon.planId.value = decoded['id'];
                iosCon.update();
              }
            }
          } else {
            if (decoded['short_url'].toString() != "null") {
              Get.toNamed(AppRoutes.paymentWebViewScreen,
                  arguments: [decoded['short_url'], decoded['id']]);
            } else {
              if (fromPlay) {
                con.planId.value = decoded['id'];
                con.update();
              } else {
                await getUserProfileApi();
                if (isBeta == true) {
                  Get.back();
                  toast("Your beta trial has been activated", true);
                } else {
                  baseController!.isTried.value = true;
                  baseController!.trialRunning.value = true;
                  Get.back();
                  toast("Your trial has been started", true);
                }
              }
            }
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
    con.showLoading.value = false;
    // toast(e.toString(), false);
  } finally {
    con.showLoading.value = false;
    profileCon.deleteLoader.value = false;
  }
}
