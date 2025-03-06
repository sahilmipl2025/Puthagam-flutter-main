import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/library/delete_saved_book_api.dart';
import 'package:puthagam/data/api/library/get_saved_book_api.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/widget/book_tile.dart';
import 'package:puthagam/screen/dashboard/library/saved/saved_controller.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/no_internet_screen.dart';

class SavedScreen extends StatelessWidget {
  SavedScreen({Key? key}) : super(key: key);
  final SavedController con = Get.put(SavedController());

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
                      getSavedBookApi();
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
                                height: isTablet ? 60 : 50,
                                decoration: BoxDecoration(
                                  gradient: horizontalGradient,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 9, right: 6),
                                          child: Image.asset(
                                            "assets/icons/search.png",
                                            height: isTablet ? 30 : 25,
                                            width: isTablet ? 30 : 25,
                                          )),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.left,
                                          controller: con.textCon.value,
                                          style: const TextStyle(fontSize: 18),
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
                                              getSavedBookApi(
                                                  pagination: false);
                                            }
                                          },
                                        ),
                                      ),
                                      Obx(
                                        () => con.isSearch.value
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 12),
                                                child: InkWell(
                                                  onTap: () {
                                                    con.isSearch.value = false;
                                                    con.textCon.value.clear();
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    getSavedBookApi(
                                                        pagination: false);
                                                  },
                                                  child: Icon(
                                                    Icons.close,
                                                    color: smallTextColor,
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
                            const SizedBox(height: 16),
                            Flexible(
                              child: con.savedBookList.isEmpty
                                  ? Center(
                                      child: Text(
                                      "No book found",
                                      style: TextStyle(
                                        fontSize: isTablet ? 24 : 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ))
                                  : ListView.builder(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: isTablet ? 16 : 12),
                                      controller: con.newScrollController,
                                      scrollDirection: Axis.vertical,
                                      itemCount: con.savedBookList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Obx(() => BookTile(
                                              isPaid: con
                                                  .savedBookList[index].isPaid,
                                                  isPremium: con.savedBookList[index].isPremium,
                                              title: con.savedBookList[index]
                                                      .title ??
                                                  "",
                                              imageUrl: con.savedBookList[index]
                                                      .image ??
                                                  "",
                                              authorName: con
                                                      .savedBookList[index]
                                                      .authorName ??
                                                  "",
                                              totalListen: con
                                                  .savedBookList[index]
                                                  .listenCount
                                                  .toString(),
                                              saveCount: con
                                                  .savedBookList[index]
                                                  .saveCount
                                                  .toString(),
                                              rating: int.parse(con
                                                  .savedBookList[index].rating!
                                                  .round()
                                                  .toString()),
                                              caption: con.savedBookList[index]
                                                      .caption ??
                                                  "",
                                              categoryName: con
                                                      .savedBookList[index]
                                                      .categoryName ??
                                                  "",
                                              showRating: con
                                                          .savedBookList[index]
                                                          .isSaved!
                                                          .value ==
                                                      true
                                                  ? true
                                                  : false,
                                              savedOnTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();

                                                deleteSavedBookApi(
                                                    fromSaved: true,
                                                    index: index,
                                                    bookId: con
                                                        .savedBookList[index].id
                                                        .toString());
                                              },
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                Get.find<BookDetailController>()
                                                    .callApis(
                                                        bookID: con
                                                            .savedBookList[
                                                                index]
                                                            .id);
                                                Get.toNamed(
                                                    AppRoutes.bookDetailScreen,
                                                    arguments: con
                                                        .savedBookList[index]
                                                        .id);
                                              },
                                              percentage: con
                                                          .savedBookList[index]
                                                          .listenChapterIds!
                                                          .length >
                                                      int.parse(con
                                                          .savedBookList[index]
                                                          .chapterCount
                                                          .toString())
                                                  ? double.parse(con
                                                          .savedBookList[index]
                                                          .chapterCount
                                                          .toString()) /
                                                      int.parse(con
                                                          .savedBookList[index]
                                                          .chapterCount
                                                          .toString())
                                                  : con
                                                          .savedBookList[index]
                                                          .listenChapterIds!
                                                          .length /
                                                      int.parse(con.savedBookList[index].chapterCount.toString()),
                                            ));
                                      }),
                            ),
                            const SizedBox(height: 8),
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
