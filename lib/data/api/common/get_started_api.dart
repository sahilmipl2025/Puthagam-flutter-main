import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/model/get_started_model.dart';
import 'package:puthagam/screen/auth/intro/intro_controller.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

import '../../handler/api_url.dart';

getStartedApi() async {
  IntroController con = Get.put(IntroController());

  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      con.isLoading.value = true;

      con.getStartedList.clear();

      http.Response response = await ApiHandler.get(
        url: "${ApiUrls.baseUrl}Auth/StartedScreens",
      );

      var decoded = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 203 ||
          response.statusCode == 204) {
        var decoded = getStartedModelFromJson(response.body);
        for (var element in decoded) {
          con.getStartedList.add(element);
        }

        debugPrint(con.getStartedList.length.toString());

        con.isLoading.value = false;
      } else {
        con.isLoading.value = false;
        con.isLoading.value = false;
        toast(decoded['detail'], false);
      }
    } else {
      con.isLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    con.isLoading.value = false;
    // toast(e.toString(), false);
  }
}
