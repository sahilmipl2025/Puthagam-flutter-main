import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/model/category_books/get_book_review_model.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

import '../../handler/api_url.dart';

submitBookReviewApi() async {
  BookDetailController con = Get.put(BookDetailController());
  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        if (connection) {
          con.savedLoading.value = true;

          http.Response response = await ApiHandler.post(
              url:
                  "${ApiUrls.baseUrl}Book/${LocalStorage.userId}/${con.bookDetail.value.id}/BookReview",
              body: {
                "comment": con.reviewController.value.text,
                "rating": con.rating.value.toString(),
              });

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            BookReview review = BookReview(
                id: decoded['_id'],
                userId: decoded['userId'],
                userImage: decoded['userImage'],
                bookId: decoded['bookId'],
                comment: decoded['comment'],
                rating: decoded['rating'],
                createdDate: DateTime.now(),
                createdBy: decoded['createdBy'],
                createdByName: decoded['createdByName'],
                modifiedBy: decoded['modifiedBy'],
                modifiedDate: DateTime.now(),
                isActive: decoded['isActive'],
                isDeleted: decoded['isDeleted']);

            con.reviewList.insert(0, review);
            con.reviewController.value.clear();
            toast(decoded['message'], true);

            con.savedLoading.value = false;
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            con.savedLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            con.savedLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      }
    } else {
      con.savedLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    con.savedLoading.value = false;
    // toast(e.toString(), false);
  }
}
