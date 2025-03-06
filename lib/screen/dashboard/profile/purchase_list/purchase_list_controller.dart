import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/model/purchase/get_purchase_list_model.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

class PurchaseListController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<PurchaseModel> purchaseList = <PurchaseModel>[].obs;

  getPurchase() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();

      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          isLoading.value = true;

          http.Response response = await ApiHandler.get(
            url:
                "${ApiUrls.baseUrl}User/${LocalStorage.userId}/SubscriptionPlans",
          );

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = purchasePlanModelFromJson(response.body);
            //
            if (decoded.data.isNotEmpty) {
              for (var element in decoded.data) {
                purchaseList.add(element);
              }
            }
            isLoading.value = false;
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            isLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            isLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        isLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getPurchase();
  }
}
