// import 'dart:developer';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:quikrbox/core/app_export.dart';
// import 'package:quikrbox/core/utils/app_utils.dart';
// import 'package:quikrbox/domain/entites/cart/get_cart_response/cart_item.dart';
// import 'package:quikrbox/domain/entites/products/get_top_offer_products_response/product.dart';
// import 'package:quikrbox/domain/params/cart/add_cart_params.dart';
// import 'package:quikrbox/domain/params/cart/remove_cart_param.dart';
// import 'package:quikrbox/gen/assets.gen.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class BuildProduct extends StatelessWidget {
//   BuildProduct(
//       {Key? key,
//       required this.product,
//       required this.showDetail,
//       required this.storeId})
//       : super(key: key);
//
//   final Product product;
//   final num storeId;
//   final bool showDetail;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: AppDecoration.outlineGray30001.copyWith(
//         borderRadius: BorderRadiusStyle.circleBorder19,
//       ),
//       child: InkWell(
//         onTap: () {
//           if ((product.stock?.toInt() ?? 0) > 0) {
//             CardBottomSheet(context, product);
//           }
//         },
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Align(
//               alignment: Alignment.center,
//               child: Container(
//                 height: getVerticalSize(
//                   105.00,
//                 ),
//                 width: getHorizontalSize(
//                   160.00,
//                 ),
//                 margin: getMargin(
//                   top: 3,
//                 ),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Align(
//                       alignment: Alignment.topCenter,
//                       child: Container(
//                         height: getVerticalSize(
//                           98.00,
//                         ),
//                         width: getHorizontalSize(
//                           133.00,
//                         ),
//                         decoration: BoxDecoration(
//                           color: ColorConstant.whiteA700,
//                         ),
//                       ),
//                     ),
//                     CustomImageView(
//                       url: product.image,
//                       imagePath: Assets.images.imageNotFound.path,
//                       height: getSize(
//                         100.00,
//                       ),
//                       width: getSize(
//                         100.00,
//                       ),
//                       alignment: Alignment.center,
//                     ).opacity(value: product.stock!.toInt() <= 0 ? 0.5 : 1),
//                     Visibility(
//                         visible: (product.stock!.toInt() <= 0),
//                         child: "Out of stock".text.size(18).make()),
//                     Visibility(
//                       visible: product.stock!.toInt() > 0,
//                       child: Positioned(
//                         bottom: 0,
//                         right: 5,
//                         child: BuildAddIcon(product),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               width: getHorizontalSize(
//                 120.00,
//               ),
//               margin: getMargin(
//                 left: 8,
//                 top: 8,
//               ),
//               child: Text(
//                 product.name ?? "n/a",
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: TextAlign.left,
//                 style: AppStyle.txtPoppinsMedium12Gray90002.copyWith(
//                   height: getVerticalSize(
//                     1.00,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: getPadding(
//                 left: 8,
//                 top: 4,
//               ),
//               child: Row(
//                 children: [
//                   Row(children: [
//                     Text(
//                         "${getCurrentCountry().currencySymbol}${product.offerPrice == null ? product.sellingPrice : product.offerPrice}",
//                         overflow: TextOverflow.ellipsis,
//                         textAlign: TextAlign.left,
//                         style: AppStyle.txtPoppinsBold16Black900
//                             .copyWith(height: getVerticalSize(1.00))),
//                     5.widthBox,
//                     Visibility(
//                       visible: product.offerPrice.isNotEmptyAndNotNull,
//                       child: Text(
//                         "${getCurrentCountry().currencySymbol}${product.sellingPrice}",
//                         overflow: TextOverflow.ellipsis,
//                         textAlign: TextAlign.left,
//                         style: AppStyle.txtPoppinsLight14.copyWith(
//                             height: getVerticalSize(1.00),
//                             decoration: TextDecoration.lineThrough),
//                       ),
//                     ),
//                   ]),
//                   Spacer(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class BuildProduct2 extends StatelessWidget {
//   BuildProduct2(
//       {Key? key,
//       required this.product,
//       required this.showDetail,
//       required this.storeId})
//       : super(key: key);
//
//   final Product product;
//   final num storeId;
//   final bool showDetail;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: getPadding(
//         left: 10,
//         top: 7,
//         right: 10,
//         bottom: 7,
//       ),
//       margin: EdgeInsets.only(bottom: 10),
//       decoration: AppDecoration.outlineGray30001.copyWith(
//         borderRadius: BorderRadiusStyle.circleBorder19,
//       ),
//       child: InkWell(
//         onTap: () {
//           if (product.stock!.toInt() > 0) {
//             CardBottomSheet(context, product);
//           }
//         },
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Align(
//               alignment: Alignment.center,
//               child: Container(
//                 height: getVerticalSize(
//                   105.00,
//                 ),
//                 width: getHorizontalSize(
//                   133.00,
//                 ),
//                 margin: getMargin(
//                   top: 3,
//                 ),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Align(
//                       alignment: Alignment.topCenter,
//                       child: Container(
//                         height: getVerticalSize(
//                           98.00,
//                         ),
//                         width: getHorizontalSize(
//                           133.00,
//                         ),
//                         decoration: BoxDecoration(
//                           color: ColorConstant.whiteA700,
//                         ),
//                       ),
//                     ),
//                     CustomImageView(
//                       url: product.image,
//                       imagePath: Assets.images.imageNotFound.path,
//                       height: getSize(
//                         100.00,
//                       ),
//                       width: getSize(
//                         100.00,
//                       ),
//                       alignment: Alignment.center,
//                     ).opacity(value: product.stock!.toInt() <= 0 ? 0.5 : 1),
//                     Visibility(
//                         visible: (product.stock!.toInt() <= 0),
//                         child: "Out of stock".text.size(18).make()),
//                   ],
//                 ),
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   product.name ?? "n/a",
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.left,
//                   style: AppStyle.txtPoppinsMedium12Gray90002.copyWith(
//                     height: getVerticalSize(
//                       1.00,
//                     ),
//                   ),
//                 ),
//                 20.heightBox,
//                 Row(children: [
//                   Text(
//                       "${getCurrentCountry().currencySymbol}${product.offerPrice == null ? product.sellingPrice : product.offerPrice}",
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.left,
//                       style: AppStyle.txtPoppinsBold16Black900
//                           .copyWith(height: getVerticalSize(1.00))),
//                   5.widthBox,
//                   Visibility(
//                     visible: product.offerPrice.isNotEmptyAndNotNull &&
//                         product.offerPrice != product.sellingPrice,
//                     child: Text(
//                       "${getCurrentCountry().currencySymbol}${product.sellingPrice}",
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.left,
//                       style: AppStyle.txtPoppinsLight14.copyWith(
//                           height: getVerticalSize(1.00),
//                           decoration: TextDecoration.lineThrough),
//                     ),
//                   ),
//                 ])
//               ],
//             ).expand(),
//             BuildAddIcon(product)
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class BuildAddIcon extends StatelessWidget {
//   BuildAddIcon(this.product, {super.key});
//   final Product product;
//   final loading = false.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     if ((product.stock!.toInt() <= 0)) {
//       return SizedBox();
//     }
//     return Obx(() {
//       return cartItems.firstWhereOrNull(
//                       (element) => element.product?.id == product.id) ==
//                   null ||
//               cartItems
//                       .firstWhere(
//                           (element) => element.product?.id == product.id)
//                       .quantity ==
//                   0
//           ? loading.isTrue
//               ? CupertinoActivityIndicator()
//               : CustomImageView(
//                   svgPath: Assets.images.svgCloseOrange,
//                   height: getSize(
//                     27.00,
//                   ),
//                   width: getSize(
//                     27.00,
//                   ),
//                   onTap: () {
//                     if (prefUtils.getID()?.isEmptyOrNull == true) {
//                       Get.toNamed(AppRoutes.loginScreen);
//                       showToastMessage("Error", "Please login to add to cart");
//                       return;
//                     }
//                     addToCart(true);
//                     // controller.addToCart(
//                     //     widget.product.id!, true);
//                   },
//                   margin: getMargin(
//                     top: 14,
//                     bottom: 3,
//                   ),
//                 )
//           : Container(
//               decoration: AppDecoration.outlineBluegray100
//                   .copyWith(borderRadius: BorderRadiusStyle.circleBorder13),
//               child: Row(mainAxisSize: MainAxisSize.min, children: [
//                 Card(
//                     clipBehavior: Clip.antiAlias,
//                     elevation: 0,
//                     margin: EdgeInsets.all(0),
//                     color: ColorConstant.orange100,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadiusStyle.circleBorder13),
//                     child: Container(
//                         height: getSize(26.00),
//                         width: getSize(26.00),
//                         padding: getPadding(all: 7),
//                         decoration: AppDecoration.fillOrange100.copyWith(
//                             borderRadius: BorderRadiusStyle.circleBorder13),
//                         child: Stack(children: [
//                           cartItems
//                                       .firstWhere((element) =>
//                                           element.product?.id == product.id)
//                                       .quantity ==
//                                   1
//                               ? CustomImageView(
//                                       svgPath: Assets.images.svgDelete,
//                                       height: getSize(12.00),
//                                       width: getSize(12.00),
//                                       alignment: Alignment.center)
//                                   .onInkTap(() {
//                                   deleteCart(cartItems.firstWhere((element) =>
//                                       element.product?.id == product.id));
//                                 })
//                               : CustomImageView(
//                                   svgPath: Assets.images.minus,
//                                   onTap: () {
//                                     addToCart(false);
//                                   },
//                                   height: getSize(12.00),
//                                   width: getSize(12.00),
//                                   alignment: Alignment.center)
//                         ]))),
//                 loading.isTrue
//                     ? Padding(
//                         padding: getPadding(left: 13, top: 4),
//                         child: CupertinoActivityIndicator(),
//                       )
//                     : Padding(
//                         padding: getPadding(left: 13, top: 4),
//                         child: Text(
//                             cartItems
//                                 .firstWhere((element) =>
//                                     element.product?.id == product.id)
//                                 .quantity
//                                 .toString(),
//                             overflow: TextOverflow.ellipsis,
//                             textAlign: TextAlign.left,
//                             style: AppStyle.txtPoppinsMedium14Amber90003
//                                 .copyWith(height: getVerticalSize(1.00)))),
//                 Card(
//                     clipBehavior: Clip.antiAlias,
//                     elevation: 0,
//                     margin: getMargin(left: 13),
//                     color: ColorConstant.orange100,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadiusStyle.circleBorder13),
//                     child: Container(
//                         height: getSize(26.00),
//                         width: getSize(26.00),
//                         padding: getPadding(all: 3),
//                         decoration: AppDecoration.fillOrange100.copyWith(
//                             borderRadius: BorderRadiusStyle.circleBorder13),
//                         child: Stack(children: [
//                           CustomImageView(
//                               svgPath: Assets.images.svgAddOrange,
//                               height: getSize(15.00),
//                               width: getSize(15.00),
//                               fit: BoxFit.cover,
//                               alignment: Alignment.center)
//                         ]))).onInkTap(() {
//                   addToCart(true);
//                 })
//               ]));
//     });
//   }
//
//   addToCart(bool add) async {
//     if (prefUtils.getID()?.isEmptyOrNull == true) {
//       Get.toNamed(AppRoutes.loginScreen);
//       showToastMessage("Error", "Please login to add to cart");
//       return;
//     }
//     loading.value = true;
//     final itemFound =
//         cartItems.firstWhereOrNull((item) => item.productId == product.id!);
//
//     final param = AddCartParams(
//         userId: int.tryParse(prefUtils.getID() ?? "0"),
//         productId: product.id,
//         storeId: product.storeId!.toInt(),
//         quantity: itemFound == null
//             ? 1
//             : add
//                 ? ((itemFound.quantity ?? 0) + 1)
//                 : itemFound.quantity! - 1);
//     final response = await cartrepo.addToCart(param);
//     Future.delayed(Duration(seconds: 1), () {
//       loading.value = false;
//     });
//     if (response.data?.data != null) {
//       showToastMessage("Success", "Added to cart successfully");
//     }
//   }
//
//   deleteCart(
//     CartItem product,
//   ) async {
//     try {
//       if (Get.isDialogOpen == true) {
//         return;
//       }
//       loading.value = true;
//       final response = (await cartrepo.deleteCartItem(RemoveCartParam(
//               cartItemId: product.id,
//               userId: int.parse(
//                 prefUtils.getID()!,
//               ))))
//           .data
//           ?.data;
//       Future.delayed(Duration(seconds: 1), () {
//         loading.value = false;
//       });
//       if (response != null) {
//         showToastMessage("Success", "Item removed successfully");
//       }
//     } catch (err) {
//       log("er $err");
//     }
//   }
// }
