import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/model/category_books/get_book_review_model.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';

import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

import '../../handler/api_url.dart';

getBookReviewApi({bookId, pagination}) async {
  BookDetailController con = Get.put(BookDetailController());
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
        if (pagination == false) {
          con.isConnected.value = true;
          con.reviewLoading.value = true;
          con.reviewList.clear();
          con.page.value = 0;
          con.nextPageStop.value = false;
        }

        http.Response response = await ApiHandler.get(
            url:
                "${ApiUrls.baseUrl}Book/${LocalStorage.userId}/$bookId/Reviews?start=${con.page.value}&length=10");

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          var decoded = getBookReviewModelFromJson(response.body);

          if (decoded.data!.isNotEmpty) {
            for (var element in decoded.data!) {
              con.reviewList.add(element);
            }
            con.page.value++;
          }

          if (con.reviewList.length.toString() ==
              decoded.status!.totalRecords.toString()) {
            con.nextPageStop.value = true;
          }

          con.reviewLoading.value = false;
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          con.reviewLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          // con.paginationLoading.value = false;
          con.reviewLoading.value = false;
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      con.isConnected.value = false;
      // con.paginationLoading.value = false;
      con.reviewLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    // con.paginationLoading.value = false;
    con.reviewLoading.value = false;
    // toast(e.toString(), false);
  }
}
