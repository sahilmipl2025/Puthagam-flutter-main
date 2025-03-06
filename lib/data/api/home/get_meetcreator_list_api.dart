import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:puthagam/model/meet_creator/get_meet_creator_modal.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

import '../../handler/api_url.dart';

getMeetCreator() async {
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
        con.meetCreatorLoading.value = true;
        // con.meetCreatorList.clear();

        http.Response response = await ApiHandler.post(
            url: "${ApiUrls.baseUrl}Book/${LocalStorage.userId}/MeetTheCreator",
            body: {
              "categoryId": "string",
              "start": 0,
              "length": 20,
              "searchString": "",
              "topListen": true,
              "topDownload": true,
              "subcategoryIds": "string"
            });

        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          var decoded = getMeetCreatorModelFromJson(response.body);
          if (decoded.data!.isNotEmpty) {
            for (var element in decoded.data!) {
              if (con.meetCreatorList
                  .where((p0) => p0.id == element.id)
                  .isEmpty) {
                con.meetCreatorList.add(element);
              }
            }
          }

          con.meetCreatorLoading.value = false;
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          con.meetCreatorLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          con.meetCreatorLoading.value = false;
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      con.isConnected.value = false;
      con.meetCreatorLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    con.meetCreatorLoading.value = false;
    // toast(e.toString(), false);
  }
}
