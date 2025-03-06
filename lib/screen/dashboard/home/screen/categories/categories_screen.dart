import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/category_book/get_category_books_api.dart';
import 'package:puthagam/data/api/category/get_subcategory_list_api.dart';
import 'package:puthagam/screen/dashboard/home/screen/categories/categoies_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/category_book/category_book_screen.dart';
import 'package:puthagam/utils/colors.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({Key? key}) : super(key: key);

  final CategoriesController con = Get.put(CategoriesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        decoration: BoxDecoration(gradient: verticalGradient),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
        height: Get.height,
        width: Get.width,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: SizedBox(),
                  ),
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const Expanded(
                    flex: 4,
                    child: SizedBox(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(
                    () => con.categoryList.isEmpty
                        ? SizedBox(
                            height: Get.height * 0.8,
                            child: const Center(
                              child: Text(
                                "No category found",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        : GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 12),
                            shrinkWrap: true,
                            itemCount: con.categoryList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.96,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Obx(
                                () => InkWell(
                                  onTap: () {
                                    getSubcategoryApi(
                                        con.categoryList[index].id ?? "");
                                    getCategoryBooksApi(
                                      categoryId:
                                          con.categoryList[index].id ?? "",
                                      pagination: false,
                                    );
                                    Get.to(() => CategoryBookScreen(
                                        categoryId: con.categoryList[index].id
                                            .toString(),
                                        categoryImage:
                                            con.categoryList[index].image ?? "",
                                        categoryName:
                                            con.categoryList[index].name ??
                                                ""));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Flexible(
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl: con
                                                        .categoryList[index]
                                                        .image ??
                                                    "",
                                                placeholder: (b, c) {
                                                  return const SizedBox();
                                                },
                                                fit: BoxFit.fill,
                                              )),
                                        ),
                                        const SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Text(
                                              con.categoryList[index].name ??
                                                  "",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: text23,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
