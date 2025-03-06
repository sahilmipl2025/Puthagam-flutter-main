import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:puthagam/podcaster/core/widgets/build_loading.dart';

Future<String> getToken() async {
  try {
    var token = await FirebaseMessaging.instance.getToken();
    return token!;
  } catch (err) {
    log("err $err");
    return "";
  }
}

bool get isTablet => Get.width >= 550;

isUserLoggedIn() async {
  try {
    buildDialogLoadingIndicator();
    final res = await Amplify.Auth.fetchAuthSession();
    Get.back();
    if (res.isSignedIn) {
      await logoutUser();
      return true;
    }
  } catch (err) {
    Get.back();
    return false;
  }
}

logoutUser() async {
  await Amplify.Auth.signOut();
}
