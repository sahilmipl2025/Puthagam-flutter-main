import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/model/category_books/get_book_chapters_model.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/utils/network_info.dart';

getQueueBookChaptersApi({bookId}) async {
  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      await LocalStorage.getData();
      RxList<BookChapter> bookChapterList = <BookChapter>[].obs;
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        if (connection) {
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
                bookChapterList.add(element);
              }
            }
            return bookChapterList;
          } else if (response.statusCode == 401)
          
           {
            LocalStorage.clearData();
            Get.offAllNamed(AppRoutes.loginScreen);

            toast(decoded['status']['message'], false);
            return bookChapterList;
          } else {
            return bookChapterList;
          }
        }
      }
    }
  } catch (e) {
    // toast(e.toString(), false);
  }
}
