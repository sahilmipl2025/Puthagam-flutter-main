import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:puthagam/data/api/library/get_downloads_list_api.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/model/library/get_download_book_model.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;

import '../../../../data/handler/api_url.dart';

class DownloadController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool downloadLoading = false.obs;
  RxList<DownloadBook> downloadList = <DownloadBook>[].obs;
  Rx<TextEditingController> textCon = TextEditingController().obs;
  RxBool isSearch = false.obs;

  RxBool paginationLoading = false.obs;

  ScrollController newScrollController = ScrollController();
  RxInt page = 0.obs;
  RxBool nextPageStop = false.obs;

  @override
  void onReady() {
    super.onReady();
    getDownloadBookApi(pagination: false);
  }

  @override
  void onInit() {
    super.onInit();
    manageScrollController();
  }

  void manageScrollController() async {
    newScrollController.addListener(
      () {
        if (newScrollController.position.maxScrollExtent ==
            newScrollController.position.pixels) {
          if (nextPageStop.isFalse) {
            getDownloadBookApi(pagination: true);
          }
        }
      },
    );
  }

  /// Download Books Api

  removeDownloadBooksApi({bookId, index}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          downloadLoading.value = true;

          http.Response response = await ApiHandler.delete(
              url:
                  "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Download/$bookId");

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            toast(decoded['message'], true);
            // toast("Delete Successfully", true);
            downloadList.removeAt(index);
            downloadLoading.value = false;
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            downloadLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            downloadLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        downloadLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      downloadLoading.value = false;
      toast(e.toString(), false);
    }
  }

  downloadBooks(bookId, index, context) async {
    try {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.storage].request();
      if (statuses[Permission.storage]!.isGranted) {
        // var dir = await DownloadsPathProvider.downloadsDirectory;
        var dir = await getApplicationDocumentsDirectory();
        if (dir.toString() != "null") {
          String savePath = dir.path + "/$bookId/";

          if (await io.Directory(savePath).exists() ||
              io.Directory(savePath).existsSync()) {
            FocusScope.of(context).unfocus();
            Get.find<BookDetailController>()
                .callApis(bookID: downloadList[index].id);
            Get.toNamed(AppRoutes.bookDetailScreen,
                arguments: downloadList[index].id);
          } else {
            toast("Can't find downloaded book in your mobile", false);
          }
        }
      } else {
        toast("Provide permission to access download files", false);
      }
    } catch (e) {
      rethrow;
    }
  }
}
