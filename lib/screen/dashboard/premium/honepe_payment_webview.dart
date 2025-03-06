import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/profile/get_profile_api.dart';
import 'package:puthagam/screen/dashboard/premium/payment_controller.dart';
import 'package:puthagam/utils/themes/global.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PhonepeWebViewScreen extends StatelessWidget {
  PhonepeWebViewScreen({Key? key}) : super(key: key);

  final PaymentController con = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        con.timer1!.cancel();
        Get.back();
        getUserProfileApi();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF065293),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: GlobalService.to.isDarkModel == true
                  ? Colors.white
                  : Colors.black,
              size: 26,
            ),
            onPressed: () {
              con.timer1!.cancel();
              Get.back();
              getUserProfileApi();
            },
          ),
          elevation: 0,
          title: const Text(
            "Payment With RazorPay",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
            ),
          ),
        ),
        body: WebView(
          initialUrl: Get.arguments[0],
          javascriptMode: JavascriptMode.unrestricted,
          zoomEnabled: true,
          navigationDelegate: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
