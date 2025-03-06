import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/library/get_history_api.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/widget/book_tile.dart';
import 'package:puthagam/screen/dashboard/library/history/history_controller.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);

  final HistoryController con = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(gradient: verticalGradient),
        child: Obx(
          () => con.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: isTablet ? 20 : 16),
                      Obx(
                        () => Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: isTablet ? 20 : 16),
                          height: isTablet ? 70 : 50,
                          decoration: BoxDecoration(
                            gradient: horizontalGradient,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: isTablet ? 12 : 9,
                                      right: isTablet ? 9 : 6),
                                  child: Image.asset(
                                    "assets/icons/search.png",
                                    height: isTablet ? 29 : 25,
                                    width: isTablet ? 29 : 25,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    textAlign: TextAlign.left,
                                    controller: con.textCon.value,
                                    style:
                                        TextStyle(fontSize: isTablet ? 20 : 18),
                                    decoration: InputDecoration(
                                      hintText: 'Title, Author or Category',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: smallTextColor,
                                        fontSize: isTablet ? 18 : 16,
                                      ),
                                    ),
                                    onChanged: (v) {
                                      if (con.textCon.value.text
                                          .trim()
                                          .isEmpty) {
                                        con.isSearch.value = false;
                                      }
                                    },
                                    onEditingComplete: () {
                                      if (con.textCon.value.text.isNotEmpty) {
                                        con.isSearch.value = true;
                                        FocusScope.of(context).unfocus();
                                        getHistoryListApi();
                                      }
                                    },
                                  ),
                                ),
                                Obx(
                                  () => con.isSearch.value
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 12),
                                          child: InkWell(
                                            onTap: () {
                                              con.isSearch.value = false;
                                              con.textCon.value.clear();
                                              FocusScope.of(context).unfocus();
                                              getHistoryListApi();
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: smallTextColor,
                                              size: isTablet ? 30 : 25,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 12 : 8),
                      Obx(() => con.continueBookList.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  "No book found",
                                  style: TextStyle(
                                    fontSize: isTablet ? 24 : 20,
                                    fontWeight: FontWeight.w500,
                                    // color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          : Flexible(
                              child: Stack(
                              children: [
                                Obx(
                                  () => ListView.builder(
                                    itemCount: con.continueBookList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Obx(() => BookTile(
                                            isPaid: con
                                                .continueBookList[index].isPaid,
                                                isPremium: con.continueBookList[index].isPremium,
                                            title: con.continueBookList[index]
                                                    .title ??
                                                "",
                                            imageUrl: con
                                                    .continueBookList[index]
                                                    .image ??
                                                "",
                                            authorName: con
                                                    .continueBookList[index]
                                                    .authorName ??
                                                "",
                                            totalListen: con
                                                .continueBookList[index]
                                                .listenCount
                                                .toString(),
                                            saveCount: con
                                                .continueBookList[index]
                                                .saveCount
                                                .toString(),
                                            rating: int.parse(con
                                                .continueBookList[index].rating!
                                                .round()
                                                .toString()),
                                            caption: con.continueBookList[index]
                                                    .caption ??
                                                "",
                                            categoryName: con
                                                    .continueBookList[index]
                                                    .categoryName ??
                                                "",
                                            showRating: con
                                                        .continueBookList[index]
                                                        .isSaved!
                                                        .value ==
                                                    true
                                                ? true
                                                : false,
                                            savedOnTap: () {
                                              FocusScope.of(context).unfocus();
                                              if (con.continueBookList[index]
                                                  .isSaved!.value) {
                                                con.deleteSavedBookApi(
                                                  index: index,
                                                  bookId: con
                                                      .continueBookList[index]
                                                      .id,
                                                );
                                              } else {
                                                con.savedBookApi(
                                                  index: index,
                                                  bookId: con
                                                      .continueBookList[index]
                                                      .id,
                                                );
                                              }
                                            },
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              Get.find<BookDetailController>()
                                                  .callApis(
                                                      bookID: con
                                                          .continueBookList[
                                                              index]
                                                          .id);
                                              Get.toNamed(
                                                  AppRoutes.bookDetailScreen,
                                                  arguments: con
                                                      .continueBookList[index]
                                                      .id);
                                            },
                                            percentage: con
                                                        .continueBookList[index]
                                                        .listenChapterIds!
                                                        .length >
                                                    int.parse(con
                                                        .continueBookList[index]
                                                        .chapterCount
                                                        .toString())
                                                ? double.parse(con
                                                        .continueBookList[index]
                                                        .chapterCount
                                                        .toString()) /
                                                    int.parse(con
                                                        .continueBookList[index]
                                                        .chapterCount
                                                        .toString())
                                                : con
                                                        .continueBookList[index]
                                                        .listenChapterIds!
                                                        .length /
                                                    int.parse(
                                                        con.continueBookList[index].chapterCount.toString()),
                                          ));
                                    },
                                  ),
                                ),
                                Obx(
                                  () => con.showLoading.value
                                      ? Container(
                                          color: Colors.grey.withOpacity(0.3),
                                          child:
                                              const Center(child: AppLoader()),
                                        )
                                      : const SizedBox(height: 0, width: 0),
                                ),
                              ],
                            )))
                    ],
                  ),
                ),
        ));
  }
}
