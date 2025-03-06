// import 'package:flutter/material.dart';
// import 'package:quikrbox/core/app_export.dart';
//
// class CustomSearchView extends StatelessWidget {
//   CustomSearchView(
//       {this.shape,
//       this.padding,
//       this.variant,
//       this.fontStyle,
//       this.alignment,
//       this.width,
//       this.margin,
//       this.controller,
//       this.focusNode,
//       this.hintText,
//       this.prefix,
//       this.prefixConstraints,
//       this.suffix,
//       this.onTapC,
//       this.suffixConstraints});
//
//   SearchViewShape? shape;
//
//   SearchViewPadding? padding;
//
//   SearchViewVariant? variant;
//
//   SearchViewFontStyle? fontStyle;
//
//   Alignment? alignment;
//
//   double? width;
//
//   EdgeInsetsGeometry? margin;
//
//   TextEditingController? controller;
//
//   FocusNode? focusNode;
//
//   String? hintText;
//
//   Widget? prefix;
//
//   BoxConstraints? prefixConstraints;
//
//   Widget? suffix;
//
//   BoxConstraints? suffixConstraints;
//   Function? onTapC;
//
//   @override
//   Widget build(BuildContext context) {
//     return alignment != null
//         ? Align(
//             alignment: alignment ?? Alignment.center,
//             child: _buildSearchViewWidget(),
//           )
//         : _buildSearchViewWidget();
//   }
//
//   _buildSearchViewWidget() {
//     return Container(
//       width: getHorizontalSize(width ?? 0),
//       margin: margin,
//       child: TextFormField(
//         controller: controller,
//         focusNode: focusNode,
//         onTap: () {
//           if (onTapC != null) {
//             onTapC!();
//           }
//         },
//         style: _setFontStyle(),
//         decoration: _buildDecoration(),
//       ),
//     );
//   }
//
//   _buildDecoration() {
//     return InputDecoration(
//       hintText: hintText ?? "",
//       hintStyle: _setFontStyle(),
//       border: _setBorderStyle(),
//       enabledBorder: _setBorderStyle(),
//       focusedBorder: _setBorderStyle(),
//       disabledBorder: _setBorderStyle(),
//       prefixIcon: prefix,
//       prefixIconConstraints: prefixConstraints,
//       suffixIcon: suffix,
//       suffixIconConstraints: suffixConstraints,
//       fillColor: _setFillColor(),
//       filled: _setFilled(),
//       isDense: true,
//       contentPadding: _setPadding(),
//     );
//   }
//
//   _setFontStyle() {
//     switch (fontStyle) {
//       default:
//         return TextStyle(
//           color: ColorConstant.blueGray400,
//           fontSize: getFontSize(
//             14,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w500,
//         );
//     }
//   }
//
//   _setOutlineBorderRadius() {
//     switch (shape) {
//       default:
//         return BorderRadius.circular(
//           getHorizontalSize(
//             6.00,
//           ),
//         );
//     }
//   }
//
//   _setBorderStyle() {
//     switch (variant) {
//       case SearchViewVariant.None:
//         return InputBorder.none;
//       default:
//         return OutlineInputBorder(
//           borderRadius: _setOutlineBorderRadius(),
//           borderSide: BorderSide.none,
//         );
//     }
//   }
//
//   _setFillColor() {
//     switch (variant) {
//       default:
//         return ColorConstant.gray100;
//     }
//   }
//
//   _setFilled() {
//     switch (variant) {
//       case SearchViewVariant.FillGray100:
//         return true;
//       case SearchViewVariant.None:
//         return false;
//       default:
//         return true;
//     }
//   }
//
//   _setPadding() {
//     switch (padding) {
//       case SearchViewPadding.PaddingT17:
//         return getPadding(
//           top: 17,
//           right: 17,
//           bottom: 17,
//         );
//       case SearchViewPadding.PaddingT15:
//         return getPadding(
//           top: 15,
//           bottom: 15,
//         );
//       case SearchViewPadding.PaddingT12:
//         return getPadding(
//           left: 12,
//           top: 12,
//           bottom: 12,
//         );
//       default:
//         return getPadding(
//           top: 13,
//           right: 13,
//           bottom: 13,
//         );
//     }
//   }
// }
//
// enum SearchViewShape {
//   RoundedBorder6,
// }
//
// enum SearchViewPadding {
//   PaddingT17,
//   PaddingT15,
//   PaddingT13,
//   PaddingT12,
// }
//
// enum SearchViewVariant {
//   None,
//   FillGray100,
// }
//
// enum SearchViewFontStyle {
//   PoppinsMedium14,
// }
