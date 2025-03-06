import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/screen/dashboard/library/collections/collection_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

import '../../handler/api_url.dart';

deleteCollectionApi({collectionId, index}) async {
  CollectionController collectionController = Get.put(CollectionController());

  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        collectionController.showLoading.value = true;

        http.Response response = await ApiHandler.delete(
          url:
              "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Collections/$collectionId",
        );

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          collectionController.collectionList.removeAt(index);

          collectionController.showLoading.value = false;
          toast(decoded['message'], true);
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          collectionController.showLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['message'], false);
        } else {
          collectionController.showLoading.value = false;
          toast(decoded['message'], false);
        }
      }
    } else {
      collectionController.showLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    collectionController.showLoading.value = false;
    // toast(e.toString(), false);
  }
}
