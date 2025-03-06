import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/model/category_books/get_category_books_model.dart';
import 'package:puthagam/model/explore/get_explore_list_model.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

import '../../../../../data/handler/api_url.dart';

class CollectionBooksController extends GetxController {
  RxBool isConnected = false.obs;
  RxBool isLoading = false.obs;
  RxBool showLoading = false.obs;
  RxBool showDelete = false.obs;
  RxInt totalCount = 0.obs;
  RxString name = "".obs;
  RxString collectionId = "".obs;
  RxList<CategoryBooks> bookList = <CategoryBooks>[].obs;

  getExploreListApi() async {
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
          isLoading.value = true;
          bookList.clear();

          http.Response response = await ApiHandler.get(
            url:
                "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Collections/${collectionId.value}/books/${showDelete.value.toString()}",
          );

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = getExploreListModelFromJson(response.body);

            if (decoded.data!.isNotEmpty) {
              for (var element in decoded.data!) {
                bookList.add(element);
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
        isConnected.value = false;
        isLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      isLoading.value = false;
      // toast(e.toString(), false);
    }
  }

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
            bookList[index].isSaved!.value = true;
            showLoading.value = false;
            toast(decoded['message'], true);
            // toast(jsonDecode(response.body)['message'], true);
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
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
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
            bookList[index].isSaved!.value = false;
            showLoading.value = false;
            toast(jsonDecode(response.body)['message'], true);
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

  /// Remove Book From Collection

  deleteCollectionBookApi({bookId, index, collectionId}) async {
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

          http.Response response = await ApiHandler.delete(
              url:
                  "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Collections/$collectionId/books/$bookId");

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            bookList.removeAt(index);
            showLoading.value = false;
            toast(jsonDecode(response.body)['message'], true);
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
}
