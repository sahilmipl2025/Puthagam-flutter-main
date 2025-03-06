import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/collection_books/collection_books_controller.dart';
import 'package:puthagam/screen/dashboard/home/widget/book_tile.dart';
import 'package:puthagam/screen/dashboard/library/collections/collection_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/no_internet_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class CollectionBooksScreen extends StatelessWidget {
  CollectionBooksScreen({Key? key}) : super(key: key);

  final CollectionBooksController con = Get.put(CollectionBooksController());

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Get.theme;
    return Theme(
      data: theme.copyWith(
        appBarTheme: theme.appBarTheme.copyWith(
          backgroundColor: theme.colorScheme.tertiary,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: horizontalGradient),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                con.name.value,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 22 : 19,
                    fontWeight: FontWeight.w500),
              ),
              5.heightBox,
              Obx(
                () => Text(
                  con.totalCount.value <= 1
                      ? con.totalCount.value.toString() + " " + "Book"
                      : con.totalCount.value.toString() + " " + "books".tr,
                  style: TextStyle(
                      fontSize: isTablet ? 18 : 14, color: Colors.white),
                ),
              )
            ],
          ),
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
                          con.getExploreListApi();
                        } else {
                          con.isConnected.value = false;
                        }
                      })
                    : Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  con.bookList.isEmpty
                                      ? Expanded(
                                          child: Center(
                                            child: Text(
                                              "No book found",
                                              style: TextStyle(
                                                fontSize: isTablet ? 29 : 25,
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    'SF-Pro-Display-Semibold',
                                                // color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  child: ListView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          con.bookList.length,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Obx(
                                                            () => BookTile(
                                                                  isPaid: con
                                                                      .bookList[
                                                                          index]
                                                                      .isPaid,
                                                                      isPremium: con.bookList[index].isPremium,
                                                                  title: con
                                                                          .bookList[
                                                                              index]
                                                                          .title ??
                                                                      "",
                                                                  imageUrl: con
                                                                          .bookList[
                                                                              index]
                                                                          .image ??
                                                                      "",
                                                                  authorName: con
                                                                          .bookList[
                                                                              index]
                                                                          .authorName ??
                                                                      "",
                                                                  totalListen: con
                                                                      .bookList[
                                                                          index]
                                                                      .listenCount
                                                                      .toString(),
                                                                  saveCount: con
                                                                      .bookList[
                                                                          index]
                                                                      .saveCount
                                                                      .toString(),
                                                                  rating: int.parse(con
                                                                      .bookList[
                                                                          index]
                                                                      .rating!
                                                                      .round()
                                                                      .toString()),
                                                                  caption: con
                                                                          .bookList[
                                                                              index]
                                                                          .caption ??
                                                                      "",
                                                                  categoryName: con
                                                                          .bookList[
                                                                              index]
                                                                          .categoryName ??
                                                                      "",
                                                                  showRating: con
                                                                              .bookList[index]
                                                                              .isSaved!
                                                                              .value ==
                                                                          true
                                                                      ? true
                                                                      : false,
                                                                  savedOnTap:
                                                                      () {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    if (con
                                                                        .bookList[
                                                                            index]
                                                                        .isSaved!
                                                                        .value) {
                                                                      con.deleteSavedBookApi(
                                                                        index:
                                                                            index,
                                                                        bookId: con
                                                                            .bookList[index]
                                                                            .id,
                                                                      );
                                                                    } else {
                                                                      con.savedBookApi(
                                                                        index:
                                                                            index,
                                                                        bookId: con
                                                                            .bookList[index]
                                                                            .id,
                                                                      );
                                                                    }
                                                                  },
                                                                  onTap: () {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    Get.find<BookDetailController>().callApis(
                                                                        bookID: con
                                                                            .bookList[index]
                                                                            .id);
                                                                    Get.toNamed(
                                                                        AppRoutes
                                                                            .bookDetailScreen,
                                                                        arguments: con
                                                                            .bookList[index]
                                                                            .id);
                                                                  },
                                                                  showDelete: con
                                                                      .showDelete
                                                                      .value,
                                                                  deleteTap:
                                                                      () async {
                                                                    await con
                                                                        .deleteCollectionBookApi(
                                                                      index:
                                                                          index,
                                                                      collectionId: con
                                                                          .collectionId
                                                                          .value,
                                                                      bookId: con
                                                                          .bookList[
                                                                              index]
                                                                          .id,
                                                                    );
                                                                    Get.find<
                                                                            CollectionController>()
                                                                        .collectionList
                                                                        .firstWhere((p0) =>
                                                                            p0.id ==
                                                                            con.collectionId
                                                                                .value)
                                                                        .bookCount!
                                                                        .value = Get.find<CollectionController>()
                                                                            .collectionList
                                                                            .firstWhere((p0) =>
                                                                                p0.id ==
                                                                                con.collectionId.value)
                                                                            .bookCount!
                                                                            .value -
                                                                        1;
                                                                  },
                                                                  percentage: con
                                                                              .bookList[
                                                                                  index]
                                                                              .listenChapterIds!
                                                                              .length >
                                                                          int.parse(con.bookList[index].chapterCount
                                                                              .toString())
                                                                      ? double.parse(con.bookList[index].chapterCount.toString()) /
                                                                          int.parse(con
                                                                              .bookList[
                                                                                  index]
                                                                              .chapterCount
                                                                              .toString())
                                                                      : con.bookList[index].listenChapterIds!.length /
                                                                          int.parse(con
                                                                              .bookList[index]
                                                                              .chapterCount
                                                                              .toString()),
                                                                ));
                                                      }),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                          Obx(() => con.showLoading.value
                              ? Container(
                                  color: Colors.grey.withOpacity(0.5),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox())
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
