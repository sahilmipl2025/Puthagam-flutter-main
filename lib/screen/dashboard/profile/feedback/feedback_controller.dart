import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

import '../../../../data/handler/api_url.dart';

class FeedbackController extends GetxController {
  Rx<TextEditingController> reviewController = TextEditingController().obs;
  RxInt rating = 4.obs;
  RxBool savedLoading = false.obs;

  submitBookReviewApi() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          if (connection) {
            savedLoading.value = true;

            http.Response response = await ApiHandler.post(
                url: "${ApiUrls.baseUrl}User/Feedback",
                body: {
                  "userId": LocalStorage.userId,
                  "description": reviewController.value.text,
                  "rating": rating.value.toString(),
                });

            var decoded = jsonDecode(response.body);

            if (response.statusCode == 200 ||
                response.statusCode == 201 ||
                response.statusCode == 202 ||
                response.statusCode == 203 ||
                response.statusCode == 204) {
              savedLoading.value = false;
              Get.back();
              toast("Successfully submitted ", true);
            } else if (response.statusCode == 401) {
              LocalStorage.clearData();
              savedLoading.value = false;
              Get.offAllNamed(AppRoutes.loginScreen);
              toast(decoded['status']['message'], false);
            } else {
              savedLoading.value = false;
              toast(decoded['message'], false);
            }
          }
        }
      } else {
        savedLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      savedLoading.value = false;
      // toast(e.toString(), false);
    }
  }
}
