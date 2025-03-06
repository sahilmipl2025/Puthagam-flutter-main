import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:launch_review/launch_review.dart';
import 'package:puthagam/data/api/auth/signout_api.dart';
import 'package:puthagam/data/api/profile/get_payment_url_api.dart';
import 'package:puthagam/data/api/profile/get_profile_api.dart';
import 'package:puthagam/data/services/dynamic_link_service.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/podcaster/modules/podcasts/controllers/podcasts_controller.dart';
import 'package:puthagam/podcaster/modules/podcasts/views/main_view.dart';
import 'package:puthagam/screen/dashboard/profile/profile_page/profile_controller.dart';
import 'package:puthagam/screen/dashboard/profile/reset_pass/reset_pass.dart';
import 'package:puthagam/screen/dashboard/profile/setting/setting_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController con = Get.put(ProfileController());

  final SettingController con1 = Get.put(SettingController());

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() => con.isLoading.value
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            body: Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(gradient: verticalGradient),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(gradient: verticalGradient),
                          child: SafeArea(
                            child: Column(
                              children: [
                                SizedBox(height: isTablet ? 8 : 5),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 24 : 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                          width: isTablet ? 4 : 2,
                                          height: isTablet ? 7 : 5),
                                      InkWell(
                                        onTap: () => Get.toNamed(
                                            AppRoutes.editProfilePage),
                                        child: Text(
                                          'Edit',
                                          style: TextStyle(
                                            fontSize: isTablet ? 18 : 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                baseController!.userProfile.value.toString() !=
                                            "null" ||
                                        baseController!
                                            .userProfile.value.isNotEmpty
                                    ? Obx(
                                        () => CircleAvatar(
                                          radius: isTablet ? 65 : 55.0,
                                          backgroundImage: NetworkImage(
                                              baseController!
                                                  .userProfile.value),
                                          backgroundColor: Colors.grey.shade400,
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: isTablet ? 65 : 55.0,
                                        backgroundImage: const AssetImage(
                                            "assets/images/user.png"),
                                        backgroundColor: Colors.grey.shade400,
                                      ),
                                SizedBox(height: isTablet ? 15 : 12),
                                Obx(
                                  () => Column(
                                    children: [
                                      Text(
                                        baseController!.userName.value,
                                        style: TextStyle(
                                          fontSize: isTablet ? 22 : 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: isTablet ? 22 : 20),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(gradient: verticalGradient),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(isTablet ? 20 : 16.0),
                              child: Column(
                                children: [
                                  baseController!.isTried.value
                                      ? const SizedBox()
                                      : baseController!.isBetaVersion.value
                                          ? const SizedBox()
                                          : const SizedBox(),
                                  // Row(
                                  //             mainAxisAlignment:
                                  //                 MainAxisAlignment.end,
                                  //             children: [
                                  //               Text(
                                  //                   "Click here to activate ${baseController!.trialDays.value} days "),
                                  //               GestureDetector(
                                  //                 onTap: () {
                                  //                   getPaymentUrlApi(
                                  //                     fromPlay: false,
                                  //                     planId: 'TRIAL',
                                  //                     isTrial: true,
                                  //                     isBeta: false,
                                  //                   );
                                  //                 },
                                  //                 child: Container(
                                  //                   padding: const EdgeInsets
                                  //                           .symmetric(
                                  //                       vertical: 4,
                                  //                       horizontal: 12),
                                  //                   decoration: BoxDecoration(
                                  //                     color:
                                  //                         Colors.green.shade500,
                                  //                     borderRadius:
                                  //                         BorderRadius.circular(
                                  //                             16),
                                  //                   ),
                                  //                   child: const Text(
                                  //                     "Free trial",
                                  //                     style: TextStyle(
                                  //                       fontWeight:
                                  //                           FontWeight.w600,
                                  //                       color: Colors.white,
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           )
                                  
                                  baseController!.isBetaVersion.value
                                      ? baseController!.isSubscribed.value &&
                                              baseController!.betaVersion.value
                                          ? const SizedBox()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                const Text(
                                                    "Click here to activate "),
                                                GestureDetector(
                                                  onTap: () {
                                                    getPaymentUrlApi(
                                                      fromPlay: false,
                                                      planId: con
                                                              .subscriptionList[
                                                                  0]
                                                              .id ??
                                                          "",
                                                      isTrial: false,
                                                      isBeta: true,
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4,
                                                        horizontal: 12),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.green.shade500,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    child: const Text(
                                                      "Beta trial",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                      : const SizedBox(),
                                  const SizedBox(height: 12),
                                  Obx(() => baseController!.trialRunning.value
                                      ? InkWell(
                                          onTap: () async {
                                            if (Platform.isIOS) {
                                              await Get.toNamed(
                                                  AppRoutes.premiumIosScreen);
                                              setState(() {});
                                              setState(() {});
                                            } else {
                                              await Get.toNamed(AppRoutes
                                                  .premiumSubscriptionPage);
                                              setState(() {});
                                              setState(() {});
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(
                                              isTablet ? 18 : 16,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: verticalGradient,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(12),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(
                                                      isTablet ? 8 : 6),
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                  child: Image.asset(
                                                    'assets/icons/subscr.png',
                                                    height: isTablet ? 22 : 20,
                                                    width: isTablet ? 22 : 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: isTablet ? 14 : 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${DateTime.fromMillisecondsSinceEpoch(baseController!.planEndDate.value * 1000).difference(DateTime.now()).inDays} days free trial left',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: isTablet
                                                              ? 16
                                                              : 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              isTablet ? 5 : 3),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'After the trial period over you will need to upgrade your account',
                                                          style: TextStyle(
                                                            color: text23,
                                                            fontSize: isTablet
                                                                ? 14
                                                                : 13,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: isTablet ? 6 : 4),
                                                IconButton(
                                                  onPressed: () async {
                                                    if (Platform.isIOS) {
                                                      await Get.toNamed(AppRoutes
                                                          .premiumIosScreen);
                                                      setState(() {});
                                                      setState(() {});
                                                    } else {
                                                      await Get.toNamed(AppRoutes
                                                          .premiumSubscriptionPage);
                                                      setState(() {});
                                                      setState(() {});
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: textColor,
                                                    size: isTablet ? 18 : 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : baseController!.trialRunning.isFalse &&
                                              baseController!
                                                  .isSubscribed.value &&
                                              baseController!
                                                  .betaVersion.isFalse
                                          ? InkWell(
                                              onTap: () async {
                                                await Get.toNamed(
                                                    AppRoutes.subscriptionPage);
                                                setState(() {});
                                                setState(() {});
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    isTablet ? 18 : 16),
                                                decoration: BoxDecoration(
                                                  gradient: verticalGradient,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/icons/subscr.png',
                                                        height:
                                                            isTablet ? 24 : 20,
                                                        width:
                                                            isTablet ? 24 : 20,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 14),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'manageSub'.tr,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: isTablet
                                                                  ? 16
                                                                  : 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: isTablet
                                                                  ? 4
                                                                  : 2),
                                                          Text(
                                                            'premiumAcc'.tr,
                                                            style: TextStyle(
                                                              color: text23,
                                                              fontSize: isTablet
                                                                  ? 14
                                                                  : 12,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () async {
                                                        if (baseController!
                                                            .betaVersion
                                                            .value) {
                                                          if (Platform.isIOS) {
                                                            Get.toNamed(AppRoutes
                                                                .premiumIosScreen);
                                                          } else {
                                                            Get.toNamed(AppRoutes
                                                                .premiumSubscriptionPage);
                                                          }
                                                        } else {
                                                          await Get.toNamed(
                                                              AppRoutes
                                                                  .subscriptionPage);
                                                          setState(() {});
                                                          setState(() {});
                                                        }
                                                      },
                                                      icon: Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: textColor,
                                                        size:
                                                            isTablet ? 18 : 15,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ))
                                          : InkWell(
                                              onTap: () async {
                                                if (Platform.isIOS) {
                                                  await Get.toNamed(AppRoutes
                                                      .premiumIosScreen);
                                                  setState(() {});
                                                  setState(() {});
                                                } else {
                                                  await Get.toNamed(AppRoutes
                                                      .premiumSubscriptionPage);
                                                  setState(() {});
                                                  setState(() {});
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    isTablet ? 18 : 16),
                                                decoration: BoxDecoration(
                                                  gradient: verticalGradient,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/icons/subscr.png',
                                                        height:
                                                            isTablet ? 24 : 20,
                                                        width:
                                                            isTablet ? 24 : 20,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Buy subscription",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: isTablet
                                                                  ? 16
                                                                  : 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          Obx(() => Text(
                                                                baseController!
                                                                        .betaVersion
                                                                        .value
                                                                    ? "Your beta trial has been started. Buy subscription to enjoy unlimited books and podcast access"
                                                                    : baseController!.isTried.value &&
                                                                            baseController!.alreadyPremium.isFalse
                                                                        ? "Your free trial has ended. Buy subscription to enjoy unlimited books and podcast access"
                                                                        : baseController!.alreadyPremium.value
                                                                            ? "Your subscription has ended. Buy subscription to enjoy unlimited books and podcast access"
                                                                            : "Buy subscription to enjoy unlimited books and podcast access",
                                                                style:
                                                                    TextStyle(
                                                                  color: text23,
                                                                  fontSize:
                                                                      Get.width >
                                                                              550
                                                                          ? 14
                                                                          : 12,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () async {
                                                        if (Platform.isIOS) {
                                                          await Get.toNamed(
                                                              AppRoutes
                                                                  .premiumIosScreen);
                                                          setState(() {});
                                                          setState(() {});
                                                        } else {
                                                          await Get.toNamed(
                                                              AppRoutes
                                                                  .premiumSubscriptionPage);
                                                          setState(() {});
                                                          setState(() {});
                                                        }
                                                      },
                                                      icon: Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: textColor,
                                                        size:
                                                            isTablet ? 18 : 15,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Visibility(
                                          visible: baseController
                                                  ?.isPodcaster.value ==
                                              "true",
                                          child: InkWell(
                                            onTap: () {
                                              Get.lazyPut<PodcastsController>(
                                                () => PodcastsController(),
                                              );
                                              Get.to(const PodcastsView());
                                            },
                                            child: profileTile(
                                              image: 'assets/icons/live.png',
                                              name: 'Go live',
                                              context: context,
                                            ),
                                          ),
                                        ),
                                        baseController!.isSubscribed.value &&
                                                baseController!
                                                    .betaVersion.value
                                            ? SizedBox(
                                                height: isTablet ? 14 : 12)
                                            : const SizedBox(),
                                        baseController!.isSubscribed.value &&
                                                baseController!
                                                    .betaVersion.value
                                            ? InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    barrierColor:
                                                        const Color.fromRGBO(
                                                            0, 0, 0, 0.80),
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        isTablet
                                                                            ? 14
                                                                            : 10)),
                                                        child: SizedBox(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    left:
                                                                        isTablet
                                                                            ? 20
                                                                            : 16,
                                                                    top: isTablet
                                                                        ? 14
                                                                        : 10,
                                                                    right:
                                                                        isTablet
                                                                            ? 20
                                                                            : 16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Cancel Beta trial',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize: isTablet
                                                                            ? 19
                                                                            : 17,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height: isTablet
                                                                            ? 6
                                                                            : 4),
                                                                    Text(
                                                                      'Are you sure you want to cancel your beta trial ? ',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize: isTablet
                                                                            ? 17
                                                                            : 15,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      isTablet
                                                                          ? 20
                                                                          : 16),
                                                              Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        isTablet
                                                                            ? 12
                                                                            : 9,
                                                                    vertical:
                                                                        isTablet
                                                                            ? 8
                                                                            : 5),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft: Radius.circular(
                                                                        isTablet
                                                                            ? 12
                                                                            : 10),
                                                                    bottomRight:
                                                                        Radius.circular(isTablet
                                                                            ? 12
                                                                            : 10),
                                                                  ),
                                                                  color: Colors
                                                                          .grey[
                                                                      100],
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(2.0),
                                                                          border:
                                                                              Border.all(color: buttonColor),
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        margin: const EdgeInsets
                                                                            .all(
                                                                            6),
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal: isTablet
                                                                                ? 24
                                                                                : 20,
                                                                            vertical: isTablet
                                                                                ? 6
                                                                                : 4),
                                                                        child:
                                                                            Text(
                                                                          "No",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: isTablet
                                                                                ? 17
                                                                                : 15,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        Get.back();
                                                                        con.deletePremiumApi(
                                                                            betaVersion:
                                                                                true);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(color: buttonColor),
                                                                            borderRadius: BorderRadius.circular(3),
                                                                            color: buttonColor),
                                                                        margin: EdgeInsets.symmetric(
                                                                            vertical: isTablet
                                                                                ? 9
                                                                                : 6),
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal: isTablet
                                                                                ? 24
                                                                                : 20,
                                                                            vertical: isTablet
                                                                                ? 8
                                                                                : 5),
                                                                        child:
                                                                            Text(
                                                                          "Yes",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize: isTablet
                                                                                ? 17
                                                                                : 15,
                                                                            color:
                                                                                Colors.white,
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
                                                child: profileTile(
                                                  image:
                                                      'assets/icons/delete.png',
                                                  name: 'Cancel Beta trial',
                                                  context: context,
                                                ),
                                              )
                                            : const SizedBox(),
                                        baseController!.isSubscribed.value &&
                                                baseController!
                                                    .trialRunning.value
                                            ? SizedBox(
                                                height: isTablet ? 14 : 12)
                                            : const SizedBox(),
                                        baseController!.isSubscribed.value &&
                                                baseController!
                                                    .trialRunning.value
                                            ? InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    barrierColor:
                                                        const Color.fromRGBO(
                                                            0, 0, 0, 0.80),
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        isTablet
                                                                            ? 14
                                                                            : 10)),
                                                        child: SizedBox(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    left:
                                                                        isTablet
                                                                            ? 20
                                                                            : 16,
                                                                    top: isTablet
                                                                        ? 14
                                                                        : 10,
                                                                    right:
                                                                        isTablet
                                                                            ? 20
                                                                            : 16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Cancel Trial Subscription',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize: isTablet
                                                                            ? 19
                                                                            : 17,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height: isTablet
                                                                            ? 6
                                                                            : 4),
                                                                    Text(
                                                                      'Are you sure you want to cancel your trial subscription ? ',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize: isTablet
                                                                            ? 17
                                                                            : 15,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      isTablet
                                                                          ? 20
                                                                          : 16),
                                                              Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        isTablet
                                                                            ? 12
                                                                            : 9,
                                                                    vertical:
                                                                        isTablet
                                                                            ? 8
                                                                            : 5),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft: Radius.circular(
                                                                        isTablet
                                                                            ? 12
                                                                            : 10),
                                                                    bottomRight:
                                                                        Radius.circular(isTablet
                                                                            ? 12
                                                                            : 10),
                                                                  ),
                                                                  color: Colors
                                                                          .grey[
                                                                      100],
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(2.0),
                                                                          border:
                                                                              Border.all(color: buttonColor),
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        margin: const EdgeInsets
                                                                            .all(
                                                                            6),
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal: isTablet
                                                                                ? 24
                                                                                : 20,
                                                                            vertical: isTablet
                                                                                ? 6
                                                                                : 4),
                                                                        child:
                                                                            Text(
                                                                          "No",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: isTablet
                                                                                ? 17
                                                                                : 15,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        Get.back();
                                                                        con.deletePremiumApi(
                                                                            betaVersion:
                                                                                false);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(color: buttonColor),
                                                                            borderRadius: BorderRadius.circular(3),
                                                                            color: buttonColor),
                                                                        margin: EdgeInsets.symmetric(
                                                                            vertical: isTablet
                                                                                ? 9
                                                                                : 6),
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal: isTablet
                                                                                ? 24
                                                                                : 20,
                                                                            vertical: isTablet
                                                                                ? 8
                                                                                : 5),
                                                                        child:
                                                                            Text(
                                                                          "Yes",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize: isTablet
                                                                                ? 17
                                                                                : 15,
                                                                            color:
                                                                                Colors.white,
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
                                                child: profileTile(
                                                  image:
                                                      'assets/icons/delete.png',
                                                  name:
                                                      'Cancel Trial Subscription',
                                                  context: context,
                                                ),
                                              )
                                            : const SizedBox(),
                                        SizedBox(height: isTablet ? 14 : 12),
                                        InkWell(
                                          onTap: () => Get.toNamed(
                                              AppRoutes.purchaseListScreen),
                                          child: profileTile(
                                            image: 'assets/icons/subscr.png',
                                            name: 'Transaction History',
                                            context: context,
                                          ),
                                        ),
                                        SizedBox(height: isTablet ? 14 : 12),
                                        InkWell(
                                          onTap: () => Get.toNamed(AppRoutes.
                                              //phonepeScreen
                                              settingPage),
                                          child: profileTile(
                                            image: 'assets/icons/setting.png',
                                            name: 'Settings',
                                            context: context,
                                          ),
                                        ),
                                        SizedBox(height: isTablet ? 14 : 12),
                                        InkWell(
                                          onTap: () => Get.toNamed(
                                              AppRoutes.selectTopicsScreen,
                                              arguments: true),
                                          child: profileTile(
                                            image:
                                                'assets/icons/categories.png',
                                            name: 'Manage categories',
                                            context: context,
                                          ),
                                        ),
                                        LocalStorage.socialLogin == false
                                            ? const SizedBox(height: 16)
                                            : const SizedBox(),
                                        LocalStorage.socialLogin == false
                                            ? InkWell(
                                                onTap: () =>
                                                    Get.to(() => ResetPass()),
                                                child: profileTile(
                                                  image:
                                                      'assets/icons/reset.png',
                                                  name: 'Change password',
                                                  context: context,
                                                ),
                                              )
                                            : const SizedBox(),
                                        const SizedBox(height: 16),
                                        Obx(
                                          () => baseController!
                                                      .isSubscribed.value ||
                                                  baseController!.isShared.value
                                              ? const SizedBox()
                                              : InkWell(
                                                  onTap: () => Get.toNamed(
                                                      AppRoutes
                                                          .redeemCodeScreen),
                                                  child: profileTile(
                                                    image:
                                                        'assets/icons/redeem_code.png',
                                                    name: 'Redeem code',
                                                    context: context,
                                                  ),
                                                ),
                                        ),
                                        Obx(() => baseController!
                                                    .isSubscribed.value ||
                                                baseController!.isShared.value
                                            ? const SizedBox()
                                            : const SizedBox(height: 16)),
                                        InkWell(
                                          onTap: () async {
                                            var link =
                                                await createShareDynamicLink();

                                            Share.share(
                                                "I just discovered an awesome app for all book and podcast lovers out there! It's called MagicTamil and it's a great way to keep all your favorite reads and listens in one place.\nHappy reading and listening! - \n\n$link");
                                          },
                                          child: profileTile(
                                            image: 'assets/icons/sharing.png',
                                            name: 'Share',
                                            context: context,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        InkWell(
                                          onTap: () => LaunchReview.launch(),
                                          child: profileTile(
                                            image: 'assets/icons/star.png',
                                            name: 'Rate us',
                                            context: context,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        InkWell(
                                          onTap: () => Get.toNamed(
                                              AppRoutes.aboutUsPage),
                                          child: profileTile(
                                            image:
                                                'assets/icons/information.png',
                                            name: 'About us',
                                            context: context,
                                          ),
                                        ),
                                        if (Platform.isIOS)
                                          const SizedBox(height: 16),
                                        if (Platform.isIOS)
                                          InkWell(
                                            onTap: () async {
                                              await _inAppPurchase
                                                  .restorePurchases();
                                              final bool isAvailable =
                                                  await _inAppPurchase
                                                      .isAvailable();
                                              if (isAvailable == false) {
                                                toast(
                                                    "Restore Purchases successfully",
                                                    true);
                                                getUserProfileApi();
                                              } else {
                                                toast("No Purchases Found",
                                                    false);
                                              }
                                            },
                                            child: profileTile(
                                              image:
                                                  'assets/icons/information.png',
                                              name: 'Restore Purchases',
                                              context: context,
                                            ),
                                          ),
                                        const SizedBox(height: 16),
                                        InkWell(
                                          onTap: () => Get.toNamed(
                                              AppRoutes.privacyPage,
                                              arguments: "help"),
                                          child: profileTile(
                                            image:
                                                'assets/icons/help&support.png',
                                            name: 'Help and support',
                                            context: context,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        InkWell(
                                          onTap: () {
                                            showDialog<bool>(
                                              barrierColor:
                                                  const Color.fromRGBO(
                                                      0, 0, 0, 0.80),
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: SizedBox(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: isTablet
                                                                      ? 20
                                                                      : 16,
                                                                  top: isTablet
                                                                      ? 14
                                                                      : 10,
                                                                  right:
                                                                      isTablet
                                                                          ? 20
                                                                          : 16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Delete Confirmation',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      isTablet
                                                                          ? 16
                                                                          : 14,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      isTablet
                                                                          ? 4
                                                                          : 2),
                                                              Text(
                                                                'Are you sure you want to delete your account from the app? After deleting the account You will not access any content.',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      isTablet
                                                                          ? 14
                                                                          : 12,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                Get.width > 550
                                                                    ? 19
                                                                    : 16),
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      isTablet
                                                                          ? 12
                                                                          : 9,
                                                                  vertical:
                                                                      isTablet
                                                                          ? 8
                                                                          : 5),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            color: Colors
                                                                .grey[100],
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  Get.back();
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            2.0),
                                                                    border: Border.all(
                                                                        color:
                                                                            buttonColor),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  margin: EdgeInsets
                                                                      .all(isTablet
                                                                          ? 9
                                                                          : 6),
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          isTablet
                                                                              ? 23
                                                                              : 20,
                                                                      vertical:
                                                                          isTablet
                                                                              ? 6
                                                                              : 4),
                                                                  child: Text(
                                                                    "No",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize: isTablet
                                                                            ? 18
                                                                            : 15),
                                                                  ),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  Get.back();
                                                                  deleteAccount();
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              buttonColor),
                                                                      borderRadius:
                                                                          BorderRadius.circular(isTablet
                                                                              ? 5
                                                                              : 3),
                                                                      color:
                                                                          buttonColor),
                                                                  margin: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          isTablet
                                                                              ? 9
                                                                              : 6),
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          isTablet
                                                                              ? 24
                                                                              : 20,
                                                                      vertical:
                                                                          isTablet
                                                                              ? 8
                                                                              : 5),
                                                                  child: Text(
                                                                    "Yes",
                                                                    style: TextStyle(
                                                                        fontSize: isTablet
                                                                            ? 17
                                                                            : 15,
                                                                        color: Colors
                                                                            .white),
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
                                          child: profileTile(
                                            image: 'assets/icons/delete.png',
                                            name: 'Delete Account',
                                            context: context,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 14 : 12),
                                  InkWell(
                                    onTap: () async => await logout(),
                                    //   },
                                    //async => await logout(),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          gradient: horizontalGradient),
                                      child: profileTile(
                                        name: "Log out",
                                        image: 'assets/icons/logout.png',
                                        context: context,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() => con.deleteLoader.value
                      ? Container(
                          color: Colors.grey.withOpacity(0.4),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox()),
                ],
              ),
            ),
          ));
  }

  Widget profileTile({required String image, required String name, context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white10,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            image,
            fit: BoxFit.cover,
            height: isTablet ? 24 : 20,
            width: isTablet ? 24 : 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              fontSize: isTablet ? 15 : 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        name == "Log out"
            ? const SizedBox()
            : Icon(
                Icons.arrow_forward_ios,
                size: isTablet ? 16 : 14,
              ),
      ],
    );
  }
}
