import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:puthagam/podcaster/core/widgets/build_loading.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../data/api/auth/signup_api.dart';

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> cPassController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> dobController = TextEditingController().obs;
  final otpController = TextEditingController();
  RxBool hidePassword = true.obs;
  RxBool cHidePassword = true.obs;
  RxBool isTermsAndConditionAccept = false.obs;

  RxBool nameValid = false.obs;
  RxBool emailValid = false.obs;
  RxBool emailValid1 = false.obs;
  RxBool passValid = false.obs;
  RxBool passValid1 = false.obs;
  RxBool cPassValid = false.obs;
  RxBool cPassValid1 = false.obs;
  RxBool dobValid = false.obs;

  selectedDate(context) async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now().subtract(const Duration(days: 1)),
        firstDate: DateTime(1970),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return SingleChildScrollView(child: child);
        });

    if (selectedDate.toString() != "null") {
      dobController.value.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
    }
  }

  Future<void> signUpUser() async {
    try {
      Get.dialog(const CupertinoActivityIndicator().centered());
      log("email ${emailController.value.text}");
      final userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.email: emailController.value.text,
      };
      final result = await Amplify.Auth.signUp(
        username: emailController.value.text.trim(),
        password: passwordController.value.text,
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );
      Get.back();
      Get.snackbar("Success", "OTP has been sent to your email id",
          backgroundColor: Colors.green);
      Get.toNamed(AppRoutes.otpScreen);
    } on AuthException catch (e) {
      log("error $e");
      Get.back();
      Get.snackbar("Error", e.message, backgroundColor: Colors.red);
    }
  }

  Future<void> confirmUser(String otp) async {
    try {
      buildDialogLoadingIndicator();
      final result = await Amplify.Auth.confirmSignUp(
          username: emailController.value.text, confirmationCode: otp);

      log("result ${result.isSignUpComplete}");
      await Amplify.Auth.signIn(
          username: emailController.value.text,
          password: passwordController.value.text);
      log("user ${await Amplify.Auth.getCurrentUser()}");
      if (result.isSignUpComplete) {
        await signUpApi();
      }

      Get.back();
    } on AuthException catch (e) {
      safePrint(e.message);
      Get.back();
      Get.snackbar("Error", e.message, backgroundColor: Colors.red);
    }
  }

// Future<void> signUpWithPhoneVerification(
//     String username, String password) async {
//   await Amplify.Auth.signUp(
//     username: username,
//     password: password,
//     options: CognitoSignUpOptions(
//       userAttributes: <CognitoUserAttributeKey, String>{
//         CognitoUserAttributeKey.email: 'test@example.com',
//         CognitoUserAttributeKey.phoneNumber: '+18885551234',
//       },
//     ),
//   );
// }
}
