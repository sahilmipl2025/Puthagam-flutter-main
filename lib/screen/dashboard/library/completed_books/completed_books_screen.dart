import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/library/get_completed_books_api.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/widget/book_tile.dart';
import 'package:puthagam/screen/dashboard/library/completed_books/completed_books_controller.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/no_internet_screen.dart';

class CompletedBooksScreen extends StatelessWidget {
  CompletedBooksScreen({Key? key}) : super(key: key);

  final CompletedBooksController con = Get.put(CompletedBooksController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(gradient: verticalGradient),
      child: Obx(
        () => con.isLoading.value
            ? const Center(child: AppLoader())
            : con.isConnected.isFalse
                ? NoInternetScreen(onTap: () async {
                    bool connection = await checkConnection();
                    if (connection) {
                      con.isConnected.value = true;
                      getCompletedBooksApi();
                    } else {
                      con.isConnected.value = false;
                    }
                  })
                : Stack(
                    children: [
                      Center(
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
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
                                          style: TextStyle(
                                              fontSize: isTablet ? 20 : 18),
                                          decoration: InputDecoration(
                                            hintText:
                                                'Title, Author or Category',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                              color: text23,
                                              fontSize: isTablet ? 16 : 14,
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
                                            if (con.textCon.value.text
                                                .isNotEmpty) {
                                              con.isSearch.value = true;
                                              FocusScope.of(context).unfocus();
                                              getCompletedBooksApi(
                                                  pagination: false);
                                            }
                                          },
                                        ),
                                      ),
                                      Obx(
                                        () => con.isSearch.value
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    right: isTablet ? 16 : 12),
                                                child: InkWell(
                                                  onTap: () {
                                                    con.isSearch.value = false;
                                                    con.textCon.value.clear();
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    getCompletedBooksApi(
                                                        pagination: false);
                                                  },
                                                  child: Icon(
                                                    Icons.close,
                                                    color: smallTextColor,
                                                    size: isTablet ? 29 : 24,
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
                            Flexible(
                              child: con.completedBookList.isEmpty
                                  ? Center(
                                      child: Text(
                                      "No book found",
                                      style: TextStyle(
                                        fontSize: isTablet ? 24 : 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ))
                                  : ListView.builder(
                                      controller: con.newScrollController,
                                      scrollDirection: Axis.vertical,
                                      itemCount: con.completedBookList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Obx(() => BookTile(
                                              isPaid: con
                                                  .completedBookList[index]
                                                  .isPaid,
                                                  isPremium: con.completedBookList[index].isPremium,
                                              title: con
                                                      .completedBookList[index]
                                                      .title ??
                                                  "",
                                              imageUrl: con
                                                      .completedBookList[index]
                                                      .image ??
                                                  "",
                                              authorName: con
                                                      .completedBookList[index]
                                                      .authorName ??
                                                  "",
                                              totalListen: con
                                                  .completedBookList[index]
                                                  .listenCount
                                                  .toString(),
                                              saveCount: con
                                                  .completedBookList[index]
                                                  .saveCount
                                                  .toString(),
                                              rating: int.parse(con
                                                  .completedBookList[index]
                                                  .rating!
                                                  .round()
                                                  .toString()),
                                              caption: con
                                                      .completedBookList[index]
                                                      .caption ??
                                                  "",
                                              categoryName: con
                                                      .completedBookList[index]
                                                      .categoryName ??
                                                  "",
                                              showRating:
                                                  con.completedBookList[index]
                                                              .isSaved!.value ==
                                                          true
                                                      ? true
                                                      : false,
                                              savedOnTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                if (con.completedBookList[index]
                                                    .isSaved!.value) {
                                                  con.deleteSavedBookApi(
                                                    index: index,
                                                    bookId: con
                                                        .completedBookList[
                                                            index]
                                                        .id,
                                                  );
                                                } else {
                                                  con.savedBookApi(
                                                    index: index,
                                                    bookId: con
                                                        .completedBookList[
                                                            index]
                                                        .id,
                                                  );
                                                }
                                              },
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                Get.find<BookDetailController>()
                                                    .callApis(
                                                        bookID: con
                                                            .completedBookList[
                                                                index]
                                                            .id);
                                                Get.toNamed(
                                                    AppRoutes.bookDetailScreen,
                                                    arguments: con
                                                        .completedBookList[
                                                            index]
                                                        .id);
                                              },
                                            ));
                                      }),
                            ),
                            SizedBox(height: isTablet ? 12 : 8),
                            con.paginationLoading.value
                                ? const AppLoader()
                                : const SizedBox()
                          ],
                        ),
                      ),
                      con.showLoading.value
                          ? Container(
                              color: Colors.grey.withOpacity(0.4),
                              child: const AppLoader(),
                            )
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            )
                    ],
                  ),
      ),
    );
  }
}
