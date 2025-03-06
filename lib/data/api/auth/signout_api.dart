import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/profile/profile_page/profile_controller.dart';

import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';

logout() async {
  final ProfileController con = Get.put(ProfileController());
  try {
    con.deleteLoader.value = true;
    var response = await patch(
      Uri.parse(ApiUrls.baseUrl + 'Auth/Signout/${LocalStorage.userId}'),
    );
    if (response.statusCode == 200) {
      baseController!.alreadyPremium.value = false;
      await LocalStorage.clearData();

      (await Amplify.Auth.signOut());
      Get.offAllNamed(AppRoutes.loginScreen);
    } else {      baseController!.clearData();

    debugPrint('failed');
    }
  } catch (e) {
    debugPrint(e.toString());
  } finally {
    con.deleteLoader.value = false;
  }
}

deleteAccount() async {
  final ProfileController con = Get.put(ProfileController());
  try {
    con.deleteLoader.value = true;
    var response = await delete(
      Uri.parse(ApiUrls.baseUrl + 'Auth/DeleteAccount/${LocalStorage.userId}'),
    );
    if (response.statusCode == 200) {
      baseController!.alreadyPremium.value = false;
        baseController!.clearData();

      (await Amplify.Auth.signOut());
      Get.offAllNamed(AppRoutes.loginScreen);
    } else {
      debugPrint('failed');
    }
  } catch (e) {
    debugPrint(e.toString());
  } finally {
    con.deleteLoader.value = false;
  }
}
