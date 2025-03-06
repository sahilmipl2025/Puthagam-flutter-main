import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/widget/book_tile.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';

class SearchListt extends StatelessWidget {
  SearchListt({Key? key}) : super(key: key);

  final HomeController con = Get.put(HomeController());
   //final PodcastController con = Get.put(PodcastController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                int.parse(con.totalBooks.value) <= 1
                    ? con.totalBooks.value.toString() + " " + "Book"
                    : con.totalBooks.value.toString() + " " + "Books".tr,
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontFamily: 'SF-Pro-Display-Regular',
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            con.searchBookList.isEmpty
                ? const SizedBox()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: con.searchBookList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return 
                      Obx(
                        () => BookTile(
                          isPremium: con.searchBookList[index].isPremium,
                          isPaid: con.searchBookList[index].isPaid,
                          title: con.searchBookList[index].title ?? "",
                          imageUrl: con.searchBookList[index].image ?? "",
                          authorName:
                              con.searchBookList[index].authorName ?? "",
                          totalListen:
                              con.searchBookList[index].listenCount.toString(),
                          saveCount:
                              con.searchBookList[index].saveCount.toString(),
                          rating: int.parse(con.searchBookList[index].rating!
                              .round()
                              .toString()),
                          caption: con.searchBookList[index].caption ?? "",
                          categoryName:
                              con.searchBookList[index].categoryName ?? "",
                          showRating:
                              con.searchBookList[index].isSaved!.value == true
                                  ? true
                                  : false,
                           savedOnTap: () {
                            FocusScope.of(context).unfocus();
                            if (con.searchBookList[index].isSaved!.value) {
                              con.deleteSavedBookApi(
                                index: index,
                                bookId: con.searchBookList[index].id,
                              );
                            } else {
                              con.savedBookApi(
                                index: index,
                                bookId: con.searchBookList[index].id,
                              );
                            }
                         },
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            Get.find<BookDetailController>()
                                .callApis(bookID: con.searchBookList[index].id);
                            Get.toNamed(AppRoutes.bookDetailScreen,
                                arguments: con.searchBookList[index].id);
                          },
                        ),
                      );
                    },
                  ),
          ],
        ));
  }
}
