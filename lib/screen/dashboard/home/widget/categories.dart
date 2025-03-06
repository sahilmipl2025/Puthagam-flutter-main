import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/category/get_subcategory_list_api.dart';
import 'package:puthagam/data/api/category_book/get_category_books_api.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/category_book/category_book_screen.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/shimmer_tile.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final HomeController con = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'categories'.tr,
                style: TextStyle(
                  fontSize: isTablet ? 18 : 14,
                  fontWeight: FontWeight.w500,
                  color: commonBlueColor,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await Get.toNamed(AppRoutes.selectTopicsScreen,
                      arguments: true);
                  setState(() {});
                },
                child: Text(
                  'View more',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: borderColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isTablet ? 24 : 20),
        Obx(
          () => SizedBox(
            height: isTablet ? 110 : 97,
            width: double.infinity,
            child: con.categoryLoading.value
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return ShimmerTile(
                        margin: const EdgeInsets.only(right: 0),
                        height: isTablet ? 105 : 90,
                        width: isTablet ? 105 : 90,
                      ).marginAll(isTablet ? 14 : 10);
                    })
                : con.categoryList.isEmpty
                    ? Center(
                        child: Text(
                          'noCategoryFound'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: isTablet ? 21 : 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: con.categoryList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          print("categoryimage${con
                                                            .categoryList[index]
                                                            .image}");
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                    right: 5,
                                  ),
                                  child: con.categoryList[index].isSelected!
                                              .value ==
                                          true
                                      ? SizedBox(
                                          width: (Get.width / 4) - 5,
                                          child: Center(
                                            child: InkWell(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                getSubcategoryApi(con
                                                        .categoryList[index]
                                                        .id ??
                                                    "");
                                                getCategoryBooksApi(
                                                  categoryId: con
                                                          .categoryList[index]
                                                          .id ??
                                                      "",
                                                  pagination: false,
                                                );
                                                Get.to(() => CategoryBookScreen(
                                                    categoryId: con
                                                        .categoryList[index].id
                                                        .toString(),
                                                    categoryImage: con
                                                            .categoryList[index]
                                                            .image ??
                                                        "",
                                                    categoryName: con
                                                            .categoryList[index]
                                                            .name ??
                                                        ""));
                                              },
                                              child: Column(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: con
                                                            .categoryList[index]
                                                            .image ??
                                                        "",
                                                    width: isTablet ? 105 : 90,
                                                    height: isTablet ? 55 : 45,
                                                    placeholder: (b, c) {
                                                      return SizedBox(
                                                        width:
                                                            isTablet ? 105 : 90,
                                                        height:
                                                            isTablet ? 55 : 45,
                                                      );
                                                    },
                                                    errorWidget: (c, v, s) {
                                                      return Container(
                                                        width:
                                                            isTablet ? 105 : 90,
                                                        height:
                                                            isTablet ? 55 : 45,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.grey
                                                              .withOpacity(.2),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          isTablet ? 14 : 12),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom:
                                                            isTablet ? 10 : 8),
                                                    child: Text(
                                                      con.categoryList[index]
                                                              .name ??
                                                          "",
                                                      style: TextStyle(
                                                        fontSize:
                                                            isTablet ? 14 : 12,
                                                        color: text23,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox()),
                            ],
                          );
                        }),
          ),
        ),
      ],
    );
  }
}
