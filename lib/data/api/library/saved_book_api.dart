import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/category_book/category_book_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

import '../../handler/api_url.dart';

savedBookApi({bookId, index, bool? fromCategory, bool? fromDetail}) async {
  CategoryBookController categoryBookController =
      Get.put(CategoryBookController());

  BookDetailController bookDetailController = Get.put(BookDetailController());

  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        if (fromCategory == true) {
          categoryBookController.savedLoading.value = true;
        } else if (fromDetail == true) {
          bookDetailController.savedLoading.value = true;
        }

        http.Response response = await ApiHandler.post(
          url: "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Save/$bookId",
        );

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          if (fromCategory == true) {
            categoryBookController.savedLoading.value = false;
            categoryBookController.booksList[index].isSaved!.value = true;
            // savedController.savedBookList.removeWhere((element) =>
            //     element.id == categoryBookController.booksList[index].id);
          } else if (fromDetail == true) {
            bookDetailController.bookDetail.value.isSaved!.value = true;
            bookDetailController.savedLoading.value = false;
            categoryBookController.booksList.asMap().forEach((key, value) {
              if (bookDetailController.bookDetail.value.id ==
                  categoryBookController.booksList[key].id) {
                categoryBookController.booksList[key].isSaved!.value = true;
              }
            });
          }
          toast(decoded['message'], true);
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          if (fromCategory == true) {
            categoryBookController.savedLoading.value = false;
          } else if (fromDetail == true) {
            bookDetailController.savedLoading.value = false;
          }
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          if (fromCategory == true) {
            categoryBookController.savedLoading.value = false;
          } else if (fromDetail == true) {
            bookDetailController.savedLoading.value = false;
          }
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      if (fromCategory == true) {
        categoryBookController.savedLoading.value = false;
      } else if (fromDetail == true) {
        bookDetailController.savedLoading.value = false;
      }
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    if (fromCategory == true) {
      categoryBookController.savedLoading.value = false;
    } else if (fromDetail == true) {
      bookDetailController.savedLoading.value = false;
    }

    // toast(e.toString(), false);
  }
}
