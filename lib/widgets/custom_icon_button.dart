// import 'dart:developer';
//
// import 'package:flutter/material.dart';
//
// class CustomIconButton extends StatelessWidget {
//   CustomIconButton(
//       {this.shape,
//       this.padding,
//       this.variant,
//       this.alignment,
//       this.margin,
//       this.width,
//       this.height,
//       this.child,
//       this.onTap});
//
//   IconButtonShape? shape;
//
//   IconButtonPadding? padding;
//
//   IconButtonVariant? variant;
//
//   Alignment? alignment;
//
//   EdgeInsetsGeometry? margin;
//
//   double? width;
//
//   double? height;
//
//   Widget? child;
//
//   VoidCallback? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return alignment != null
//         ? Align(
//             alignment: alignment ?? Alignment.center,
//             child: _buildIconButtonWidget(),
//           )
//         : _buildIconButtonWidget();
//   }
//
//   _buildIconButtonWidget() {
//     log("route ${Get.previousRoute}");
//     return (Get.previousRoute == AppRoutes.splashScreen ||
//             Get.previousRoute == AppRoutes.otpScreen ||
//             Get.previousRoute == AppRoutes.onbordingScreen)
//         ? Container()
//         : Padding(
//             padding: margin ?? EdgeInsets.zero,
//             child: IconButton(
//               iconSize: getSize(height ?? 0),
//               padding: EdgeInsets.all(0),
//               icon: Container(
//                 alignment: Alignment.center,
//                 width: getSize(width ?? 0),
//                 height: getSize(height ?? 0),
//                 padding: _setPadding(),
//                 decoration: _buildDecoration(),
//                 child: child,
//               ),
//               onPressed: onTap,
//             ),
//           );
//   }
//
//   _buildDecoration() {
//     return BoxDecoration(
//       color: _setColor(),
//       borderRadius: _setBorderRadius(),
//     );
//   }
//
//   _setPadding() {
//     switch (padding) {
//       case IconButtonPadding.PaddingAll4:
//         return getPadding(
//           all: 4,
//         );
//       case IconButtonPadding.PaddingAll15:
//         return getPadding(
//           all: 15,
//         );
//       default:
//         return getPadding(
//           all: 11,
//         );
//     }
//   }
//
//   _setColor() {
//     switch (variant) {
//       case IconButtonVariant.FillGray50:
//         return ColorConstant.gray50;
//       case IconButtonVariant.FillGray100:
//         return ColorConstant.gray100;
//       case IconButtonVariant.FillGray30001:
//         return ColorConstant.gray30001;
//       default:
//         return ColorConstant.gray5090;
//     }
//   }
//
//   _setBorderRadius() {
//     switch (shape) {
//       case IconButtonShape.CircleBorder28:
//         return BorderRadius.circular(
//           getHorizontalSize(
//             28.00,
//           ),
//         );
//       default:
//         return BorderRadius.circular(
//           getHorizontalSize(
//             24.00,
//           ),
//         );
//     }
//   }
// }
//
// enum IconButtonShape {
//   CircleBorder24,
//   CircleBorder28,
// }
//
// enum IconButtonPadding {
//   PaddingAll11,
//   PaddingAll4,
//   PaddingAll15,
// }
//
// enum IconButtonVariant {
//   FillGray5090,
//   FillGray50,
//   FillGray100,
//   FillGray30001,
// }
