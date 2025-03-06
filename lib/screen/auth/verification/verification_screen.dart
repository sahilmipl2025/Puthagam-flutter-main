import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:puthagam/screen/auth/verification/verification_controller.dart';
import 'package:puthagam/utils/colors.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  VerificationController con = Get.put(VerificationController());

  late final String? phoneNumber;

  StreamController<ErrorAnimationType>? errorController;

  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: buttonColor,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(gradient: verticalGradient),
          padding: const EdgeInsets.all(16.0),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 315,
                  child: Text(
                    'verfi'.tr,
                    style: const TextStyle(
                      // color: Colors.black,
                      fontSize: 32,
                      fontFamily: 'SF-Pro-Display-Semibold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Container(
                  alignment: Alignment.center,
                  width: 315,
                  child: Text(
                    'verifitext'.tr,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'SF-Pro-Display-Semibold',
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: double.infinity,
                  child: Form(
                    key: formKey,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 30),
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
                            inactiveColor: borderColor,
                            inactiveFillColor: Colors.white,
                            selectedFillColor: Colors.white,
                            selectedColor: borderColor,
                            activeColor: buttonColor,
                            activeFillColor: buttonColor,
                          ),
                          cursorColor: Colors.black,
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: con.otpController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          // Only numbers can be entered
                          boxShadows: const [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.white,
                              blurRadius: 10,
                            )
                          ],
                          onCompleted: (v) {
                            debugPrint("Completed");
                          },
                          onTap: () {},
                          onChanged: (value) {
                            debugPrint(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            debugPrint("Allowing to paste $text");
                            return true;
                          },
                        )),
                  ),
                ),
                const SizedBox(height: 35),
                Obx(() => Container(
                      height: 50,
                      width: 351,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(width: 1, color: borderColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          controller: con.passwordController1.value,
                          obscureText: !con.hidePassword.value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'newpass'.tr,
                            hintStyle: TextStyle(
                              color: textColor,
                              fontSize: 17,
                              fontFamily: 'SF-Pro-Display-Regular',
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  con.hidePassword.value =
                                      !con.hidePassword.value;
                                },
                                icon: Icon(
                                  con.hidePassword.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 25),
                Obx(() => Container(
                      width: 351,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(width: 1, color: borderColor)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          controller: con.passwordController2.value,
                          obscureText: !con.hidePassword1.value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'newpass'.tr,
                            hintStyle: TextStyle(
                              color: textColor,
                              fontSize: 17,
                              fontFamily: 'SF-Pro-Display-Regular',
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  con.hidePassword1.value =
                                      !con.hidePassword1.value;
                                },
                                icon: Icon(
                                  con.hidePassword1.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 45),

                // Container(
                //   alignment: Alignment.center,
                //   height: 45,
                //   width: 315,
                //   child: Text(
                //     'otp'.tr,
                //     style: TextStyle(
                //       color: textColor,
                //       fontFamily: 'SF-Pro-Display-Regular',
                //      fontSize: 14,
                //     ),
                //   ),
                // ),
                // Container(
                //   alignment: Alignment.topCenter,
                //   width: 315,
                //   child: Text(
                //     "Re-send on 0:12",
                //     style: TextStyle(
                //       color: resendBtnColor,
                //       fontFamily: 'SF-Pro-Display-Semibold',
                //      fontSize: 14,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    con.resetPassword();
                  },
                  child: Container(
                    height: 45,
                    width: 315,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      'restPass'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'SF-Pro-Display-Semibold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
