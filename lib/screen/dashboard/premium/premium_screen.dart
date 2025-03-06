import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:puthagam/data/api/profile/get_payment_url_api.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/model/book_detail/get_subscription_model.dart';
import 'package:puthagam/screen/dashboard/premium/premium_controller.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';

import '../../paymentscreen/payemntscreen.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final PremiumController con = Get.put(PremiumController());

  String sub1Id = 'com.puthagam.month';
  String sub2Id = 'com.puthagam.six_months';
  String sub3Id = 'com.puthagam.yearly';
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final List<ProductDetails> _products = <ProductDetails>[];
  bool loading = true;
  List<String> _notFoundIds = <String>[];

  List<String> subList = [
    'com.puthagam.month',
    'com.puthagam.six_months',
    'com.puthagam.yearly'
  ];

  late StreamSubscription _subscription;

  Future<void> initStoreInfo() async {
    loading = true;

    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _notFoundIds = <String>[];
        loading = false;
      });
      return;
    }

    Set<String> monthProduct = <String>{sub1Id};
    Set<String> sixMonthProduct = <String>{sub2Id};
    Set<String> yearlyProduct = <String>{sub3Id};

    subList.asMap().forEach((key, value) async {
      final ProductDetailsResponse productDetailResponse =
          await _inAppPurchase.queryProductDetails(key == 0
              ? monthProduct
              : key == 1
                  ? sixMonthProduct
                  : yearlyProduct);

      setState(() {
        if (productDetailResponse.error != null) {
          setState(() {
            for (var element in productDetailResponse.notFoundIDs) {
              if (!_notFoundIds.contains(element)) {
                _notFoundIds.add(element);
              }
            }
          });
          return;
        } else {
          if (productDetailResponse.productDetails.isNotEmpty) {
            _products.addAll(productDetailResponse.productDetails);
          }
        }
      });
    });
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///Step: 1
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object e) {
      debugPrint("error :${e.toString()}");
    });

    initStoreInfo();
  }

  _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        ///Step: 1, case:1
        ///
        debugPrint("Show pending ui");
        // showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          ///Step: 1, case:2
          debugPrint(purchaseDetails.error!.toString());
          // handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          ///Step: 1, case:3
          verifyAndDeliverProduct(purchaseDetails);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> verifyAndDeliverProduct(PurchaseDetails purchaseDetails) async {
    con.paymentDoneApi();
    debugPrint(purchaseDetails.toString());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(gradient: verticalGradient),
          child: Obx(
            () => con.isLoading.value
                ? const Center(child: AppLoader())
                : Stack(
                    children: [
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 20 : 16),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: Get.height * 0.12),
                                Text(
                                  'premiumSub'.tr,
                                  style: TextStyle(
                                    fontSize: isTablet ? 30 : 26,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: isTablet ? 29 : 25),
                                SizedBox(
                                  height: isTablet ? 140 : 120,
                                  child: Image.asset(
                                    'assets/images/Artwork.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Container(
                                  width: 351,
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/checkmark.png',
                                            height: isTablet ? 25 : 22,
                                            width: isTablet ? 25 : 22,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Unlimited access',
                                            style: TextStyle(
                                              fontSize: isTablet ? 16 : 14,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/checkmark.png',
                                            height: isTablet ? 26 : 22,
                                            width: isTablet ? 26 : 22,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Personalized home',
                                            style: TextStyle(
                                              fontSize: isTablet ? 16 : 14,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/checkmark.png',
                                            height: isTablet ? 26 : 22,
                                            width: isTablet ? 26 : 22,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Prioritized support',
                                            style: TextStyle(
                                              fontSize: isTablet ? 16 : 14,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 28),
                                // baseController!.isTried.value
                                //     ? const SizedBox()
                                //     : baseController!.isBetaVersion.value
                                //         ? const SizedBox()
                                //         : Align(
                                //             alignment: Alignment.centerLeft,
                                //             child: Text(
                                //               "Choose a trial plan to start your ${con.trialDays.value} days free trial!",
                                //               style: TextStyle(
                                //                 fontSize: isTablet ? 17 : 15,
                                //               ),
                                //             ),
                                //           ),
                                // const SizedBox(height: 12),
                                Obx(
                                  () => con.applyCoupon.value
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 6),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          con.couponCode.value,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        const Text(" applied"),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(con.isAmount.value
                                                        ? "${con.codeDiscount.value.toStringAsFixed(2)} off on Yearly Subscription"
                                                        : "${con.codeDiscount.value.toStringAsFixed(2)}% off on Yearly Subscription")
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  con.codeDiscount.value = 0.0;
                                                  con.couponCode.value = "";
                                                  con.applyCoupon.value = false;
                                                  con.showCouponText.value =
                                                      false;
                                                },
                                                child: const Text(
                                                  "Remove",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : con.showCouponText.value
                                          ? IntrinsicHeight(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(50),
                                                  ),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Center(
                                                          child: TextFormField(
                                                            textAlign: TextAlign
                                                                .center,
                                                            controller: con
                                                                .couponController
                                                                .value,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  "Enter code here",
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    textColor,
                                                                fontSize:
                                                                    isTablet
                                                                        ? 16
                                                                        : 15,
                                                              ),
                                                            ),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: isTablet
                                                                  ? 18
                                                                  : 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 6),
                                                        child: VerticalDivider(
                                                          width: 1,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          con.applyCouponApi();
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Icon(
                                                            Icons
                                                                .subdirectory_arrow_left,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                const Text("Do you have a "),
                                                GestureDetector(
                                                  onTap: () {
                                                    con.couponController.value
                                                        .clear();
                                                    con.showCouponText.value =
                                                        true;
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
                                                      "Coupon code?",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                              ],
                                            ),
                                ),
                                const SizedBox(height: 16),

                                ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: con.subscriptionList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                               final paymentdata = con.subscriptionList[index];
                                    return InkWell(
                                      onTap: () {
                                        // Get.toNamed(AppRoutes.phonepeScreen);
                                           Get.toNamed(AppRoutes.paymentPage, arguments: [
             
                                            con.subscriptionList[index]
                                               ]);
                                    
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        padding: EdgeInsets.symmetric(
                                            vertical: con
                                                        .subscriptionList[index]
                                                        .item!
                                                        .name ==
                                                    "Yearly"
                                                ? 4
                                                : 14,
                                            horizontal: 12),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                            border: Border.all(
                                              color: baseController!
                                                          .lastPlanId.value ==
                                                      con
                                                          .subscriptionList[
                                                              index]
                                                          .id
                                                  ? Colors.white
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                            gradient: horizontalGradient),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      con
                                                                  .subscriptionList[
                                                                      index]
                                                                  .item!
                                                                  .name ==
                                                              "Yearly"
                                                          ? "Annual"
                                                          : con
                                                                      .subscriptionList[
                                                                          index]
                                                                      .item!
                                                                      .name ==
                                                                  "6 Month Plan"
                                                              ? "Six months"
                                                              : con
                                                                      .subscriptionList[
                                                                          index]
                                                                      .item!
                                                                      .name ??
                                                                  "",
                                                      style: TextStyle(
                                                        fontSize:
                                                            isTablet ? 21 : 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  flex: 2,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Column(
                                                      children: [
                                                        con.subscriptionList[index]
                                                                    .item!.name ==
                                                                "Yearly"
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            2),
                                                                child: Text(
                                                                  con.subscriptionList[index].item!
                                                                              .currency!
                                                                              .toLowerCase()
                                                                              .trim() ==
                                                                          "inr"
                                                                      ? "₹ ${(con.subscriptionList[index].originalAmt).toStringAsFixed(2)}"
                                                                      : "\$ ${(con.subscriptionList[index].originalAmt).toStringAsFixed(2)}",
                                                                  style:
                                                                      TextStyle(
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        isTablet
                                                                            ? 20
                                                                            : 18,
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                        Obx(
                                                          () => Text(
                                                            con
                                                                        .subscriptionList[
                                                                            index]
                                                                        .item!
                                                                        .currency!
                                                                        .toLowerCase()
                                                                        .trim() ==
                                                                    "inr"
                                                                ? con
                                                                            .subscriptionList[
                                                                                index]
                                                                            .item!
                                                                            .name ==
                                                                        "Yearly"
                                                                    ? con.isAmount
                                                                            .value
                                                                        ? "₹ ${(double.parse(con.subscriptionList[index].item!.amount.toString()) - double.parse(con.codeDiscount.value.toString())).toStringAsFixed(2)}"
                                                                        : "₹ ${(double.parse(con.subscriptionList[index].item!.amount.toString()) - ((double.parse(con.subscriptionList[index].item!.amount.toString()) * con.codeDiscount.value) / 100)).toStringAsFixed(2)}"
                                                                    : "₹ ${(double.parse(con.subscriptionList[index].item!.amount.toString())).toStringAsFixed(2)}"
                                                                : con
                                                                            .subscriptionList[
                                                                                index]
                                                                            .item!
                                                                            .name ==
                                                                        "Yearly"
                                                                    ? con.isAmount
                                                                            .value
                                                                        ? "\$ ${(double.parse(con.subscriptionList[index].item!.amount.toString()) - (double.parse(con.codeDiscount.value.toString()))).toStringAsFixed(2)}"
                                                                        : "\$ ${(double.parse(con.subscriptionList[index].item!.amount.toString()) - ((double.parse(con.subscriptionList[index].item!.amount.toString()) * con.codeDiscount.value) / 100)).toStringAsFixed(2)}"
                                                                    : "\$ ${(double.parse(con.subscriptionList[index].item!.amount.toString())).toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: isTablet
                                                                  ? 20
                                                                  : 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 65,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_outlined),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                      Obx(
                        () => con.showLoading.value
                            ? Container(
                                color: Colors.grey.withOpacity(0.3),
                                child: const Center(child: AppLoader()),
                              )
                            : const SizedBox(height: 0, width: 0),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  ProductDetails? findProductDetail(String id) {
    for (ProductDetails pd in _products) {
      if (pd.id == id) return pd;
    }
    return null;
  }

  buySubscription(ProductDetails productDetails) async {
    Plan? abc;
    if (productDetails.title
            .replaceAll('(Magic 20 தமிழ்)', '')
            .toLowerCase()
            .trim() ==
        "monthly") {
      abc = con.subscriptionList.firstWhere(
          (p0) => p0.period == "monthly" && p0.interval.toString() == "1");
    } else if (productDetails.title
            .replaceAll('(Magic 20 தமிழ்)', '')
            .toLowerCase()
            .trim() ==
        "six months") {
      abc = con.subscriptionList.firstWhere(
          (p0) => p0.period == "monthly" && p0.interval.toString() == "6");
    } else if (productDetails.title
            .replaceAll('(Magic 20 தமிழ்)', '')
            .toLowerCase()
            .trim() ==
        "yearly") {
      abc = con.subscriptionList.firstWhere(
          (p0) => p0.period == "yearly" && p0.interval.toString() == "1");
    }

    // yearly

    await getPaymentUrlApi(
        planId: abc!.id, isBeta: false, isTrial: false, fromPlay: true);
    if (con.planId.value.isNotEmpty) {
      ///Step: 3
      late PurchaseParam purchaseParam;

      ///IOS handling
      purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null,
      );

      ///buying Subscription
      _inAppPurchase
          .buyNonConsumable(purchaseParam: purchaseParam)
          .then((value) {});
    }
  }
}
