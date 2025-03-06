import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/auth/reset_pass_api.dart';
import 'package:puthagam/screen/dashboard/profile/reset_pass/reset_controller.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';

import '../../../../utils/app_snackbar.dart';

class ResetPass extends StatelessWidget {
  ResetPass({Key? key}) : super(key: key);

  final ResetController con = Get.put(ResetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => Container(
        decoration: BoxDecoration(gradient: verticalGradient),
        height: Get.height,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(gradient: verticalGradient),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => Get.back(),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Change password",
                                style: TextStyle(
                                  fontSize: isTablet ? 23 : 19,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                          width: 1,
                          color: Colors.white,
                        ),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
                        child: TextFormField(
                          controller: con.oldPass.value,
                          obscureText: !con.showOldPass.value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Old password",
                            hintStyle: TextStyle(
                              fontSize: isTablet ? 17 : 15,
                              color: Colors.white,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                con.showOldPass.value = !con.showOldPass.value;
                              },
                              icon: Icon(
                                !con.showOldPass.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.white,
                                size: isTablet ? 22 : 20,
                              ),
                            ),
                          ),
                          style: TextStyle(fontSize: isTablet ? 18 : 16),
                        ),
                      ),
                    ),
                    con.oldValid.value
                        ? const SizedBox(height: 16)
                        : const SizedBox(height: 4),
                    con.oldValid.isFalse
                        ? Text(
                            "Enter valid password",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: isTablet ? 14 : 12,
                            ),
                          )
                        : const SizedBox(),
                    con.oldValid.isFalse
                        ? const SizedBox(height: 16)
                        : const SizedBox(height: 0),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(width: 1, color: Colors.white),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
                        child: TextFormField(
                          obscureText: !con.showNewPass.value,
                          controller: con.newPass.value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "New password",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 17 : 15,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                con.showNewPass.value = !con.showNewPass.value;
                              },
                              icon: Icon(
                                !con.showNewPass.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.white,
                                size: isTablet ? 22 : 20,
                              ),
                            ),
                          ),
                          style: TextStyle(fontSize: isTablet ? 18 : 16),
                        ),
                      ),
                    ),
                    con.newValid.value
                        ? const SizedBox(height: 16)
                        : const SizedBox(height: 4),
                    SizedBox(
                        width: Get.width * 0.84,
                        child: con.newValid.isFalse
                            ? Text(
                                "Please enter minimum 10 letter",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: isTablet ? 14 : 12,
                                ),
                              )
                            : const SizedBox()),
                          
                    con.newValid.isFalse
                        ? const SizedBox(height: 16)
                        : const SizedBox(height: 0),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(width: 1, color: Colors.white),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
                        child: TextFormField(
                          obscureText: !con.showCNewPass.value,
                          controller: con.cPass.value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Confirm New Password",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 17 : 15,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                con.showCNewPass.value =
                                    !con.showCNewPass.value;
                              },
                              icon: Icon(
                                !con.showCNewPass.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.white,
                                size: isTablet ? 22 : 20,
                              ),
                            ),
                          ),
                          style: TextStyle(fontSize: isTablet ? 18 : 16),
                        ),
                      ),
                    ),
                    con.cValid.value
                        ? const SizedBox(height: 16)
                        : const SizedBox(height: 4),
                    SizedBox(
                        width: Get.width * 0.84,
                        child: con.cValid.isFalse
                            ? Text(
                                "Both Password doesn't match",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: isTablet ? 14 : 12,
                                ),
                              )
                            : const SizedBox()),
                    con.cValid.isFalse
                        ? const SizedBox(height: 16)
                        : const SizedBox(height: 0),
                    const SizedBox(height: 24),
                    con.isLoading.value
                        ? const Center(child: AppLoader())
                        : Center(
                            child: InkWell(
                              onTap: () async {
                                FocusScope.of(context).unfocus();

                                /// email validation

                                if (con.oldPass.value.text.trim().isEmpty) {
                                  con.oldValid.value = false;
                                } else {
                                  con.oldValid.value = true;
                                }

                                if (con.newPass.value.text.trim().isEmpty) {
                                  con.newValid.value = false;
                                } else if (con.newPass.value.text
                                        .trim()
                                        .length <
                                    6) {
                                  con.newValid.value = false;
                                } else {
                                  con.newValid.value = true;
                                }
                                  //  if (con.oldPass.value.text !=
                                  //     con.newPass.value.text) {
                                  //         con.newValid.value = false;
                                  //   toast(
                                  //       "old pss should not be same with new pass",
                                  //       true);
                                  // } else {
                                  //   con.newValid.value = true;
                                  // //  resetPassApi();
                                  // }
                                if (con.cPass.value.text.trim().isEmpty) {
                                  con.cValid.value = false;
                                } else if (con.newPass.value.text.trim() !=
                                    con.cPass.value.text.trim()) {
                                  con.cValid.value = false;
                                } else {
                                  con.cValid.value = true;
                                }

                                if (con.oldValid.value &&
                                    con.newValid.value &&
                                    con.cValid.value) {
                                  resetPassApi();

                                //   if (con.oldPass.value.text !=
                                //       con.newPass.value.text) {
                                //     toast(
                                //         "old pss should not be same with new pass",
                                //         true);
                                //   } else {
                                //     resetPassApi();
                                //   }
                               }
                              },
                              child: Container(
                                width: Get.width * 0.6,
                                height: isTablet ? 60 : 45,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  gradient: verticalGradient,
                                ),
                                child: Text(
                                  'Change password',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isTablet ? 20 : 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
