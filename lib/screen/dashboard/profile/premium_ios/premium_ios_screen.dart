import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:puthagam/data/api/profile/get_payment_url_api.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/model/book_detail/get_subscription_model.dart';
import 'package:puthagam/screen/dashboard/profile/premium_ios/premium_ios_controller.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/progress_dialog_utils.dart';

class PremiumIosScreen extends StatefulWidget {
  const PremiumIosScreen({Key? key}) : super(key: key);

  @override
  State<PremiumIosScreen> createState() => _PremiumIosScreenState();
}

class _PremiumIosScreenState extends State<PremiumIosScreen> {
  String sub1Id = 'com.puthagam.month';
  String sub2Id = 'com.puthagam.3Months';
  String sub3Id = 'com.puthagam.yearly';
    List<bool> isLoadingList = [];
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final List<ProductDetails> _products = <ProductDetails>[];
  bool loading = true;
   bool isLoading = false; // Add this for the loader
  List<String> _notFoundIds = <String>[];

  PremiumIOSController con = Get.put(PremiumIOSController());

  List<String> subList = [
    'com.puthagam.month',
    'com.puthagam.3Months',
    'com.puthagam.yearly'
  ];

  InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = InAppPurchase
      .instance
      .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();

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

    final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
        _inAppPurchase
            .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());

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
     isLoadingList = List.filled(subList.length, false);

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
        debugPrint("Show pending  pending  pendingui");
                  await _inAppPurchase.completePurchase(purchaseDetails);
        // showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          ///Step: 1, case:2
        debugPrint(purchaseDetails.error!.toString());
           debugPrint("purchase status status");
          // handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
                debugPrint("purchase details bbbbbbbbbbbbbbbbbb");
          ///Step: 1, case:3
          verifyAndDeliverProduct(purchaseDetails);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
            debugPrint("complete purchase  purchase");
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
          child: Stack(
            children: [
              loading == true || _products.length != 3
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                              const SizedBox(height: 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Do you have a "),
                                  GestureDetector(
                                    onTap: () async {
                                      await iosPlatformAddition
                                          .presentCodeRedemptionSheet()
                                          .then((value) {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade500,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Text(
                                        "Coupon code?",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                              ),
                              const SizedBox(height: 12),
                            
                              // ),
                              baseController!.isTried.value
                                  ? const SizedBox()
                                  : baseController!.isBetaVersion.value
                                      ? const SizedBox()
                                      : const SizedBox(height: 12),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: subList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _notFoundIds
                                              .contains(subList[index]) ==
                                          true
                                      ? const SizedBox(height: 0, width: 0)
                                      : 
                                      yearly(index: index);
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
              // Obx(
              //   () => con.showLoading.value
              //       ? Container(
              //           color: Colors.grey.withOpacity(0.3),
              //           child: const Center(child: AppLoader()),
              //         )
              //       : const SizedBox(height: 0, width: 0),
              // ),
            ],
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

 void buySubscription(ProductDetails productDetails, int index) async {
    setState(() {
      isLoadingList[index] = true; // Set loading true only for the tapped subscription
    });

    // Simulate your subscription process here
    Plan? abc;
    if (productDetails.title.toLowerCase().trim() == "monthly") {
      abc = con.subscriptionList.firstWhere(
          (p0) => p0.period == "monthly" && p0.interval.toString() == "1");
    } else if (productDetails.title.toLowerCase().trim() == "3 months") {
      abc = con.subscriptionList.firstWhere(
          (p0) => p0.period == "monthly" && p0.interval.toString() == "3");
    } else if (productDetails.title.toLowerCase().trim() == "annual") {
      abc = con.subscriptionList.firstWhere(
          (p0) => p0.period == "yearly" && p0.interval.toString() == "1");
    }

    // Call your API to get the payment URL
    await getPaymentUrlApi(
        planId: abc!.id, isBeta: false, isTrial: false, fromPlay: false);

    if (con.planId.value.isNotEmpty) {
      late PurchaseParam purchaseParam;

      purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null,
      );

      // Make the purchase
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam).then((_) {
        setState(() {
          isLoadingList[index] = false; // Stop loading for this subscription after purchase
        });
      }).catchError((error) {
        setState(() {
          isLoadingList[index] = false; // Stop loading if there's an error
        });
        debugPrint('Error during purchase: $error');
      });
    } else {
      setState(() {
        isLoadingList[index] = false; // Stop loading if API call fails
      });
    }
  }

  Widget yearly({required int index}) {
    ProductDetails pd = findProductDetail(subList[index])!;
    return InkWell(
      onTap: () {
        buySubscription(pd, index); // Pass index to handle the specific subscription
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
          border: Border.all(
            color: Colors.transparent,
            width: 2,
          ),
          gradient: horizontalGradient,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Subscription details or product information
            Text(
              pd.title, // or any other relevant detail
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Loader or price
            isLoadingList[index] // Check loading state for this specific subscription
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    pd.price, // Show the price if not loading
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
