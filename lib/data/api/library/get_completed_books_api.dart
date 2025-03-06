import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/model/category_books/get_category_books_model.dart';
import 'package:puthagam/screen/dashboard/library/completed_books/completed_books_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

import '../../handler/api_url.dart';

getCompletedBooksApi({pagination}) async {
  CompletedBooksController con = Get.put(CompletedBooksController());
  try {
    if (LocalStorage.token.toString() != "null" &&
        LocalStorage.token.toString().isNotEmpty &&
        LocalStorage.userId.toString() != "null" &&
        LocalStorage.userId.toString().isNotEmpty) {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          con.isConnected.value = true;
          if (pagination == true) {
            con.paginationLoading.value = true;
          } else {
            con.isLoading.value = true;
            con.completedBookList.clear();
            con.page.value = 0;
            con.nextPageStop.value = false;
          }

          http.Response response = await ApiHandler.post(
              url: "${ApiUrls.baseUrl}Book/${LocalStorage.userId}",
              body: {
                "categoryId": "",
                "start": con.page.value,
                "length": 15,
                "searchString": con.textCon.value.text,
                "subcategoryIds": "",
                "authorId": "",
                "sortBy": "",
                "isFinished": true,
              });

          var decoded = jsonDecode(response.body);
          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = getCategoryBooksModelFromJson(response.body);
            if (decoded.data!.isNotEmpty) {
              for (var element in decoded.data!) {
                if (con.completedBookList
                    .where((p0) => p0.id == element.id)
                    .isEmpty) {
                  con.completedBookList.add(element);
                }
              }

              con.page.value++;
            }

            if (con.completedBookList.length.toString() ==
                decoded.status!.totalRecords.toString()) {
              con.nextPageStop.value = true;
            }

            con.paginationLoading.value = false;
            con.isLoading.value = false;
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            con.isLoading.value = false;
            con.paginationLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['message'], false);
          } else {
            con.isLoading.value = false;
            con.paginationLoading.value = false;
            toast(decoded['message'], false);
          }
        }
      } else {
        con.isConnected.value = false;
        con.isLoading.value = false;
        con.paginationLoading.value = false;
        toast("No Internet Connection!", false);
      }
    }
  } catch (e) {
    con.isLoading.value = false;
    con.paginationLoading.value = false;
    // toast(e.toString(), false);
  }
}
