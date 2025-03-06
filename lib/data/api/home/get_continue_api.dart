import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/model/explore/get_explore_list_model.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

getContinueListenListApi() async {
  HomeController con = Get.put(HomeController());
  BookDetailController con1 = Get.put(BookDetailController());

  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      con.isConnected.value = true;
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        con.continueLoading.value = true;

        con.continueBookList.clear();

        http.Response response = await ApiHandler.post(
            url: "${ApiUrls.baseUrl}Book/${LocalStorage.userId}",
            body: {
              "categoryId": "",
              "start": 0,
              "length": 50,
              "searchString": "",
              "subcategoryIds": "",
              "authorId": "",
              "sortBy": "",
              "isFinished": false,
              "isContinuous": true,
              "isPoodcast": false
              // con1.isBookDetail.isTrue
            });

        var decoded = jsonDecode(response.body);
        print("isPoodcast${con1.isBookDetail.isTrue}");

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          var decoded = getExploreListModelFromJson(response.body);
         
          con.continueBookList.value = decoded.data ?? [];

          con.continueLoading.value = false;
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          con.continueLoading.value = false;

          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          con.continueLoading.value = false;

          toast(decoded['status']['message'], false);
        }
      }
    } else {
      con.isConnected.value = false;
      con.continueLoading.value = false;

      toast("No Internet Connection!", false);
    }
  } catch (e) {
    con.continueLoading.value = false;
  }
}
