import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/model/category/get_subcategory_model.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

getSubcategoryApi(String categoryId) async {
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
        con.subCategoryList.clear();

        http.Response response = await ApiHandler.get(
            url: ApiUrls.baseUrl +
                ApiUrls.subCategory +
                LocalStorage.userId +
                "/" +
                categoryId.toString());

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          var decoded = getSubCategoryModelFromJson(response.body);
          if (decoded.data!.isNotEmpty) {
            con.subCategoryList.value = decoded.data!;
          }
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    // toast(e.toString(), false);
  }
}
