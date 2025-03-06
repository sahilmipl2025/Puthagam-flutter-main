import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: Get.width * 0.065,
              height: Get.width * 0.065,
              child: getLoader(),
            ),
          ],
        ),
      ),
    );
  }

  getLoader() {
    // if (Platform.isIOS) {
    //   return const CupertinoActivityIndicator();
    // } else {
    return const CircularProgressIndicator(strokeWidth: 3);
    // }
  }
}
