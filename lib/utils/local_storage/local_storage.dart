import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/podcaster/core/utils/app_utils.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/podcaster/data/datasources/local/app_database.dart'
    as podcaster;
import 'package:puthagam/utils/themes/theme.dart';

class LocalStorage {
 
  static String tokenid = "";
  static String id = "";
  static String userId = "";
  static String token = "";
  static String userName = "";
  static String isPodcaster = "false";
  static String userEmail = "";
  static String profileImage = "";
  static String phoneNumber = "";
  static bool isPhoneVerified = false;
  static String userDOB = "";
  static String password = "";
  static Map userData = {};
  static List downloadBooksList = [];
  static String planEndDate = "";
  static String planId = "";
  static bool downloadWithMobileData = true;
  static bool autoPlay = true;
  static bool isPremium = false;
  static bool isShared = false;
  static bool socialLogin = false;
  static bool dailyReminder = true;
  static bool podcastNotification = true;
  static bool productUpdate = true;

  static GetStorage box = GetStorage();

  static Future<void>? getData() async {
    token = await box.read(Prefs.token) ?? "";
    tokenid = box.read(Prefs.tokenid) ??"";
    id = box.read(Prefs.id) ?? "";
    userId = box.read(Prefs.userId) ?? "";
    userName = box.read(Prefs.userName) ?? "";
    isPodcaster = (box.read(Prefs.isPodcaster) ?? "false").toString();
    userEmail = box.read(Prefs.userEmail) ?? "";
    profileImage = box.read(Prefs.profileImage) ?? "";
    phoneNumber = box.read(Prefs.phoneNumber) ?? "";
    password = box.read(Prefs.password) ?? "";
    userDOB = box.read(Prefs.userDOB) ?? "";
    userData = jsonDecode(box.read(Prefs.userData) ?? "{}");
    downloadBooksList = jsonDecode(box.read(Prefs.downloadBooks) ?? "[]");
    planEndDate = box.read(Prefs.planEndDate).toString();
    planId = box.read(Prefs.planId) ?? "";
    downloadWithMobileData = box.read(Prefs.downloadWithMobileData) ?? true;

    isPhoneVerified = box.read(Prefs.isPhoneVerified) ?? false;
    autoPlay = box.read(Prefs.autoPlay) ?? true;
    isPremium = box.read(Prefs.isPremium) ?? false;
    isShared = box.read(Prefs.isShared) ?? false;
    socialLogin = box.read(Prefs.socialLogin) ?? false;
    productUpdate = box.read(Prefs.productUpdate) ?? true;
    baseController!.isShared.value = isShared;
    baseController!.isSubscribed.value = isPremium;
    baseController!.downloadBooks.value = downloadBooksList;
    baseController!.userName.value = userName;
    baseController!.isPodcaster.value = isPodcaster;
    baseController!.userDOB.value = userDOB;
    baseController!.userProfile.value = profileImage;
  }

  static setDarkMode(bool value) async {
    await box.write(Prefs.isDarkMode, value);
  }

  static getThemeStatus() {
    final isDarkMode = box.read(Prefs.isDarkMode) ?? false;
    Get.changeTheme(
      isDarkMode == true ? AppTheme.dark : AppTheme.light,
    );
    log("dark ${Get.isDarkMode}");
  }

  static void storedToken(data, storeToken, {pass}) async {
    var box = GetStorage();

    await box.write(Prefs.userData, jsonEncode(data));
    userData = data ?? "";

    if (storeToken == true) {
      await box.write(Prefs.token, data['token'] ?? "");
      token = data['token'] ?? "";
    }

    await box.write(Prefs.userId, data['_id'] ?? "");
    userId = data['_id'] ?? "";

     await box.write(Prefs.tokenid, data['_id'] ?? "");
     tokenid = data['_id'] ?? "";
    

    podcaster.LocalStorages.saveAuthorId(userId);
    await box.write(Prefs.userName, data['name'] ?? "");
    userName = data['name'] ?? "";
    podcaster.LocalStorages.saveName(userName);
    CommonRepository.setApiService();

    await box.write(
        Prefs.isPodcaster, (data['isPodcaster'] ?? "false").toString());
    isPodcaster = (data['isPodcaster'] ?? "false").toString();

    await box.write(Prefs.userEmail, data['email'] ?? "");
    userEmail = data['email'] ?? "";

    await box.write(Prefs.profileImage, data['image'] ?? "");
    profileImage = data['image'] ?? "";

    await box.write(Prefs.phoneNumber, data['phoneNumber'] ?? "");
    phoneNumber = data['phoneNumber'] ?? "";

    await box.write(Prefs.phoneNumber, data['phoneNumber'] ?? "");
    phoneNumber = data['phoneNumber'] ?? "";
    await box.write(
        Prefs.isPhoneVerified, data['phoneNumberVerified'] ?? false);
    isPhoneVerified = data['phoneNumberVerified'] ?? false;

    dailyReminder = data['dailyRemindarNotification'] ?? true;
    podcastNotification = data['sendPodcastNotification'] ?? true;

    if (pass != null) {
      await box.write(Prefs.password, pass);
      password = pass;
    }

    await box.write(Prefs.userDOB, data['dateofBirth'].split('T').first ?? "");
    userDOB = data['dateofBirth'].split('T').first ?? "";

    if (data['subscriptionPlan'] != null) {
      await box.write(
          Prefs.planEndDate, data['subscriptionPlan']['current_end']);
      planEndDate = data['subscriptionPlan']['current_end'].toString();

      await box.write(Prefs.planId, data['subscriptionPlan']['id']);
      planId = data['subscriptionPlan']['id'].toString();

      await box.write(Prefs.isShared, data['subscriptionPlan']['isShared']);
      isShared = data['subscriptionPlan']['isShared'];
      baseController!.isShared.value = data['subscriptionPlan']['isShared'];
    } else {
      isShared = false;
      baseController!.isShared.value = false;
    }

    baseController!.userName.value = userName;
    baseController!.isPodcaster.value = isPodcaster;
    baseController!.userDOB.value = userDOB;
    baseController!.userProfile.value = profileImage;
  }

  static clearData() async {
    var box = GetStorage();
    await box.write(Prefs.token, "");
    await box.write(Prefs.userId, "");
     await box.write(Prefs.tokenid, "");
    await box.write(Prefs.userEmail, "");
    await box.write(Prefs.userName, "");
    await box.write(Prefs.isPodcaster, false);
    await box.write(Prefs.profileImage, "");
    await box.write(Prefs.phoneNumber, "");
    await box.write(Prefs.isPhoneVerified, false);

    await box.write(Prefs.selectedCategory, "[]");
    await box.write(Prefs.downloadBooks, "[]");
    await box.write(Prefs.planEndDate, "");
    await box.write(Prefs.planId, "");
    await box.write(Prefs.downloadWithMobileData, true);
    await box.write(Prefs.isPremium, false);
    await box.write(Prefs.socialLogin, false);
    await box.write(Prefs.productUpdate, false);
    box.erase();
    token = "";
    tokenid ="";
    userId = "";
    userName = "";
    isPodcaster = "false";
    userEmail = "";
    phoneNumber = "";
    isPhoneVerified = false;
    downloadBooksList = [];
    planEndDate = "";
    planId = "";
    downloadWithMobileData = true;
    socialLogin = false;
    productUpdate = false;
    isShared = false;
    baseController!.isShared.value = false;
    baseController!.isSubscribed.value = false;
    baseController!.isTried.value = false;
    baseController!.trialRunning.value = false;
    baseController!.lastPlanId.value = '';
  }
}
