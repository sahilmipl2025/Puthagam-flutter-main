import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:puthagam/model/category_books/get_category_books_model.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/screen/dashboard/home/screen/category_book/category_book_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

import '../../handler/api_url.dart';

getCategoryBooksApi({categoryId, pagination}) async {
  CategoryBookController con = Get.put(CategoryBookController());
  try {
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
          con.categoryId.value = categoryId;
          con.isLoading.value = true;
          con.booksList.clear();
          con.page.value = 0;
          con.nextPageStop.value = false;
        }

        http.Response response = await ApiHandler.post(
            url: "${ApiUrls.baseUrl}Book/${LocalStorage.userId}",
            body: {
              "categoryId": categoryId,
              "start": con.page.value,
              "length": 15,
              "searchString": "",
              "subcategoryIds": "",
              "authorId": "",
              "sortBy": con.status1.value
                  ? "TL"
                  : con.status1.value
                      ? "TD"
                      : "",
            });

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          var decoded = getCategoryBooksModelFromJson(response.body);
          con.totalBooks.value = decoded.status!.totalRecords ?? 0;
          if (decoded.data!.isNotEmpty) {
            for (var element in decoded.data!) {
              if (con.booksList.where((p0) => p0.id == element.id).isEmpty) {
                con.booksList.add(element);
              }
            }
            con.page.value++;
          }

          if (con.booksList.length.toString() ==
              decoded.status!.totalRecords.toString()) {
            con.nextPageStop.value = true;
          }

          con.paginationLoading.value = false;
          con.isLoading.value = false;
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          con.paginationLoading.value = false;
          con.isLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          con.paginationLoading.value = false;
          con.isLoading.value = false;
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      con.isConnected.value = false;
      con.paginationLoading.value = false;
      con.isLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    con.paginationLoading.value = false;
    con.isLoading.value = false;
    // toast(e.toString(), false);
  }
}
