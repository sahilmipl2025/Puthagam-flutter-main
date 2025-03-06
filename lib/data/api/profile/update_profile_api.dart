import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/profile/edit_profile/edit_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';




updateProfileApi({required String name,required String dob}) async {
  print("con.nameController.value.text inside name ${name}");
  
EditProfileController con = Get.put(EditProfileController());
//   EditProfileController con;
// try {
//   con = Get.find<EditProfileController>();
// } catch (e) {
//   // Handle the exception if the controller doesn't exist
//   print("EditProfileController not found: $e");
//   // Optionally, initialize the controller here if it doesn't exist
//   con = Get.put(EditProfileController());
// }

//  print("con.nameController.value.text inside ${con.name.text}");
  print("con.nameController.value.text inside name 1 ${name}");
                                  

  try {
    print("Checking network connectivity...");
    bool connection = await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      print("Connected to the internet.");
      await LocalStorage.getData();
      print("Fetched local storage data.");

      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        print("Token and UserID are valid.");
        con.isLoading.value = true;

        var body = {
          // "name": con.nameController.value.text,
          "name" : name,
          "dateofBirth": con.dob.text + 'T09:33:55.888Z',
        };
        print("con.nameController.value.text inside near request ${con.name.text}");
                                  
        print("Request body: $body");

        http.Response response = await ApiHandler.post(
          url: ApiUrls.baseUrl + 'User/' + LocalStorage.userId + '/User',
          body: body,
        );
print("isPhoneVerifiedString value: ${LocalStorage.isPhoneVerified}, type: ${LocalStorage.isPhoneVerified.runtimeType}");
print("isPhoneVerifiedString value: 111${LocalStorage.userName}, type: ${LocalStorage.userName.runtimeType}");

print("isPhoneVerifiedString value: 22222${LocalStorage.userDOB}, type: ${LocalStorage.userDOB.runtimeType}");


        print("Response received: ${response.body}");
        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          print("Profile update successful, updating local data...");

          var box = GetStorage();
          await box.write(
              Prefs.userData, jsonEncode(jsonDecode(response.body)['user']));
          LocalStorage.userData = jsonDecode(response.body)['user'] ?? "";

          await box.write(
              Prefs.userName, jsonDecode(response.body)['user']['name'] ?? "");
          LocalStorage.userName = jsonDecode(response.body)['user']['name'] ?? "";
          // LocalStorage.isPhoneVerified =
          //     jsonDecode(response.body)['user']['phoneNumberVerified'] ?? "false";
              // Variable ki value aur type dono print karenge
//print("isPhoneVerifiedString value: ${LocalStorage.isPhoneVerified}, type: ${LocalStorage.isPhoneVerified}");
//print("LocalStorage.isPhoneVerified value: ${LocalStorage.isPhoneVerified}, type: ${LocalStorage.isPhoneVerified.runtimeType}");


          await box.write(
              Prefs.userDOB,
              jsonDecode(response.body)['user']['dateofBirth']
                      .split('T')
                      .first ?? "");
          LocalStorage.userDOB = jsonDecode(response.body)['user']['dateofBirth']
                  .split('T')
                  .first ?? "";

          baseController!.userName.value =
              jsonDecode(response.body)['user']['name'] ?? "";
          baseController!.userDOB.value = LocalStorage.userName;
          baseController!.userProfile.value = LocalStorage.profileImage;
          con.isLoading.value = false;

          print("Local data updated successfully.");
            //Get.offAllNamed(AppRoutes.profilePage);
          Get.back();
          toast("Profile updated successfully", true);
        } else if (response.statusCode == 401) {
          print("Unauthorized access, clearing local data.");
          LocalStorage.clearData();
          con.isLoading.value = false;
         Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['title'], false);
        } else {
          print("Error: ${decoded['title']}");
          con.isLoading.value = false;
          toast(decoded['title'], false);
        }
      } else {
        print("Token or UserID is invalid.");
      }
    } else {
      print("No internet connection.");
      con.isLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    con.isLoading.value = false;
    print("Exception caught: $e");
    // toast(e.toString(), false);
  }
}

// updateProfileApi() async {
//   EditProfileController con = Get.put(EditProfileController());

//   try {
//     bool connection =
//         await NetworkInfo(connectivity: Connectivity()).isConnected();
//     if (connection) {
//       await LocalStorage.getData();
//       if (LocalStorage.token.toString() != "null" &&
//           LocalStorage.token.toString().isNotEmpty &&
//           LocalStorage.userId.toString() != "null" &&
//           LocalStorage.userId.toString().isNotEmpty) {
//         con.isLoading.value = true;

//         var body = {
//           "name": con.nameController.value.text,
//           "dateofBirth": con.dobController.value.text + 'T09:33:55.888Z',
//         };

//         http.Response response = await ApiHandler.post(
//           url: ApiUrls.baseUrl + 'User/' + LocalStorage.userId + '/User',
//           body: body,
//         );

//         var decoded = jsonDecode(response.body);
//         if (response.statusCode == 200 ||
//             response.statusCode == 201 ||
//             response.statusCode == 202 ||
//             response.statusCode == 203 ||
//             response.statusCode == 204) {
//           var box = GetStorage();
//           await box.write(
//               Prefs.userData, jsonEncode(jsonDecode(response.body)['user']));
//           LocalStorage.userData = jsonDecode(response.body)['user'] ?? "";

//           await box.write(
//               Prefs.userName, jsonDecode(response.body)['user']['name'] ?? "");
//           LocalStorage.userName =
//               jsonDecode(response.body)['user']['name'] ?? "";
//           LocalStorage.isPhoneVerified =
//               jsonDecode(response.body)['user']['phoneNumberVerified'] ?? "";

//           await box.write(
//               Prefs.userDOB,
//               jsonDecode(response.body)['user']['dateofBirth']
//                       .split('T')
//                       .first ??
//                   "");
//           LocalStorage.userDOB = jsonDecode(response.body)['user']
//                       ['dateofBirth']
//                   .split('T')
//                   .first ??
//               "";

//           baseController!.userName.value =
//               jsonDecode(response.body)['user']['name'] ?? "";
//           baseController!.userDOB.value = LocalStorage.userName;
//           baseController!.userProfile.value = LocalStorage.profileImage;
//           con.isLoading.value = false;
//           Get.back();
//           toast("Profile updated successfully", true);
//         } else if (response.statusCode == 401) {
//           LocalStorage.clearData();
//           con.isLoading.value = false;
//           Get.offAllNamed(AppRoutes.loginScreen);
//           toast(decoded['title'], false);
//         } else {
//           con.isLoading.value = false;
//           toast(decoded['title'], false);
//         }
//       }
//     } else {
//       con.isLoading.value = false;
//       toast("No Internet Connection!", false);
//     }
//   } catch (e) {
//     con.isLoading.value = false;
//     // toast(e.toString(), false);
//   }
// }
