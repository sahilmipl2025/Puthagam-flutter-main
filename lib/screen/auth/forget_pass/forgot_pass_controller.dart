import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get.dart';

import 'package:puthagam/podcaster/core/widgets/build_loading.dart';
import 'package:puthagam/screen/auth/forget_pass/mixin/create_account_mixin.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'mixin/forget_password_mixin.dart';
import 'mixin/validate_mixin.dart';

class ForgotPassController extends GetxController
    with ForgetPasswordMixin, CreateAccountMixin, ValidateMixin {
 checkUserExists() async {
  try {
    final isValid = await validateInput();
    if (!isValid) {
      return;
    }
    buildDialogLoadingIndicator();
    await isUserLoggedIn();
    await Amplify.Auth.signIn(
      username: emailController.value.text,
      password: ".",
    );
  } on AmplifyException catch (err) {
    if (err is UserNotFoundException || err is UserNotConfirmedException) {
      Get.back();
      sendOTPForSignUp(
        emailController.value.text,
        passwordController1.value.text,
        otpController,
        err,
      );
      return;
    }

    if (err.message.contains('NotAuthorizedException')) {
      Get.back();
      sendOTPForReset(
        emailController.value.text,
        passwordController1.value.text,
        otpController,
      );
      return;
    }

    handleError(err);
  }
}
    }
