

import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:puthagam/data/api/profile/get_payment_url_api.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/model/book_detail/get_subscription_model.dart';
import 'package:puthagam/screen/dashboard/premium/premium_controller.dart';
import 'package:puthagam/screen/paymentscreen/payemntscreen_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:puthagam/utils/progress_dialog_utils.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:upi_india/upi_india.dart';
import 'package:http/http.dart' as http;
import '../../data/api/profile/get_profile_api.dart';
import '../../data/handler/api_handler.dart';
import '../../data/handler/api_url.dart';
import '../../utils/local_storage/local_storage.dart';
import '../dashboard/profile/premium_ios/premium_ios_controller.dart';
import '../dashboard/profile/profile_page/profile_controller.dart';


class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final PremiumController con = Get.put(PremiumController());
  final PayemntStripeController con1 = Get.put(PayemntStripeController());
  String getidforstripe ='pm_1OwHGJSAreHXvlwhiBYovar6';
  String paymentMethodId ='';
  String? signaturvalue = '';
 String customerId = '';
  String getcallbackurlvalue = "";
  String getsubscriptionid = '';
  bool firstPress = true;
 bool isPaymentSheetOpen = false;
  String  getamount = "";
   Map<String, dynamic>? paymentIntent;
    String? subscriptionid = "";

  Map<String, dynamic>? paymentIntentData;
  Future<UpiResponse>? _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

void refreshTransactionId() {
  print("subscriptionid fir se: $subscriptionid"); // Check the value here
  setState(() {
    transactionId = transactionId = "tran_" + subscriptionid.toString();
    // subscriptionid.toString() + DateTime.now().microsecondsSinceEpoch.toString();
    print("transactionIdsubs: $transactionId");
  });
}
//  void refreshTransactionId() {
//     setState(() {
//       transactionId = "txn" + DateTime.now().microsecondsSinceEpoch.toString();
//     });
//   }
 

  TextStyle value = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
  final arguments = Get.arguments;
  bool isSelected = false;
  String receivedamount = "";
  String environment = "PRODUCTION";
  String transactionId = "";
  String appId = "183414a8199a4048938db1081e8cb5a1";
  String merchantId = "MAGIC20ONLINE";
  bool enableLogging = true;
  String checksum = "";
  String saltkey = "657dc828-07d8-44ab-a40c-c4386274d4e8";
  String saltIndex = "1";
   String receivedCallbackurl = "";
  // "https://api.magic20.co.in/SubscriptionPlan/83a2031d-82a4-4a8a-9f5b-79d22e31ca1f/UpdatePPSubscriptionPayment/sub_NqlXJ3HQq06YOHnxFE9Aaw";

 String body = "";
 String apiEndPoint = "/pg/v1/pay";

  Object? result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      transactionId = "tran_" + subscriptionid.toString();
      print("transitionidinit k andr${subscriptionid.toString()}");
    print("transitionidinit k andr${ transactionId.toString()}");
   
    refreshTransactionId();
    phonepeInit();
   //  startPGTransaction();
    // getcountrydata();
   // body = getChecksum().toString();
   // phonepeInit();

    // phonepeInit();
    if (arguments != null && arguments is List<Plan>) {
      List<Plan> subscriptionList = arguments;
      // Now you have access to the subscriptionList passed from the previous screen
      // Use subscriptionList as needed in your UI or logic
      // ...
    }
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
  }

  
  
  getPaymentUrlApi1({
    planId,
    required bool isTrial,
    required bool isBeta,
    required bool fromPlay,
    String? coupon = "",
  }) async {
    ProfileController profileCon = Get.put(ProfileController());
    PremiumController con = Get.put(PremiumController());
    PremiumIOSController iosCon = Get.put(PremiumIOSController());

    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          con.showLoading.value = true;
          profileCon.deleteLoader.value = true;

          http.Response response = await ApiHandler.post(
              url: '${ApiUrls.baseUrl}SubscriptionPlan/SubscriptionPlan',
              body: {
                "userId": LocalStorage.userId,
                "subscriptionPlanId": isTrial
                    ? 'TRIAL'
                    : isBeta
                        ? 'BETA'
                        : planId,
                "paymentGatewayType": isTrial
                    ? 'TRIAL'
                    : isBeta
                        ? 'BETA'
                        : Platform.isIOS || fromPlay
                            ? 'AP'
                            : 'PP',
                "couponCode": coupon,
                "timeZone": 0,
              });
          var decoded = jsonDecode(response.body);

          con.showLoading.value = false;
          if (decoded['callBackUrl'].toString() != "null") {
            receivedCallbackurl = decoded['callBackUrl'].toString();
            receivedamount = decoded['amount'].toString();
            subscriptionid = decoded['id'].toString();
            
             transactionId = "tran_" + subscriptionid.toString();
             // subscriptionid.toString() + DateTime.now().microsecondsSinceEpoch.toString();
              if (transactionId.length > 38) {
      transactionId = transactionId.substring(0, 38);
    }
             print("subscriptionid${subscriptionid.toString()}");
            body = getChecksum().toString();
             print("printbodychecksum${getChecksum().toString()}");
            phonepeInit();
            print("phonepeforcheckurl${decoded['callBackUrl'].toString()}");
          //  ProgressDialogUtils.showProgressDialog();
          //  startPGTransaction();                             //sahil
           // ProgressDialogUtils.hideProgressDialog();
            //getUserProfileApi();
           //  print("printbodychecksum${startPGTransaction()}");
          }
         
        }
      } else {
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      con.showLoading.value = false;
      // toast(e.toString(), false);
    } finally {
      con.showLoading.value = false;
      profileCon.deleteLoader.value = false;
    }
  }
  
  void phonepeInit() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void handleError(error) {
    setState(() {
      result = {"errorhhhhhhh": error};
      // TODO: implement setState
    });
  }

  // void startPGTransaction() async {
  //   try {
  //          ProgressDialogUtils.showProgressDialog();
  //     Future<String?> string_signature =
  //         PhonePePaymentSdk.getPackageSignatureForAndroid()
  //             .then((value) => signaturvalue = value);
  //     print("signaturevalue   ${signaturvalue.toString()}");

  //     var response = PhonePePaymentSdk.startPGTransaction(
  //         body, receivedCallbackurl, checksum, {}, apiEndPoint, "");
  //     response
  //         .then((val) => {
  //               setState(()  {
  //                 print("response  ${response}");
  //                 print("pgtransactionbody  ${body}");
  //                 print("pgtransaction callbackurl    ${receivedCallbackurl}");
  //                 print("pgtransaction  checksum      ${checksum}");
  //                 print("pgtransaction apiendpoint  ${ apiEndPoint}");
                
  //                 //result = val;
  //                 if (val != null) {
  //                   String status = val['status'].toString();
  //                   String error = val['error'].toString();
  //                   if (status == 'SUCCESS') {
  //                      print("pgtransaction999999${response}");
  //                   // ProgressDialogUtils.hideProgressDialog();
  //                       getUserProfileApi();
  //                 Get.back();
  //                  Get.back();
  //                  ProgressDialogUtils.hideProgressDialog();
  //                 print("gdhfvgfvgvgdhc${getUserProfileApi()}");
                      
  //                       // sucess payment 
  //                     print("pgtransactioN after api ${response}");
  //                     result = "Flow complete - status: SUCCES";
  //                     //checkStatus();
  //                   } else {
  //                     result =
  //                         "Flow complete - status: $status and error$error";
  //                     print("pgtransaction333333");
  //                     ProgressDialogUtils.hideProgressDialog();
  //                   }
  //                 } else {
  //                   ProgressDialogUtils.hideProgressDialog();
  //                   result = "Flow Incomplete";
  //                 }
  //               })
  //             })
  //         .catchError((error) {
  //       handleError(error);
  //       return <dynamic>{};
  //     });
  //   } catch (error) {
  //     ProgressDialogUtils.hideProgressDialog();
  //     handleError(error);
  //   }
  // }

  

  getChecksum() {
    print(
        "DateTime${"txn" + DateTime.now().microsecondsSinceEpoch.toString()}");
  
    final requestdata = {
      "merchantId": merchantId,
      "merchantTransactionId": transactionId,
      "merchantUserId": "magic20.co.in",
      "amount": calculateAmount(receivedamount),
      //receivedamount,
      "mobileNumber": "9999999999",
      "isProduction": true,
      "callbackUrl": receivedCallbackurl,
      "paymentInstrument": {
        "type": "PAY_PAGE",
        "targetApp": "com.app.puthagam"
      },
    };

    String base64Body = base64.encode(utf8.encode(json.encode(requestdata)));
    checksum =
        '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltkey)).toString()}###$saltIndex';
    return base64Body;
  }
  //   RxList<Plan> con.subscriptionList = <Plan>[].obs;

  //   late Plan con.subscriptionList;

  bool isSelectedPhonePe = false;
  bool isSelectedRazorpay = false;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //decoration: BoxDecoration(gradient: verticalGradient),
          title: Container(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                //  signaturvalue.toString(),
                "Select Payment Method",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              )),
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: verticalGradient),
          ),
        ),
        body: Container(
            alignment: Alignment.center,
            height: Get.height,
            decoration: BoxDecoration(gradient: verticalGradient),
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
                //  crossAxisAlignment: CrossAxisAlignment.center,
                //  mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  70.heightBox,

                  baseController!.currentcountryone.value == "india"
                  
                      //toString() == "India"
                      ? InkWell(
                          onTap: () {
                            
                    refreshTransactionId();
                            if (Get.arguments != null &&
                                Get.arguments is List<Plan>) {
                              List<Plan> arguments = Get.arguments;

                              // Display the length of the arguments
                              print('Arguments length: ${arguments.length}');

                              // Assuming 'index' is a valid index within the arguments list
                              int index =
                                  0; // Replace this with your actual index value
                              if (index >= 0 && index < arguments.length) {
                                // Access the planId from the specific index in arguments list
                                String planId = arguments[index].id ?? '';

                                // Call getPaymentUrlApi with the retrieved planId
                                getPaymentUrlApi1(
                                  fromPlay: false,
                                  planId: planId,
                                  isTrial: false,
                                  isBeta: false,
                                  coupon: con.couponCode.value,
                                  
                                );
                              ProgressDialogUtils.showProgressDialog();
                              } else {
                              //  ProgressDialogUtils.hideProgressDialog();
                                // Handle the case where the index is out of bounds
                                print('Invalid index');
                              }
                            } else {
                               // ProgressDialogUtils.hideProgressDialog();
                              // Handle the case where arguments are null or not of the expected type
                              print('Invalid arguments');
                            }
                          },
                          child: Container(
                            height: 180,
                            width: 360,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 2,
                                color: isSelectedPhonePe
                                    ? Colors.white
                                    : Colors
                                        .transparent, // Change color based on isSelected state
                              ),
                              gradient: horizontalGradient,
                              //  gradient: isSelected ? horizontalGradient : null, // Apply gradient if selected
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        "UPI",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      padding: EdgeInsets.only(
                                          left: 20, top: 12, bottom: 7),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey,
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.white,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.asset(
                                                "assets/images/IBN.png"),
                                          ),
                                        ),
                                        Text("iMobile Pay",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            )).paddingOnly(top: 15)
                                      ],
                                    ).paddingOnly(left: 30, right: 20, top: 20),
                                    Column(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.white,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.asset(
                                                "assets/images/goole-pay.png"),
                                          ),
                                        ),
                                        Text("GPay",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            )).paddingOnly(top: 15)
                                      ],
                                    ).paddingOnly(left: 10, right: 20, top: 20),
                                    Column(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 20,
                                          // backgroundColor: Colors.white,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.asset(
                                                "assets/images/phonepe-icon.png"),
                                          ),
                                        ),
                                        Text("PhonePe",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            )).paddingOnly(top: 15)
                                      ],
                                    ).paddingOnly(left: 10, right: 20, top: 20),
                                    Column(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.white,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.asset(
                                                "assets/images/Pay.png"),
                                          ),
                                        ),
                                        Text("Paytm",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            )).paddingOnly(top: 15)
                                      ],
                                    ).paddingOnly(left: 20, right: 20, top: 20),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      :
                      // SizedBox(),
                      InkWell(
                          onTap: () {
                            if (Get.arguments != null &&
                                Get.arguments is List<Plan>) {
                              List<Plan> arguments = Get.arguments;

                              // Display the length of the arguments
                              print(
                                  'Arguments length stripe: ${arguments.length}');

                              // Assuming 'index' is a valid index within the arguments list
                              int index =
                                  0; // Replace this with your actual index value
                              if (index >= 0 && index < arguments.length) {
                                // Access the planId from the specific index in arguments list
                                String planId = arguments[index].id ?? '';

                                //        firstPress ?    LinearProgressIndicator()
                                // :
                                //  print("printontap${getcallbackurlvalue}");
                                // Call getPaymentUrlApi with the retrieved planId
                                //   if(firstPress==true){
                                getPaymentUrlApiStripe(
                                  fromPlay: false,
                                  planId: planId,
                                  isTrial: false,
                                  isBeta: false,
                                  coupon: con.couponCode.value,
                                );
                                 ProgressDialogUtils.showProgressDialog();

                                //   }else{
                                //     Center(
                                //   child: CircularProgressIndicator(),
                                // );
                                // }
                              } else {
                                ProgressDialogUtils.hideProgressDialog();
                                // Handle the case where the index is out of bounds
                                print('Invalid index');
                              }
                            } else {
                              // Handle the case where arguments are null or not of the expected type
                              print('Invalid arguments');
                            }

                            // async {
                            //  await makePayment();
                          },
                          child: Container(
                              height: 150,
                              width: 360,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  width: 2,
                                  color: isSelectedRazorpay
                                      ? Colors.white
                                      : Colors.transparent,
                                  // Change color based on isSelected state
                                ),
                                gradient:
                                    horizontalGradient, // Apply gradient if selected
                              ),
                              child: Column(
                                  // crossAxisAlignment:
                                  //     CrossAxisAlignment.center,
                                  children: [
                                    //  Padding(padding:EdgeInsets.only(left: 30)),
                                    Row(children: [
                                      Container(
                                          child: Text(
                                            "Stripe",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 20, top: 12, bottom: 7)),
                                    ]),
                                    Divider(color: Colors.grey),
                                 
                                    Container(
                                        child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 60.0,
                                          width: 60.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/visa.png"),
                                              fit: BoxFit.fill,
                                            ),
                                            //shape: BoxShape.circle,
                                          ),
                                        ).paddingOnly(left: 15, right: 15),
                                        Container(
                                          height: 60.0,
                                          width: 60.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/masterCard.png"),
                                              fit: BoxFit.fill,
                                            ),
                                            //shape: BoxShape.circle,
                                          ),
                                        ).paddingOnly(left: 0, right: 15),
                                        Container(
                                          height: 45.0,
                                          width: 60.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/amex.png"),
                                              fit: BoxFit.fill,
                                            ),
                                            //shape: BoxShape.circle,
                                          ),
                                        ).paddingOnly(left: 0, right: 15),
                                        Container(
                                          height: 60.0,
                                          width: 60.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/discover.png"),
                                              fit: BoxFit.fill,
                                            ),
                                            //shape: BoxShape.circle,
                                          ),
                                        ).paddingOnly(left: 0, right: 15),
                                      ],
                                    ).paddingOnly(left: 20, right: 20, top: 12))
                                  ])),
                        ),

                  40.heightBox,
                  // currentCountry.value = country.toLowerCase();
                  //  baseController!.currentCountry.value.toLowerCase() == "india" ?
                  InkWell(
                    onTap: () {
                      isSelectedRazorpay = true;
                      isSelectedPhonePe = false;

                      if (Get.arguments != null &&
                          Get.arguments is List<Plan>) {
                        List<Plan> arguments = Get.arguments;

                        // Display the length of the arguments
                        print('Arguments length: ${arguments.length}');

                        // Assuming 'index' is a valid index within the arguments list
                        int index =
                            0; // Replace this with your actual index value
                        if (index >= 0 && index < arguments.length) {
                          // Access the planId from the specific index in arguments list
                          String planId = arguments[index].id ?? '';

                          // Call getPaymentUrlApi with the retrieved planId
                          getPaymentUrlApi(
                            fromPlay: false,
                            planId: planId,
                            isTrial: false,
                            isBeta: false,
                            coupon: con.couponCode.value,
                          );
                        } else {
                          // Handle the case where the index is out of bounds
                          print('Invalid index');
                        }
                      } else {
                        // Handle the case where arguments are null or not of the expected type
                        print('Invalid arguments');
                      }
                    },
                    child: Container(
                        height: 150,
                        width: 360,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 2,
                            color: isSelectedRazorpay
                                ? Colors.white
                                : Colors.transparent,
                            // Change color based on isSelected state
                          ),
                          gradient:
                              horizontalGradient, // Apply gradient if selected
                        ),
                        child: Column(
                            // crossAxisAlignment:
                            //     CrossAxisAlignment.center,
                            children: [
                              //  Padding(padding:EdgeInsets.only(left: 30)),
                              Row(children: [
                                baseController!.currentcountryone.value ==
                                        "india"
                                    ?
                                    // .// baseController!.currentcountryone.value == "India" ?
                                    Container(
                                        child: Text(
                                          "Card / Net Banking / Wallets",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                            left: 20, top: 12, bottom: 7))
                                    : Container(
                                        child: Text("Razorpay",
                                          //"Paypal",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                            left: 20, top: 12, bottom: 7)),
                              ]),
                              Divider(color: Colors.grey),
                              ListTile(
                                leading: CircleAvatar(
                                    radius: (22),
                                    backgroundColor: Colors.white,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                          "assets/images/razorpay.com.png"),
                                    )),
                                title:     baseController!.currentcountryone.value ==
                                        "india"
                                    ?
                                Text(
                                  'Razorpay',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ):Text(
                                  "Paypal",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  'Pay Via Credit/Debit Card',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                ),
                              ),
                            ])),
                  ),
                  40.heightBox,
                  // currentCountry.value = country.toLowerCase();
                  //  baseController!.currentCountry.value.toLowerCase() == "india"
                  // ? SizedBox()
                  // :
                ])));
  }

  payFee() {
    try {
      //if you want to upload data to any database do it here
    } catch (e) {
      // exception while uploading data
    }
  }

    Future<void> makePayment() async {
    try {
      
     // String customerName = 'Jenny Rosen';
      // String customerEmail = 'jenny.rosen@example.com';
       String customerAddressLine1 = '510 Townsend St';
    //  String customerPostalCode = '98140';
      // String customerCity = 'San Francisco';
      // String customerState = 'CA';
     String customerCountry = 'US';

      // Create a customer in Stripe
      var customerData = {
        'name': LocalStorage.userName.toString(),
        'email':  LocalStorage.userEmail.toString(),
        'address[line1]': customerAddressLine1,
        //'address[postal_code]': customerPostalCode,
        // 'address[city]': customerCity,
        // 'address[state]': customerState,
       'address[country]': customerCountry,
      };
      var customerResponse = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers'),
        headers: {
          
          'Authorization': 
          'Bearer ${dotenv.env['STRIPE_SECRET']}',
          //sk_test_51OA471SAreHXvlwhHCIbGBQhRs1s2KM5sJsZaNd5V40D6RTspiaVwMPruWyU45Lvvd101znzsrtLxZDsiIAsy8AW00ySJHS6Uw',
          // ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: Uri(queryParameters: customerData).query,
      );
      if (customerResponse.statusCode != 200) {
        print("responseof customer${result.toString()}");
        throw 'Failed to create customer: ${customerResponse.statusCode}';
      }
      var customer = jsonDecode(customerResponse.body);
     customerId = customer['id'];

      // Create payment intent
      paymentIntent = await createPaymentIntent('10', 'USD', customerId);
      // ignore: unused_local_variable
    // var paymentMethod = await createPaymentMethod(number: '4242424242424242', expMonth: '03', expYear: '23', cvc: '123');

      
      // Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                
                  
               
                  style: ThemeMode.dark,
                  
                  merchantDisplayName: 'Your Merchant Name'),
                
                 
                  
                )
          .then((value) {});  
  // displayPaymentSheet();
      // Display payment sheet
     if (!isPaymentSheetOpen) {
      isPaymentSheetOpen = true; // Set the flag to indicate that payment sheet is now open
      await displayPaymentSheet();
       ProgressDialogUtils.hideProgressDialog();
    }
  //   displayPaymentSheet();
   
    } catch (e, s) {
      print('Exception: $e\nStack Trace: $s');
    }
  }

   displayPaymentSheet() async {
   try {
    // Set isPaymentSheetOpen to true before presenting payment sheet
    isPaymentSheetOpen = true;
    
    await Stripe.instance.presentPaymentSheet().then((newValue) {
      // Handle successful payment
      paymentDoneStripApi();
    
      payFee();
  //  number,
  // required String expMonth,
  // required String expYear,
  // required String cvc,
      isPaymentSheetOpen = false;
      
      print("displayPaymentSheet then called");
      
      // Clear paymentIntent variable after successful payment
      paymentIntentData = null;
    }).onError((error, stackTrace) {
      // Handle errors during payment
      print('Error during payment: $error');
      if (kDebugMode) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      }
      
      // Set isPaymentSheetOpen to false if an error occurs
      isPaymentSheetOpen = false;
    });
  } on StripeException catch (e) {
    // Handle Stripe exceptions
    print('Stripe exception occurred: $e');
    if (kDebugMode) {
      print(e);
    }
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        content: Text("Payment cancelled."),
      ),
    );
    print('Popup closed');
    
    // Set isPaymentSheetOpen to false if a Stripe exception occurs
    isPaymentSheetOpen = false;
  } catch (e) {
    // Handle other exceptions
    print('Exception occurred: $e');
    if (kDebugMode) {
      print('$e');
    }
    
    // Set isPaymentSheetOpen to false if any other exception occurs
    isPaymentSheetOpen = false;
  }
}


  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency, String customerId) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(getamount.toString()),
        'currency': currency,
        'payment_method_types[]': 'card',
        'description':"Magic Tamil Payment",
        'customer': customerId,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':'Bearer ${dotenv.env['STRIPE_SECRET']}', 
          //sk_test_51OA471SAreHXvlwhHCIbGBQhRs1s2KM5sJsZaNd5V40D6RTspiaVwMPruWyU45Lvvd101znzsrtLxZDsiIAsy8AW00ySJHS6Uw',
          //${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      if (response.statusCode != 200) {
        throw 'Failed to create payment intent: ${response.statusCode}';
      }
    
      print("customerresponse${response.body}");
      
      return jsonDecode(response.body);
    } catch (err) {
      print('Error creating payment intent: $err');
      rethrow;
    }
  }

 Future<Map<String, dynamic>> getPaymentMethod(getPaymentMethod) async {
  final String url = 'https://api.stripe.com/v1/payment_methods/pm_1OwHGJSAreHXvlwhiBYovar6';
  
  // Replace 'YOUR_STRIPE_SECRET_KEY' with your actual secret key
 
  
  // Set up headers for authentication
  Map<String, String> headers = {
      'Authorization':'Bearer  sk_test_51OA471SAreHXvlwhHCIbGBQhRs1s2KM5sJsZaNd5V40D6RTspiaVwMPruWyU45Lvvd101znzsrtLxZDsiIAsy8AW00ySJHS6Uw',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  // Make the GET request to retrieve the payment method
  var response = await http.get(Uri.parse(url), headers: headers);

  // Check response status code
  if (response.statusCode == 200) {
    // Decode and return the response body
    return json.decode(response.body);
  } else {
    // Print error message and throw an exception
    print(json.decode(response.body));
    throw 'Failed to retrieve PaymentMethod.';
  }
}



 

//     Future<void> makePayment() async {
//     try {
      
//      // String customerName = 'Jenny Rosen';
//       // String customerEmail = 'jenny.rosen@example.com';
//        String customerAddressLine1 = '510 Townsend St';
//     //  String customerPostalCode = '98140';
//       // String customerCity = 'San Francisco';
//       // String customerState = 'CA';
//      String customerCountry = 'US';

//       // Create a customer in Stripe
//       var customerData = {
//         'name': LocalStorage.userName.toString(),
//         'email':  LocalStorage.userEmail.toString(),
//         'address[line1]': customerAddressLine1,
//         //'address[postal_code]': customerPostalCode,
//         // 'address[city]': customerCity,
//         // 'address[state]': customerState,
//        'address[country]': customerCountry,
//       };
//       var customerResponse = await http.post(
//         Uri.parse('https://api.stripe.com/v1/customers'),
//         headers: {
          
//           'Authorization': 
//           'Bearer sk_test_51OA471SAreHXvlwhHCIbGBQhRs1s2KM5sJsZaNd5V40D6RTspiaVwMPruWyU45Lvvd101znzsrtLxZDsiIAsy8AW00ySJHS6Uw',
//           // ${dotenv.env['STRIPE_SECRET']}',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: Uri(queryParameters: customerData).query,
//       );
//       if (customerResponse.statusCode != 200) {
//         print("responseof customer${result.toString()}");
//         throw 'Failed to create customer: ${customerResponse.statusCode}';
//       }
//       var customer = jsonDecode(customerResponse.body);
//      customerId = customer['id'];

//       // Create payment intent
//       paymentIntent = await createPaymentIntent('10', 'USD', customerId);
//       // ignore: unused_local_variable
//     // var paymentMethod = await createPaymentMethod(number: '4242424242424242', expMonth: '03', expYear: '23', cvc: '123');

      
//       // Initialize Payment Sheet
//       await Stripe.instance
//           .initPaymentSheet(
//               paymentSheetParameters: SetupPaymentSheetParameters(
//                   paymentIntentClientSecret: paymentIntent!['client_secret'],
                
                  
               
//                   style: ThemeMode.dark,
                  
//                   merchantDisplayName: 'Your Merchant Name'),
                
                 
                  
//                 )
//           .then((value) {});  
//   // displayPaymentSheet();
//       // Display payment sheet
//      if (!isPaymentSheetOpen) {
//       isPaymentSheetOpen = true; // Set the flag to indicate that payment sheet is now open
//       await displayPaymentSheet();
//        ProgressDialogUtils.hideProgressDialog();
//     }
//   //   displayPaymentSheet();
   
//     } catch (e, s) {
//       print('Exception: $e\nStack Trace: $s');
//     }
//   }

//    displayPaymentSheet() async {
//    try {
//     // Set isPaymentSheetOpen to true before presenting payment sheet
//     isPaymentSheetOpen = true;
    
//     await Stripe.instance.presentPaymentSheet().then((newValue) {
//       // Handle successful payment
//       paymentDoneStripApi();
    
//       payFee();
//   //  number,
//   // required String expMonth,
//   // required String expYear,
//   // required String cvc,
//       isPaymentSheetOpen = false;
      
//       print("displayPaymentSheet then called");
      
//       // Clear paymentIntent variable after successful payment
//       paymentIntentData = null;
//     }).onError((error, stackTrace) {
//       // Handle errors during payment
//       print('Error during payment: $error');
//       if (kDebugMode) {
//         print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
//       }
      
//       // Set isPaymentSheetOpen to false if an error occurs
//       isPaymentSheetOpen = false;
//     });
//   } on StripeException catch (e) {
//     // Handle Stripe exceptions
//     print('Stripe exception occurred: $e');
//     if (kDebugMode) {
//       print(e);
//     }
//     showDialog(
//       context: context,
//       builder: (_) => const AlertDialog(
//         content: Text("Payment cancelled."),
//       ),
//     );
//     print('Popup closed');
    
//     // Set isPaymentSheetOpen to false if a Stripe exception occurs
//     isPaymentSheetOpen = false;
//   } catch (e) {
//     // Handle other exceptions
//     print('Exception occurred: $e');
//     if (kDebugMode) {
//       print('$e');
//     }
    
//     // Set isPaymentSheetOpen to false if any other exception occurs
//     isPaymentSheetOpen = false;
//   }
// }


//   Future<Map<String, dynamic>> createPaymentIntent(
//       String amount, String currency, String customerId) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': calculateAmount(getamount.toString()),
//         'currency': currency,
//         'payment_method_types[]': 'card',
//         'description':"Magic Tamil Payment",
//         'customer': customerId,
//       };

//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization':'Bearer  sk_test_51OA471SAreHXvlwhHCIbGBQhRs1s2KM5sJsZaNd5V40D6RTspiaVwMPruWyU45Lvvd101znzsrtLxZDsiIAsy8AW00ySJHS6Uw',
//           //${dotenv.env['STRIPE_SECRET']}',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       if (response.statusCode != 200) {
//         throw 'Failed to create payment intent: ${response.statusCode}';
//       }
    
//       print("customerresponse${response.body}");
      
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('Error creating payment intent: $err');
//       rethrow;
//     }
//   }

//  Future<Map<String, dynamic>> getPaymentMethod(getPaymentMethod) async {
//   final String url = 'https://api.stripe.com/v1/payment_methods/pm_1OwHGJSAreHXvlwhiBYovar6';
  
//   // Replace 'YOUR_STRIPE_SECRET_KEY' with your actual secret key
 
  
//   // Set up headers for authentication
//   Map<String, String> headers = {
//       'Authorization':'Bearer  sk_test_51OA471SAreHXvlwhHCIbGBQhRs1s2KM5sJsZaNd5V40D6RTspiaVwMPruWyU45Lvvd101znzsrtLxZDsiIAsy8AW00ySJHS6Uw',
//     'Content-Type': 'application/x-www-form-urlencoded',
//   };

//   // Make the GET request to retrieve the payment method
//   var response = await http.get(Uri.parse(url), headers: headers);

//   // Check response status code
//   if (response.statusCode == 200) {
//     // Decode and return the response body
//     return json.decode(response.body);
//   } else {
//     // Print error message and throw an exception
//     print(json.decode(response.body));
//     throw 'Failed to retrieve PaymentMethod.';
//   }
// }



 



Future<Map<String, dynamic>> createSubscription(String customerId) async {
  try {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/subscriptions'),
      headers: {
        'Authorization': 'Bearer sk_test_51OA471SAreHXvlwhHCIbGBQhRs1s2KM5sJsZaNd5V40D6RTspiaVwMPruWyU45Lvvd101znzsrtLxZDsiIAsy8AW00ySJHS6Uw',
        'Content-Type': 'application/json',
      },
      body: json.encode({

        'customer': customerId,
        'items[0][price]':'price_1OuYw5SAreHXvlwhmoz2PT6O'
    
      }),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      print("resultcreateSubscription $responseBody");
      return responseBody;
    } else {
      final errorMessage = responseBody['error']['message'];
      throw 'Failed to register as a subscriber: $errorMessage';
    }
  } catch (e) {
    print('Error creating subscription: $e');
    
    rethrow;
  }
}





  paymentDoneStripApi() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();

      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          print("planidforstripe${getsubscriptionid.toString()}");
          http.Response response = await ApiHandler.get(
              url:
                  '${ApiUrls.baseUrl}SubscriptionPlan/${LocalStorage.userId.toString()}/UpdateSPSubscriptionPayment/${getsubscriptionid.toString()}');

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            await getUserProfileApi();
            print("getprofile${getUserProfileApi()}");
            Get.back();
            Get.back();
           createSubscription(customerId.toString());
       //  getPaymentMethod(getidforstripe);
            print("finalcustomerid${customerId.toString()}");
            // print("getpaymentmethod id    ${getidforstripe.toString()}");
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            Get.offAllNamed(AppRoutes.loginScreen);
            var decoded = jsonDecode(response.body);
            toast(decoded['status']['message'], false);
          } else {
            var decoded = jsonDecode(response.body);
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      //   isLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  calculateAmount(String amount) {
    num a = (num.parse(amount)) * 100;
   a = a.toInt();
    print("calculateamount${a}");
    return a.toString();
  }


  //  calculateAmount(String amount) {
  //   final a = (num.parse(amount)) * 100;
    
  //   print("calculateamount${a}");
  //   return a.toString();
  // }

  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps!.length == 0)
      return InkWell(
        onTap: () {
          // startPGTransaction();                        //sahil
        },
        child: Center(
          child: Container(
            padding: EdgeInsets.only(
              top: 40,
            ),
            child: Text("No apps found to handle transaction.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                )),
          ),
        ),
      );
    else
      // ignore: curly_braces_in_flow_control_structures
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  //   _transaction = initiateTransaction(app);
                  setState(() {
                    //  isSelectedPhonePe = true;
                    //  isSelectedRazorpay = false;
                   // startPGTransaction();           // sahil
                  });
                },
                // ignore: sized_box_for_whitespace
                child: Container(
                  height: 100,
                  width: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 30,
                        width: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                        ),
                      ),
                      Text(
                        app.name,
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }

  getPaymentUrlApiStripe({
    planId,
    required bool isTrial,
    required bool isBeta,
    required bool fromPlay,
    String? coupon = "",
  }) async {
    ProfileController profileCon = Get.put(ProfileController());
    PremiumController con = Get.put(PremiumController());
    PremiumIOSController iosCon = Get.put(PremiumIOSController());

    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          con.showLoading.value = true;
          profileCon.deleteLoader.value = true;

          http.Response response = await ApiHandler.post(
              url: '${ApiUrls.baseUrl}SubscriptionPlan/SubscriptionPlan',
              body: {
                "userId": LocalStorage.userId,
                "subscriptionPlanId": isTrial
                    ? 'TRIAL'
                    : isBeta
                        ? 'BETA'
                        : planId,
                "paymentGatewayType": isTrial
                    ? 'TRIAL'
                    : isBeta
                        ? 'BETA'
                        : Platform.isIOS || fromPlay
                            ? 'AP'
                            : 'SP',
                "couponCode": coupon,
                "timeZone": 0,
              });
          var decoded = jsonDecode(response.body);

          con.showLoading.value = false;
          if (decoded['id'].toString() != "null") {
            // receivedCallbackurl = decoded['callBackUrl'].toString();
            // receivedamount = decoded['originalAmount'].toString();
            // body = getChecksum().toString();
            // phonepeInit();
            getsubscriptionid = decoded['id'].toString();
            getamount = decoded['amount'].toString();
            print("phonepeforcheckurl${decoded['id'].toString()}");

          makePayment();
          
            // startPGTransaction();
          }

        }
      } else {
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      con.showLoading.value = false;
      // toast(e.toString(), false);
    } finally {
      con.showLoading.value = false;
      profileCon.deleteLoader.value = false;
    }
  }

 
}


//ignore_for_file: prefer_const_constructors

// import 'dart:convert';
// import 'dart:core';
// import 'dart:io';

// import 'package:connectivity/connectivity.dart';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:get/get.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
// import 'package:puthagam/data/api/profile/get_payment_url_api.dart';
// import 'package:puthagam/main.dart';
// import 'package:puthagam/model/book_detail/get_subscription_model.dart';
// import 'package:puthagam/screen/dashboard/premium/premium_controller.dart';
// import 'package:puthagam/screen/paymentscreen/payemntscreen_controller.dart';
// import 'package:puthagam/utils/app_routes.dart';
// import 'package:puthagam/utils/app_snackbar.dart';
// import 'package:puthagam/utils/colors.dart';
// import 'package:puthagam/utils/network_info.dart';
// import 'package:puthagam/utils/progress_dialog_utils.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:velocity_x/velocity_x.dart';
// import 'package:upi_india/upi_india.dart';
// import 'package:http/http.dart' as http;
// import '../../data/api/profile/get_profile_api.dart';
// import '../../data/handler/api_handler.dart';
// import '../../data/handler/api_url.dart';
// import '../../utils/local_storage/local_storage.dart';
// import '../dashboard/profile/premium_ios/premium_ios_controller.dart';
// import '../dashboard/profile/profile_page/profile_controller.dart';


// class PaymentPage extends StatefulWidget {
//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   final PremiumController con = Get.put(PremiumController());
//   final PayemntStripeController con1 = Get.put(PayemntStripeController());
//   String getidforstripe ='pm_1OwHGJSAreHXvlwhiBYovar6';
//   String paymentMethodId ='';
  
//   String? signaturvalue = '';
//  String customerId = '';
//   String getcallbackurlvalue = "";
//   String getsubscriptionid = '';
//   bool firstPress = true;
//  bool isPaymentSheetOpen = false;
//   String  getamount = "";
//    Map<String, dynamic>? paymentIntent;
//  String transactionId = '';
//   Map<String, dynamic>? paymentIntentData;
//   Future<UpiResponse>? _transaction;
//   UpiIndia _upiIndia = UpiIndia();
//   List<UpiApp>? apps;

//   TextStyle header = TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.bold,
//   );

//  void refreshTransactionId() {
//     setState(() {
//       transactionId = "txn" + DateTime.now().microsecondsSinceEpoch.toString();
//     });
//   }
 

//   TextStyle value = TextStyle(
//     fontWeight: FontWeight.w400,
//     fontSize: 14,
//   );
//   final arguments = Get.arguments;
//   bool isSelected = false;
 
//  String body = "";
//  String apiEndPoint = "/v3/recurring/subscription/create";

//   Object? result;

//   @override
//   void initState() {
//     refreshTransactionId();
//     // TODO: implement initState
//     super.initState();
//     //refreshTransactionId();
//    // phonepeInit();
//    //  startPGTransaction();
//     // getcountrydata();
//    // body = getChecksum().toString();
//    // phonepeInit();

//     // phonepeInit();
//     if (arguments != null && arguments is List<Plan>) {
//       List<Plan> subscriptionList = arguments;
//       // Now you have access to the subscriptionList passed from the previous screen
//       // Use subscriptionList as needed in your UI or logic
//       // ...
//     }
//     _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
//       setState(() {
//         apps = value;
//       });
//     }).catchError((e) {
//       apps = [];
//     });
//   }

  
  
//  getPaymentUrlApi1({
//     planId,
//     required bool isTrial,
//     required bool isBeta,
//     required bool fromPlay,
//     String? coupon = "",
//   }) async {
//     ProfileController profileCon = Get.put(ProfileController());
//     PremiumController con = Get.put(PremiumController());
//     PremiumIOSController iosCon = Get.put(PremiumIOSController());

//     try {
//       bool connection =
//           await NetworkInfo(connectivity: Connectivity()).isConnected();
//       if (connection) {
//         await LocalStorage.getData();
//         if (LocalStorage.token.toString() != "null" &&
//             LocalStorage.token.toString().isNotEmpty &&
//             LocalStorage.userId.toString() != "null" &&
//             LocalStorage.userId.toString().isNotEmpty) {
//           con.showLoading.value = true;
//           profileCon.deleteLoader.value = true;

//           http.Response response = await ApiHandler.post(
//               url: '${ApiUrls.baseUrl}SubscriptionPlan/SubscriptionPlan',
//               body: {
//                 "userId": LocalStorage.userId,
//                 "subscriptionPlanId": isTrial
//                     ? 'TRIAL'
//                     : isBeta
//                         ? 'BETA'
//                         : planId,
//                 "paymentGatewayType": isTrial
//                     ? 'TRIAL'
//                     : isBeta
//                         ? 'BETA'
//                         : Platform.isIOS || fromPlay
//                             ? 'AP'
//                             : 'PP',
//                 "couponCode": coupon,
//                 "timeZone": 0,
//               });
//           var decoded = jsonDecode(response.body);

//           con.showLoading.value = false;
//           if (decoded['callBackUrl'].toString() != "null") {
//            // receivedCallbackurl = decoded['callBackUrl'].toString();
//            // receivedamount = decoded['amount'].toString();
           
//          //   body = getChecksum().toString();
//            //  print("printbodychecksum${getChecksum().toString()}");
//            //   runNetworking();R
//              //createUserSubscription();
//            // phonepeInit();
//             print("phonepeforcheckurl${decoded['callBackUrl'].toString()}");
//           //  ProgressDialogUtils.showProgressDialog();
//          //   startPGTransaction();
//            // ProgressDialogUtils.hideProgressDialog();
//             //getUserProfileApi();
//            //  print("printbodychecksum${startPGTransaction()}");
//           }
         
//         }
//       } else {
//         toast("No Internet Connection!", false);
//       }
//     } catch (e) {
//       con.showLoading.value = false;
//       // toast(e.toString(), false);
//     } finally {
//       con.showLoading.value = false;
//       profileCon.deleteLoader.value = false;
//     }
//   }

  
//   // void phonepeInit() {
//   //   PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
//   //       .then((val) => {
//   //             setState(() {
//   //               result = 'PhonePe SDK Initialized - $val';
//   //             })
//   //           })
//   //       .catchError((error) {
//   //     handleError(error);
//   //     return <dynamic>{};
//   //   });
//   // }

//   void handleError(error) {
//     setState(() {
//       result = {"errorhhhhhhh": error};
//       // TODO: implement setState
//     });
//   }

// final  usersubscriptionid = "".obs;
// final notificationIdrecurring = "".obs;
// final submitauthrequesturl = "".obs;

// void usersubscriptionstatus() {
//   String merchantId = "PGTESTPAYUAT"; // Update with your merchant ID
//   String merchantSubscriptionId = "MSUB123456789012345"; // Update with your subscription ID
//   String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399"; // Update with your salt key
//   int saltIndex = 1;

//   String apiUrl = "https://api-preprod.phonepe.com/apis/pg-sandbox/v3/recurring/subscription/status/$merchantId/$merchantSubscriptionId";
//   print("subscriptionstatus${apiUrl}");
//   String xVerifyHeader = calculateXVerifyHeader(merchantId, merchantSubscriptionId, saltKey, saltIndex);
//   print("headersubscriptionstatus                  ${xVerifyHeader.toString()}");
//    print("merchantiddd                  ${merchantSubscriptionId.toString()}");
//   Map<String, String> headers = {
//     HttpHeaders.contentTypeHeader: "application/json",
//     "X-VERIFY": xVerifyHeader,
//   };

//   http.get(
//     Uri.parse(apiUrl),
//     headers: headers,
//   ).then((http.Response response) {
//     if (response.statusCode == 200) {
//       Map<String, dynamic> responseData = jsonDecode(response.body);
//       print("subscriptionstatus");
//        print("after2000${result}");
//       // Process responseData as needed
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//        print('Request failed with status: ${result}.');
//     }
//   }).catchError((error) {
//     print('Error: $error');
//   });
// }

// String calculateXVerifyHeader(String merchantId, String merchantSubscriptionId, String saltKey, int saltIndex) {

//   String payloadWithEndpoint = "/v3/recurring/subscription/status/$merchantId/$merchantSubscriptionId+$saltKey";
//   String checksum = sha256.convert(utf8.encode(payloadWithEndpoint)).toString();
// print("checksumfor subscriptionstatus       ${payloadWithEndpoint.toString()}");
// print("checksumforyyyyyyyyyyyjjj      $checksum###$saltIndex");
//   return "$checksum###$saltIndex";
// }




// void runNetworking() {

  
//   String mobileNumber = "9999999999";
//   String saltKey = "657dc828-07d8-44ab-a40c-c4386274d4e8";
//   int saltIndex = 1;

//   Map<String, dynamic> payload = {
 
//    "merchantId": "MAGIC20ONLINE",
//   "merchantSubscriptionId":transactionId.toString(),
//   "merchantUserId": "MU123456789",
//   "authWorkflowType": "PENNY_DROP",		  //PENNY_DROP or TRANSACTION
//   "amountType": "FIXED",		          //FIXED or VARIABLE
//   "amount": 120,
//   "frequency": "MONTHLY",
//   "recurringCount": 12,
//   "mobileNumber": "919453003734",
//   "deviceContext": {
//   "phonePeVersionCode": 400922		         //Only for ANDROID 
//   }
 
//   };

  
// print("transitionidforcreatesubscription${transactionId.toString()}");
//   String base64Payload = base64Encode(utf8.encode(jsonEncode(payload)));
// // print("checkalllstatus777777${merchantId}");
//   String xVerifyHeader = calculateXVerifyHeader1(base64Payload, saltKey, saltIndex);

//   Map<String, String> headers = {
//     HttpHeaders.contentTypeHeader: "application/json",
//     "X-VERIFY": xVerifyHeader,
//   };

//   String apiUrl = "https://mercury-t2.phonepe.com/v3/recurring/subscription/create";


//   http.post(
//     Uri.parse(apiUrl),
//     headers: headers,
//     body: jsonEncode({"request": base64Payload}),
    
//   ).then((http.Response response) {
    
//     if (response.statusCode == 200) {
    
   
//       Map<String, dynamic> responseData = jsonDecode(response.body);
     
       
//        print("afterpayment555");
//       if (responseData.containsKey("data")) {
//         print("firttttt${responseData.containsKey("data")}");
//          print("afterpayment8888888888");
//         Map<String, dynamic> data = responseData["data"];
//         print("paymenetsucessfull for subscription ${responseData["data"]}");
//          usersubscriptionid.value  = responseData["data"]["subscriptionId"].toString();
//            print("usersubscriptionid${responseData["data"]["subscriptionId"].toString()}");
        
//          recurringsubscription();
//         // submitauthrequest();
//          // response["subscriptionId"];
//         if (data.containsKey("instrumentResponse")) {
//           Map<String, dynamic> instrumentResponse = data["instrumentResponse"];
//           if (instrumentResponse.containsKey("redirectInfo")) {
//             String redirectUrl = instrumentResponse["redirectInfo"]["url"];
//          // usersubscriptionid.value = jsonDecode(usersubscriptionid.toString());
//       //print("getsubscripttion${jsonDecode( instrumentResponse["redirectInfo"]["url"])}");
        
//             launch(redirectUrl); // Launch the URL in a web browser
//              print("firttttt            ${redirectUrl}");
//             print("finasllypayment");
//             // ignore: unrelated_type_equality_checks
            
//          }
//        }
//       }
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//        print('Request failed with status: ${response.body}.');
//     }
//   }).catchError((error) {
//     print('Error: $error');
//   });
// }




// String calculateXVerifyHeader1(String base64Payload, String saltKey, int saltIndex) {
//   String payloadWithEndpoint = "$base64Payload/v3/recurring/subscription/create$saltKey";
//   String checksum = sha256.convert(utf8.encode(payloadWithEndpoint)).toString();
//   return "$checksum###$saltIndex";
// }







// void recurringsubscription() {
//   String saltKey = "657dc828-07d8-44ab-a40c-c4386274d4e8";
//   int saltIndex = 1;

//   Map<String, dynamic> payload = {
//     "merchantId": "MAGIC20ONLINE",
//     "merchantUserId": "MU123456789",
//     "subscriptionId": usersubscriptionid.toString(),
//     "transactionId": transactionId.toString(),
//     "autoDebit": true,
//     "amount": 39900
//   };

//   print("recurringsubscription: ${usersubscriptionid.toString()}");
//   print("transitionidforcreatesubscription: ${payload.toString()}");

//   String base64Payload = base64Encode(utf8.encode(jsonEncode(payload)));
//   String xVerifyHeader = calculateXVerifyHeader2(base64Payload, saltKey, saltIndex);

//   Map<String, String> headers = {
//     HttpHeaders.contentTypeHeader: "application/json",
//     "X-VERIFY": xVerifyHeader,
//   };

//   String apiUrl = "https://mercury-t2.phonepe.com/v3/recurring/debit/init";

//   http.post(
//     Uri.parse(apiUrl),
//     headers: headers,
//     body: jsonEncode({"request": base64Payload}),
//   ).then((http.Response response) {
//     if (response.statusCode == 200) {
//       Map<String, dynamic> responseData = jsonDecode(response.body);
//       print("afterpayment: ${responseData.toString()}");

//       if (responseData.containsKey("data")) {
//         print("firttttt: ${responseData.containsKey("data")}");
//         print("afterpayment8888888888");
//         Map<String, dynamic> data = responseData["data"];
//         print("recurringinit: ${responseData["data"]}");
//         notificationIdrecurring.value = responseData["data"]["notificationId"].toString();
//         print("notificationId: ${responseData["data"]["notificationId"].toString()}");
//         recurringdebitexecute();

//         if (data.containsKey("instrumentResponse")) {
//           Map<String, dynamic> instrumentResponse = data["instrumentResponse"];
//           if (instrumentResponse.containsKey("redirectInfo")) {
//             String redirectUrl = instrumentResponse["redirectInfo"]["url"];
//             launch(redirectUrl); // Launch the URL in a web browser
//             print("firttttt: ${redirectUrl}");
//             print("finasllypayment");
//           }
//         }
//       }
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//       print('Response body: ${response.body}.');
//     }
//   }).catchError((error) {
//     print('Error: $error');
//   });
// }

// String calculateXVerifyHeader2(String base64Payload, String saltKey, int saltIndex) {
//   String payloadWithEndpoint = "$base64Payload/v3/recurring/debit/init$saltKey";
//   String checksum = sha256.convert(utf8.encode(payloadWithEndpoint)).toString();
//   return "$checksum###$saltIndex";
// }


//  void submitauthrequest() {

  
//   String saltKey = "657dc828-07d8-44ab-a40c-c4386274d4e8";
//   int saltIndex = 1;

//   Map<String, dynamic> payload = {
  
//   "merchantId": "MAGIC20ONLINE",
//   "merchantUserId": "MU123456789",
//   "subscriptionId": usersubscriptionid.toString(),
//    "authRequestId":transactionId.toString(),
//     "paymentInstrument": {
//       "type": "UPI_INTENT",
//       "targetApp": "com.phonepe.app"
//     },
//     "deviceContext" : {
//     "deviceOS" : "ANDROID"
//     }
  
//   };

//   print("recurringsubscription${usersubscriptionid.toString()}");
// print("submit auth  ${transactionId.toString()}");
//   String base64Payload = base64Encode(utf8.encode(jsonEncode(payload)));
// // print("checkalllstatus777777${merchantId}");
//   String xVerifyHeader = calculateXVerifyHeader4(base64Payload, saltKey, saltIndex);

//   Map<String, String> headers = {
//     HttpHeaders.contentTypeHeader: "application/json",
//     "X-VERIFY": xVerifyHeader,
//   };

//   String apiUrl = "https://mercury-t2.phonepe.com/v3/recurring/auth/init";


//   http.post(
//     Uri.parse(apiUrl),
//     headers: headers,
//     body: jsonEncode({"request": base64Payload}),
    
//   ).then((http.Response response) {
    
//     if (response.statusCode == 200) {
    
   
//       Map<String, dynamic> responseData = jsonDecode(response.body);
     
       
//        print("afterpayment555");
//       if (responseData.containsKey("data")) {
//         print("firttttt${responseData.containsKey("data")}");
//          print("afterpayment8888888888");
//         Map<String, dynamic> data = responseData["data"];
//         print("recurringinit ${responseData["data"]}");
//          submitauthrequesturl.value  = responseData["data"]["redirectUrl"].toString();
//            print("submitauthrequesturl${responseData["data"]["redirectUrl"].toString()}");
         
//          // response["subscriptionId"];
//         if (data.containsKey("instrumentResponse")) {
//           Map<String, dynamic> instrumentResponse = data["instrumentResponse"];
//           if (instrumentResponse.containsKey("redirectInfo")) {
//             String redirectUrl = instrumentResponse["redirectInfo"]["url"];
//           //   usersubscriptionid.value = jsonDecode(usersubscriptionid.toString());
//       //print("getsubscripttion${jsonDecode( instrumentResponse["redirectInfo"]["url"])}");
        
//             launch(redirectUrl); // Launch the URL in a web browser
//              print("firttttt            ${redirectUrl}");
//             print("finasllypayment");
//             // ignore: unrelated_type_equality_checks
            
//          }
//        }
//       }
//     } else {
//       print('Request failed with status  submitauthrequest: ${response.statusCode}.');
//        print('Request failed with status  submitauthrequest: ${response.body}.');
//     }
//   }).catchError((error) {
//     print('Error: $error');
//   });
// }




// String calculateXVerifyHeader4(String base64Payload, String saltKey, int saltIndex) {
//   String payloadWithEndpoint = "$base64Payload/v3/recurring/auth/init$saltKey";
//   String checksum = sha256.convert(utf8.encode(payloadWithEndpoint)).toString();
//   return "$checksum###$saltIndex";
// }



// void recurringdebitexecute() {

  
//   String mobileNumber = "9999999999";
//   String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
//   int saltIndex = 1;

//   Map<String, dynamic> payload = {
   
//    "merchantId": "PGTESTPAYUAT",
   
//   "merchantUserId": "MU123456789",
//   "subscriptionId": usersubscriptionid.toString(),
//   "notificationId": notificationIdrecurring.toString(),
//     "transactionId":transactionId.toString(),
//   };

//   print("notificationIdrecurring${notificationIdrecurring.toString()}");
// print("transitionidforcreatesubscription${transactionId.toString()}");
//   String base64Payload = base64Encode(utf8.encode(jsonEncode(payload)));
// // print("checkalllstatus777777${merchantId}");
//   String xVerifyHeader = calculateXVerifyHeader3(base64Payload, saltKey, saltIndex);

//   Map<String, String> headers = {
//     HttpHeaders.contentTypeHeader: "application/json",
//     "X-VERIFY": xVerifyHeader,
//   };

//   String apiUrl = "https://api-preprod.phonepe.com/apis/pg-sandbox/v3/recurring/debit/execute";

 
//   http.post(
//     Uri.parse(apiUrl),
//     headers: headers,
//     body: jsonEncode({"request": base64Payload}),
    
//   ).then((http.Response response) {
    
//     if (response.statusCode == 200) {
    
   
//       Map<String, dynamic> responseData = jsonDecode(response.body);
     
       
//        print("afterpayment555");
//       if (responseData.containsKey("data")) {
//         print("firttttt${responseData.containsKey("data")}");
//          print("afterpayment8888888888");
//         Map<String, dynamic> data = responseData["data"];
//         print("recurringinit ${responseData["data"]}");
//          notificationIdrecurring.value  = responseData["data"]["notificationId"].toString();
//            print("notificationId${responseData["data"]["notificationId"].toString()}");
//          // submitauthrequest();
//          // response["subscriptionId"];
//         if (data.containsKey("instrumentResponse")) {
//           Map<String, dynamic> instrumentResponse = data["instrumentResponse"];
//           if (instrumentResponse.containsKey("redirectInfo")) {
//             String redirectUrl = instrumentResponse["redirectInfo"]["url"];
             
//           //   usersubscriptionid.value = jsonDecode(usersubscriptionid.toString());
      
//          }
//        }
//       }
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//     }
//   }).catchError((error) {
//     print('Error: $error');
//   });
// }




// String calculateXVerifyHeader3(String base64Payload, String saltKey, int saltIndex) {
//   String payloadWithEndpoint = "$base64Payload/v3/recurring/debit/execute$saltKey";
//   String checksum = sha256.convert(utf8.encode(payloadWithEndpoint)).toString();
//   return "$checksum###$saltIndex";
// }

//   // void startPGTransaction() async {
//   //   try {
//   //     Future<String?> string_signature =
//   //         PhonePePaymentSdk.getPackageSignatureForAndroid()
//   //             .then((value) => signaturvalue = value);
//   //     print("signaturevalue   ${signaturvalue.toString()}");

//   //     var response = PhonePePaymentSdk.startPGTransaction(
//   //         body, receivedCallbackurl, checksum, {}, apiEndPoint, "");
//   //     response
//   //         .then((val) => {
//   //               setState(()  {
//   //                 print("response  ${response}");
//   //                 print("pgtransactionbody  ${body}");
//   //                 print("pgtransaction callbackurl    ${receivedCallbackurl}");
//   //                 print("pgtransaction  checksum      ${checksum}");
//   //                 print("pgtransaction apiendpoint  ${ apiEndPoint}");
                
//   //                 //result = val;
//   //                 if (val != null) {
//   //                   String status = val['status'].toString();
//   //                   String error = val['error'].toString();
//   //                   if (status == 'SUCCESS') {
//   //                      print("pgtransaction999999${response}");
//   //                   // ProgressDialogUtils.hideProgressDialog();
//   //                       getUserProfileApi();
//   //                 Get.back();
//   //                  Get.back();
//   //                  ProgressDialogUtils.hideProgressDialog();
//   //                 print("gdhfvgfvgvgdhc${getUserProfileApi()}");
                      
//   //                       // sucess payment 
//   //                     print("pgtransactioN after api ${response}");
//   //                     result = "Flow complete - status: SUCCES";
//   //                     //checkStatus();
//   //                   } else {
//   //                     result =
//   //                         "Flow complete - status: $status and error$error";
//   //                     print("pgtransaction333333 ${result}");
//   //                   }
//   //                 } else {
//   //                   result = "Flow Incomplete";
//   //                 }
//   //               })
//   //             })
//   //         .catchError((error) {
//   //       handleError(error);
//   //       return <dynamic>{};
//   //     });
//   //   } catch (error) {
//   //     handleError(error);
//   //   }
//   // }

  

//   // getChecksum() {
//   //   print(
//   //       "DateTime${"txn" + DateTime.now().microsecondsSinceEpoch.toString()}");
  
//   //   final requestdata = {
//   //      "merchantId": merchantId,
//   // "merchantSubscriptionId":  transactionId,
//   // "merchantUserId": "magic20.co.in",
//   // "authWorkflowType": "PENNY_DROP",		  //PENNY_DROP or TRANSACTION
//   // "amountType": "FIXED",		          //FIXED or VARIABLE
//   // "amount": 39900,
//   // "frequency": "MONTHLY",
//   // "recurringCount": 12,
//   // "mobileNumber": "9xxxxxxxxx",
//   // "deviceContext": {
//   // "phonePeVersionCode": 400922		         //Only for ANDROID 
//   // }
//   //     // "merchantId": merchantId,
//   //     // "merchantTransactionId": transactionId,
//   //     // "merchantUserId": "magic20.co.in",
//   //     // "amount": calculateAmount(receivedamount),
//   //     // //receivedamount,
//   //     // "mobileNumber": "9999999999",
//   //     // "isProduction": true,
//   //     // "callbackUrl": receivedCallbackurl,
//   //     // "paymentInstrument": {
//   //     //   "type": "PAY_PAGE",
//   //     //   "targetApp": "com.app.puthagam"
//   //     // },
//   //   };

//   //   String base64Body = base64.encode(utf8.encode(json.encode(requestdata)));
//   //   checksum =
//   //       '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltkey)).toString()}###$saltIndex';
//   //   return base64Body;
//   // }
//   //   RxList<Plan> con.subscriptionList = <Plan>[].obs;

//   //   late Plan con.subscriptionList;

//   bool isSelectedPhonePe = false;
//   bool isSelectedRazorpay = false;
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           //decoration: BoxDecoration(gradient: verticalGradient),
//           title: Container(
//               padding: EdgeInsets.only(left: 30),
//               child: Text(
//                 //  signaturvalue.toString(),
//                 "Select Payment Method",

//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               )),
//           elevation: 0.0,
//           flexibleSpace: Container(
//             decoration: BoxDecoration(gradient: verticalGradient),
//           ),
//         ),
//         body: Container(
//             alignment: Alignment.center,
//             height: Get.height,
//             decoration: BoxDecoration(gradient: verticalGradient),
//             padding: const EdgeInsets.symmetric(horizontal: 0),
//             child: Column(
//                 //  crossAxisAlignment: CrossAxisAlignment.center,
//                 //  mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   70.heightBox,

//                   baseController!.currentcountryone.value == "india"
                  
//                       //toString() == "India"
//                       ? InkWell(
//                           onTap: () {
//                            runNetworking();
                         
//                           //  createUserSubscription();
//                     // refreshTransactionId();
//                     //         if (Get.arguments != null &&
//                     //             Get.arguments is List<Plan>) {
//                     //           List<Plan> arguments = Get.arguments;

//                     //           // Display the length of the arguments
//                     //           print('Arguments length: ${arguments.length}');

//                     //           // Assuming 'index' is a valid index within the arguments list
//                     //           int index =
//                     //               0; // Replace this with your actual index value
//                     //           if (index >= 0 && index < arguments.length) {
//                     //             // Access the planId from the specific index in arguments list
//                     //             String planId = arguments[index].id ?? '';

//                     //             // Call getPaymentUrlApi with the retrieved planId
//                     //             getPaymentUrlApi1(
//                     //               fromPlay: false,
//                     //               planId: planId,
//                     //               isTrial: false,
//                     //               isBeta: false,
//                     //               coupon: con.couponCode.value,
                                  
//                     //             );
//                     //               ProgressDialogUtils.showProgressDialog();
//                     //           } else {
//                     //             // Handle the case where the index is out of bounds
//                     //             print('Invalid index');
//                     //           }
//                     //         } else {
//                     //           // Handle the case where arguments are null or not of the expected type
//                     //           print('Invalid arguments');
//                     //         }
//                           },
//                           child: Container(
//                             height: 180,
//                             width: 360,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               border: Border.all(
//                                 width: 2,
//                                 color: isSelectedPhonePe
//                                     ? Colors.white
//                                     : Colors
//                                         .transparent, // Change color based on isSelected state
//                               ),
//                               gradient: horizontalGradient,
//                               //  gradient: isSelected ? horizontalGradient : null, // Apply gradient if selected
//                             ),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Container(
//                                       child: Text(
//                                         "UPI",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       padding: EdgeInsets.only(
//                                           left: 20, top: 12, bottom: 7),
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(
//                                   color: Colors.grey,
//                                 ),
//                                 Row(
//                                   children: <Widget>[
//                                     Column(
//                                       children: <Widget>[
//                                         CircleAvatar(
//                                           radius: 20,
//                                           backgroundColor: Colors.white,
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(50),
//                                             child: Image.asset(
//                                                 "assets/images/IBN.png"),
//                                           ),
//                                         ),
//                                         Text("iMobile Pay",
//                                             style: TextStyle(
//                                               fontSize: 11,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w500,
//                                             )).paddingOnly(top: 15)
//                                       ],
//                                     ).paddingOnly(left: 30, right: 20, top: 20),
//                                     Column(
//                                       children: <Widget>[
//                                         CircleAvatar(
//                                           radius: 20,
//                                           backgroundColor: Colors.white,
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(50),
//                                             child: Image.asset(
//                                                 "assets/images/goole-pay.png"),
//                                           ),
//                                         ),
//                                         Text("GPay",
//                                             style: TextStyle(
//                                               fontSize: 11,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w500,
//                                             )).paddingOnly(top: 15)
//                                       ],
//                                     ).paddingOnly(left: 10, right: 20, top: 20),
//                                     Column(
//                                       children: <Widget>[
//                                         CircleAvatar(
//                                           radius: 20,
//                                           // backgroundColor: Colors.white,
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(50),
//                                             child: Image.asset(
//                                                 "assets/images/phonepe-icon.png"),
//                                           ),
//                                         ),
//                                         Text("PhonePe",
//                                             style: TextStyle(
//                                               fontSize: 11,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w500,
//                                             )).paddingOnly(top: 15)
//                                       ],
//                                     ).paddingOnly(left: 10, right: 20, top: 20),
//                                     Column(
//                                       children: <Widget>[
//                                         CircleAvatar(
//                                           radius: 20,
//                                           backgroundColor: Colors.white,
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(50),
//                                             child: Image.asset(
//                                                 "assets/images/Pay.png"),
//                                           ),
//                                         ),
//                                         Text("Paytm",
//                                             style: TextStyle(
//                                               fontSize: 11,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w500,
//                                             )).paddingOnly(top: 15)
//                                       ],
//                                     ).paddingOnly(left: 20, right: 20, top: 20),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       :
//                       // SizedBox(),
//                       InkWell(
//                           onTap: () {
//                             if (Get.arguments != null &&
//                                 Get.arguments is List<Plan>) {
//                               List<Plan> arguments = Get.arguments;

//                               // Display the length of the arguments
//                               print(
//                                   'Arguments length stripe: ${arguments.length}');

//                               // Assuming 'index' is a valid index within the arguments list
//                               int index =
//                                   0; // Replace this with your actual index value
//                               if (index >= 0 && index < arguments.length) {
//                                 // Access the planId from the specific index in arguments list
//                                 String planId = arguments[index].id ?? '';

//                                 //        firstPress ?    LinearProgressIndicator()
//                                 // :
//                                 //  print("printontap${getcallbackurlvalue}");
//                                 // Call getPaymentUrlApi with the retrieved planId
//                                 //   if(firstPress==true){
//                                 getPaymentUrlApiStripe(
//                                   fromPlay: false,
//                                   planId: planId,
//                                   isTrial: false,
//                                   isBeta: false,
//                                   coupon: con.couponCode.value,
//                                 );
//                                  ProgressDialogUtils.showProgressDialog();

//                                 //   }else{
//                                 //     Center(
//                                 //   child: CircularProgressIndicator(),
//                                 // );
//                                 // }
//                               } else {
//                                 ProgressDialogUtils.hideProgressDialog();
//                                 // Handle the case where the index is out of bounds
//                                 print('Invalid index');
//                               }
//                             } else {
//                               // Handle the case where arguments are null or not of the expected type
//                               print('Invalid arguments');
//                             }

//                             // async {
//                             //  await makePayment();
//                           },
//                           child: Container(
//                               height: 150,
//                               width: 360,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 border: Border.all(
//                                   width: 2,
//                                   color: isSelectedRazorpay
//                                       ? Colors.white
//                                       : Colors.transparent,
//                                   // Change color based on isSelected state
//                                 ),
//                                 gradient:
//                                     horizontalGradient, // Apply gradient if selected
//                               ),
//                               child: Column(
//                                   // crossAxisAlignment:
//                                   //     CrossAxisAlignment.center,
//                                   children: [
//                                     //  Padding(padding:EdgeInsets.only(left: 30)),
//                                     Row(children: [
//                                       Container(
//                                           child: Text(
//                                             "Stripe",
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                           padding: EdgeInsets.only(
//                                               left: 20, top: 12, bottom: 7)),
//                                     ]),
//                                     Divider(color: Colors.grey),
                                 
//                                     Container(
//                                         child: Row(
//                                       children: <Widget>[
//                                         Container(
//                                           height: 60.0,
//                                           width: 60.0,
//                                           decoration: BoxDecoration(
//                                             image: DecorationImage(
//                                               image: AssetImage(
//                                                   "assets/images/visa.png"),
//                                               fit: BoxFit.fill,
//                                             ),
//                                             //shape: BoxShape.circle,
//                                           ),
//                                         ).paddingOnly(left: 15, right: 15),
//                                         Container(
//                                           height: 60.0,
//                                           width: 60.0,
//                                           decoration: BoxDecoration(
//                                             image: DecorationImage(
//                                               image: AssetImage(
//                                                   "assets/images/masterCard.png"),
//                                               fit: BoxFit.fill,
//                                             ),
//                                             //shape: BoxShape.circle,
//                                           ),
//                                         ).paddingOnly(left: 0, right: 15),
//                                         Container(
//                                           height: 45.0,
//                                           width: 60.0,
//                                           decoration: BoxDecoration(
//                                             image: DecorationImage(
//                                               image: AssetImage(
//                                                   "assets/images/amex.png"),
//                                               fit: BoxFit.fill,
//                                             ),
//                                             //shape: BoxShape.circle,
//                                           ),
//                                         ).paddingOnly(left: 0, right: 15),
//                                         Container(
//                                           height: 60.0,
//                                           width: 60.0,
//                                           decoration: BoxDecoration(
//                                             image: DecorationImage(
//                                               image: AssetImage(
//                                                   "assets/images/discover.png"),
//                                               fit: BoxFit.fill,
//                                             ),
//                                             //shape: BoxShape.circle,
//                                           ),
//                                         ).paddingOnly(left: 0, right: 15),
//                                       ],
//                                     ).paddingOnly(left: 20, right: 20, top: 12))
//                                   ])),
//                         ),

//                   40.heightBox,
//                   // currentCountry.value = country.toLowerCase();
//                   //  baseController!.currentCountry.value.toLowerCase() == "india" ?
//                   InkWell(
//                     onTap: () {
//                       isSelectedRazorpay = true;
//                       isSelectedPhonePe = false;

//                       if (Get.arguments != null &&
//                           Get.arguments is List<Plan>) {
//                         List<Plan> arguments = Get.arguments;

//                         // Display the length of the arguments
//                         print('Arguments length: ${arguments.length}');

//                         // Assuming 'index' is a valid index within the arguments list
//                         int index =
//                             0; // Replace this with your actual index value
//                         if (index >= 0 && index < arguments.length) {
//                           // Access the planId from the specific index in arguments list
//                           String planId = arguments[index].id ?? '';

//                           // Call getPaymentUrlApi with the retrieved planId
//                           getPaymentUrlApi(
//                             fromPlay: false,
//                             planId: planId,
//                             isTrial: false,
//                             isBeta: false,
//                             coupon: con.couponCode.value,
//                           );
//                         } else {
//                           // Handle the case where the index is out of bounds
//                           print('Invalid index');
//                         }
//                       } else {
//                         // Handle the case where arguments are null or not of the expected type
//                         print('Invalid arguments');
//                       }
//                     },
//                     child: Container(
//                         height: 150,
//                         width: 360,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           border: Border.all(
//                             width: 2,
//                             color: isSelectedRazorpay
//                                 ? Colors.white
//                                 : Colors.transparent,
//                             // Change color based on isSelected state
//                           ),
//                           gradient:
//                               horizontalGradient, // Apply gradient if selected
//                         ),
//                         child: Column(
//                             // crossAxisAlignment:
//                             //     CrossAxisAlignment.center,
//                             children: [
//                               //  Padding(padding:EdgeInsets.only(left: 30)),
//                               Row(children: [
//                                 baseController!.currentcountryone.value ==
//                                         "india"
//                                     ?
//                                     // .// baseController!.currentcountryone.value == "India" ?
//                                     Container(
//                                         child: Text(
//                                           "Card / Net Banking / Wallets",
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                         padding: EdgeInsets.only(
//                                             left: 20, top: 12, bottom: 7))
//                                     : Container(
//                                         child: Text("Razorpay",
//                                           //"Paypal",
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                         padding: EdgeInsets.only(
//                                             left: 20, top: 12, bottom: 7)),
//                               ]),
//                               Divider(color: Colors.grey),
//                               ListTile(
//                                 leading: CircleAvatar(
//                                     radius: (22),
//                                     backgroundColor: Colors.white,
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(50),
//                                       child: Image.asset(
//                                           "assets/images/razorpay.com.png"),
//                                     )),
//                                 title:     baseController!.currentcountryone.value ==
//                                         "india"
//                                     ?
//                                 Text(
//                                   'Razorpay',
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ):Text(
//                                   "Paypal",
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 subtitle: Text(
//                                   'Pay Via Credit/Debit Card',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 trailing: Icon(
//                                   Icons.arrow_forward_ios,
//                                   size: 18,
//                                 ),
//                               ),
//                             ])),
//                   ),
//                   40.heightBox,
//                   // currentCountry.value = country.toLowerCase();
//                   //  baseController!.currentCountry.value.toLowerCase() == "india"
//                   // ? SizedBox()
//                   // :
//                 ])));
//   }

//   payFee() {
//     try {
//       //if you want to upload data to any database do it here
//     } catch (e) {
//       // exception while uploading data
//     }
//   }

//     Future<void> makePayment() async {
//     try {
      
//      // String customerName = 'Jenny Rosen';
//       // String customerEmail = 'jenny.rosen@example.com';
//        String customerAddressLine1 = '510 Townsend St';
//     //  String customerPostalCode = '98140';
//       // String customerCity = 'San Francisco';
//       // String customerState = 'CA';
//      String customerCountry = 'US';

//       // Create a customer in Stripe
//       var customerData = {
//         'name': LocalStorage.userName.toString(),
//         'email':  LocalStorage.userEmail.toString(),
//         'address[line1]': customerAddressLine1,
//         //'address[postal_code]': customerPostalCode,
//         // 'address[city]': customerCity,
//         // 'address[state]': customerState,
//        'address[country]': customerCountry,
//       };
//       var customerResponse = await http.post(
//         Uri.parse('https://api.stripe.com/v1/customers'),
//         headers: {
          
//           'Authorization': 
//           'Bearer sk_test_51OA471SAreHXvlwhHCIbGBQhRs1s2KM5sJsZaNd5V40D6RTspiaVwMPruWyU45Lvvd101znzsrtLxZDsiIAsy8AW00ySJHS6Uw',
//           // ${dotenv.env['STRIPE_SECRET']}',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: Uri(queryParameters: customerData).query,
//       );
//       if (customerResponse.statusCode != 200) {
//         print("responseof customer${result.toString()}");
//         throw 'Failed to create customer: ${customerResponse.statusCode}';
//       }
//       var customer = jsonDecode(customerResponse.body);
//      customerId = customer['id'];

//       // Create payment intent
//       paymentIntent = await createPaymentIntent('10', 'USD', customerId);
//       // ignore: unused_local_variable
//     // var paymentMethod = await createPaymentMethod(number: '4242424242424242', expMonth: '03', expYear: '23', cvc: '123');

      
//       // Initialize Payment Sheet
//       await Stripe.instance
//           .initPaymentSheet(
//               paymentSheetParameters: SetupPaymentSheetParameters(
//                   paymentIntentClientSecret: paymentIntent!['client_secret'],
                
                  
               
//                   style: ThemeMode.dark,
                  
//                   merchantDisplayName: 'Your Merchant Name'),
                
                 
                  
//                 )
//           .then((value) {});  
//   // displayPaymentSheet();
//       // Display payment sheet
//      if (!isPaymentSheetOpen) {
//       isPaymentSheetOpen = true; // Set the flag to indicate that payment sheet is now open
//       await displayPaymentSheet();
//        ProgressDialogUtils.hideProgressDialog();
//     }
//   //   displayPaymentSheet();
   
//     } catch (e, s) {
//       print('Exception: $e\nStack Trace: $s');
//     }
//   }

//    displayPaymentSheet() async {
//    try {
//     // Set isPaymentSheetOpen to true before presenting payment sheet
//     isPaymentSheetOpen = true;
    
//     await Stripe.instance.presentPaymentSheet().then((newValue) {
//       // Handle successful payment
//       paymentDoneStripApi();
    
//       payFee();
//   //  number,
//   // required String expMonth,
//   // required String expYear,
//   // required String cvc,
//       isPaymentSheetOpen = false;
      
//       print("displayPaymentSheet then called");
      
//       // Clear paymentIntent variable after successful payment
//       paymentIntentData = null;
//     }).onError((error, stackTrace) {
//       // Handle errors during payment
//       print('Error during payment: $error');
//       if (kDebugMode) {
//         print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
//       }
      
//       // Set isPaymentSheetOpen to false if an error occurs
//       isPaymentSheetOpen = false;
//     });
//   } on StripeException catch (e) {
//     // Handle Stripe exceptions
//     print('Stripe exception occurred: $e');
//     if (kDebugMode) {
//       print(e);
//     }
//     showDialog(
//       context: context,
//       builder: (_) => const AlertDialog(
//         content: Text("Payment cancelled."),
//       ),
//     );
//     print('Popup closed');
    
//     // Set isPaymentSheetOpen to false if a Stripe exception occurs
//     isPaymentSheetOpen = false;
//   } catch (e) {
//     // Handle other exceptions
//     print('Exception occurred: $e');
//     if (kDebugMode) {
//       print('$e');
//     }
    
//     // Set isPaymentSheetOpen to false if any other exception occurs
//     isPaymentSheetOpen = false;
//   }
// }


//   Future<Map<String, dynamic>> createPaymentIntent(
//       String amount, String currency, String customerId) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': calculateAmount(getamount.toString()),
//         'currency': currency,
//         'payment_method_types[]': 'card',
//         'description':"Magic Tamil Payment",
//         'customer': customerId,
//       };

//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization':'Bearer  sk_test_51OA471SAreHXvlwhHCIbGBQhRs1s2KM5sJsZaNd5V40D6RTspiaVwMPruWyU45Lvvd101znzsrtLxZDsiIAsy8AW00ySJHS6Uw',
//           //${dotenv.env['STRIPE_SECRET']}',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       if (response.statusCode != 200) {
//         throw 'Failed to create payment intent: ${response.statusCode}';
//       }
    
//       print("customerresponse${response.body}");
      
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('Error creating payment intent: $err');
//       rethrow;
//     }
//   }

//  Future<Map<String, dynamic>> getPaymentMethod(getPaymentMethod) async {
//   final String url = 'https://api.stripe.com/v1/payment_methods/pm_1OwHGJSAreHXvlwhiBYovar6';
  
//   // Replace 'YOUR_STRIPE_SECRET_KEY' with your actual secret key
 
  
//   // Set up headers for authentication
//   Map<String, String> headers = {
//       'Authorization':'Bearer  sk_test_51OA471SAreHXvlwhHCIbGBQhRs1s2KM5sJsZaNd5V40D6RTspiaVwMPruWyU45Lvvd101znzsrtLxZDsiIAsy8AW00ySJHS6Uw',
//     'Content-Type': 'application/x-www-form-urlencoded',
//   };

//   // Make the GET request to retrieve the payment method
//   var response = await http.get(Uri.parse(url), headers: headers);

//   // Check response status code
//   if (response.statusCode == 200) {
//     // Decode and return the response body
//     return json.decode(response.body);
//   } else {
//     // Print error message and throw an exception
//     print(json.decode(response.body));
//     throw 'Failed to retrieve PaymentMethod.';
//   }
// }



 



// Future<Map<String, dynamic>> createSubscription(String customerId) async {
//   try {
//     final response = await http.post(
//       Uri.parse('https://api.stripe.com/v1/subscriptions'),
//       headers: {
//         'Authorization': 'Bearer sk_test_51OA471SAreHXvlwhHCIbGBQhRs1s2KM5sJsZaNd5V40D6RTspiaVwMPruWyU45Lvvd101znzsrtLxZDsiIAsy8AW00ySJHS6Uw',
//         'Content-Type': 'application/json',
//       },
//       body: json.encode({

//         'customer': customerId,
//         'items[0][price]':'price_1OuYw5SAreHXvlwhmoz2PT6O'
    
//       }),
//     );

//     final responseBody = json.decode(response.body);

//     if (response.statusCode == 200) {
//       print("resultcreateSubscription $responseBody");
//       return responseBody;
//     } else {
//       final errorMessage = responseBody['error']['message'];
//       throw 'Failed to register as a subscriber: $errorMessage';
//     }
//   } catch (e) {
//     print('Error creating subscription: $e');
    
//     rethrow;
//   }
// }





//   paymentDoneStripApi() async {
//     try {
//       bool connection =
//           await NetworkInfo(connectivity: Connectivity()).isConnected();

//       if (connection) {
//         await LocalStorage.getData();
//         if (LocalStorage.token.toString() != "null" &&
//             LocalStorage.token.toString().isNotEmpty &&
//             LocalStorage.userId.toString() != "null" &&
//             LocalStorage.userId.toString().isNotEmpty) {
//           print("planidforstripe${getsubscriptionid.toString()}");
//           http.Response response = await ApiHandler.get(
//               url:
//                   '${ApiUrls.baseUrl}SubscriptionPlan/${LocalStorage.userId.toString()}/UpdateSPSubscriptionPayment/${getsubscriptionid.toString()}');

//           if (response.statusCode == 200 ||
//               response.statusCode == 201 ||
//               response.statusCode == 202 ||
//               response.statusCode == 203 ||
//               response.statusCode == 204) {
//             await getUserProfileApi();
//             print("getprofile${getUserProfileApi()}");
//             Get.back();
//             Get.back();
//            createSubscription(customerId.toString());
//        //  getPaymentMethod(getidforstripe);
//             print("finalcustomerid${customerId.toString()}");
//             // print("getpaymentmethod id    ${getidforstripe.toString()}");
//           } else if (response.statusCode == 401) {
//             LocalStorage.clearData();
//             Get.offAllNamed(AppRoutes.loginScreen);
//             var decoded = jsonDecode(response.body);
//             toast(decoded['status']['message'], false);
//           } else {
//             var decoded = jsonDecode(response.body);
//             toast(decoded['status']['message'], false);
//           }
//         }
//       } else {
//         toast("No Internet Connection!", false);
//       }
//     } catch (e) {
//       //   isLoading.value = false;
//       // toast(e.toString(), false);
//     }
//   }

//   calculateAmount(String amount) {
//     num a = (num.parse(amount)) * 100;
//    a = a.toInt();
//     print("calculateamount${a}");
//     return a.toString();
//   }


//   //  calculateAmount(String amount) {
//   //   final a = (num.parse(amount)) * 100;
    
//   //   print("calculateamount${a}");
//   //   return a.toString();
//   // }

//   // Widget displayUpiApps() {
//   //   if (apps == null)
//   //     return Center(child: CircularProgressIndicator());
//   //   else if (apps!.length == 0)
//   //     return InkWell(
//   //       onTap: () {
//   //         startPGTransaction();
//   //       },
//   //       child: Center(
//   //         child: Container(
//   //           padding: EdgeInsets.only(
//   //             top: 40,
//   //           ),
//   //           child: Text("No apps found to handle transaction.",
//   //               style: TextStyle(
//   //                 fontSize: 16,
//   //                 color: Colors.white,
//   //                 fontWeight: FontWeight.w500,
//   //               )),
//   //         ),
//   //       ),
//   //     );
//   //   else
//   //     // ignore: curly_braces_in_flow_control_structures
//   //     return Align(
//   //       alignment: Alignment.topCenter,
//   //       child: SingleChildScrollView(
//   //         physics: BouncingScrollPhysics(),
//   //         child: Wrap(
//   //           children: apps!.map<Widget>((UpiApp app) {
//   //             return GestureDetector(
//   //               onTap: () {
//   //                 //   _transaction = initiateTransaction(app);
//   //                 setState(() {
//   //                   //  isSelectedPhonePe = true;
//   //                   //  isSelectedRazorpay = false;
//   //                  // startPGTransaction();
//   //                 });
//   //               },
//   //               // ignore: sized_box_for_whitespace
//   //               child: Container(
//   //                 height: 100,
//   //                 width: 80,
//   //                 child: Column(
//   //                   mainAxisSize: MainAxisSize.min,
//   //                   mainAxisAlignment: MainAxisAlignment.center,
//   //                   children: <Widget>[
//   //                     Image.memory(
//   //                       app.icon,
//   //                       height: 30,
//   //                       width: 30,
//   //                     ),
//   //                     Padding(
//   //                       padding: EdgeInsets.only(
//   //                         top: 10,
//   //                       ),
//   //                     ),
//   //                     Text(
//   //                       app.name,
//   //                       style: TextStyle(fontSize: 10),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ),
//   //             );
//   //           }).toList(),
//   //         ),
//   //       ),
//   //     );
//   // }

//   getPaymentUrlApiStripe({
//     planId,
//     required bool isTrial,
//     required bool isBeta,
//     required bool fromPlay,
//     String? coupon = "",
//   }) async {
//     ProfileController profileCon = Get.put(ProfileController());
//     PremiumController con = Get.put(PremiumController());
//     PremiumIOSController iosCon = Get.put(PremiumIOSController());

//     try {
//       bool connection =
//           await NetworkInfo(connectivity: Connectivity()).isConnected();
//       if (connection) {
//         await LocalStorage.getData();
//         if (LocalStorage.token.toString() != "null" &&
//             LocalStorage.token.toString().isNotEmpty &&
//             LocalStorage.userId.toString() != "null" &&
//             LocalStorage.userId.toString().isNotEmpty) {
//           con.showLoading.value = true;
//           profileCon.deleteLoader.value = true;

//           http.Response response = await ApiHandler.post(
//               url: '${ApiUrls.baseUrl}SubscriptionPlan/SubscriptionPlan',
//               body: {
//                 "userId": LocalStorage.userId,
//                 "subscriptionPlanId": isTrial
//                     ? 'TRIAL'
//                     : isBeta
//                         ? 'BETA'
//                         : planId,
//                 "paymentGatewayType": isTrial
//                     ? 'TRIAL'
//                     : isBeta
//                         ? 'BETA'
//                         : Platform.isIOS || fromPlay
//                             ? 'AP'
//                             : 'SP',
//                 "couponCode": coupon,
//                 "timeZone": 0,
//               });
//           var decoded = jsonDecode(response.body);

//           con.showLoading.value = false;
//           if (decoded['id'].toString() != "null") {
//             // receivedCallbackurl = decoded['callBackUrl'].toString();
//             // receivedamount = decoded['originalAmount'].toString();
//             // body = getChecksum().toString();
//             // phonepeInit();
//             getsubscriptionid = decoded['id'].toString();
//             getamount = decoded['amount'].toString();
//             print("phonepeforcheckurl${decoded['id'].toString()}");

//           makePayment();
          
//             // startPGTransaction();
//           }

//         }
//       } else {
//         toast("No Internet Connection!", false);
//       }
//     } catch (e) {
//       con.showLoading.value = false;
//       // toast(e.toString(), false);
//     } finally {
//       con.showLoading.value = false;
//       profileCon.deleteLoader.value = false;
//     }
//   }

 
// }
