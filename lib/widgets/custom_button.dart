// import 'package:flutter/material.dart';
// import 'package:quikrbox/core/app_export.dart';
//
// class CustomButton extends StatelessWidget {
//   CustomButton(
//       {this.shape,
//       this.padding,
//       this.variant,
//       this.fontStyle,
//       this.alignment,
//       this.margin,
//       this.onTap,
//       this.width,
//       this.height,
//       this.text,
//       this.prefixWidget,
//       this.suffixWidget});
//
//   ButtonShape? shape;
//
//   ButtonPadding? padding;
//
//   ButtonVariant? variant;
//
//   ButtonFontStyle? fontStyle;
//
//   Alignment? alignment;
//
//   EdgeInsetsGeometry? margin;
//
//   VoidCallback? onTap;
//
//   double? width;
//
//   double? height;
//
//   String? text;
//
//   Widget? prefixWidget;
//
//   Widget? suffixWidget;
//
//   @override
//   Widget build(BuildContext context) {
//     return alignment != null
//         ? Align(
//             alignment: alignment!,
//             child: _buildButtonWidget(),
//           )
//         : _buildButtonWidget();
//   }
//
//   _buildButtonWidget() {
//     return Padding(
//       padding: margin ?? EdgeInsets.zero,
//       child: TextButton(
//         onPressed: onTap,
//         style: _buildTextButtonStyle(),
//         child: _buildButtonChildWidget(),
//       ),
//     );
//   }
//
//   _buildButtonChildWidget() {
//     if (checkGradient()) {
//       return Container(
//         width: getHorizontalSize(width ?? 0),
//         padding: _setPadding(),
//         decoration: _buildDecoration(),
//         child: _buildButtonWithOrWithoutIcon(),
//       );
//     } else {
//       return _buildButtonWithOrWithoutIcon();
//     }
//   }
//
//   _buildButtonWithOrWithoutIcon() {
//     if (prefixWidget != null || suffixWidget != null) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           prefixWidget ?? SizedBox(),
//           Text(
//             text ?? "",
//             textAlign: TextAlign.center,
//             style: _setFontStyle(),
//           ),
//           suffixWidget ?? SizedBox(),
//         ],
//       );
//     } else {
//       return Text(
//         text ?? "",
//         textAlign: TextAlign.center,
//         style: _setFontStyle(),
//       );
//     }
//   }
//
//   _buildDecoration() {
//     return BoxDecoration(
//       border: _setBorder(),
//       borderRadius: _setBorderRadius(),
//       gradient: _setGradient(),
//       boxShadow: _setBoxShadow(),
//     );
//   }
//
//   _buildTextButtonStyle() {
//     if (checkGradient()) {
//       return TextButton.styleFrom(
//         padding: EdgeInsets.zero,
//       );
//     } else {
//       return TextButton.styleFrom(
//         fixedSize: Size(
//           getHorizontalSize(width ?? 0),
//           getVerticalSize(height ?? 0),
//         ),
//         padding: _setPadding(),
//         backgroundColor: _setColor(),
//         side: _setTextButtonBorder(),
//         shadowColor: _setTextButtonShadowColor(),
//         shape: RoundedRectangleBorder(
//           borderRadius: _setBorderRadius(),
//         ),
//       );
//     }
//   }
//
//   _setPadding() {
//     switch (padding) {
//       case ButtonPadding.PaddingAll5:
//         return getPadding(
//           all: 5,
//         );
//       case ButtonPadding.PaddingT16:
//         return getPadding(
//           top: 16,
//           right: 16,
//           bottom: 16,
//         );
//       case ButtonPadding.PaddingAll12:
//         return getPadding(
//           all: 12,
//         );
//       default:
//         return getPadding(
//           all: 16,
//         );
//     }
//   }
//
//   _setColor() {
//     switch (variant) {
//       case ButtonVariant.OutlineGray90001:
//         return ColorConstant.whiteA700;
//       case ButtonVariant.FillGray100:
//         return ColorConstant.gray100;
//       case ButtonVariant.OutlineOrange700:
//         return ColorConstant.whiteA700;
//       case ButtonVariant.FillWhiteA700:
//         return ColorConstant.whiteA700;
//       case ButtonVariant.FillBlack900:
//         return ColorConstant.black900;
//       case ButtonVariant.OutlineYellow90003:
//         return ColorConstant.whiteA700;
//       case ButtonVariant.OutlineLightgreen600:
//         return ColorConstant.lightGreen100;
//       case ButtonVariant.OutlineGray30001:
//         return ColorConstant.whiteA700;
//       case ButtonVariant.OutlineLightgreenA7003f_1:
//         return ColorConstant.whiteA700;
//       default:
//         return null;
//     }
//   }
//
//   _setTextButtonBorder() {
//     switch (variant) {
//       case ButtonVariant.OutlineGray90001:
//         return BorderSide(
//           color: ColorConstant.gray90001,
//           width: getHorizontalSize(
//             1.00,
//           ),
//         );
//       case ButtonVariant.OutlineOrange700:
//         return BorderSide(
//           color: ColorConstant.orange700,
//           width: getHorizontalSize(
//             1.00,
//           ),
//         );
//       case ButtonVariant.OutlineBlack900:
//         return BorderSide(
//           color: ColorConstant.black900,
//           width: getHorizontalSize(
//             1.00,
//           ),
//         );
//       case ButtonVariant.OutlineYellow90003:
//         return BorderSide(
//           color: ColorConstant.yellow90003,
//           width: getHorizontalSize(
//             1.00,
//           ),
//         );
//       case ButtonVariant.OutlineLightgreen600:
//         return BorderSide(
//           color: ColorConstant.lightGreen600,
//           width: getHorizontalSize(
//             1.00,
//           ),
//         );
//       case ButtonVariant.OutlineGray30001:
//         return BorderSide(
//           color: ColorConstant.gray30001,
//           width: getHorizontalSize(
//             1.00,
//           ),
//         );
//       default:
//         return null;
//         ;
//     }
//   }
//
//   _setTextButtonShadowColor() {
//     switch (variant) {
//       case ButtonVariant.OutlineGray90001:
//         return ColorConstant.lightGreenA7003f;
//       case ButtonVariant.OutlineLightgreenA7003f_1:
//         return ColorConstant.lightGreenA7003f;
//       case ButtonVariant.FillGray100:
//       case ButtonVariant.OutlineOrange700:
//       case ButtonVariant.FillWhiteA700:
//       case ButtonVariant.FillBlack900:
//       case ButtonVariant.OutlineBlack900:
//       case ButtonVariant.GradientAmber90002OrangeA20001:
//       case ButtonVariant.OutlineYellow90003:
//       case ButtonVariant.OutlineLightgreen600:
//       case ButtonVariant.OutlineGray30001:
//       case ButtonVariant.GradientAmber90003OrangeA20001:
//         return null;
//       default:
//         return ColorConstant.lightGreenA7003f;
//     }
//   }
//
//   _setBorderRadius() {
//     switch (shape) {
//       case ButtonShape.CircleBorder16:
//         return BorderRadius.circular(
//           getHorizontalSize(
//             16.00,
//           ),
//         );
//       case ButtonShape.RoundedBorder13:
//         return BorderRadius.circular(
//           getHorizontalSize(
//             13.00,
//           ),
//         );
//       case ButtonShape.Square:
//         return BorderRadius.circular(0);
//       default:
//         return BorderRadius.circular(
//           getHorizontalSize(
//             8.00,
//           ),
//         );
//     }
//   }
//
//   _setFontStyle() {
//     switch (fontStyle) {
//       case ButtonFontStyle.PoppinsSemiBold14Gray900:
//         return TextStyle(
//           color: ColorConstant.gray900,
//           fontSize: getFontSize(
//             14,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w600,
//         );
//       case ButtonFontStyle.PoppinsMedium12:
//         return TextStyle(
//           color: ColorConstant.blueGray400,
//           fontSize: getFontSize(
//             12,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w500,
//         );
//       case ButtonFontStyle.PoppinsMedium14:
//         return TextStyle(
//           color: ColorConstant.orange700,
//           fontSize: getFontSize(
//             14,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w500,
//         );
//       case ButtonFontStyle.PoppinsMedium14Gray80001:
//         return TextStyle(
//           color: ColorConstant.gray80001,
//           fontSize: getFontSize(
//             14,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w500,
//         );
//       case ButtonFontStyle.PoppinsMedium12Amber90003:
//         return TextStyle(
//           color: ColorConstant.amber90003,
//           fontSize: getFontSize(
//             12,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w500,
//         );
//       case ButtonFontStyle.PoppinsSemiBold10:
//         return TextStyle(
//           color: ColorConstant.black900,
//           fontSize: getFontSize(
//             10,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w600,
//         );
//       case ButtonFontStyle.PoppinsSemiBold10WhiteA700:
//         return TextStyle(
//           color: ColorConstant.whiteA700,
//           fontSize: getFontSize(
//             10,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w600,
//         );
//       case ButtonFontStyle.PoppinsMedium14WhiteA700:
//         return TextStyle(
//           color: ColorConstant.whiteA700,
//           fontSize: getFontSize(
//             14,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w500,
//         );
//       case ButtonFontStyle.PoppinsMedium14Black900:
//         return TextStyle(
//           color: ColorConstant.black900,
//           fontSize: getFontSize(
//             14,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w500,
//         );
//       case ButtonFontStyle.PoppinsSemiBold14Yellow90002:
//         return TextStyle(
//           color: ColorConstant.yellow90002,
//           fontSize: getFontSize(
//             14,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w600,
//         );
//       case ButtonFontStyle.PoppinsSemiBold10Lightgreen600:
//         return TextStyle(
//           color: ColorConstant.lightGreen600,
//           fontSize: getFontSize(
//             10,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w600,
//         );
//       case ButtonFontStyle.PoppinsMedium14Bluegray400:
//         return TextStyle(
//           color: ColorConstant.blueGray400,
//           fontSize: getFontSize(
//             14,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w500,
//         );
//       case ButtonFontStyle.PoppinsSemiBold14Gray80002:
//         return TextStyle(
//           color: ColorConstant.gray80002,
//           fontSize: getFontSize(
//             14,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w600,
//         );
//       case ButtonFontStyle.PoppinsSemiBold14Bluegray40002:
//         return TextStyle(
//           color: ColorConstant.blueGray40002,
//           fontSize: getFontSize(
//             14,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w600,
//         );
//       default:
//         return TextStyle(
//           color: ColorConstant.whiteA700,
//           fontSize: getFontSize(
//             14,
//           ),
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w600,
//         );
//     }
//   }
//
//   _setBorder() {
//     switch (variant) {
//       case ButtonVariant.OutlineGray90001:
//         return Border.all(
//           color: ColorConstant.gray90001,
//           width: getHorizontalSize(
//             1.00,
//           ),
//         );
//       case ButtonVariant.OutlineOrange700:
//         return Border.all(
//           color: ColorConstant.orange700,
//           width: getHorizontalSize(
//             1.00,
//           ),
//         );
//       case ButtonVariant.OutlineBlack900:
//         return Border.all(
//           color: ColorConstant.black900,
//           width: getHorizontalSize(
//             1.00,
//           ),
//         );
//       case ButtonVariant.OutlineYellow90003:
//         return Border.all(
//           color: ColorConstant.yellow90003,
//           width: getHorizontalSize(
//             1.00,
//           ),
//         );
//       case ButtonVariant.OutlineLightgreen600:
//         return Border.all(
//           color: ColorConstant.lightGreen600,
//           width: getHorizontalSize(
//             1.00,
//           ),
//         );
//       case ButtonVariant.OutlineGray30001:
//         return Border.all(
//           color: ColorConstant.gray30001,
//           width: getHorizontalSize(
//             1.00,
//           ),
//         );
//       default:
//         return null;
//         ;
//     }
//   }
//
//   checkGradient() {
//     switch (variant) {
//       case ButtonVariant.GradientAmber90002OrangeA20001:
//       case ButtonVariant.GradientAmber90003OrangeA20001:
//         return true;
//       case ButtonVariant.OutlineGray90001:
//       case ButtonVariant.FillGray100:
//       case ButtonVariant.OutlineOrange700:
//       case ButtonVariant.FillWhiteA700:
//       case ButtonVariant.FillBlack900:
//       case ButtonVariant.OutlineBlack900:
//       case ButtonVariant.OutlineYellow90003:
//       case ButtonVariant.OutlineLightgreen600:
//       case ButtonVariant.OutlineGray30001:
//       case ButtonVariant.OutlineLightgreenA7003f_1:
//         return false;
//       default:
//         return true;
//     }
//   }
//
//   _setGradient() {
//     switch (variant) {
//       case ButtonVariant.GradientAmber90002OrangeA20001:
//         return LinearGradient(
//           begin: Alignment(
//             0,
//             0,
//           ),
//           end: Alignment(
//             1,
//             1,
//           ),
//           colors: [
//             ColorConstant.amber90002,
//             ColorConstant.orangeA20001,
//           ],
//         );
//       case ButtonVariant.GradientAmber90003OrangeA20001:
//         return LinearGradient(
//           begin: Alignment(
//             0,
//             0.5,
//           ),
//           end: Alignment(
//             1,
//             0.5,
//           ),
//           colors: [
//             ColorConstant.amber90003,
//             ColorConstant.orangeA20001,
//           ],
//         );
//       case ButtonVariant.OutlineGray90001:
//       case ButtonVariant.FillGray100:
//       case ButtonVariant.OutlineOrange700:
//       case ButtonVariant.FillWhiteA700:
//       case ButtonVariant.FillBlack900:
//       case ButtonVariant.OutlineBlack900:
//       case ButtonVariant.OutlineYellow90003:
//       case ButtonVariant.OutlineLightgreen600:
//       case ButtonVariant.OutlineGray30001:
//       case ButtonVariant.OutlineLightgreenA7003f_1:
//         return null;
//       default:
//         return LinearGradient(
//           begin: Alignment(
//             0,
//             -0.07,
//           ),
//           end: Alignment(
//             1,
//             1.18,
//           ),
//           colors: [
//             ColorConstant.amber90001,
//             ColorConstant.orangeA200,
//           ],
//         );
//     }
//   }
//
//   _setBoxShadow() {
//     switch (variant) {
//       case ButtonVariant.OutlineGray90001:
//         return [
//           BoxShadow(
//             color: ColorConstant.lightGreenA7003f,
//             spreadRadius: getHorizontalSize(
//               2.00,
//             ),
//             blurRadius: getHorizontalSize(
//               2.00,
//             ),
//             offset: Offset(
//               0,
//               10,
//             ),
//           )
//         ];
//       case ButtonVariant.OutlineLightgreenA7003f_1:
//         return [
//           BoxShadow(
//             color: ColorConstant.lightGreenA7003f,
//             spreadRadius: getHorizontalSize(
//               2.00,
//             ),
//             blurRadius: getHorizontalSize(
//               2.00,
//             ),
//             offset: Offset(
//               0,
//               10,
//             ),
//           )
//         ];
//       case ButtonVariant.FillGray100:
//       case ButtonVariant.OutlineOrange700:
//       case ButtonVariant.FillWhiteA700:
//       case ButtonVariant.FillBlack900:
//       case ButtonVariant.OutlineBlack900:
//       case ButtonVariant.GradientAmber90002OrangeA20001:
//       case ButtonVariant.OutlineYellow90003:
//       case ButtonVariant.OutlineLightgreen600:
//       case ButtonVariant.OutlineGray30001:
//       case ButtonVariant.GradientAmber90003OrangeA20001:
//         return null;
//       default:
//         return [
//           BoxShadow(
//             color: ColorConstant.lightGreenA7003f,
//             spreadRadius: getHorizontalSize(
//               2.00,
//             ),
//             blurRadius: getHorizontalSize(
//               2.00,
//             ),
//             offset: Offset(
//               0,
//               10,
//             ),
//           )
//         ];
//     }
//   }
// }
//
// enum ButtonShape {
//   Square,
//   RoundedBorder8,
//   CircleBorder16,
//   RoundedBorder13,
// }
//
// enum ButtonPadding {
//   PaddingAll16,
//   PaddingAll5,
//   PaddingT16,
//   PaddingAll12,
// }
//
// enum ButtonVariant {
//   OutlineLightgreenA7003f,
//   OutlineGray90001,
//   FillGray100,
//   OutlineOrange700,
//   FillWhiteA700,
//   FillBlack900,
//   OutlineBlack900,
//   GradientAmber90002OrangeA20001,
//   OutlineYellow90003,
//   OutlineLightgreen600,
//   OutlineGray30001,
//   GradientAmber90003OrangeA20001,
//   OutlineLightgreenA7003f_1,
// }
//
// enum ButtonFontStyle {
//   PoppinsSemiBold14,
//   PoppinsSemiBold14Gray900,
//   PoppinsMedium12,
//   PoppinsMedium14,
//   PoppinsMedium14Gray80001,
//   PoppinsMedium12Amber90003,
//   PoppinsSemiBold10,
//   PoppinsSemiBold10WhiteA700,
//   PoppinsMedium14WhiteA700,
//   PoppinsMedium14Black900,
//   PoppinsSemiBold14Yellow90002,
//   PoppinsSemiBold10Lightgreen600,
//   PoppinsMedium14Bluegray400,
//   PoppinsSemiBold14Gray80002,
//   PoppinsSemiBold14Bluegray40002,
// }
