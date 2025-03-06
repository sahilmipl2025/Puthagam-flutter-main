import 'dart:convert';
import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:puthagam/data/api/auth/login_api.dart';
import 'package:puthagam/data/api/auth/signup_api.dart';
import 'package:puthagam/podcaster/core/widgets/build_loading.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool emailValid = false.obs;
  RxBool emailValid1 = false.obs;
  RxBool passValid = false.obs;
  RxBool passValid1 = false.obs;
  RxBool showSocial = false.obs;

  Rx<TextEditingController> emailController =
            TextEditingController(text: kDebugMode ? "shubham.j.mipl@gmail.com" : "").obs;
  Rx<TextEditingController> passwordController =
      TextEditingController(text: kDebugMode ? "Admin@1234567890" : "").obs;

  RxBool hidePassword = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    clientId: GetPlatform.isIOS
        ? '660794496508-t6f05n61fnknsj7auf9tr332b07ra1li.apps.googleusercontent.com'
        : '965478135468-6599id8gvgpk6siin7vt5uua7uhrbgk0.apps.googleusercontent.com',
  );

  @override
  void onInit() {
    super.onInit();
    getData();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  getData() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    showSocial.value = await remoteConfig.getBool("social_login2");
  }

  Future<void> handleGoogleSignIn() async {
    try {
      _googleSignIn.signOut();
      final account = await _googleSignIn.signIn();

      log("account id ${account?.id}");
      log("account name ${account?.displayName}");
      log("account email ${account?.email}");
      if (account != null) {
        checkEmailApi(
            account.id, "", account.displayName ?? "n/a", account.email);
      }
    } catch (error) {
      log("errorforgooglelogin $error");
    }
  }

  handleFacbookSignIn() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: [
          'public_profile',
          'email',
        ],
      );
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();

        checkEmailApi(
            "", userData["id"], userData["name"] ?? "n/a", userData["email"]);
        log("user data ${userData.entries}");
      } else {
        log(result.toString());
      }
    } catch (err) {
      log("err $err");
    }
  }

  veryifyOTP(String email, String otp) async {
    buildDialogLoadingIndicator();
    await Amplify.Auth.confirmSignUp(username: email, confirmationCode: otp);
    Get.back();
    Get.back();
    loginApi(doSignup: true);
  }

  /// apple login

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void appleLogIn() async {
    try {
      const _storage = FlutterSecureStorage();
      final _email = await _storage.read(key: "email");

      final _socialId = await _storage.read(key: "socialId");

      final _firstName = await _storage.read(key: "firstName");

      final _lastName = await _storage.read(key: "lastName");

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.toString() != "null") {
        credential.userIdentifier != null
            ? await _storage.write(
                key: "socialId", value: credential.userIdentifier)
            : debugPrint('user = $_socialId');
        credential.email != null
            ? await _storage.write(key: "email", value: credential.email)
            : debugPrint('email = $_email');
        credential.givenName != null
            ? await _storage.write(
                key: "firstName", value: credential.givenName)
            : debugPrint('name = $_firstName');
        credential.familyName != null
            ? await _storage.write(
                key: "lastName", value: credential.familyName)
            : debugPrint('name = $_lastName');
      }

      var socialId = (_socialId ?? credential.userIdentifier)!;
      var email = (_email ?? credential.email)!;
      var firstName = (_firstName ?? credential.givenName)!;
      var lastName = (_lastName ?? credential.familyName)!;

      checkEmailApi("", socialId, firstName + " " + lastName, email);
      print("appleloginerrorforlogin${socialId}");
    } catch (e) {
      print("appleloginerror${e}");
      debugPrint(e.toString());
    }
  }

// Future<void> AWS() async {
//   final userPool = CognitoUserPool(
//     'us-east-1_wLTqqj3cU',
//     'arn:aws:cognito-idp:us-east-',
//   );

//   final cognitoUser = CognitoUser('email@inspire.my', userPool);

//   bool registrationConfirmed = false;
//   try {
//     registrationConfirmed = await cognitoUser.confirmRegistration('123456');
//   } catch (e) {
//     print(e);
//   }
//   print(registrationConfirmed);
// }

// void changeTheme(BuildContext context) {
//   final theme =
//       Get.isDarkMode ? AppThemes.lightThemeData : AppThemes.darkThemeData;
//   ThemeSwitcher.of(context).changeTheme(theme: theme);
//   if (_getStorage.read(GetStorageKey.IS_DARK_MODE)) {
//     _getStorage.write(GetStorageKey.IS_DARK_MODE, false);
//     isDarkMode.value = false;
//   } else {
//     _getStorage.write(GetStorageKey.IS_DARK_MODE, true);
//     isDarkMode.value = true;
//   }
// }
}
