import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/model/explore/get_explore_list_model.dart';
import 'package:puthagam/screen/dashboard/library/history/history_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

getHistoryListApi() async {
  HistoryController historyCon = Get.put(HistoryController());
  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        historyCon.isLoading.value = true;

        historyCon.continueBookList.clear();

        http.Response response = await ApiHandler.post(
            url: "${ApiUrls.baseUrl}Book/${LocalStorage.userId}",
            body: {
              "categoryId": "",
              "start": 0,
              "length": 15,
              "searchString": historyCon.textCon.value.text,
              "subcategoryIds": "",
              "authorId": "",
              "sortBy": "",
              "isFinished": false,
              "isContinuous": true,
            });

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          var decoded = getExploreListModelFromJson(response.body);
          for (var element in decoded.data!) {
            historyCon.continueBookList.add(element);
          }

          historyCon.isLoading.value = false;
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();

          historyCon.isLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          historyCon.isLoading.value = false;
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      historyCon.isLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    historyCon.isLoading.value = false;
  }
}
