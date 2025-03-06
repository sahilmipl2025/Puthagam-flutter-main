import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color gray5001 = fromHex('#f8f8f8');

  static Color blueA200 = fromHex('#4b7dff');

  static Color gray80002 = fromHex('#4d4d4d');

  static Color gray80001 = fromHex('#404040');

  static Color black9003f = fromHex('#3f000000');

  static Color green700 = fromHex('#1abb00');

  static Color green500 = fromHex('#61b04c');

  static Color orangeA20051 = fromHex('#51ff9e4c');

  static Color orange70051 = fromHex('#51ff7a0a');

  static Color black90001 = fromHex('#020202');

  static Color greenA700 = fromHex('#00a341');

  static Color black90000 = fromHex('#00000000');

  static Color lightGreen600 = fromHex('#68b04c');

  static Color gray5090 = fromHex('#90f8fafc');

  static Color blueGray90001 = fromHex('#263238');

  static Color blueGray900 = fromHex('#303030');

  static Color gray600 = fromHex('#6e6e6e');

  static Color amber900 = fromHex('#ff7400');

  static Color lightGreenA7003f = fromHex('#3f6bc51c');

  static Color orangeA200 = fromHex('#ff9f4f');

  static Color blueGray100 = fromHex('#d9d9d9');

  static Color black9008c = fromHex('#8c000000');

  static Color gray800 = fromHex('#3d3d3d');

  static Color blueGray500 = fromHex('#64748b');

  static Color orangeA20001 = fromHex('#ff9e4c');

  static Color orangeA20002 = fromHex('#ff9338');

  static Color gray200 = fromHex('#e7e7e7');

  static Color bluegray400 = fromHex('#888888');

  static Color blueGray40002 = fromHex('#8d8d8d');

  static Color blueGray40001 = fromHex('#8b8b8b');

  static Color whiteA700 = fromHex('#ffffff');

  static Color deepOrange50 = fromHex('#ffefe7');

  static Color lightGreen100 = fromHex('#dfeed7');

  static Color green600 = fromHex('#28ae5c');

  static Color gray50 = fromHex('#f8fafc');

  static Color blueGray3000f = fromHex('#0f94a3b8');

  static Color black900 = fromHex('#000000');

  static Color gray50001 = fromHex('#9fa0a2');

  static Color yellow900 = fromHex('#ff7b0c');

  static Color gray50003 = fromHex('#9e9e9e');

  static Color gray50002 = fromHex('#909090');

  static Color gray90002 = fromHex('#292825');

  static Color amber90001 = fromHex('#ff7807');

  static Color gray90003 = fromHex('#1f1f1f');

  static Color gray700 = fromHex('#6a6a6a');

  static Color gray60002 = fromHex('#747474');

  static Color gray500 = fromHex('#a1a0a8');

  static Color gray60001 = fromHex('#6f6f6f');

  static Color blueGray400 = fromHex('#868889');

  static Color amber400 = fromHex('#fcc81a');

  static Color indigo50 = fromHex('#e3e8fc');

  static Color amber90002 = fromHex('#ff7908');

  static Color gray900 = fromHex('#111111');

  static Color gray90001 = fromHex('#2a242d');

  static Color amber90003 = fromHex('#ff7909');

  static Color orange700 = fromHex('#ff7a0a');

  static Color gray300 = fromHex('#dadada');

  static Color gray30001 = fromHex('#dddddd');

  static Color gray100 = fromHex('#f4f5f9');

  static Color orange100 = fromHex('#ffdbbe');

  static Color yellow90002 = fromHex('#ff7c0d');

  static Color yellow90001 = fromHex('#ff7e11');

  static Color orange50 = fromHex('#fff4e2');

  static Color yellow90004 = fromHex('#ff7b0d');

  static Color yellow90003 = fromHex('#ff7d0e');

  static Color orange70001 = fromHex('#ff7a09');

  static final rgbColor = [255, 116, 0];
  static const themeColor = Color(0xffff7400);
  static final Map<int, Color> themeMapColor = {
    50: Color.fromRGBO(rgbColor[0], rgbColor[1], rgbColor[2], .1),
    100: Color.fromRGBO(rgbColor[0], rgbColor[1], rgbColor[2], .2),
    200: Color.fromRGBO(rgbColor[0], rgbColor[1], rgbColor[2], .3),
    300: Color.fromRGBO(rgbColor[0], rgbColor[1], rgbColor[2], .4),
    400: Color.fromRGBO(rgbColor[0], rgbColor[1], rgbColor[2], .5),
    500: Color.fromRGBO(rgbColor[0], rgbColor[1], rgbColor[2], .6),
    600: Color.fromRGBO(rgbColor[0], rgbColor[1], rgbColor[2], .7),
    700: Color.fromRGBO(rgbColor[0], rgbColor[1], rgbColor[2], .8),
    800: Color.fromRGBO(rgbColor[0], rgbColor[1], rgbColor[2], .9),
    900: Color.fromRGBO(rgbColor[0], rgbColor[1], rgbColor[2], 1),
  };

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
