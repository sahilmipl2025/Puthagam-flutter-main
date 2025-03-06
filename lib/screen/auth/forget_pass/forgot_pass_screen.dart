import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/auth/forget_pass/forgot_pass_controller.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';

class ForgotPassScreen extends StatelessWidget {
  ForgotPassScreen({Key? key}) : super(key: key);

  final ForgotPassController con = Get.put(ForgotPassController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          decoration: BoxDecoration(gradient: verticalGradient),
          child: SafeArea(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: isTablet ? 20 : 16),
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: isTablet ? 28 : 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.04),
                  Center(
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: isTablet ? 32 : 28,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: isTablet ? 41 : 35),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'forgetSubTitle'.tr,
                      style: TextStyle(
                        fontSize: isTablet ? 17 : 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: isTablet ? 55 : 45),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                        width: 1,
                        color: Colors.white,
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
                      child: TextField(
                        controller: con.emailController.value,
                        style: TextStyle(fontSize: isTablet ? 20 : 18),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email address'.tr,
                          hintStyle: TextStyle(
                            color: textColor,
                            fontSize: isTablet ? 16 : 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Column(
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
                  ),
                  SizedBox(height: isTablet ? 29 : 25),
                  Obx(() => Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: isTablet ? 30 : 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(isTablet ? 12 : 8),
                          ),
                          border: Border.all(width: 1, color: Colors.white),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 12 : 8),
                          child: TextField(
                            controller: con.passwordController1.value,
                            obscureText: !con.hidePassword.value,
                            style: TextStyle(fontSize: isTablet ? 20 : 18),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password min 10 characters'.tr,
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
                                  size: isTablet ? 23 : 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        con.passValid.value || con.passValid1.value
                            ? SizedBox(height: isTablet ? 8 : 6)
                            : const SizedBox(),
                        SizedBox(
                          width: Get.width * 0.84,
                          child: con.passValid.value
                              ? Text(
                                  "Enter password".tr,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: isTablet ? 14 : 12,
                                  ),
                                )
                              : con.passValid1.value
                                  ? Text(
                                      "Password is not long enough min 10 characters is required"
                                          .tr,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: isTablet ? 14 : 12,
                                      ),
                                    )
                                  : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isTablet ? 29 : 25),
                  Obx(() => Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: isTablet ? 30 : 30),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(width: 1, color: Colors.white),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 12 : 8),
                          child: TextField(
                            controller: con.passwordController2.value,
                            obscureText: !con.hidePassword1.value,
                            style: TextStyle(fontSize: isTablet ? 20 : 18),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirm password',
                              hintStyle: TextStyle(
                                color: textColor,
                                fontSize: isTablet ? 16 : 15,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  con.hidePassword1.value =
                                      !con.hidePassword1.value;
                                },
                                icon: Icon(
                                  con.hidePassword1.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.white,
                                  size: isTablet ? 23 : 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        con.cPassValid.value || con.cPassValid1.value
                            ? SizedBox(height: isTablet ? 8 : 6)
                            : const SizedBox(),
                        SizedBox(
                          width: Get.width * 0.84,
                          child: con.cPassValid.value
                              ? Text(
                                  "Enter password".tr,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: isTablet ? 14 : 12,
                                  ),
                                )
                              : con.cPassValid1.value
                                  ? Text(
                                      "Password doesn't match".tr,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: isTablet ? 14 : 12,
                                      ),
                                    )
                                  : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isTablet ? 55 : 45),
                  InkWell(
                    onTap: () {
                      con.checkUserExists();
                    },
                    child: Container(
                      height: isTablet ? 55 : 45,
                      margin:
                          EdgeInsets.symmetric(horizontal: isTablet ? 38 : 30),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50),
                          ),
                          gradient: verticalGradient),
                      child: Text(
                        'Send OTP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 19 : 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
