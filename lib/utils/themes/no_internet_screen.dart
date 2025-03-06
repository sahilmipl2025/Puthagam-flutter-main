import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/utils/colors.dart';

checkConnection() async {
  ConnectivityResult result = (await Connectivity().checkConnectivity()) as ConnectivityResult;
  return (result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi);
}

class NoInternetScreen extends StatelessWidget {
  final GestureTapCallback onTap;

  const NoInternetScreen({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: verticalGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/magic_app.png',
                // height: 150,
                width: Get.width * 0.6,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              " Connection!",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: onTap,
              child: Container(
                width: Get.width * 0.6,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(100),
                    ),
                    gradient: verticalGradient),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
