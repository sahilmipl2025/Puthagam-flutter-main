import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/podcaster/core/utils/app_utils.dart';
import 'package:puthagam/screen/auth/signup/signup_controller.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final SignUpController con = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          decoration: BoxDecoration(gradient: verticalGradient),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Get.height * 0.13),
              const Text(
                'Create new Account',
                style: TextStyle(
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 45),
              nameField(),
              emailField(),
              passwordField(),
              confirmPassField(),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      activeColor: Colors.blue,
                      value: con.isTermsAndConditionAccept.value,
                      onChanged: (bool? val) {
                        if (con.isTermsAndConditionAccept.value == false) {
                          con.isTermsAndConditionAccept.value = true;
                        } else {
                          con.isTermsAndConditionAccept.value = false;
                        }
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'I agree to  ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(
                                    color: Colors.blue.shade100,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(Uri.parse(
                                        'https://admin.magic20.co.in/Pages/TermsOfUse.html'));
                                  }),
                            const TextSpan(
                              text: '  Or  ',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                                text: " " 'Privacy Policy',
                                style: TextStyle(
                                    color: Colors.blue.shade100,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(Uri.parse(
                                        'https://admin.magic20.co.in/Pages/PrivacyPolicy.html'));
                                  })
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 45),
              InkWell(
                onTap: () async {
                  if (con.isLoading.isFalse) {
                    /// Name Validation

                    if (con.nameController.value.text.trim().isEmpty) {
                      con.nameValid.value = true;
                    } else {
                      con.nameValid.value = false;
                    }

                    /// email validation

                    if (con.emailController.value.text.trim().isEmpty) {
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

                    if (con.passwordController.value.text.trim().isEmpty) {
                      con.passValid.value = true;
                      con.passValid1.value = false;
                    } else if (con.passwordController.value.text.trim().length <
                        10) {
                      con.passValid.value = false;
                      con.passValid1.value = true;
                    } else {
                      con.passValid.value = false;
                      con.passValid1.value = false;
                    }

                    /// Confirm Password Validation

                    if (con.cPassController.value.text.trim().isEmpty) {
                      con.cPassValid.value = true;
                      con.cPassValid1.value = false;
                    } else if (con.cPassController.value.text.trim() !=
                        con.passwordController.value.text.trim()) {
                      con.cPassValid.value = false;
                      con.cPassValid1.value = true;
                    } else {
                      con.cPassValid.value = false;
                      con.cPassValid1.value = false;
                    }

                    if (con.nameValid.isFalse &&
                        con.emailValid.isFalse &&
                        con.emailValid1.isFalse &&
                        con.passValid.isFalse &&
                        con.passValid1.isFalse &&
                        con.cPassValid.isFalse &&
                        con.cPassValid1.isFalse) {
                      if (con.isTermsAndConditionAccept.value) {
                        await isUserLoggedIn();

                        con.signUpUser();
                      } else {
                        toast(
                            'Accept Terms & Conditions and Privacy Policy for continue',
                            false);
                      }
                    }
                  }
                },
                child: Container(
                  height: isTablet ? 55 : 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                      gradient: verticalGradient),
                  child: con.isLoading.value
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          'signUp'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 20 : 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You have an account?',
                    style: TextStyle(
                      fontSize: isTablet ? 19 : 17,
                    ),
                  ),
                  SizedBox(width: isTablet ? 8 : 5),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Text(
                      "signBtn".tr,
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: isTablet ? 25 : 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Name Text Field

  Widget nameField() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(width: 1, color: borderColor),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
                child: TextFormField(
                  controller: con.nameController.value,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'fullName'.tr,
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
                con.nameValid.value
                    ? const SizedBox(height: 4)
                    : const SizedBox(),
                con.nameValid.value
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Please enter full name".tr,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: isTablet ? 13 : 12,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ));
  }

  /// Password Text Field

  Widget passwordField() {
    return Obx(() => Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(width: 1, color: borderColor),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller: con.passwordController.value,
                  obscureText: con.hidePassword.value,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'password'.tr,
                    hintStyle: TextStyle(
                      color: textColor,
                      fontSize: isTablet ? 16 : 15,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        con.hidePassword.value = !con.hidePassword.value;
                      },
                      icon: Icon(
                        con.hidePassword.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  style: TextStyle(fontSize: isTablet ? 17 : 16),
                ),
              ),
            ),
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    con.passValid.value || con.passValid1.value
                        ? SizedBox(height: isTablet ? 9 : 6)
                        : const SizedBox(),
                    SizedBox(
                      width: Get.width,
                      child: con.passValid.value
                          ? Text(
                              "passValidation".tr,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: isTablet ? 13 : 12,
                              ),
                            )
                          : con.passValid1.value
                              ? Text(
                                  "passValidation1".tr,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: isTablet ? 13 : 12,
                                  ),
                                )
                              : const SizedBox(),
                    ),
                  ],
                )),
            SizedBox(height: isTablet ? 20 : 16),
          ],
        ));
  }

  /// Confirm Password Text Field

  Widget confirmPassField() {
    return Obx(() => Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(width: 1, color: borderColor),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller: con.cPassController.value,
                  obscureText: con.cHidePassword.value,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Confirm password'.tr,
                    hintStyle: TextStyle(
                      color: textColor,
                      fontSize: isTablet ? 16 : 15,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        con.cHidePassword.value = !con.cHidePassword.value;
                      },
                      icon: Icon(
                        con.cHidePassword.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  style: TextStyle(fontSize: isTablet ? 17 : 16),
                ),
              ),
            ),
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    con.cPassValid.value || con.cPassValid1.value
                        ? SizedBox(height: isTablet ? 9 : 6)
                        : const SizedBox(),
                    SizedBox(
                      width: Get.width,
                      child: con.cPassValid.value
                          ? Text(
                              "passValidation".tr,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: isTablet ? 13 : 12,
                              ),
                            )
                          : con.cPassValid1.value
                              ? Text(
                                  "Both Password doesn't match".tr,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: isTablet ? 13 : 12,
                                  ),
                                )
                              : const SizedBox(),
                    ),
                  ],
                )),
            SizedBox(height: isTablet ? 20 : 16),
          ],
        ));
  }

  /// Email Text Field

  Widget emailField() {
    return Obx(() => Column(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(width: 1, color: borderColor),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
                child: TextFormField(
                  controller: con.emailController.value,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: textColor,
                      fontSize: isTablet ? 17 : 15,
                    ),
                    hintText: 'emailAddress'.tr,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                con.emailValid.value || con.emailValid1.value
                    ? const SizedBox(height: 4)
                    : const SizedBox(),
                SizedBox(
                  width: Get.width,
                  child: con.emailValid.value
                      ? Text(
                          "emailValidation".tr,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: isTablet ? 13 : 12,
                          ),
                        )
                      : con.emailValid1.value
                          ? Text(
                              "emailValidation1".tr,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: isTablet ? 13 : 12,
                              ),
                            )
                          : const SizedBox(),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 24 : 20),
          ],
        ));
  }

  /// DOB Text Field

  Widget dobField({context}) {
    return Obx(() => Column(
          children: [
            InkWell(
              onTap: () {
                con.selectedDate(context);
              },
              child: Container(
                height: 50,
                width: 364,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(width: 1, color: borderColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    enabled: false,
                    controller: con.dobController.value,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'dobValidation'.tr,
                      hintStyle: TextStyle(
                        color: textColor,
                        fontSize: 17,
                      ),
                      suffixIcon: const Icon(
                        Icons.calendar_month,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                con.dobValid.value
                    ? const SizedBox(height: 4)
                    : const SizedBox(),
                SizedBox(
                  width: Get.width,
                  child: con.dobValid.value
                      ? Text(
                          "dobValidation".tr,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ));
  }
}

class BuildBottomSheet extends StatelessWidget {
  const BuildBottomSheet(
      {Key? key, required this.onPressed, required this.otpController})
      : super(key: key);
  final Function(String) onPressed;
  final TextEditingController otpController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        10.heightBox,
        "Enter otp".text.bold.make(),
        10.heightBox,
        VxTextField(
          hint: "Enter otp",
          controller: otpController,
          maxLength: 6,
          keyboardType: TextInputType.phone,
          borderType: VxTextFieldBorderType.roundLine,
          borderRadius: 10,
        ),
        10.heightBox,
        ElevatedButton(
                onPressed: () {
                  if (otpController.text.isBlank == true ||
                      otpController.text.length != 6) {
                    showToastMessage(
                      title: "Error",
                      message: otpController.text.isBlank == true
                          ? "OTP required"
                          : "Invalid otp",
                    );
                    return;
                  }
                  onPressed(otpController.text);
                },
                child: "Verify".text.make())
            .w(double.infinity)
      ],
    ).p(10).box.height(200).make();
  }
}
