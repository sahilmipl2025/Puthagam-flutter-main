import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/model/category/get_category_list_model.dart';
import 'package:puthagam/screen/auth/select_topic/select_topic_controller.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';


getCategoryListApi({fromHome = false}) async {
  SelectTopicController con = Get.put(SelectTopicController());
  HomeController homeController = Get.put(HomeController());
  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      homeController.isConnected.value = true;
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        if (fromHome == false) {
          homeController.categoryLoading.value = true;
        }

        con.isLoading.value = true;

        http.Response response = await ApiHandler.get(
          url: ApiUrls.baseUrl + ApiUrls.getCategoryList + LocalStorage.userId,
        );

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          var decoded = getCategoryModelFromJson(response.body);
          con.categoryList.value = decoded.data!;
          homeController.categoryList.value = decoded.data!;
          homeController.categoryList2.value = decoded.data!;
          con.isLoading.value = false;
          homeController.categoryLoading.value = false;
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          con.isLoading.value = false;
          homeController.categoryLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          con.isLoading.value = false;
          homeController.categoryLoading.value = false;
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      homeController.isConnected.value = false;
      homeController.categoryLoading.value = false;
      con.isLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    homeController.categoryLoading.value = false;
    con.isLoading.value = false;
  } finally {
    if (fromHome == false) {
      homeController.getCategoryBooksListApi();
    }
  }
}
