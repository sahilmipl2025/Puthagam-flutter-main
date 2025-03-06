import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/model/library/get_saved_book_model.dart';
import 'package:puthagam/screen/dashboard/library/saved/saved_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

import '../../handler/api_url.dart';

getSavedBookApi({pagination}) async {
  SavedController con = Get.put(SavedController());
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
        if (pagination == true) {
          con.paginationLoading.value = true;
        } else {
          con.isLoading.value = true;
          con.savedBookList.clear();
          con.page.value = 0;
          con.nextPageStop.value = false;
        }

        http.Response response = await ApiHandler.post(
            url: "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Saved",
            body: {
              "categoryId": "",
              "start": con.page.value,
              "length": 15,
              "searchString": con.textCon.value.text.toLowerCase(),
              "subcategoryIds": "",
              "authorId": "",
              "sortBy": ""
            });

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          var decoded = getSavedBookModelFromJson(response.body);
          if (decoded.data!.isNotEmpty) {
            for (var element in decoded.data!) {
              if (!con.savedBookList.contains(element)) {
                con.savedBookList.add(element);
              }
            }

            con.page.value++;
          }

          if (con.savedBookList.length.toString() ==
              decoded.status!.totalRecords.toString()) {
            con.nextPageStop.value = true;
          }

          con.paginationLoading.value = false;
          con.isLoading.value = false;
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          con.isLoading.value = false;
          con.paginationLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          // toast(decoded['message'], false);
        } else {
          con.isLoading.value = false;
          con.paginationLoading.value = false;
          // toast(decoded['message'], false);
        }
      }
    } else {
      con.isConnected.value = false;
      con.isLoading.value = false;
      con.paginationLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    con.isLoading.value = false;
    con.paginationLoading.value = false;
    // toast(e.toString(), false);
  }
}
