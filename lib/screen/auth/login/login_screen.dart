import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/auth/login_api.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/screen/auth/login/login_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final LoginController con = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(gradient: verticalGradient),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: Get.height * 0.14),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/magic_app.png',
                          width: Get.width * 0.5,
                        ),
                        SizedBox(height: Get.height * 0.1),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: isTablet ? 40 : 30),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 12 : 8),
                            child: TextFormField(
                              controller: con.emailController.value,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "emailAddress".tr,
                                hintStyle: TextStyle(
                                  color: textColor,
                                  fontSize: isTablet ? 16 : 15,
                                ),
                              ),
                              style: TextStyle(fontSize: isTablet ? 17 : 16),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            con.emailValid.value || con.emailValid1.value
                                ? SizedBox(height: isTablet ? 8 : 6)
                                : const SizedBox(),
                            SizedBox(
                              width: Get.width * 0.84,
                              child: con.emailValid.value
                                  ? Text(
                                      "emailValidation".tr,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: isTablet ? 14 : 12,
                                      ),
                                    )
                                  : con.emailValid1.value
                                      ? Text(
                                          "emailValidation1".tr,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: isTablet ? 14 : 12,
                                          ),
                                        )
                                      : const SizedBox(),
                            ),
                          ],
                        ),
                        SizedBox(height: isTablet ? 16 : 12),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: isTablet ? 40 : 30),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextFormField(
                              controller: con.passwordController.value,
                              obscureText: !con.hidePassword.value,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "password".tr,
                                hintStyle: TextStyle(
                                  color: textColor,
                                  fontSize: isTablet ? 16 : 15,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    con.hidePassword.value =
                                        !con.hidePassword.value;
                                  },
                                  icon: Icon(
                                    con.hidePassword.value
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.white,
                                    size: isTablet ? 22 : 20,
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                              ),
                            ),
                          ),
                        ),
                        Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                con.passValid.value || con.passValid1.value
                                    ? const SizedBox(height: 6)
                                    : const SizedBox(),
                                SizedBox(
                                  width: Get.width * 0.84,
                                  child: con.passValid.value
                                      ? Text(
                                          "passValidation".tr,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: isTablet ? 14 : 12,
                                          ),
                                        )
                                      : con.passValid1.value
                                          ? Text(
                                              "passValidation1".tr,
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: isTablet ? 14 : 12,
                                              ),
                                            )
                                          : const SizedBox(),
                                ),
                              ],
                            )),
                        SizedBox(height: isTablet ? 12 : 8),
                        InkWell(
                          onTap: () =>
                              Get.toNamed(AppRoutes.forgotPasswordScreen),
                          child: Container(
                            padding: EdgeInsets.only(right: isTablet ? 40 : 30),
                            height: isTablet ? 55 : 45,
                            alignment: Alignment.centerRight,
                            child: Text(
                              'forgotPassword'.tr,
                              style: TextStyle(
                                fontSize: isTablet ? 17 : 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isTablet ? 24 : 20),
                        con.isLoading.value
                            ? const Center(child: AppLoader())
                            : InkWell(
                                onTap: () async {
                                  /// email validation

                                  if (con.emailController.value.text
                                      .trim()
                                      .isEmpty) {
                                    con.emailValid.value = true;
                                    con.emailValid1.value = false;
                                  } else if (!GetUtils.isEmail(
                                      con.emailController.value.text.trim())) {
                                    con.emailValid.value = false;
                                    con.emailValid1.value = true;
                                  } else {
                                    con.emailValid.value = false;
                                    con.emailValid1.value = false;
                                  }

                                  /// Password Validation

                                  if (con.passwordController.value.text
                                      .trim()
                                      .isEmpty) {
                                    con.passValid.value = true;
                                    con.passValid1.value = false;
                                  } else if (con.passwordController.value.text
                                          .trim()
                                          .length <
                                      6) {
                                    con.passValid.value = false;
                                    con.passValid1.value = true;
                                  } else {
                                    con.passValid.value = false;
                                    con.passValid1.value = false;
                                  }

                                  if (con.emailValid.isFalse &&
                                      con.emailValid1.isFalse &&
                                      con.passValid.isFalse &&
                                      con.passValid1.isFalse) {
                                    await isUserLoggedIn();
                                    loginApi();
                                  }
                                },
                                child: Container(
                                  height: isTablet ? 55 : 45,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 40 : 30),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                      gradient: verticalGradient),
                                  child: Text(
                                    'Sign in',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isTablet ? 20 : 17,
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(height: isTablet ? 36 : 24),
                        con.showSocial.value || Platform.isAndroid
                            ? Column(
                                children: [
                                  Center(
                                    child: Text(
                                      'OR Continue with',
                                      style: TextStyle(
                                        fontSize: isTablet ? 17 : 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 36 : 24),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: isTablet ? 40 : 30),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: isTablet ? 55 : 45,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                  color: fbBtnColor,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.facebook,
                                                      color: Colors.white,
                                                      size: isTablet ? 35 : 30,
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            isTablet ? 12 : 8),
                                                    Text(
                                                      "Facebook",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            isTablet ? 20 : 17,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ).onInkTap(() {
                                                con.handleFacbookSignIn();
                                              }),
                                            ),
                                            const SizedBox(width: 15),
                                            Expanded(
                                              child: Container(
                                                height: isTablet ? 55 : 45,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                  color: googleBtnColor,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "assets/splash/google.png",
                                                      height:
                                                          isTablet ? 28 : 23,
                                                      width: isTablet ? 28 : 23,
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            isTablet ? 12 : 8),
                                                    Text(
                                                      'Google',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            isTablet ? 20 : 17,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ).onInkTap(() {
                                                con.
                                                handleGoogleSignIn();
                                              }),
                                            ),
                                          ],
                                        ),
                                        if (Platform.isIOS)
                                          const SizedBox(height: 12),
                                        if (Platform.isIOS)
                                          Container(
                                            height: isTablet ? 52 : 42,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/apple.png",
                                                  height: isTablet ? 28 : 23,
                                                  width: isTablet ? 28 : 23,
                                                ),
                                                SizedBox(
                                                    width: isTablet ? 12 : 8),
                                                Text(
                                                  'Sign in with Apple',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        isTablet ? 20 : 17,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ).onInkTap(() {
                                            con.appleLogIn();
                                          }),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox()
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 17 : 14,
                          ),
                        ),
                        SizedBox(width: isTablet ? 8 : 5),
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.signUpScreen);
                          },
                          child: Text(
                            "signUp".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 20 : 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: isTablet ? 26 : 20)
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
