import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/model/category_books/get_book_chapters_model.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

import '../../handler/api_url.dart';

getBookChaptersApi({bookId}) async {
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
        if (connection) {
          con.isConnected.value = true;
          con.chapterLoading.value = true;
          con.bookChapterList.clear();

          http.Response response = await ApiHandler.get(
            url:
                "${ApiUrls.baseUrl}Book/${LocalStorage.userId}/$bookId/Chapters",
          );

          var decoded = jsonDecode(response.body);
          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = getBookChaptersModelFromJson(response.body);
            if (decoded.data!.isNotEmpty) {
              for (var element in decoded.data!) {
                con.bookChapterList.add(element);
              }
            }
            con.chapterLoading.value = false;
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            Get.offAllNamed(AppRoutes.loginScreen);
            con.chapterLoading.value = false;
            toast(decoded['status']['message'], false);
          } else {
            con.chapterLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      }
    } else {
      con.isConnected.value = false;
      con.chapterLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    con.chapterLoading.value = false;
    // toast(e.toString(), false);
  }
}
