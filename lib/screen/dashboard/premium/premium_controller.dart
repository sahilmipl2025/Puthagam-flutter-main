import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:puthagam/data/api/profile/get_subscription_list_api.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/model/book_detail/get_subscription_model.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

import '../../../data/api/profile/get_profile_api.dart';


class PremiumController extends GetxController {
  RxBool isLoading = false.obs;

  RxBool showLoading = false.obs;
  RxList<Plan> subscriptionList = <Plan>[].obs;
  Rx<TextEditingController> couponController = TextEditingController().obs;
  RxString planId = "".obs;
   Map<String, dynamic>? paymentIntentData;
  RxString trialDays = "5".obs;

  RxDouble codeDiscount = 0.0.obs;
  RxString couponCode = "".obs;
  RxBool applyCoupon = false.obs;
  RxBool showCouponText = false.obs;
  RxBool isAmount = false.obs;

  @override
  void onReady() {
    super.onReady();
    getSubscriptionPlanList();
  }



  applyCouponApi() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          showLoading.value = true;

          http.Response response = await ApiHandler.post(
              url: '${ApiUrls.baseUrl}SubscriptionPlan/CouponCodeValidate',
              body: {
                "userId": LocalStorage.userId,
                "couponCode": couponController.value.text.trim(),
                "timeZone": 0,
              });
          var decoded = jsonDecode(response.body);
          showLoading.value = false;

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            if (jsonDecode(response.body)['data'] != null) {
              if (jsonDecode(response.body)['data']['discountType']
                      .toString()
                      .toLowerCase() ==
                  "percentage") {
                applyCoupon.value = true;
                couponCode.value = couponController.value.text.trim();
                codeDiscount.value = double.parse(
                    jsonDecode(response.body)['data']['discount'].toString());
                if (jsonDecode(response.body)['data']['discountType']
                        .toString()
                        .toLowerCase() ==
                    "flat") {
                  isAmount.value = true;
                } else {
                  isAmount.value = false;
                }
                toast(decoded['status']['message'], true);
              } else if (jsonDecode(response.body)['data']['currency']
                          .toString()
                          .toLowerCase() ==
                      "inr" &&
                  // baseController!.currentCountry.value.toLowerCase() ==
                  //     "india"
                   baseController!.currentcountryone.value == "india"
                      ) {
                applyCoupon.value = true;
                
                couponCode.value = couponController.value.text.trim();
                codeDiscount.value = double.parse(
                    jsonDecode(response.body)['data']['discount'].toString());
                if (jsonDecode(response.body)['data']['discountType']
                        .toString()
                        .toLowerCase() ==
                    "flat") {
                  isAmount.value = true;
                } else {
                  isAmount.value = false;
                }
                toast(decoded['status']['message'], true);
              } else if (jsonDecode(response.body)['data']['currency']
                          .toString()
                          .toLowerCase() ==
                      "usd" &&
                  baseController!.currentCountry.value.toLowerCase() !=
                      "india") {
                applyCoupon.value = true;
                couponCode.value = couponController.value.text.trim();
                codeDiscount.value = double.parse(
                    jsonDecode(response.body)['data']['discount'].toString());
                if (jsonDecode(response.body)['data']['discountType']
                        .toString()
                        .toLowerCase() ==
                    "flat") {
                  isAmount.value = true;
                } else {
                  isAmount.value = false;
                }
                toast(decoded['status']['message'], true);
              } else {
                toast('Coupon not available for your currency', false);
              }
            } else {
              toast(decoded['status']['message'], false);
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
      showLoading.value = false;
      // toast(e.toString(), false);
    } finally {
      showLoading.value = false;
    }
  }

  paymentDoneApi() async {
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
    } catch (e) {
      isLoading.value = false;
      // toast(e.toString(), false);
    }
  }
  
}