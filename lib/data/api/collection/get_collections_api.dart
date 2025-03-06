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

getCollectionList() async {
  CollectionController con = Get.put(CollectionController());
  // try {
  bool connection =
      await NetworkInfo(connectivity: Connectivity()).isConnected();
  if (connection) {
    await LocalStorage.getData();
    if (LocalStorage.token.toString() != "null" &&
        LocalStorage.token.toString().isNotEmpty &&
        LocalStorage.userId.toString() != "null" &&
        LocalStorage.userId.toString().isNotEmpty) {
      con.isConnected.value = true;
      con.isLoading.value = true;
      con.collectionList.clear();

      http.Response response = await ApiHandler.get(
          url:
              '${ApiUrls.baseUrl}User/${LocalStorage.userId}/Collections/true');

      var decoded = jsonDecode(response.body);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 203 ||
          response.statusCode == 204) {
        var decoded = getCollectionModelFromJson(response.body);
        if (decoded.data!.isNotEmpty) {
          for (var element in decoded.data!) {
            con.collectionList.add(element);
          }
        }

        con.isLoading.value = false;
      } else if (response.statusCode == 401) {
        LocalStorage.clearData();
        
        con.isLoading.value = false;
        Get.offAllNamed(AppRoutes.loginScreen);
        toast(decoded['status']['message'], false);
      } else {
        con.isLoading.value = false;
        toast(decoded['status']['message'], false);
      }
    }
  } else {
    con.isConnected.value = false;
    con.isLoading.value = false;
    toast("No Internet Connection!", false);
  }
  // } catch (e) {
  //   con.isLoading.value = false;
  //   // toast(e.toString(), false);
  // }
}
