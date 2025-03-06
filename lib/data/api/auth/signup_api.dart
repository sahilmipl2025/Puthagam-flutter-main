import 'dart:convert';
import 'dart:developer';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/api/profile/get_profile_api.dart';
import 'package:puthagam/data/api/profile/get_users_purchase_list_api.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/screen/auth/signup/signup_controller.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../utils/app_utils.dart';
import '../../../utils/local_storage/local_storage.dart';

signUpApi() async {
  SignUpController con = Get.put(SignUpController());

  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      con.isLoading.value = true;
      var token = await getToken();
      log(token);

      final user = await Amplify.Auth.getCurrentUser();
      var body = {
        "name": con.nameController.value.text,
        "emailOrPhone": con.emailController.value.text.trim(),
        "dateofBirth": null,
        "authKey": user.userId,
        "googleId": "",
        "facebookId": "",
        "deviceToken": token,
        "deviceType": "android"
      };

      log("body $body");

      http.Response response = await ApiHandler.post(
          url: ApiUrls.baseUrl + ApiUrls.signupUrl, body: body);
      log("respone2 ${response.body}");

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 203 ||
          response.statusCode == 204) {
        con.isLoading.value = false;
        var decoded = jsonDecode(response.body);
        LocalStorage.storedToken(decoded['data'], true,
            pass: con.passwordController.value.text);
        var box = GetStorage();
        await box.write(Prefs.socialLogin, false);
        LocalStorage.socialLogin = false;

        Get.offAllNamed(AppRoutes.whatsappScreen, arguments: true);
        toast("Successfully Registered", true);
      } else {
        var decoded = jsonDecode(response.body);
        con.isLoading.value = false;
        toast(decoded['status']['message'], false);
      }
    } else {
      con.isLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    log("e $e");
    con.isLoading.value = false;
    // toast(e.toString(), false);
    await isUserLoggedIn();
  }
}

socialLoginApi(String googleid, String fbid, String name, String emailOrPhone,
    bool isExist) async {
  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    var token = await getToken();
    log(token);
    if (connection) {
      var body = {
        "name": name,
        "emailOrPhone": emailOrPhone,
        "dateofBirth": null,
        "password": "",
        "googleId": googleid,
        "facebookId": fbid,
        "deviceToken": token,
        "deviceType": "android"
      };
      Get.dialog(const CupertinoActivityIndicator().centered());
      log("body $body");
      http.Response response = await ApiHandler.post(
          url: ApiUrls.baseUrl + ApiUrls.signupUrl, body: body);
      log("body ${response.body}");
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 203 ||
          response.statusCode == 204) {
        Get.back();
        var decoded = jsonDecode(response.body);
        log("decoded $decoded");
        LocalStorage.storedToken(decoded['data'], true, pass: null);

        var box = GetStorage();
        await box.write(Prefs.socialLogin, true);
        LocalStorage.socialLogin = true;
        await getUserProfileApi();
        getPurchasesListApi();
        if (isExist == true) {
          if (decoded['data']['phoneNumber'].toString().isNotEmpty &&
              decoded['data']['phoneNumber'].toString() != "null") {
            HomeController hCon = Get.put(HomeController());
            hCon.callAllApis();
            Get.offAllNamed(AppRoutes.bottomBarScreen);
            toast("Successfully Logged in", true);
          } else {
            toast("Successfully Logged in", true);
            Get.offAllNamed(AppRoutes.whatsappScreen, arguments: true);
          }
        } else {
          Get.offAllNamed(AppRoutes.whatsappScreen, arguments: true);
          toast("Successfully Registered", true);
        }
      } else {
        var decoded = jsonDecode(response.body);
        log("decoded $decoded");
        Get.back();
        toast(decoded['status']['message'], false);
      }
    } else {
      Get.back();
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    Get.back();
    log("err ${e.toString()}");
    // toast(e.toString(), false);
  }
}

checkEmailApi(
    String googleid, String fbid, String name, String emailOrPhone) async {
  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    var token = await getToken();
    log(token);
    if (connection) {
      Get.dialog(const CupertinoActivityIndicator().centered());

      http.Response response = await ApiHandler.post(
          url: ApiUrls.baseUrl + 'Auth/IsEmailExists?email=$emailOrPhone');
      log("body ${response.body}");
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 203 ||
          response.statusCode == 204 ||
          response.statusCode == 409 ||
          response.statusCode == 404) {
        if (jsonDecode(response.body)['isExists'].toString() == "true") {
          await socialLoginApi(googleid, fbid, name, emailOrPhone, true);
        } else {
          await socialLoginApi(googleid, fbid, name, emailOrPhone, false);
        }
      } else {
        var decoded = jsonDecode(response.body);
        Get.back();
        toast(decoded['message'], false);
      }
    } else {
      Get.back();
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    Get.back();
    log("err ${e.toString()}");
    // toast(e.toString(), false);
  }
}
