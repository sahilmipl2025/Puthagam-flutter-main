import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/library/get_favorite_list_api.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/model/library/get_favorite_book_model.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

import '../../../../data/handler/api_url.dart';

class FavouriteController extends GetxController {
  RxBool isConnected = false.obs;
  RxBool isLoading = false.obs;
  RxBool savedLoading = false.obs;
  RxList<FavoriteBook> favoriteBook = <FavoriteBook>[].obs;
  Rx<TextEditingController> textCon = TextEditingController().obs;
  RxBool isSearch = false.obs;

  RxBool paginationLoading = false.obs;
  ScrollController newScrollController = ScrollController();
  RxInt page = 0.obs;
  RxBool nextPageStop = false.obs;

  @override
  void onInit() {
    super.onInit();
    manageScrollController();
  }

  @override
  void onReady() {
    super.onReady();
    getFavoriteBookApi(pagination: false);
  }

  void manageScrollController() async {
    newScrollController.addListener(
      () {
        if (newScrollController.position.maxScrollExtent ==
            newScrollController.position.pixels) {
          if (nextPageStop.isFalse && paginationLoading.isFalse) {
            getFavoriteBookApi(pagination: true);
          }
        }
      },
    );
  }

  /// Delete Favorite

  deleteFavoriteBookApi({bookId, index}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          isConnected.value = true;
          savedLoading.value = true;

          http.Response response = await ApiHandler.delete(
              url:
                  "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Favourites/$bookId");

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            favoriteBook.removeAt(index);
            savedLoading.value = false;
            toast(decoded['message'], true);
            // toast("Removed from favorite successfully", true);
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            savedLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            savedLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        isConnected.value = false;
        savedLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      savedLoading.value = false;
      toast(e.toString(), false);
    }
  }
}
