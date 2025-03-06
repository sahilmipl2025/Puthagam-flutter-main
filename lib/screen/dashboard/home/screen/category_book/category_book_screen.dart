import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/category_book/get_category_books_api.dart';
import 'package:puthagam/data/api/library/delete_saved_book_api.dart';
import 'package:puthagam/data/api/library/saved_book_api.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/category_book/category_book_controller.dart';
import 'package:puthagam/screen/dashboard/home/widget/book_tile.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/global.dart';
import 'package:puthagam/utils/themes/no_internet_screen.dart';

class CategoryBookScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImage;

  CategoryBookScreen(
      {Key? key,
      required this.categoryId,
      required this.categoryName,
      required this.categoryImage})
      : super(key: key);

  final CategoryBookController con = Get.put(CategoryBookController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          gradient: verticalGradient,
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          gradient: verticalGradient,
                        ),
                        padding: EdgeInsets.only(left: isTablet ? 20 : 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: isTablet ? 10 : 6),
                            InkWell(
                              onTap: () => Get.back(),
                              child: Icon(
                                Icons.arrow_back,
                                color: GlobalService.to.isDarkModel == true
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            SizedBox(height: isTablet ? 20 : 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: isTablet ? 45 : 40,
                                          width: isTablet ? 45 : 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                categoryImage,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: isTablet ? 12 : 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                             // height: 40,
                                            width: 270,
                                              child: Text(
                                                categoryName,
                                                maxLines: 3,
                                                style: TextStyle(
                                                  fontSize: isTablet ? 17 : 15,
                                                  
                                                  fontWeight: FontWeight.w500,
                                                  overflow: TextOverflow
                                                              .ellipsis,
                                                        
                                                ),
                                              ),
                                            ),
                                            Obx(
                                              () => con.isLoading.value
                                                  ? const SizedBox()
                                                  : Text(
                                                      con.totalBooks.value <= 1
                                                          ? con.totalBooks.value
                                                                  .toString() +
                                                              " " +
                                                              "Book"
                                                          : con.totalBooks.value
                                                                  .toString() +
                                                              " " +
                                                              "books".tr,
                                                      style: TextStyle(
                                                        fontSize:
                                                            isTablet ? 15 : 13,
                                                        color: text23,
                                                        // color: textColor,
                                                      ),
                                                    ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: isTablet ? 16 : 12),
                                  child: InkWell(
                                    onTap: () => filterSheet(
                                        context: context,
                                        categoryId: categoryId),
                                    child: Icon(
                                      Icons.filter_list,
                                      color: textColor,
                                      size: isTablet ? 34 : 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isTablet ? 16 : 16),
                          ],
                        ),
                      )),
                  Expanded(
                    child: Obx(
                      () => con.isLoading.value
                          ? const Center(child: AppLoader())
                          : con.isConnected.isFalse
                              ? NoInternetScreen(onTap: () async {
                                  bool connection = await checkConnection();
                                  if (connection) {
                                    con.isConnected.value = true;
                                    getCategoryBooksApi(
                                      pagination: false,
                                      categoryId: con.categoryId.value,
                                    );
                                  } else {
                                    con.isConnected.value = false;
                                  }
                                })
                              : con.booksList.isEmpty
                                  ? Center(
                                      child: Text(
                                        "No book found",
                                        style: TextStyle(
                                          fontSize: isTablet ? 24 : 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            controller: con.newScrollController,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: con.booksList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Obx(() => BookTile(
                                                    isPaid: con.booksList[index]
                                                        .isPaid,
                                                        isPremium: con.booksList[index].isPremium,
                                                    title: con.booksList[index]
                                                            .title ??
                                                        "",
                                                    imageUrl: con
                                                            .booksList[index]
                                                            .image ??
                                                        "",
                                                    authorName: con
                                                            .booksList[index]
                                                            .authorName ??
                                                        "",
                                                    totalListen: con
                                                        .booksList[index]
                                                        .listenCount
                                                        .toString(),
                                                    saveCount: con
                                                        .booksList[index]
                                                        .saveCount
                                                        .toString(),
                                                    rating: int.parse(con
                                                        .booksList[index]
                                                        .rating!
                                                        .round()
                                                        .toString()),
                                                    caption: con
                                                            .booksList[index]
                                                            .caption ??
                                                        "",
                                                    categoryName: con
                                                            .booksList[index]
                                                            .categoryName ??
                                                        "",
                                                    showRating: con
                                                                .booksList[
                                                                    index]
                                                                .isSaved!
                                                                .value ==
                                                            true
                                                        ? true
                                                        : false,
                                                    savedOnTap: () {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      if (con.booksList[index]
                                                          .isSaved!.value) {
                                                        deleteSavedBookApi(
                                                          index: index,
                                                          bookId: con
                                                              .booksList[index]
                                                              .id,
                                                          fromCategory: true,
                                                          fromSaved: false,
                                                        );
                                                      } else {
                                                        savedBookApi(
                                                          index: index,
                                                          bookId: con
                                                              .booksList[index]
                                                              .id,
                                                          fromCategory: true,
                                                        );
                                                      }
                                                    },
                                                    onTap: () {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      Get.find<
                                                              BookDetailController>()
                                                          .callApis(
                                                              bookID: con
                                                                  .booksList[
                                                                      index]
                                                                  .id);
                                                      Get.toNamed(
                                                          AppRoutes
                                                              .bookDetailScreen,
                                                          arguments: con
                                                              .booksList[index]
                                                              .id);
                                                    },
                                                  ));
                                            },
                                          ),
                                        ),
                                        con.paginationLoading.value
                                            ? const Center(child: AppLoader())
                                            : const SizedBox()
                                      ],
                                    ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => con.savedLoading.value
                ? Container(
                    color: Colors.grey.withOpacity(0.5),
                    child: const AppLoader(),
                  )
                : const SizedBox())
          ],
        ),
      ),
    );
  }

  /// Books Filer Sheet

  filterSheet({context, categoryId}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        barrierColor: const Color.fromARGB(255, 167, 219, 244).withOpacity(.2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                height: Get.height * 0.40,
                decoration: BoxDecoration(
                  gradient: verticalGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isTablet ? 36 : 25.0),
                    topRight: Radius.circular(isTablet ? 36 : 25.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(isTablet ? 16 : 12.0),
                        child: Container(
                          height: isTablet ? 7 : 5,
                          alignment: Alignment.center,
                          width: isTablet ? 42 : 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(isTablet ? 16 : 10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                con.selectedSubCatId.value = "";
                                con.selectedAuthorId.value = "";
                                con.status1.value = false;
                                con.status2.value = false;
                              });
                              getCategoryBooksApi(
                                categoryId: categoryId,
                                pagination: false,
                              );
                              con.update();
                              Get.back();
                            },
                            child: Text(
                              'reset'.tr,
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                              ),
                            ),
                          ),
                          Text(
                            'filter'.tr,
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              getCategoryBooksApi(
                                categoryId: categoryId,
                                pagination: false,
                              );
                            },
                            child: Text(
                              'done'.tr,
                              style: TextStyle(
                                fontSize: isTablet ? 17 : 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: isTablet ? 3 : 2, color: Colors.white),
                    // Get.find<HomeController>().subCategoryList.isNotEmpty
                    //     ? Container(
                    //         alignment: Alignment.centerLeft,
                    //         child: Padding(
                    //           padding:  EdgeInsets.all(8),
                    //           child: Text(
                    //             'subCate'.tr,
                    //             style:  TextStyle(
                    //               fontSize: 17,
                    //               fontFamily: '.SF Pro Display-Regular',
                    //               fontWeight: FontWeight.w700,
                    //             ),
                    //             textAlign: TextAlign.left,
                    //           ),
                    //         ),
                    //       )
                    //     :  SizedBox(),
                    Get.find<HomeController>().subCategoryList.isNotEmpty
                        ? SizedBox(
                            height: isTablet ? 60 : 50,
                            child: ListView.builder(
                                itemCount: Get.find<HomeController>()
                                    .subCategoryList
                                    .length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          con.selectedSubCatId.value =
                                              Get.find<HomeController>()
                                                  .subCategoryList[index]
                                                  .id
                                                  .toString();
                                        });
                                        con.update();
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          padding:
                                              EdgeInsets.all(isTablet ? 12 : 8),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: isTablet ? 3 : 2,
                                                  color: con.selectedSubCatId
                                                              .value ==
                                                          Get.find<
                                                                  HomeController>()
                                                              .subCategoryList[
                                                                  index]
                                                              .id
                                                      ? buttonColor
                                                      : borderColor),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      isTablet ? 11 : 8))),
                                          child: Center(
                                            child: Text(
                                              Get.find<HomeController>()
                                                      .subCategoryList[index]
                                                      .name ??
                                                  "",
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: isTablet ? 16 : 14,
                                                fontFamily:
                                                    '.SF Pro Display-Regular',
                                                color: con.selectedSubCatId
                                                            .value ==
                                                        Get.find<
                                                                HomeController>()
                                                            .subCategoryList[
                                                                index]
                                                            .id
                                                    ? buttonColor
                                                    : textColor,
                                              ),
                                            ),
                                          )),
                                    ),
                                  );
                                }),
                          )
                        : const SizedBox(),
                    SizedBox(height: isTablet ? 16 : 12),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: isTablet ? 14 : 10),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(isTablet ? 12 : 8),
                              child: Text(
                                'sortBy'.tr,
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(isTablet ? 12 : 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'listeners'.tr,
                                  style: TextStyle(
                                    fontSize: isTablet ? 16 : 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(height: isTablet ? 14 : 10.0),
                                Obx(
                                  () => FlutterSwitch(
                                    padding: 1.0,
                                    width: isTablet ? 56 : 50,
                                    height: isTablet ? 29 : 25,
                                    activeIcon: Icon(
                                      Icons.check,
                                      size: isTablet ? 24 : 20,
                                      color: commonBlueColor,
                                    ),
                                    inactiveIcon: Icon(
                                      Icons.check,
                                      size: isTablet ? 24 : 20,
                                      color: Colors.white,
                                    ),
                                    inactiveColor: borderColor,
                                    activeColor: commonBlueColor,
                                    value: con.status1.value,
                                    onToggle: (val) {
                                      con.status1.value = val;
                                      con.status2.value = false;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isTablet ? 12 : 8),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 12 : 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'downlods'.tr,
                                  style: TextStyle(
                                    fontSize: isTablet ? 16 : 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(height: isTablet ? 14 : 10.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Obx(() => FlutterSwitch(
                                          width: isTablet ? 56 : 50,
                                          height: isTablet ? 29 : 25,
                                          activeIcon: Icon(
                                            Icons.check,
                                            size: isTablet ? 24 : 20,
                                            color: commonBlueColor,
                                          ),
                                          inactiveIcon: Icon(
                                            Icons.check,
                                            size: isTablet ? 24 : 20,
                                            color: Colors.white,
                                          ),
                                          inactiveColor: borderColor,
                                          activeColor: commonBlueColor,
                                          padding: 1,
                                          value: con.status2.value,
                                          onToggle: (val) {
                                            con.status2.value = val;
                                            con.status1.value = false;
                                          },
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isTablet ? 24 : 20)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
