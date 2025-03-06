import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/model/category_books/get_category_books_model.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

class HistoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool showLoading = false.obs;

  RxList<CategoryBooks> continueBookList = <CategoryBooks>[].obs;
  Rx<TextEditingController> textCon = TextEditingController().obs;
  RxBool isSearch = false.obs;

  /// Save Bookmark API

  savedBookApi({bookId, index}) async {
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
            url: "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Save/$bookId",
          );

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            continueBookList[index].isSaved!.value = true;
            showLoading.value = false;
            // toast(decoded['message'], true);
            toast(decoded['message'], true);
            //  toast("Saved to your library ", true);
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            showLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            showLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        showLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      showLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  /// Remove Book Api

  deleteSavedBookApi({bookId, index}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        showLoading.value = true;

        http.Response response = await ApiHandler.delete(
          url: "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Save/$bookId",
        );

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          continueBookList[index].isSaved!.value = false;
          showLoading.value = false;
          toast(decoded['message'], true);
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          showLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          showLoading.value = false;
          toast(decoded['status']['message'], false);
        }
      } else {
        showLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      showLoading.value = false;
      // toast(e.toString(), false);
    }
  }
}
