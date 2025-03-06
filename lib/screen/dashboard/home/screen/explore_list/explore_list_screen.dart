import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/explore_list/explore_list_controller.dart';
import 'package:puthagam/screen/dashboard/home/widget/book_tile.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/global.dart';
import 'package:puthagam/utils/themes/no_internet_screen.dart';

class ExploreListScreen extends StatelessWidget {
  ExploreListScreen({Key? key}) : super(key: key);
  final ExploreListController con = Get.put(ExploreListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: horizontalGradient),
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back,
            color: GlobalService.to.isDarkModel == true
                ? Colors.white
                : Colors.black,
          ),
        ),
        title: Text(
          'Explore',
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 19 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: isTablet ? 16 : 12,
                top: isTablet ? 6 : 4,
                bottom: isTablet ? 6 : 4),
            child: InkWell(
              onTap: () => filterSheet(context: context),
              child: Icon(
                Icons.filter_list,
                color: textColor,
                size: isTablet ? 34 : 30,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(gradient: verticalGradient),
        child: Obx(
          () => con.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : con.isConnected.isFalse
                  ? NoInternetScreen(onTap: () async {
                      bool connection = await checkConnection();
                      if (connection) {
                        con.isConnected.value = true;
                        con.getExploreListApi(pagination: false);
                      } else {
                        con.isConnected.value = false;
                      }
                    })
                  : Column(
                      children: [
                        con.bookList.isEmpty
                            ? Expanded(
                                child: Center(
                                  child: Text(
                                    "No book found",
                                    style: TextStyle(
                                      fontSize: isTablet ? 29 : 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : Flexible(
                                child: ListView.builder(
                                    controller: con.newScrollController,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: con.bookList.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Obx(() => BookTile(
                                            isPaid: con.bookList[index].isPaid,
                                            isPremium: con.bookList[index].isPremium,
                                            title:
                                                con.bookList[index].title ?? "",
                                            imageUrl:
                                                con.bookList[index].image ?? "",
                                            authorName: con.bookList[index]
                                                    .authorName ??
                                                "",
                                            totalListen: con
                                                .bookList[index].listenCount
                                                .toString(),
                                            saveCount: con
                                                .bookList[index].saveCount
                                                .toString(),
                                            rating: int.parse(con
                                                .bookList[index].rating!
                                                .round()
                                                .toString()),
                                            caption:
                                                con.bookList[index].caption ??
                                                    "",
                                            categoryName: con.bookList[index]
                                                    .categoryName ??
                                                "",
                                            showRating: con.bookList[index]
                                                        .isSaved!.value ==
                                                    true
                                                ? true
                                                : false,
                                            savedOnTap: () {
                                              FocusScope.of(context).unfocus();
                                              if (con.bookList[index].isSaved!
                                                  .value) {
                                                con.deleteSavedBookApi(
                                                  index: index,
                                                  bookId:
                                                      con.bookList[index].id,
                                                );
                                              } else {
                                                con.savedBookApi(
                                                  index: index,
                                                  bookId:
                                                      con.bookList[index].id,
                                                );
                                              }
                                            },
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              Get.find<BookDetailController>()
                                                  .callApis(
                                                      bookID: con
                                                          .bookList[index].id);
                                              Get.toNamed(
                                                  AppRoutes.bookDetailScreen,
                                                  arguments:
                                                      con.bookList[index].id);
                                            },
                                          ));
                                    }),
                              ),
                        Obx(() => con.paginationLoading.value
                            ? Center(
                                child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    height: isTablet ? 30 : 24,
                                    width: isTablet ? 30 : 24,
                                    child: const CircularProgressIndicator(
                                        strokeWidth: 3)),
                              )
                            : const SizedBox())
                      ],
                    ),
        ),
      ),
    );
  }

  /// Books Filer Sheet

  filterSheet({context}) {
    showModalBottomSheet(
        barrierColor: const Color.fromARGB(255, 167, 219, 244).withOpacity(.2),
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                height: Get.height * 0.5,
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
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: isTablet ? 7 : 5,
                          alignment: Alignment.center,
                          width: isTablet ? 44 : 35,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
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
                                con.selectedAuthorId.value = "";
                                con.status1.value = false;
                                con.status2.value = false;
                              });
                              con.getExploreListApi(pagination: false);
                              con.update();
                              Get.back();
                            },
                            child: Text(
                              'reset'.tr,
                              style: TextStyle(
                                fontSize: isTablet ? 17 : 15,
                              ),
                            ),
                          ),
                          Text(
                            'filter'.tr,
                            style: TextStyle(
                              fontSize: isTablet ? 19 : 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              con.getExploreListApi(pagination: false);
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
                    const Divider(height: 2, color: Colors.white),
                    // Get.find<HomeController>().subCategoryList.isNotEmpty
                    //     ? Container(
                    //         alignment: Alignment.centerLeft,
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(8),
                    //           child: Text(
                    //             'subCate'.tr,
                    //             style: const TextStyle(
                    //               fontSize: 17,
                    //               fontWeight: FontWeight.w700,
                    //             ),
                    //             textAlign: TextAlign.left,
                    //           ),
                    //         ),
                    //       )
                    //     : const SizedBox(),
                    // Get.find<HomeController>().subCategoryList.isNotEmpty
                    //     ? SizedBox(
                    //         height: 50,
                    //         child: ListView.builder(
                    //             itemCount: Get.find<HomeController>()
                    //                 .subCategoryList
                    //                 .length,
                    //             scrollDirection: Axis.horizontal,
                    //             itemBuilder: (BuildContext context, int index) {
                    //               return Padding(
                    //                 padding: const EdgeInsets.only(left: 12),
                    //                 child: InkWell(
                    //                   onTap: () {
                    //                     setState(() {
                    //                       con.selectedSubCatId.value =
                    //                           Get.find<HomeController>()
                    //                               .subCategoryList[index]
                    //                               .id
                    //                               .toString();
                    //                     });
                    //                     con.update();
                    //                   },
                    //                   child: Container(
                    //                       alignment: Alignment.center,
                    //                       padding: const EdgeInsets.all(8),
                    //                       decoration: BoxDecoration(
                    //                           border: Border.all(
                    //                               width: 2,
                    //                               color: con.selectedSubCatId
                    //                                           .value ==
                    //                                       Get.find<
                    //                                               HomeController>()
                    //                                           .subCategoryList[
                    //                                               index]
                    //                                           .id
                    //                                   ? buttonColor
                    //                                   : borderColor),
                    //                           borderRadius:
                    //                               const BorderRadius.all(
                    //                                   Radius.circular(8))),
                    //                       child: Center(
                    //                         child: Text(
                    //                           Get.find<HomeController>()
                    //                                   .subCategoryList[index]
                    //                                   .name ??
                    //                               "",
                    //                           maxLines: 1,
                    //                           style: TextStyle(
                    //                             fontSize: 18,
                    //                             fontFamily:
                    //                                 '.SF Pro Display-Regular',
                    //                             color: con.selectedSubCatId
                    //                                         .value ==
                    //                                     Get.find<
                    //                                             HomeController>()
                    //                                         .subCategoryList[
                    //                                             index]
                    //                                         .id
                    //                                 ? buttonColor
                    //                                 : textColor,
                    //                           ),
                    //                         ),
                    //                       )),
                    //                 ),
                    //               );
                    //             }),
                    //       )
                    //     : const SizedBox(),
                    // Get.find<HomeController>().subCategoryList.isNotEmpty
                    //     ? const SizedBox(height: 16)
                    //     : const SizedBox(),

                    SizedBox(height: isTablet ? 16 : 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'listeners'.tr,
                                  style: TextStyle(
                                    fontSize: isTablet ? 17 : 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 10.0),
                                Obx(
                                  () => FlutterSwitch(
                                    width: isTablet ? 60 : 50,
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
                                    padding: 1,
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
                                    fontSize: isTablet ? 17 : 15,
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
                                          width: isTablet ? 60 : 50,
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
                          SizedBox(height: isTablet ? 12 : 8),
                          Divider(height: 2, color: borderColor),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'author'.tr,
                                style: const TextStyle(
                                  fontFamily: '.SF Pro Display-Medium',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 130,
                            child: ListView.builder(
                                itemCount: Get.find<HomeController>()
                                    .creatorList
                                    .length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        con.selectedAuthorId.value =
                                            Get.find<HomeController>()
                                                .creatorList[index]
                                                .id
                                                .toString();
                                      });
                                      con.update();
                                    },
                                    child: Container(
                                      height: 130,
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 12),
                                      width: 120,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 75,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(Get.find<
                                                              HomeController>()
                                                          .creatorList[index]
                                                          .image ??
                                                      ""),
                                                  fit: BoxFit.contain),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4)),
                                              border: Border.all(
                                                width: con.selectedAuthorId
                                                            .value ==
                                                        Get.find<
                                                                HomeController>()
                                                            .creatorList[index]
                                                            .id
                                                    ? 2
                                                    : 1,
                                                color: con.selectedAuthorId
                                                            .value ==
                                                        Get.find<
                                                                HomeController>()
                                                            .creatorList[index]
                                                            .id
                                                    ? commonBlueColor
                                                    : Colors.grey.shade300,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            Get.find<HomeController>()
                                                    .creatorList[index]
                                                    .name ??
                                                "",
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: con.selectedAuthorId
                                                          .value ==
                                                      Get.find<HomeController>()
                                                          .creatorList[index]
                                                          .id
                                                  ? commonBlueColor
                                                  : Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(height: isTablet ? 24 : 20)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}
