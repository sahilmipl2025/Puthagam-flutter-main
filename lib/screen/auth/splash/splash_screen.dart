import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/auth/splash/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final SplashController con = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Image(
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
