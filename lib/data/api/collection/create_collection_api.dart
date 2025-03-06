import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/model/library/get_collection_model.dart';
import 'package:puthagam/screen/dashboard/library/collections/collection_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

import '../../handler/api_url.dart';

createCollectionApi({name}) async {
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

        http.Response response = await ApiHandler.post(
            url: "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Collections",
            body: {
              "_id": "00000000-0000-0000-0000-000000000000",
              "userId": LocalStorage.userId,
              "name": name
            });

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          collectionController.collectionList.add(CollectionModel(
              id: decoded['data']['_id'],
              name: decoded['data']['name'],
              image: decoded['data']['image'],
              bookCount: int.parse(decoded['data']['bookCount'].toString()).obs,
              bookIds: decoded['data']['bookIds'],
              userId: decoded['data']['userId']));

          collectionController.controller.value.clear();
          collectionController.showLoading.value = false;
          toast(decoded['status']['message'], true);
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          collectionController.showLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          collectionController.showLoading.value = false;
          toast(decoded['status']['message'], false);
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
