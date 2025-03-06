import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:puthagam/podcaster/core/utils/app_utils.dart';
import 'package:puthagam/screen/auth/forget_pass/forgot_pass_controller.dart';
import 'package:puthagam/screen/auth/login/login_controller.dart';
import 'package:puthagam/screen/auth/signup/signup_controller.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../utils/app_routes.dart';
import 'otp_controller.dart';

// ignore: must_be_immutable
class OtpScreen extends StatelessWidget {
  final OtpController con = Get.put(OtpController());
  final formKey = GlobalKey<FormState>();
  final args = Get.arguments;
  ForgotPassController? forgetController;
  SignUpController? signUpController;
  LoginController? loginController;

  OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    con.timer();
    if (Get.previousRoute == AppRoutes.forgotPasswordScreen) {
      forgetController = Get.find<ForgotPassController>();
    }
    if (Get.previousRoute == AppRoutes.signUpScreen) {
      signUpController = Get.find<SignUpController>();
    }
    if (Get.previousRoute == AppRoutes.loginScreen) {
      loginController = Get.find<LoginController>();
    }

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                height: Get.height,
                decoration: BoxDecoration(gradient: verticalGradient),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: Get.height * 0.13),
                      const Text(
                        'Verification',
                        style: TextStyle(
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      40.heightBox,
                      "Enter the OTP code you received in your email"
                          .text
                          .color(text23)
                          .center
                          .make()
                          .w(200),
                      40.heightBox,
                      SizedBox(
                        width: double.infinity,
                        child: Form(
                          key: formKey,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 30),
                              child: PinCodeTextField(
                                appContext: context,
                                length: 6,
                                obscureText: false,
                                hintCharacter: '',
                                textStyle: const TextStyle(color: Colors.white),
                                blinkWhenObscuring: false,
                                animationType: AnimationType.fade,

                                validator: (v) {
                                  return;
                                },
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 40,
                                  fieldWidth: 40,
                                  inactiveColor: text23,
                                  inactiveFillColor:
                                      Colors.transparent.withOpacity(.0),
                                  selectedFillColor: Colors.white,
                                  selectedColor: borderColor,
                                  activeColor: commonBlueColor,
                                  activeFillColor: commonBlueColor,
                                ),
                                cursorColor: Colors.black,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                enableActiveFill: true,
                                // errorAnimationController: errorController,
                                controller: con.otpController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                // Only numbers can be entered
                                boxShadows: const [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.transparent,
                                    blurRadius: 10,
                                  )
                                ],
                                onCompleted: (v) {
                                  debugPrint("Completed");
                                },
                                onTap: () {},
                                onChanged: (value) {
                                  debugPrint(value);
                                },
                                beforeTextPaste: (text) {
                                  debugPrint("Allowing to paste $text");
                                  return true;
                                },
                              )),
                        ),
                      ),
                      20.heightBox,

                      ///  "Haven't received an OTP yet!".text.center.make(),
                      // 20.heightBox,
                      // Obx(() {
                      //   return con.seconds.value > 0
                      //       ? "Resend OTP in ${con.seconds.value} seconds"
                      //           .text
                      //           .center
                      //           .make()
                      //       : "Resend OTP".text.center.make().onInkTap(() {
                      //           con.resendOTP();
                      //         });
                      // }),
                      80.heightBox,
                      InkWell(
                        onTap: () async {
                          log("otp ${con.otpController.text}");
                          if (con.otpController.text.isEmpty) {
                            showToastMessage(
                                title: "OTP Required",
                                message: "Please enter your otp code");
                            return;
                          }
                          if (forgetController != null) {
                            if (args["type"] == "reset") {
                              forgetController!
                                  .confirmReset(con.otpController.text);
                            } else {
                              forgetController!
                                  .confirmCreateUser(con.otpController.text);
                            }
                            return;
                          }
                          if (signUpController != null) {
                            signUpController!
                                .confirmUser(con.otpController.text);
                            return;
                          }
                          if (loginController != null) {
                            loginController!.veryifyOTP(
                                args["email"], con.otpController.text);
                          }
                        },
                        child: Container(
                          width: 200,
                          height: 45,
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50),
                              ),
                              gradient: verticalGradient),
                          child: const Text(
                            'Verify',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      )
                    ]))));
  }
}
