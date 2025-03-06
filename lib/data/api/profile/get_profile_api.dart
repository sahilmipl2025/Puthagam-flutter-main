// import 'dart:convert';
// import 'dart:developer';
// // import 'dart:ffi';
// import 'dart:io';
// import 'package:connectivity/connectivity.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:puthagam/data/handler/api_handler.dart';
// import 'package:puthagam/data/handler/api_url.dart';
// import 'package:puthagam/main.dart';
// import 'package:puthagam/utils/app_routes.dart';
// import 'package:puthagam/utils/app_snackbar.dart';
// import 'package:puthagam/utils/local_storage/app_prefs.dart';
// import 'package:puthagam/utils/local_storage/local_storage.dart';
// import 'package:puthagam/utils/network_info.dart';
//
// getUserProfileApi({bool? forBeta = false}) async {
//   try {
//     log("get user profile");
//     bool connection =
//         await NetworkInfo(connectivity: Connectivity()).isConnected();
//     if (connection) {
//       final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//       await LocalStorage.getData();
//       if (LocalStorage.token.toString() != "null" &&
//           LocalStorage.token.toString().isNotEmpty &&
//           LocalStorage.userId.toString() != "null" &&
//           LocalStorage.userId.toString().isNotEmpty) {
//         http.Response response = await ApiHandler.get(
//           url: ApiUrls.baseUrl + ApiUrls.editProfile + LocalStorage.userId,
//         );
//         print("get user profile ${ApiUrls.baseUrl + ApiUrls.editProfile + LocalStorage.userId}");
//         var decoded = jsonDecode(response.body);
//         if (response.statusCode == 200 ||
//             response.statusCode == 201 ||
//
//             response.statusCode == 202 ||
//             response.statusCode == 203 ||
//             response.statusCode == 204) {
//           LocalStorage.storedToken(decoded, false);
//           var box = GetStorage();
//
//           baseController!.isBetaVersion.value =
//               decoded['isBetaVersion'] ?? false;
//
//           if (decoded['subscriptionPlan'].toString() != "null" &&
//               decoded['subscriptionPlan'].toString() != "{}" &&
//               decoded['subscriptionPlan'].toString() != "") {
//             await box.write(Prefs.isPremium, true);
//             LocalStorage.isPremium = true;
//             baseController!.isSubscribed.value = true;
//
//             if (decoded['subscriptionPlan'] != null) {
//               baseController!.premiumId.value =
//                   decoded['subscriptionPlan']['id'] ?? "";
//             baseController!.getpodcastAccess.value = decoded['subscriptionPlan']['podcastAccess'] ?? "";
//              //   baseController!.getreadAccess.value = decoded['subscriptionPlan']['readAccess'] ?? "";
//                 print("getreadAccess${baseController!.getpodcastAccess.value}");
//                 //   print("getpodcast${baseController!.getreadAccess.value}");
//
//               if (decoded['subscriptionPlan']['plan_id'] == "BETA" &&
//                   decoded['isBetaVersion'] == true) {
//                 baseController!.betaVersion.value = true;
//               } else {
//                 baseController!.betaVersion.value = false;
//               }
//               baseController!.trialRunning.value =
//                   jsonDecode(response.body)['subscriptionPlan']['isTrial'];
//             } else {
//               baseController!.premiumId.value =
//                   decoded['subscriptionPlan']['id'] ?? "";
//               baseController!.trialRunning.value = false;
//               baseController!.betaVersion.value = false;
//             }
//
//             baseController!.planStartDate.value =
//                 jsonDecode(response.body)['subscriptionPlan']['current_start'];
//             baseController!.planEndDate.value =
//                 jsonDecode(response.body)['subscriptionPlan']['current_end'];
//
//             baseController!.isTried.value = decoded['isTrial'];
//             baseController!.lastPlanId.value = decoded['planId'];
//           } else {
//             if (Platform.isIOS) {
//               if (forBeta == true) {
//                 await box.write(Prefs.isPremium, false);
//                 LocalStorage.isPremium = false;
//                 baseController!.trialRunning.value = false;
//                 baseController!.isTried.value = decoded['isTrial'];
//                 baseController!.lastPlanId.value = decoded['planId'];
//                 baseController!.isSubscribed.value = false;
//               } else {
//                 await _inAppPurchase.restorePurchases();
//                 final bool isAvailable = await _inAppPurchase.isAvailable();
//                 // if (isAvailable == true) {
//                 //   baseController!.isSubscribed.value = true;
//                 //   await box.write(Prefs.isPremium, true);
//                 //   LocalStorage.isPremium = true;
//                 // } else {
//                 await box.write(Prefs.isPremium, false);
//                 LocalStorage.isPremium = false;
//                 baseController!.trialRunning.value = false;
//                 baseController!.isTried.value = decoded['isTrial'];
//                 baseController!.lastPlanId.value = decoded['planId'];
//                 baseController!.isSubscribed.value = false;
//                 // }
//               }
//             } else {
//               await box.write(Prefs.isPremium, false);
//               LocalStorage.isPremium = false;
//               baseController!.betaVersion.value = false;
//               baseController!.trialRunning.value = false;
//               baseController!.isTried.value = decoded['isTrial'];
//               baseController!.lastPlanId.value = decoded['planId'];
//               baseController!.isSubscribed.value = false;
//             }
//           }
//         } else if (response.statusCode == 401) {
//           LocalStorage.clearData();
//           Get.offAllNamed(AppRoutes.loginScreen);
//           toast(decoded['status']['message'], false);
//         } else {
//           toast(decoded['status']['message'], false);
//         }
//       }
//     } else {
//       toast("No Internet Connection!", false);
//     }
//   } catch (e) {
//     // toast(e.toString(), false);
//   }
// }
import 'dart:convert';
import 'dart:developer';
// Conditionally import dart:io only for native platforms
import 'dart:io' if (dart.library.html) 'dart:html' as platform;
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
// Conditionally import in_app_purchase only for native platforms
import 'package:in_app_purchase/in_app_purchase.dart' if (dart.library.html) 'package:puthagam/data/api/profile/in_app_stub.dart' as iap;
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

Future<void> getUserProfileApi({bool? forBeta = false}) async {
  try {
    log("get user profile");
    bool connection = await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      // Use a stub for InAppPurchase on web
      final iap.InAppPurchase _inAppPurchase = iap.InAppPurchase.instance;
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        http.Response response = await ApiHandler.get(
          url: ApiUrls.baseUrl + ApiUrls.editProfile + LocalStorage.userId,
        );
        print("get user profile ${ApiUrls.baseUrl + ApiUrls.editProfile + LocalStorage.userId}");
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          LocalStorage.storedToken(decoded, false);
          var box = GetStorage();

          baseController!.isBetaVersion.value = decoded['isBetaVersion'] ?? false;

          if (decoded['subscriptionPlan'].toString() != "null" &&
              decoded['subscriptionPlan'].toString() != "{}" &&
              decoded['subscriptionPlan'].toString() != "") {
            await box.write(Prefs.isPremium, true);
            LocalStorage.isPremium = true;
            baseController!.isSubscribed.value = true;

            if (decoded['subscriptionPlan'] != null) {
              baseController!.premiumId.value = decoded['subscriptionPlan']['id'] ?? "";
              baseController!.getpodcastAccess.value = decoded['subscriptionPlan']['podcastAccess'] ?? "";
              // baseController!.getreadAccess.value = decoded['subscriptionPlan']['readAccess'] ?? "";
              print("getreadAccess${baseController!.getpodcastAccess.value}");

              if (decoded['subscriptionPlan']['plan_id'] == "BETA" &&
                  decoded['isBetaVersion'] == true) {
                baseController!.betaVersion.value = true;
              } else {
                baseController!.betaVersion.value = false;
              }
              baseController!.trialRunning.value = decoded['subscriptionPlan']['isTrial'];
            } else {
              baseController!.premiumId.value = decoded['subscriptionPlan']['id'] ?? "";
              baseController!.trialRunning.value = false;
              baseController!.betaVersion.value = false;
            }

            baseController!.planStartDate.value = decoded['subscriptionPlan']['current_start'];
            baseController!.planEndDate.value = decoded['subscriptionPlan']['current_end'];

            baseController!.isTried.value = decoded['isTrial'];
            baseController!.lastPlanId.value = decoded['planId'];
          } else {
            // Check if running on web or native platform
            bool isWeb = !GetPlatform.isIOS && !GetPlatform.isAndroid;
            if (!isWeb && GetPlatform.isIOS) {
              if (forBeta == true) {
                await box.write(Prefs.isPremium, false);
                LocalStorage.isPremium = false;
                baseController!.trialRunning.value = false;
                baseController!.isTried.value = decoded['isTrial'];
                baseController!.lastPlanId.value = decoded['planId'];
                baseController!.isSubscribed.value = false;
              } else {
                await _inAppPurchase.restorePurchases();
                final bool isAvailable = await _inAppPurchase.isAvailable();
                await box.write(Prefs.isPremium, false);
                LocalStorage.isPremium = false;
                baseController!.trialRunning.value = false;
                baseController!.isTried.value = decoded['isTrial'];
                baseController!.lastPlanId.value = decoded['planId'];
                baseController!.isSubscribed.value = false;
              }
            } else {
              // Web or non-iOS fallback
              await box.write(Prefs.isPremium, false);
              LocalStorage.isPremium = false;
              baseController!.betaVersion.value = false;
              baseController!.trialRunning.value = false;
              baseController!.isTried.value = decoded['isTrial'];
              baseController!.lastPlanId.value = decoded['planId'];
              baseController!.isSubscribed.value = false;
            }
          }
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    // toast(e.toString(), false);
  }
}