import 'dart:convert';
import 'dart:developer';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/profile/edit_profile/edit_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

getUpdatePhoto() async {
  EditProfileController con = Get.put(EditProfileController());

  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        con.isLoading.value = true;

        var box = GetStorage();
        LocalStorage.token = await box.read(Prefs.token) ?? "";

        var headers = {'Authorization': 'Bearer ${LocalStorage.token}'};

        var request = http.MultipartRequest(
            'POST',
            Uri.parse(ApiUrls.baseUrl +
                'User/' +
                LocalStorage.userId +
                '/UploadProfileImage'));

        if (con.image.toString() != "null") {
          request.files.add(
              await http.MultipartFile.fromPath('file', con.image.value.path));
        }

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        final respStr = await response.stream.bytesToString();

        con.isLoading.value = false;

        var decoded = jsonDecode(respStr);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          var box = GetStorage();
          await box.write(Prefs.profileImage, await decoded['filePath'] ?? "");
          LocalStorage.profileImage = await decoded['filePath'] ?? "";
          log("apiimage ${LocalStorage.profileImage}");
          baseController!.userProfile.value = await decoded['filePath'];
          con.isLoading.value = false;
          toast("Profile picture uploaded successfully", true);
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          con.isLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
        } else {
          con.isLoading.value = false;
        }
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
