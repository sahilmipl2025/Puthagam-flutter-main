import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/library/get_favorite_list_api.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/widget/book_tile.dart';
import 'package:puthagam/screen/dashboard/library/favorites/favourite_controller.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/no_internet_screen.dart';

class FavouriteScreen extends StatelessWidget {
  FavouriteScreen({Key? key}) : super(key: key);
  final FavouriteController con = Get.put(FavouriteController());

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
                      getFavoriteBookApi();
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
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(isTablet ? 12 : 8)),
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
                                              getFavoriteBookApi(
                                                  pagination: false);
                                            }
                                          },
                                        ),
                                      ),
                                      Obx(
                                        () => con.isSearch.value
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    right: isTablet ? 15 : 12),
                                                child: InkWell(
                                                  onTap: () {
                                                    con.isSearch.value = false;
                                                    con.textCon.value.clear();
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    getFavoriteBookApi(
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
                            SizedBox(height: isTablet ? 12 : 8),
                            Flexible(
                              child: con.favoriteBook.isEmpty
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
                                      itemCount: con.favoriteBook.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Obx(() => BookTile(
                                              isPaid: con
                                                  .favoriteBook[index].isPaid,
                                                  isPremium: con.favoriteBook[index].isPremium,
                                              title: con.favoriteBook[index]
                                                      .title ??
                                                  "",
                                              imageUrl: con.favoriteBook[index]
                                                      .image ??
                                                  "",
                                              authorName: con
                                                      .favoriteBook[index]
                                                      .authorName ??
                                                  "",
                                              totalListen: con
                                                  .favoriteBook[index]
                                                  .listenCount
                                                  .toString(),
                                              saveCount: con
                                                  .favoriteBook[index].saveCount
                                                  .toString(),
                                              rating: int.parse(con
                                                  .favoriteBook[index].rating!
                                                  .round()
                                                  .toString()),
                                              caption: con.favoriteBook[index]
                                                      .caption ??
                                                  "",
                                              categoryName: con
                                                      .favoriteBook[index]
                                                      .categoryName ??
                                                  "",
                                              showRating: true,
                                              showDelete: true,
                                              deleteTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();

                                                con.deleteFavoriteBookApi(
                                                    bookId: con
                                                        .favoriteBook[index].id,
                                                    index: index);
                                              },
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                Get.find<BookDetailController>()
                                                    .callApis(
                                                        bookID: con
                                                            .favoriteBook[index]
                                                            .id);
                                                Get.toNamed(
                                                    AppRoutes.bookDetailScreen,
                                                    arguments: con
                                                        .favoriteBook[index]
                                                        .id);
                                              },
                                              percentage: con
                                                          .favoriteBook[index]
                                                          .listenChapterIds!
                                                          .length >
                                                      int.parse(con
                                                          .favoriteBook[index]
                                                          .chapterCount
                                                          .toString())
                                                  ? double.parse(con
                                                          .favoriteBook[index]
                                                          .chapterCount
                                                          .toString()) /
                                                      int.parse(con
                                                          .favoriteBook[index]
                                                          .chapterCount
                                                          .toString())
                                                  : con
                                                          .favoriteBook[index]
                                                          .listenChapterIds!
                                                          .length /
                                                      int.parse(con.favoriteBook[index].chapterCount.toString()),
                                              savedOnTap: () {},
                                            ));
                                      }),
                            ),
                            con.paginationLoading.value
                                ? const AppLoader()
                                : const SizedBox(),
                            SizedBox(height: isTablet ? 12 : 8),
                          ],
                        ),
                      ),
                      Obx(
                        () => con.savedLoading.value
                            ? Container(
                                color: Colors.grey.withOpacity(0.3),
                                child: const Center(child: AppLoader()),
                              )
                            : const SizedBox(height: 0, width: 0),
                      ),
                    ],
                  ),
      ),
    );
  }
}
