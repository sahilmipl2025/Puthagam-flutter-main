import 'dart:convert';
import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/profile/edit_profile/edit_controller.dart';
import 'package:puthagam/screen/dashboard/profile/whatsapp_page/whats_app_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

updateWaNumber(bool status, bool fromRegister) async {
  WhatsAppController con = Get.find<WhatsAppController>();
  EditProfileController con1 = Get.put(EditProfileController());
  log('update_WA_numberApi entry');
  con.loaderBool.value = true;
  // try {
  log('update_WA_numberApi try');
  bool connection =
      await NetworkInfo(connectivity: Connectivity()).isConnected();
  if (connection) {
    await LocalStorage.getData();
    if (LocalStorage.token.toString() != "null" &&
        LocalStorage.token.toString().isNotEmpty &&
        LocalStorage.userId.toString() != "null" &&
        LocalStorage.userId.toString().isNotEmpty) {
      var body = {
        "name": con1.name.text,
        "phoneNumber": "+" +
            con.selectedCountry.value.phoneCode +
            con.phoneNumberController.text,
        "phoneNumberVerified": status,
      };
      log("update user url ${ApiUrls.baseUrl + 'User/' + LocalStorage.userId + '/User'}");

      http.Response response = await ApiHandler.post(
        url: ApiUrls.baseUrl + 'User/' + LocalStorage.userId + '/User',
        body: body,
      );

      var decoded = jsonDecode(response.body);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 203 ||
          response.statusCode == 204) {
        var box = GetStorage();

        log("update whatsapp number api ${response.body}");
        await box.write(
            Prefs.userData, jsonEncode(jsonDecode(response.body)['user']));
        LocalStorage.userData = jsonDecode(response.body)['user'] ?? "";

        await box.write(
            Prefs.userName, jsonDecode(response.body)['user']['name'] ?? " ");
        LocalStorage.userName =
            jsonDecode(response.body)['user']['name'] ?? " ";
        log(' local Storage ${jsonDecode(response.body)['user']['phoneNumberVerified']}');
        LocalStorage.isPhoneVerified =
            jsonDecode(response.body)['user']['phoneNumberVerified'];
        LocalStorage.phoneNumber =
            jsonDecode(response.body)['user']['phoneNumber'] ?? "";

        baseController!.userName.value =
            jsonDecode(response.body)['user']['name'] ?? " ";

        baseController!.userProfile.value = LocalStorage.profileImage;
        con.loaderBool.value = false;
        if (fromRegister) {
          Get.offAllNamed(AppRoutes.selectTopicsScreen, arguments: false);
        } else {
          Get.back();
          Get.back();
        }
        toast("Number Saved successfully", true);
      } else if (response.statusCode == 401) {
        LocalStorage.clearData();
        con.loaderBool.value = false;
        Get.offAllNamed(AppRoutes.loginScreen);
        toast(decoded['message'], false);
      } else {
        con.loaderBool.value = false;
        toast(decoded['message'], false);
      }
    }
  } else {
    toast("No Internet Connection!", false);
    con.loaderBool.value = false;
  }
  // } catch (e) {
  //   con.loaderBool.value = false;
  //   log('update_WA_numberApi catch $e');
  //   toast(e.toString(), false);
  // }
  con.loaderBool.value = false;
}
