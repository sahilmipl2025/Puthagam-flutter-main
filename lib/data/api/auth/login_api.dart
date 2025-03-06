// ignore_for_file: dead_code_on_catch_subtype

import 'dart:convert';
import 'dart:developer';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:puthagam/data/api/profile/get_profile_api.dart';
import 'package:puthagam/screen/auth/login/login_controller.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/api_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

 loginApi({bool doSignup = false}) async {
   LoginController con = Get.put(LoginController());

   try {
     if (kDebugMode) {
       print("Checking network connection...");
     }
     bool connection = await NetworkInfo(connectivity: Connectivity())
         .isConnected();

     if (connection) {
       if (kDebugMode) {
         print("Connected to the internet");
       }
       con.isLoading.value = true;

       if (kDebugMode) {
         print("Fetching token...");
       }
       var token = await getToken();
       if (kDebugMode) {
         print("Token received: $token");
       }

       if (kDebugMode) {
         print("Signing in with username: ${con.emailController.value.text
             .trim()}");
       }
       await Amplify.Auth.signIn(
         username: con.emailController.value.text.trim(),
         password: con.passwordController.value.text,
       );

       final user = await Amplify.Auth.getCurrentUser();
       if (kDebugMode) {
         print("Current user ID: ${user.userId}");
       }

       if (kDebugMode) {
         print("Checking if email exists: ${con.emailController.value.text}");
       }
       http.Response emailExitsResponse = await ApiHandler.post(
           url: ApiUrls.baseUrl +
               'Auth/IsEmailExists?email=${con.emailController.value.text}');

       print("Email exists response code: ${emailExitsResponse.statusCode}");
       var body = {
         "emailOrPhone": con.emailController.value.text,
         "authKey": user.userId,
         "deviceToken": token,
         if (emailExitsResponse.statusCode == 404)
           "name": con.emailController.value.text.split("@")[0],
         "deviceType": "android"
       };

       if (kDebugMode) {
         print("Sending login/signup request with body: $body");
       }
       http.Response response = await ApiHandler.post(
           url: ApiUrls.baseUrl +
               (emailExitsResponse.statusCode == 404
                   ? ApiUrls.signupUrl
                   : ApiUrls.loginUrl),
           body: body);

       if (kDebugMode) {
         print("Response code: ${response.statusCode}");
       }
       if (response.statusCode == 200 ||
           response.statusCode == 201 ||
           response.statusCode == 202 ||
           response.statusCode == 203 ||
           response.statusCode == 204) {
         var decoded = jsonDecode(response.body);
         if (kDebugMode) {
           print("Response body: $decoded");
         }

         LocalStorage.storedToken(decoded['data'], true,
             pass: con.passwordController.value.text);
         con.isLoading.value = false;

         if (emailExitsResponse.statusCode == 404) {
           print("User registered successfully");
           toast("User Registered Successfully", false);
         }

         Get.lazyPut<BookDetailApiController>(() => BookDetailApiController(),
             fenix: true);

         var box = GetStorage();
         await box.write(Prefs.socialLogin, false);
         LocalStorage.socialLogin = false;

         print("Fetching user profile...");
         await getUserProfileApi();

         HomeController hCon = Get.put(HomeController());
         hCon.callAllApis();

         if (decoded['data']['phoneNumber']
             .toString()
             .isNotEmpty &&
             decoded['data']['phoneNumber'].toString() != "null") {
           if (kDebugMode) {
             print("Phone number is not empty");
           }
           if (emailExitsResponse.statusCode == 404) {
             if (kDebugMode) {
               print("Navigating to WhatsApp Screen for new user");
             }
             Get.offAllNamed(AppRoutes.whatsappScreen, arguments: true);
           } else {
             if (kDebugMode) {
               print("Navigating to Bottom Bar Screen for existing user");
             }
             Get.offAllNamed(AppRoutes.bottomBarScreen);
           }
         } else {
           if (kDebugMode) {
             print("Phone number is empty, navigating to WhatsApp Screen");
           }
           Get.offAllNamed(AppRoutes.whatsappScreen, arguments: true);
         }
       } else {
         if (kDebugMode) {
           print("Failed response with body: ${response.body}");
         }
         var decoded = jsonDecode(response.body);
         con.isLoading.value = false;
         toast(decoded['status']['message'], false);
       }
     } else {
       print("No internet connection");
       con.isLoading.value = false;
       toast("No Internet Connection!", false);
     }
   } on UserNotConfirmedException {
     print("User not confirmed, resending OTP");
     con.isLoading.value = false;
     toast("OTP sent to your email, please verify", true);
     await Amplify.Auth.resendSignUpCode(
       username: con.emailController.value.text.trim(),
     );
     Get.toNamed(AppRoutes.otpScreen,
         arguments: {"email": con.emailController.value.text});
   } on AuthNotAuthorizedException {
     print("Incorrect username or password");
     con.isLoading.value = false;
     toast("Incorrect username or password", false);
   } on UserNotFoundException {
     print("User not found, prompting for registration");
     con.isLoading.value = false;
     toast("User not found, try register", false);
   } catch (e) {
     print("Error occurred: ${e.toString()}");
     con.isLoading.value = false;
     await isUserLoggedIn();
   }
 }