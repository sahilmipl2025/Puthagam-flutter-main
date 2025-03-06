import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:puthagam/data/api/profile/get_profile_api.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/model/book_detail/get_subscription_model.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  Rx<File> image = File("").obs;
  RxBool isLoading = false.obs;
  RxBool colorshow = false.obs;

  RxBool deleteLoader = false.obs;
  RxList<Plan> subscriptionList = <Plan>[].obs;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      this.image.value = imageTemporary;
    } on PlatformException catch (e) {
      debugPrint("$e");
    }
  }

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

  deletePremiumApi({required bool betaVersion}) async {
    try {
      deleteLoader.value = true;
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
          await getUserProfileApi(forBeta: true);
          Get.back();
          deleteLoader.value = false;
          if (betaVersion == true) {
            toast("Your beta trial has been successfully cancelled", true);
          } else {
            toast(decoded['status']['message'], true);
          }
        } else if (response.statusCode == 401) {
          deleteLoader.value = false;
          LocalStorage.clearData();
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['message'], false);
        } else {
          deleteLoader.value = false;
          toast(decoded['message'], false);
        }
      } else {
        deleteLoader.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      deleteLoader.value = false;
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
