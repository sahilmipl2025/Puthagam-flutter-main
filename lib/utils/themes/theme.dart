import 'package:flutter/material.dart';
import 'package:puthagam/utils/themes/color_scheme.dart';
import 'package:puthagam/utils/themes/material_coor.dart';

class AppTheme {
  static MaterialColor myColor = stringToMaterialColor("008744");

  static ThemeData light = ThemeData(
    fontFamily: 'SF-Pro-Display',
    colorScheme: lightColorScheme,
    cardColor: Colors.white,
    canvasColor: Colors.white,
    primaryColorLight: Colors.grey.withOpacity(.1),
    indicatorColor: Colors.black,
    appBarTheme: ThemeData.light().appBarTheme.copyWith(
          // textTheme: const TextTheme(
          //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          // ),
          titleTextStyle: ThemeData.light().textTheme.titleLarge?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
        ),
  );

  static ThemeData dark = ThemeData(
    fontFamily: 'SF-Pro-Display',
    colorScheme: darkColorScheme,
    cardColor: Colors.black,
    canvasColor: Colors.black,
    primaryColorLight: Colors.black,
    indicatorColor: Colors.white,
    appBarTheme: ThemeData.dark().appBarTheme.copyWith(
          // textTheme: const TextTheme(
          //   headline1: TextStyle(
          //       fontSize: 72.0,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.white30),
          //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.normal),
          //   headline4: TextStyle(
          //       fontSize: 36.0,
          //       fontStyle: FontStyle.normal,
          //       color: Colors.white30),
          //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          // ),
        ),
  );
}
