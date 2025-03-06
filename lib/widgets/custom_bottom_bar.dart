// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';
// import 'package:badges/badges.dart' as badges;
//
// class CustomBottomBar extends StatelessWidget {
//   CustomBottomBar({
//     this.onChanged,
//   });
//   final HomeContainerController homeController = Get.find();
//
//   List<BottomMenuModel> bottomMenuList = [
//     BottomMenuModel(
//       icon: Assets.images.svgHomeBluegrey,
//       title: "lbl_home".tr,
//       type: BottomBarEnum.Home,
//     ),
//     BottomMenuModel(
//       icon: Assets.images.svgAddBucket,
//       title: "lbl_order".tr,
//       type: BottomBarEnum.Order,
//     ),
//     BottomMenuModel(
//       icon: Assets.images.svgQuickmart,
//       title: "lbl_quikrmart2".tr,
//       type: BottomBarEnum.Quikrmart2,
//     ),
//     BottomMenuModel(
//       icon: Assets.images.svgSingleUser,
//       title: "lbl_profile".tr,
//       type: BottomBarEnum.Profile,
//     ),
//     BottomMenuModel(
//       icon: Assets.images.svgBucketBlue,
//       title: "lbl_basket".tr,
//       type: BottomBarEnum.Basket,
//     )
//   ];
//
//   Function(BottomBarEnum)? onChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Container(
//         margin: getMargin(
//           left: 2,
//         ),
//         decoration: BoxDecoration(
//           color: ColorConstant.whiteA700,
//           boxShadow: [
//             BoxShadow(
//               color: ColorConstant.blueGray3000f,
//               spreadRadius: getHorizontalSize(
//                 2.00,
//               ),
//               blurRadius: getHorizontalSize(
//                 2.00,
//               ),
//               offset: Offset(
//                 0,
//                 -8,
//               ),
//             ),
//           ],
//         ),
//         child: BottomNavigationBar(
//           backgroundColor: Colors.transparent,
//           showSelectedLabels: false,
//           showUnselectedLabels: false,
//           elevation: 0,
//           selectedFontSize: 0,
//           currentIndex: homeController.silderIndex.value,
//           type: BottomNavigationBarType.fixed,
//           items: List.generate(bottomMenuList.length, (index) {
//             return BottomNavigationBarItem(
//               backgroundColor: Colors.transparent,
//               icon: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Obx(() {
//                     return badges.Badge(
//                       badgeContent: "${totalCartItem.value}".text.white.make(),
//                       showBadge: bottomMenuList[index].title == "lbl_basket".tr,
//                       child: CustomImageView(
//                         svgPath: bottomMenuList[index].icon,
//                         height: getSize(
//                           25.00,
//                         ),
//                         width: getSize(
//                           25.00,
//                         ),
//                         color: ColorConstant.blueGray500,
//                       ),
//                     );
//                   }),
//                   Padding(
//                     padding: getPadding(
//                       top: 3,
//                     ),
//                     child: Text(
//                       bottomMenuList[index].title ?? "",
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.left,
//                       style: AppStyle.txtPoppinsRegular10Bluegray500.copyWith(
//                         height: getVerticalSize(
//                           1.00,
//                         ),
//                         color: ColorConstant.blueGray500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               activeIcon: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Obx(() {
//                     return badges.Badge(
//                       badgeContent: "${totalCartItem.value}".text.white.make(),
//                       showBadge: bottomMenuList[index].title == "lbl_basket".tr,
//                       child: CustomImageView(
//                         svgPath: bottomMenuList[index].icon,
//                         height: getSize(
//                           24.00,
//                         ),
//                         width: getSize(
//                           24.00,
//                         ),
//                         color: ColorConstant.amber90003,
//                       ),
//                     );
//                   }),
//                   Padding(
//                     padding: getPadding(
//                       top: 4,
//                     ),
//                     child: Text(
//                       bottomMenuList[index].title ?? "",
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.left,
//                       style: AppStyle.txtPoppinsSemiBold10Amber90003.copyWith(
//                         height: getVerticalSize(
//                           1.00,
//                         ),
//                         color: ColorConstant.amber90003,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               label: '',
//             );
//           }),
//           onTap: (index) {
//             homeController.silderIndex.value = index;
//             onChanged!(bottomMenuList[index].type);
//           },
//         ),
//       ),
//     );
//   }
// }
//
// enum BottomBarEnum {
//   Home,
//   Order,
//   Quikrmart2,
//   Profile,
//   Basket,
// }
//
// class BottomMenuModel {
//   BottomMenuModel({required this.icon, this.title, required this.type});
//
//   String icon;
//
//   String? title;
//
//   BottomBarEnum type;
// }
//
// class DefaultWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.all(10),
//       child: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Please replace the respective Widget here',
//               style: TextStyle(
//                 fontSize: 18,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
