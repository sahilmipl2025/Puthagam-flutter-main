// import 'package:flutter/material.dart';
// import 'package:quikrbox/core/app_export.dart';
//
// class CustomDropDown extends StatelessWidget {
//   CustomDropDown(
//       {this.shape,
//       this.padding,
//       this.variant,
//       this.fontStyle,
//       this.alignment,
//       this.width,
//       this.margin,
//       this.focusNode,
//       this.icon,
//       this.hintText,
//       this.prefix,
//       this.prefixConstraints,
//       this.items,
//       this.onChanged,
//       this.validator});
//
//   DropDownShape? shape;
//
//   DropDownPadding? padding;
//
//   DropDownVariant? variant;
//
//   DropDownFontStyle? fontStyle;
//
//   Alignment? alignment;
//
//   double? width;
//
//   EdgeInsetsGeometry? margin;
//
//   FocusNode? focusNode;
//
//   Widget? icon;
//
//   String? hintText;
//
//   Widget? prefix;
//
//   BoxConstraints? prefixConstraints;
//
//   List<SelectionPopupModel>? items;
//
//   Function(SelectionPopupModel)? onChanged;
//
//   FormFieldValidator<SelectionPopupModel>? validator;
//
//   @override
//   Widget build(BuildContext context) {
//     return alignment != null
//         ? Align(
//             alignment: alignment ?? Alignment.center,
//             child: _buildDropDownWidget(),
//           )
//         : _buildDropDownWidget();
//   }
//
//   _buildDropDownWidget() {
//     return Container(
//       width: getHorizontalSize(width ?? 0),
//       margin: margin,
//       child: DropdownButtonFormField<SelectionPopupModel>(
//         focusNode: focusNode,
//         icon: icon,
//         style: _setFontStyle(),
//         decoration: _buildDecoration(),
//         items: items?.map((SelectionPopupModel item) {
//           return DropdownMenuItem<SelectionPopupModel>(
//             value: item,
//             child: Text(
//               item.title,
//               overflow: TextOverflow.ellipsis,
//             ),
//           );
//         }).toList(),
//         onChanged: (value) {
//           onChanged!(value!);
//         },
//         validator: validator,
//       ),
//     );
//   }
//
//   _buildDecoration() {
//     return InputDecoration(
//       hintText: hintText ?? "",
//       hintStyle: _setFontStyle(),
//       border: _setBorderStyle(),
//       focusedBorder: _setBorderStyle(),
//       prefixIcon: prefix,
//       prefixIconConstraints: prefixConstraints,
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
//           color: ColorConstant.gray80001,
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
//       case DropDownVariant.FillGray100:
//         return OutlineInputBorder(
//           borderRadius: _setOutlineBorderRadius(),
//           borderSide: BorderSide.none,
//         );
//       case DropDownVariant.None:
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
//       case DropDownVariant.None:
//         return false;
//       default:
//         return true;
//     }
//   }
//
//   _setPadding() {
//     switch (padding) {
//       default:
//         return getPadding(
//           left: 17,
//           top: 17,
//           bottom: 17,
//         );
//     }
//   }
// }
//
// enum DropDownShape {
//   RoundedBorder6,
// }
//
// enum DropDownPadding {
//   PaddingT17,
// }
//
// enum DropDownVariant {
//   None,
//   FillGray100,
// }
//
// enum DropDownFontStyle {
//   PoppinsMedium14,
// }
