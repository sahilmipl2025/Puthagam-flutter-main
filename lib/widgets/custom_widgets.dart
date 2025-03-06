// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// Widget buildSkeltion() {
//   return Container(
//     height: 60,
//     width: Get.width,
//     decoration: BoxDecoration(
//         color: ColorConstant.amber900, borderRadius: BorderRadius.circular(10)),
//     margin: getMargin(
//       left: 16,
//       top: 28,
//       right: 16,
//     ),
//   );
// }
//
// buildManageAppBar(String label) {
//   return CustomAppBar(
//       height: getVerticalSize(76.00),
//       leadingWidth: 65,
//       leading: AppbarIconbutton1(
//           svgPath: Assets.images.svgArrowleftBluecolor,
//           margin: getMargin(left: 17, top: 12, bottom: 16),
//           onTap: () {
//             Get.back();
//           }),
//       title: AppbarSubtitle(text: label, margin: getMargin(left: 10)),
//       styleType: Style.bgShadowLightgreenA7003f);
// }
//
// Row buildSlideShow(List<String> images, {bool isPng = false}) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       ImageSlideshow(
//         width: 358,
//         height: 132,
//         indicatorColor: ColorConstant.amber400,
//         initialPage: 0,
//         children: List.generate(images.length, (index) {
//           final banner = images[index];
//           return Padding(
//             padding: const EdgeInsets.only(right: 5),
//             child: CustomImageView(
//               url: banner,
//               fit: BoxFit.contain,
//             ),
//           );
//         }),
//         autoPlayInterval: 3000,
//         isLoop: images.length > 1 ? true : false,
//       ),
//     ],
//   );
// }
//
// class BuildViewBasket extends StatelessWidget {
//   const BuildViewBasket({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (cartItems.isEmpty) {
//         return SizedBox();
//       }
//       double total = 0.0;
//       cartItems.forEach((element) {
//         total = total +
//             (double.parse(element.product?.offerPrice ??
//                     element.product!.sellingPrice!) *
//                 element.quantity!);
//       });
//       return Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           (cartItems.first.store?.orderMinAmount ?? 0) > total
//               ? "Add ${getCurrentCountry().currencySymbol}${(cartItems.first.store?.orderMinAmount ?? 0) - total} more to be able to place your order"
//                   .text
//                   .white
//                   .bold
//                   .make()
//               : SizedBox(),
//           Row(
//             children: [
//               "${cartItems.length} Item".text.white.make(),
//               20.widthBox,
//               "${getCurrentCountry().currency} ${total}".text.white.make(),
//               Spacer(),
//               OutlinedButton(
//                   onPressed: () {
//                     Get.offAllNamed(AppRoutes.homeContainerScreen,
//                         arguments: "lbl_basket".tr);
//                   },
//                   child: "View Basket".text.white.make())
//             ],
//           ),
//         ],
//       ).p(15).box.color(ColorConstant.amber900).make();
//     });
//   }
// }
