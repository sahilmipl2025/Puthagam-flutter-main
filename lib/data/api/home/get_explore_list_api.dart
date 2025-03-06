import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:puthagam/model/explore/get_explore_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

import '../../handler/api_url.dart';

getExploreListApi() async {
  HomeController con = Get.put(HomeController());
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
        con.exploreLoading.value = true;
        // con.bookList.clear();

        http.Response response = await ApiHandler.post(
            url: "${ApiUrls.baseUrl}Book/${LocalStorage.userId}",
            body: {
              "categoryId": "",
              "start": 0,
              "length": 20,
              "searchString": "",
              "subcategoryIds": "",
              "authorId": "",
              "sortBy": "",
              "isFinished": false,
              "isContinues": false,
            });

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          var decoded = getExploreListModelFromJson(response.body);
          for (var element in decoded.data!) {
            if (con.bookList.where((p0) => p0.id == element.id).isEmpty) {
              con.bookList.add(element);
            }
          }

          con.exploreLoading.value = false;
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          con.exploreLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          con.exploreLoading.value = false;
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      con.isConnected.value = false;
      con.exploreLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    con.exploreLoading.value = false;
    // toast(e.toString(), false);
  }
}
