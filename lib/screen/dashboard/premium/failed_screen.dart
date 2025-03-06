import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/global.dart';

class FailedScreen extends StatefulWidget {
  const FailedScreen({Key? key}) : super(key: key);

  @override
  State<FailedScreen> createState() => _FailedScreenState();
}

class _FailedScreenState extends State<FailedScreen> {
  RxInt timer = 0.obs;
  Timer? timer1;

  checkPremiumOrNot() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer1 = Timer.periodic(
      const Duration(seconds: 1),
      (timer1) {
        timer.value++;
        if (timer.value == 3) {
          timer.close();
          Get.back();
          Get.back();
          baseController!.update();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        timer.close();
        Get.back();
        Get.back();
        Get.back();
        return true;
      },
      child: Scaffold(
        body: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(gradient: verticalGradient),
          child: SafeArea(
            child: Column(
              children: [
                Obx(() => Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        gradient: verticalGradient,
                      ),
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Payment Failed",
                                    style: TextStyle(
                                      fontSize: isTablet ? 19 : 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            left: isTablet ? 20 : 16,
                            child: InkWell(
                              onTap: () {
                                timer.close();
                                Get.back();
                                Get.back();
                                Get.back();
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: GlobalService.to.isDarkModel == true
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        height: Get.height * 0.5,
                        child: Lottie.asset('assets/lottie/failed.json'),
                      ),
                      Text(
                        "Subscription payment failed",
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
