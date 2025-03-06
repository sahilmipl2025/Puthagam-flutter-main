import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:puthagam/data/api/reedem_code/get_reedem_code.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/profile/subscription/subcription_controller.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionPage extends StatelessWidget {
  SubscriptionPage({Key? key}) : super(key: key);
  final SubscriptionController con = Get.put(SubscriptionController());

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: verticalGradient),
            height: Get.height,
            width: Get.width,
            child: Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(gradient: verticalGradient),
                    child: Padding(
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      child: SafeArea(
                        child: Row(
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
                                  "Manage subscription",
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
                    decoration: BoxDecoration(
                      gradient: verticalGradient,
                      borderRadius:
                          BorderRadius.all(Radius.circular(isTablet ? 12 : 8)),
                    ),
                    child: Column(children: [
                      SizedBox(height: isTablet ? 12 : 8),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 20 : 16,
                            vertical: isTablet ? 14 : 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Membership',
                                      style: TextStyle(
                                        fontSize: isTablet ? 19 : 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: isTablet ? 6 : 4),
                                    Text(
                                      LocalStorage.planEndDate != "null"
                                          ? 'Now you are premium member & renews on ${DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(int.parse(LocalStorage.planEndDate) * 1000)).toLowerCase()}'
                                          : "",
                                      style: TextStyle(
                                        fontSize: isTablet ? 15 : 13,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: isTablet ? 35 : 30,
                              width: isTablet ? 35 : 30,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/images/checkmark.png',
                                color: Colors.green,
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(thickness: 1, color: Colors.white),
                      Obx(
                        () => baseController!.isShared.value
                            ? const SizedBox()
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: isTablet ? 14 : 10,
                                    horizontal: isTablet ? 17 : 14),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => getRedeemCodeApi(),
                                        child: SizedBox(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'invite'.tr,
                                                style: TextStyle(
                                                  fontSize: isTablet ? 19 : 17,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              SizedBox(
                                                  height: isTablet ? 11 : 8),
                                              Text(
                                                'You can share this subscription to 2 members of your choice',
                                                style: TextStyle(
                                                  fontSize: isTablet ? 15 : 13,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: isTablet ? 13 : 10),
                                    Icon(Icons.arrow_forward_ios,
                                        size: isTablet ? 24 : 20),
                                  ],
                                ),
                              ),
                      ),
                      const Divider(thickness: 1, color: Colors.white),
                      InkWell(
                        onTap: () {
                          showDialog(
                            barrierColor: const Color.fromRGBO(0, 0, 0, 0.80),
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        isTablet ? 14 : 10)),
                                child: SizedBox(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: isTablet ? 20 : 16,
                                            top: isTablet ? 14 : 10,
                                            right: isTablet ? 20 : 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              baseController!.trialRunning.value
                                                  ? 'Cancel Trial Subscription'
                                                  : 'Cancel subscription',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: isTablet ? 19 : 17,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: isTablet ? 6 : 4),
                                            Text(
                                              baseController!.trialRunning.value
                                                  ? 'Are you sure you want to cancel your trial subscription ? '
                                                  : 'Are you sure you want to cancel your subscription ? ',
                                              style: TextStyle(
                                                fontSize: isTablet ? 17 : 15,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: isTablet ? 20 : 16),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: isTablet ? 12 : 9,
                                            vertical: isTablet ? 8 : 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(
                                                isTablet ? 12 : 10),
                                            bottomRight: Radius.circular(
                                                isTablet ? 12 : 10),
                                          ),
                                          color: Colors.grey[100],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.0),
                                                  border: Border.all(
                                                      color: buttonColor),
                                                  color: Colors.white,
                                                ),
                                                margin: const EdgeInsets.all(6),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        isTablet ? 24 : 20,
                                                    vertical: isTablet ? 6 : 4),
                                                child: Text(
                                                  "No",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        isTablet ? 17 : 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                Get.back();
                                                if (Platform.isIOS) {
                                                  launchUrl(Uri.parse(
                                                          "https://apple.co/2Th4vqI"))
                                                      .then((value) async {
                                                    await _inAppPurchase
                                                        .restorePurchases();
                                                    final bool isAvailable =
                                                        await _inAppPurchase
                                                            .isAvailable();
                                                    if (isAvailable == false) {
                                                      con.deletePremiumApi();
                                                    }
                                                  });
                                                } else {
                                                  con.deletePremiumApi();
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: buttonColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                    color: buttonColor),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: isTablet ? 9 : 6),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        isTablet ? 24 : 20,
                                                    vertical: isTablet ? 8 : 5),
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                    fontSize:
                                                        isTablet ? 17 : 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 14 : 10,
                              horizontal: isTablet ? 16 : 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  baseController!.trialRunning.value
                                      ? 'Cancel Trial Subscription'
                                      : 'Cancel subscription',
                                  style: TextStyle(
                                    fontSize: isTablet ? 19 : 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(width: isTablet ? 13 : 10),
                              Icon(Icons.arrow_forward_ios,
                                  size: isTablet ? 24 : 20)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 12 : 8),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          Obx(() => con.showLoader.value
              ? Container(
                  color: Colors.grey.withOpacity(0.5),
                  child: const AppLoader(),
                )
              : const SizedBox())
        ],
      ),
    );
  }
}
