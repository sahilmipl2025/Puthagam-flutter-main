import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/auth/reset_password/reset_pass_controller.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/global.dart';

class ResetPassScreen extends StatelessWidget {
  ResetPassScreen({Key? key}) : super(key: key);

  final ResetPassController con = Get.put(ResetPassController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor:
            GlobalService.to.isDarkModel == true ? buttonColor : Colors.white,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back,
            color: GlobalService.to.isDarkModel == true
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: Obx((() => Container(
            height: Get.height,
            decoration: BoxDecoration(gradient: verticalGradient),
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Container(
                height: 600,
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 315,
                      height: 50,
                      child: Text(
                        'restPass'.tr,
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
                        'restText'.tr,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'SF-Pro-Display-Regular',
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 45),
                    Container(
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
                    ),
                    const SizedBox(height: 25),
                    Container(
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
                    ),
                    const SizedBox(height: 45),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Text(
                          'restPass'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'SF-Pro-Display-Semibold',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ))),
    );
  }
}
