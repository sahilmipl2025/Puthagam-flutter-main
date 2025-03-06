import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/model/podcast/get_podcast_explore_modal.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

import '../../../../../data/handler/api_url.dart';

class ExplorePodcastController extends GetxController {
  RxBool isConnected = false.obs;
  RxBool paginationLoading = false.obs;
  ScrollController newScrollController = ScrollController();
  RxInt page = 0.obs;
  RxBool nextPageStop = false.obs;
  RxBool isLoading = false.obs;
  RxBool showLoading = false.obs;
  RxList<ExplorePodcast> podcastList = <ExplorePodcast>[].obs;

  RxBool status1 = false.obs;
  RxBool status2 = false.obs;
  RxString selectedAuthorId = "".obs;

  @override
  void onInit() {
    super.onInit();
    manageScrollController();
  }

  @override
  void onReady() {
    super.onReady();
    getCategoriesListApi(pagination: false);
  }

  void manageScrollController() async {
    newScrollController.addListener(
      () {
        if (newScrollController.position.maxScrollExtent ==
            newScrollController.position.pixels) {
          if (nextPageStop.isFalse) {
            getCategoriesListApi(pagination: true);
          }
        }
      },
    );
  }

  getCategoriesListApi({pagination}) async {
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
            podcastList.clear();
            page.value = 0;
            nextPageStop.value = false;
          }

          http.Response response = await ApiHandler.post(
              url: '${ApiUrls.baseUrl}Podcast/${LocalStorage.userId}/Podcasts',
              body: {
                "categoryId": "",
                "start": page.value,
                "length": 10,
                "searchString": "",
                "subcategoryIds": "",
                "authorId": selectedAuthorId.value,
                "sortBy": ""
              });

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = getExplorePodcastModelFromJson(response.body);

            if (decoded.data!.isNotEmpty) {
              for (var element in decoded.data!) {
                podcastList.add(element);
              }
              page.value++;
            }

            if (podcastList.length.toString() ==
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
      toast(e.toString(), false);
    }
  }

  /// Save Bookmark API

  savedBookApi({bookId, index}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          showLoading.value = true;

          http.Response response = await ApiHandler.post(
            url: "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Save/$bookId",
          );

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            podcastList[index].isSaved!.value = true;
            showLoading.value = false;
            // toast("Added to Save Successfully", true);
            toast(decoded['message'], true);
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            showLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['message'], false);
          } else {
            showLoading.value = false;

            toast(decoded['message'], false);
          }
        }
      } else {
        showLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      showLoading.value = false;
      toast(e.toString(), false);
    }
  }

  /// Remove Book Api

  deleteSavedBookApi({bookId, index}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          showLoading.value = true;

          http.Response response = await ApiHandler.delete(
            url: "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Save/$bookId",
          );

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            podcastList[index].isSaved!.value = false;
            showLoading.value = false;
            toast(decoded['message'], true);
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            showLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['message'], false);
          } else {
            showLoading.value = false;
            toast(decoded['message'], false);
          }
        }
      } else {
        showLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      showLoading.value = false;
      toast(e.toString(), false);
    }
  }
}
