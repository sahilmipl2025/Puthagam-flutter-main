import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/screen/auth/select_topic/select_topic_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

updateCategoryApi({status, categoryId}) async {
  SelectTopicController con = Get.put(SelectTopicController());

  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        con.showLoading.value = true;
        var box = GetStorage();
        LocalStorage.token = await box.read(Prefs.token) ?? "";

        var headers = {'Authorization': 'Bearer ${LocalStorage.token}'};

        var request = http.Request(
          'PATCH',
          Uri.parse(ApiUrls.baseUrl +
              'Category/${LocalStorage.userId}/$categoryId/$status'),
        );

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          con.categoryList
              .firstWhere((element) => element.id == categoryId)
              .isSelected!
              .value = status;
          con.showLoading.value = false;
        } else if (response.statusCode == 401) {
          var decoded = jsonDecode(await response.stream.bytesToString());
          LocalStorage.clearData();
          con.showLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          var decoded = jsonDecode(await response.stream.bytesToString());
          con.showLoading.value = false;
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      con.showLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    con.showLoading.value = false;
    // toast(e.toString(), false);
  }
}
