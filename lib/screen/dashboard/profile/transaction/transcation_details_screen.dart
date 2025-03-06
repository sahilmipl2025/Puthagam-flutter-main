import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:puthagam/model/purchase/get_purchase_list_model.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';

class TransactionDetailsScreen extends StatefulWidget {
  const TransactionDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  PurchaseModel? data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    data = Get.arguments[0];
    setState(() {});
    debugPrint(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(gradient: verticalGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(gradient: verticalGradient),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20 : 16,
                    vertical: isTablet ? 16 : 10),
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
                            'Transaction details',
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 24 : 20),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${data?.planName ?? ""} subscription",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 17,
                          color: commonBlueColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Transaction date: ${data?.createdAt != null ? DateFormat('dd-MMM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(data!.createdAt * 1000)) : ""}",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Amount : ${data?.currency.toString().toLowerCase() == "inr" || data?.currency.toString().toLowerCase() == "" ? "Rs." : '\$'} ${data?.amount.toStringAsFixed(2) ?? "0"}",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Order ID : ${data?.id ?? ""}",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Product details",
                        style: TextStyle(
                          fontSize: 17,
                          color: commonBlueColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Plan type",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            data?.planName ?? "",
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Valid from",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            data?.currentStart != null
                                ? DateFormat('dd-MMM-yyyy').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        data!.currentStart! * 1000))
                                : "-",
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Valid till",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            data?.currentEnd != null
                                ? DateFormat('dd-MMM-yyyy').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        data!.currentEnd! * 1000))
                                : "-",
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Text(
                      //   "Payment Details",
                      //   style: TextStyle(
                      //     fontSize: 17,
                      //     color: commonBlueColor,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      // const SizedBox(height: 15),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: const [
                      //     Text(
                      //       "Transaction Method",
                      //       style: TextStyle(
                      //         fontSize: 15,
                      //       ),
                      //     ),
                      //     Text(
                      //       "UPI",
                      //       style: TextStyle(
                      //         fontSize: 15,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: const [
                      //     Text(
                      //       "Payment Status",
                      //       style: TextStyle(
                      //         fontSize: 15,
                      //       ),
                      //     ),
                      //     Text(
                      //       "Success",
                      //       style: TextStyle(
                      //         fontSize: 15,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: const [
                      //     Text(
                      //       "Auto-renewal",
                      //       style: TextStyle(
                      //         fontSize: 15,
                      //       ),
                      //     ),
                      //     Text(
                      //       "No",
                      //       style: TextStyle(
                      //         fontSize: 15,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
