import 'package:flutter/cupertino.dart';

class Loader extends StatelessWidget {
  final double radius;
  final Brightness brightness;

  const Loader({
    Key? key,
    this.radius = mediumRadius,
    this.brightness = Brightness.light,
  }) : super(key: key);

  static const double smallRadius = 10.0;
  static const double mediumRadius = 14.0;

  @override
  Widget build(BuildContext context) {
    if (brightness == Brightness.light) {
      return Center(
        child: CupertinoActivityIndicator(
          radius: radius,
        ),
      );
    }

    return Center(
      child: CupertinoActivityIndicator(
        radius: radius,
      ),
    );
  }
}

class MyErrorWidget extends StatelessWidget {
  final String error;

  const MyErrorWidget({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error));
  }
}
