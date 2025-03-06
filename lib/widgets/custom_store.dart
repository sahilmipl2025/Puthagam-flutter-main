// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quikrbox/core/utils/color_constant.dart';
// import 'package:quikrbox/core/utils/size_utils.dart';
// import 'package:quikrbox/domain/entites/store/get_store_response/store.dart';
// import 'package:quikrbox/gen/assets.gen.dart';
// import 'package:quikrbox/presentation/home_page/widgets/utils.dart';
// import 'package:quikrbox/routes/app_routes.dart';
// import 'package:quikrbox/theme/app_decoration.dart';
// import 'package:quikrbox/theme/app_style.dart';
// import 'package:quikrbox/widgets/custom_image_view.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class BuildStore extends StatelessWidget {
//   const BuildStore({
//     Key? key,
//     required this.store,
//   }) : super(key: key);
//
//   final Store store;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: getPadding(
//         top: 5,
//         bottom: 5,
//       ),
//       decoration: AppDecoration.outlineGray30001.copyWith(
//         borderRadius: BorderRadiusStyle.roundedBorder16,
//       ),
//       child: InkWell(
//         onTap: () {
//           Get.toNamed(AppRoutes.storepageScreen, arguments: store);
//         },
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 CustomImageView(
//                   url: store.logo,
//                   imagePath: Assets.images.imageNotFound.path,
//                   height: getSize(
//                     72.00,
//                   ),
//                   width: getSize(
//                     72.00,
//                   ),
//                   radius: BorderRadius.circular(
//                     getHorizontalSize(
//                       5.00,
//                     ),
//                   ),
//                   margin: getMargin(
//                     top: 5,
//                     left: 5,
//                     right: 10,
//                     bottom: 5,
//                   ),
//                   alignment: Alignment.center,
//                 ).opacity(value: store.storeClosed() ? 0.5 : 1),
//                 Visibility(
//                     visible: (store.storeClosed()),
//                     child: "Store \nClosed".text.center.size(12).make()),
//               ],
//             ).box.width(74).height(74).make(),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       store.name ?? "n/a",
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.left,
//                       style: AppStyle.txtPoppinsMedium12Black900.copyWith(
//                         letterSpacing: getHorizontalSize(
//                           0.36,
//                         ),
//                         height: getVerticalSize(
//                           1.00,
//                         ),
//                       ),
//                     ).expand(),
//                     Text(
//                       "${store.distance?.toStringAsFixed(2) ?? "1"} km",
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.left,
//                       style: AppStyle.txtPoppinsMedium14Gray90002.copyWith(
//                         letterSpacing: getHorizontalSize(
//                           0.30,
//                         ),
//                         height: getVerticalSize(
//                           1.00,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 10.heightBox,
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           store.storeAddress ?? "n/a",
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.left,
//                           style:
//                               AppStyle.txtPoppinsMedium10Bluegray400.copyWith(
//                             letterSpacing: getHorizontalSize(
//                               0.30,
//                             ),
//                             height: getVerticalSize(
//                               1.00,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: getPadding(
//                             top: 20,
//                           ),
//                           child: Row(
//                             children: [
//                               Text(
//                                 "${store.storeClosed() ? "Closed" : "Open"}",
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left,
//                                 style: AppStyle.txtPoppinsMedium12Orange700
//                                     .copyWith(
//                                   letterSpacing: getHorizontalSize(
//                                     0.30,
//                                   ),
//                                   color: ColorConstant.greenA700,
//                                   height: getVerticalSize(
//                                     1.00,
//                                   ),
//                                 ),
//                               ),
//                               5.widthBox,
//                               Text(
//                                 store.storeClosed()
//                                     ? "This store closed at ${store.getClosingTime()}"
//                                     : "Will closes at ${store.getClosingTime()}",
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left,
//                                 style:
//                                     AppStyle.txtPoppinsMedium12Gray600.copyWith(
//                                   letterSpacing: getHorizontalSize(
//                                     0.30,
//                                   ),
//                                   height: getVerticalSize(
//                                     1.00,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ).expand(),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text(
//                           "${store.estimateDeliveryTime}".tr,
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.left,
//                           style:
//                               AppStyle.txtPoppinsSemiBold16Amber90003.copyWith(
//                             letterSpacing: getHorizontalSize(
//                               0.48,
//                             ),
//                             height: getVerticalSize(
//                               1.00,
//                             ),
//                           ),
//                         ),
//                         Text(
//                           "lbl_min".tr,
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.left,
//                           style: AppStyle.txtPoppinsMedium10Amber90003.copyWith(
//                             letterSpacing: getHorizontalSize(
//                               0.30,
//                             ),
//                             height: getVerticalSize(
//                               1.00,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ).expand(),
//             10.widthBox,
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Widget buildOfferList(List<Store> stores) {
//   return ListView.builder(
//       itemCount: stores.length,
//       scrollDirection: Axis.horizontal,
//       itemBuilder: ((context, index) {
//         final store = stores[index];
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CustomImageView(
//               url: store.logo,
//               width: 84,
//               height: 84,
//             ).p(5).box.border(color: Vx.gray200).rounded.make(),
//             10.heightBox,
//             buildSubTitle(store.name ?? "n/a").h(30),
//             "${store.estimateDeliveryTime ?? "0"} mins"
//                 .tr
//                 .text
//                 .textStyle(AppStyle.txtPoppinsMedium10Orange700.copyWith(
//                   letterSpacing: getHorizontalSize(
//                     0.30,
//                   ),
//                   height: getVerticalSize(
//                     1.00,
//                   ),
//                 ))
//                 .make()
//           ],
//         ).w(85).marginAll(5).onInkTap(() {
//           Get.toNamed(AppRoutes.storepageScreen, arguments: store);
//         });
//       })).h(160);
// }
