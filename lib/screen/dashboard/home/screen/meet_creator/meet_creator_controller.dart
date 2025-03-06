import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/model/meet_creator/get_meet_creator_modal.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

class MeetCreatorController extends GetxController {
  RxBool isConnected = false.obs;
  RxBool isLoading = false.obs;
  RxBool paginationLoading = false.obs;
  RxList<MeetCreator> creatorList = <MeetCreator>[].obs;
  ScrollController newScrollController = ScrollController();
  RxInt page = 0.obs;
  RxBool nextPageStop = false.obs;

  @override
  void onInit() {
    super.onInit();
    manageScrollController();
  }

  @override
  void onReady() {
    super.onReady();
    getCreatorList(pagination: false);
  }

  void manageScrollController() async {
    newScrollController.addListener(
      () {
        if (newScrollController.position.maxScrollExtent ==
            newScrollController.position.pixels) {
          if (nextPageStop.isFalse && paginationLoading.isFalse) {
            getCreatorList(pagination: true);
          }
        }
      },
    );
  }

  getCreatorList({pagination}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          isConnected.value = true;
          if (pagination == true) {
            paginationLoading.value = true;
          } else {
            isLoading.value = true;
            creatorList.clear();
            page.value = 0;
            nextPageStop.value = false;
          }

          http.Response response = await ApiHandler.post(
              url:
                  "${ApiUrls.baseUrl}Book/${LocalStorage.userId}/MeetTheCreator",
              body: {
                "categoryId": "",
                "start": page.value,
                "length": 32,
                "searchString": "",
                "subcategoryIds": "",
                "authorId": "",
                "sortBy": ""
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
                creatorList.add(element);
              }
              page.value++;
            }

            if (creatorList.length.toString() ==
                decoded.status!.totalRecords.toString()) {
              nextPageStop.value = true;
            }

            isLoading.value = false;
            paginationLoading.value = false;
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            isLoading.value = false;
            paginationLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            isLoading.value = false;
            paginationLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        isConnected.value = false;
        isLoading.value = false;
        paginationLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      isLoading.value = false;
      paginationLoading.value = false;
      // toast(e.toString(), false);
    }
  }
}
