import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:puthagam/screen/dashboard/profile/purchase_list/purchase_list_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';

class PurchaseListScreen extends StatelessWidget {
  PurchaseListScreen({Key? key}) : super(key: key);

  final PurchaseListController con = Get.put(PurchaseListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 20 : 16,
                  vertical: isTablet ? 10 : 5,
                ),
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
                            "Transaction history",
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
            Expanded(
              child: Obx(
                () => con.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: con.purchaseList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.transactionDetailsScreen,
                                arguments: [con.purchaseList[index]],
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: verticalGradient,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${con.purchaseList[index].planName} subscription",
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 17,
                                            color: commonBlueColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Transaction date : ${DateFormat('dd-MMM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(con.purchaseList[index].createdAt * 1000))}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "Amount : ${con.purchaseList[index].currency.toString().toLowerCase() == "inr" || con.purchaseList[index].currency.toString().toLowerCase() == "" ? "Rs." : '\$'} ${con.purchaseList[index].amount.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "Order ID : ${con.purchaseList[index].id}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "Payment Status : ${con.purchaseList[index].currentEnd != null ? "Purchased" : "Cancelled"}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
