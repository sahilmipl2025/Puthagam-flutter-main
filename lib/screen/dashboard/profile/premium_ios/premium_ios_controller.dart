import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/model/book_detail/get_subscription_model.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

class PremiumIOSController extends GetxController {
  RxList<Plan> subscriptionList = <Plan>[].obs;

  RxString planId = "".obs;
  RxString trialDays = "".obs;

  getSubscriptionPlanList() async {
    // try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        subscriptionList.clear();

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
            if (baseController!.currentCountry.value.toLowerCase() == "india") {
              subscriptionList.addAll(decoded.data!
                  .where((element) =>
                      element.item!.currency!.toLowerCase().trim() == "inr")
                  .toList());
            } else {
              subscriptionList.addAll(decoded.data!
                  .where((element) =>
                      element.item!.currency!.toLowerCase().trim() != "inr")
                  .toList());
            }
          }
          trialDays.value = decoded.trialDays ?? "5";
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
    // } catch (e) {
    //   con.isLoading.value = false;
    //   // toast(e.toString(), false);
    // }
  }

  paymentDoneApi() async {
    // try {
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
                '${ApiUrls.baseUrl}SubscriptionPlan/${LocalStorage.userId.toString()}/UpdateIOSSubscriptionPayment/${planId.value.toString()}');

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          await getUserProfileApi();
          Get.back();
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          Get.offAllNamed(AppRoutes.loginScreen);
          var decoded = jsonDecode(response.body);
          toast(decoded['status']['message'], false);
        } else {
          var decoded = jsonDecode(response.body);
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      toast("No Internet Connection!", false);
    }
    // } catch (e) {
    //   con.isLoading.value = false;
    //   // toast(e.toString(), false);
    // }
  }

  getUserProfileApi() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        final InAppPurchase _inAppPurchase = InAppPurchase.instance;
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

            var box = GetStorage();
            baseController!.isBetaVersion.value =
                decoded['isBetaVersion'] ?? false;

            if (decoded['subscriptionPlan'].toString() != "null" &&
                decoded['subscriptionPlan'].toString() != "{}" &&
                decoded['subscriptionPlan'].toString() != "") {
              await box.write(Prefs.isPremium, true);
              LocalStorage.isPremium = true;
              baseController!.isSubscribed.value = true;

              if (decoded['subscriptionPlan'] != null) {
                baseController!.premiumId.value =
                    decoded['subscriptionPlan']['id'] ?? "";
                if (decoded['subscriptionPlan']['plan_id'] == "BETA") {
                  baseController!.betaVersion.value = true;
                } else {
                  baseController!.betaVersion.value = false;
                }
                baseController!.trialRunning.value =
                    jsonDecode(response.body)['subscriptionPlan']['isTrial'];
              } else {
                baseController!.premiumId.value =
                    decoded['subscriptionPlan']['id'] ?? "";
                baseController!.trialRunning.value = false;
                baseController!.betaVersion.value = false;
              }

              baseController!.planStartDate.value =
                  jsonDecode(response.body)['subscriptionPlan']
                      ['current_start'];
              baseController!.planEndDate.value =
                  jsonDecode(response.body)['subscriptionPlan']['current_end'];

              baseController!.isTried.value = decoded['isTrial'];
              baseController!.lastPlanId.value = decoded['planId'];
              Get.toNamed(AppRoutes.successScreen);
            } else {
              await _inAppPurchase.restorePurchases();
              // final bool isAvailable = await _inAppPurchase.isAvailable();
              // if (isAvailable == true) {
              //   baseController!.isSubscribed.value = true;
              //   await box.write(Prefs.isPremium, true);
              //   LocalStorage.isPremium = true;
              //   Get.toNamed(AppRoutes.successScreen);
              // } else {
              await box.write(Prefs.isPremium, false);
              LocalStorage.isPremium = false;
              baseController!.trialRunning.value = false;
              baseController!.isTried.value = decoded['isTrial'];
              baseController!.lastPlanId.value = decoded['planId'];
              baseController!.isSubscribed.value = false;
              Get.back();
              // }
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

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getSubscriptionPlanList();
  }
}
