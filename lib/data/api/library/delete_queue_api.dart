import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

deleteQueueApi({bookId}) async {
  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        baseController!.continueLoading.value = true;
        http.Response response = await ApiHandler.delete(
          url: "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Queue/$bookId",
        );

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          baseController!.queueList
              .removeWhere((element) => element.id == bookId);
          baseController!.booksQueueList
              .removeWhere((element) => element.bookId == bookId);

          baseController!.currentPlayingBookIndex.value =
              baseController!.queueList.indexWhere((element) =>
                  element.id.toString() ==
                  baseController!.runningBookId.toString());
          baseController!.continueLoading.value = false;
          toast(decoded['message'], true);
        } else if (response.statusCode == 401) {
          baseController!.continueLoading.value = false;
          LocalStorage.clearData();
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          baseController!.continueLoading.value = false;
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      baseController!.continueLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    baseController!.continueLoading.value = false;
    // toast(e.toString(), false);
  }
}
