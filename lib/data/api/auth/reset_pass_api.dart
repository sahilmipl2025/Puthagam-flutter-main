import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/auth/signout_api.dart';
import 'package:puthagam/screen/dashboard/profile/reset_pass/reset_controller.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/network_info.dart';

resetPassApi() async {
  ResetController con = Get.put(ResetController());

  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      con.isLoading.value = true;

      (await Amplify.Auth.updatePassword(
          oldPassword: con.oldPass.value.text,
          newPassword: con.newPass.value.text));
      logout();
      con.isLoading.value = false;

      toast("Password Updated", true);
    } else {
      con.isLoading.value = false;
      toast("No Internet Connection!", false);
    }
  } on AmplifyException catch (err) {
    debugPrint(err.toString());
    if (err.message == "Incorrect username or password.") {
      toast("Incorrect old password!", false);
    }
  } catch (e) {
    con.isLoading.value = false;
    // toast(e.toString(), false);
  } finally {
    con.isLoading.value = false;
  }
}
