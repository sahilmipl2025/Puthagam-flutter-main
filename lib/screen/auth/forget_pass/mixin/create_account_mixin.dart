import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/handler/api_handler.dart';
import '../../../../data/handler/api_url.dart';
import '../../../../podcaster/core/widgets/build_loading.dart';
import '../../../../utils/app_routes.dart';
import '../../../../utils/app_utils.dart';

mixin CreateAccountMixin {
  String emaill = "";
  String passwordd = "";
  bool signup = false;

  Future<void> sendOTPForSignUp(
      String email,
      String password,
      TextEditingController otpController,
      AmplifyException amplifyException) async {
    try {
      emaill = email;
      passwordd = password;

      buildDialogLoadingIndicator();
      final userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.email: email,
      };
      if (amplifyException is UserNotConfirmedException) {
        await Amplify.Auth.resendSignUpCode(
          username: email.trim(),
        );
      } else {
        await Amplify.Auth.signUp(
          username: email.trim(),
          password: password,
          options: CognitoSignUpOptions(userAttributes: userAttributes),
        );
      }
      signup = amplifyException is UserNotFoundException;
      Get.back();
      Get.snackbar("Success", "OTP has been sent to your email id",
          backgroundColor: Colors.green);
      Get.toNamed(AppRoutes.otpScreen, arguments: {"type": "create"});
    } on AuthException catch (e) {
      log("error $e");
      Get.back();
      Get.snackbar("Error", e.message, backgroundColor: Colors.red);
    }
  }

  Future<void> confirmCreateUser(
    String otp,
  ) async {
    try {
      buildDialogLoadingIndicator();
      await Amplify.Auth.confirmSignUp(username: emaill, confirmationCode: otp);
      log("is signup $signup");
      if (signup) {
        await createAccountInServer(emaill, passwordd);
      }
      Get.back();
      Get.snackbar("Success", "Password reset successfully");
      Get.offAllNamed(AppRoutes.loginScreen);
    } on AuthException catch (e) {
      safePrint(e.message);
      Get.back();
      Get.snackbar("Error", e.message, backgroundColor: Colors.red);
      await isUserLoggedIn();
    }
  }

  createAccountInServer(String email, String password) async {
    log("create account in server for google signin");
    await Amplify.Auth.signIn(username: email, password: password);
    final user = await Amplify.Auth.getCurrentUser();
    var token = await getToken();
    var body = {
      "name": "test",
      "emailOrPhone": email.trim(),
      "dateofBirth": null,
      "authKey": user.userId,
      "googleId": "",
      "facebookId": "",
      "deviceToken": token,
      "deviceType": "android"
    };
    log("body $body");
    await ApiHandler.post(url: ApiUrls.baseUrl + ApiUrls.signupUrl, body: body);
  }
}
