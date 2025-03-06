import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../resources/app_resources.dart';

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary({Key? key, required this.title, required this.onPressed})
      : super(key: key);
  final Function onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: commonBlueColor),
            onPressed: () {
              onPressed();
            },
            child: title.text.white.make())
        .w(double.infinity)
        .marginOnly(left: 20, right: 20);
  }
}

class ButtonLoading extends StatelessWidget {
  const ButtonLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
            onPressed: () {}, child: const CupertinoActivityIndicator())
        .w(double.infinity)
        .marginOnly(left: 20, right: 20);
  }
}

class ButtonSecondary extends StatelessWidget {
  const ButtonSecondary(
      {Key? key, required this.title, required this.onPressed})
      : super(key: key);
  final Function onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
            onPressed: () {
              onPressed();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: themeColor)))),
            child: title.text.color(themeColor).make())
        .w(double.infinity)
        .marginOnly(left: 20, right: 20);
  }
}
