import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/creator_books/creator_books_controller.dart';
import 'package:puthagam/screen/dashboard/home/widget/book_tile.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/no_internet_screen.dart';

import '../../home_controller.dart';

class CreatorBooksScreen extends StatelessWidget {
  CreatorBooksScreen({Key? key}) : super(key: key);

  final CreatorBooksController con = Get.put(CreatorBooksController());
  final HomeController homcon = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
             homcon.meetrefreshData();
            Get.back();
           
            //homcon.getCreatorList(fromHome: true);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: horizontalGradient),
        ),
        bottom: PreferredSize(
          preferredSize: Size(Get.width, 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 12),
              child: Text(
                Get.arguments[0],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 20 : 19,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
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
                        con.getExploreListApi(pagination: false);
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Get.arguments[2] != null
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: isTablet ? 16 : 12,
                                            bottom: isTablet ? 9 : 6,
                                            right: isTablet ? 16 : 12),
                                        child: Html(
                                          data: Get.arguments[2],
                                          style: {
                                            "p": Style(
                                              fontSize:
                                                  FontSize(isTablet ? 16 : 14),
                                              color: Colors.grey.shade300,
                                            ),
                                            "h1": Style(
                                              fontSize:
                                                  FontSize(isTablet ? 24 : 20),
                                              color: Colors.grey.shade300,
                                            ),
                                          },
                                       
                                        ),
                                        // Text(
                                        //   Get.arguments[2],
                                        //   style: TextStyle(
                                        //     fontSize: isTablet ? 16 : 14,
                                        //     color: Colors.grey.shade300,
                                        //   ),
                                        // ),
                                      )
                                    : const SizedBox(),
                                con.bookList.isEmpty
                                    ? Expanded(
                                        child: Center(
                                          child: Text(
                                            "No book found",
                                            style: TextStyle(
                                              fontSize: isTablet ? 26 : 22,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Flexible(
                                        child: ListView.builder(
                                            controller: con.newScrollController,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: con.bookList.length,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Obx(() => BookTile(
                                                    isPaid: con
                                                        .bookList[index].isPaid,
                                                    isPremium: con
                                                        .bookList[index]
                                                        .isPremium,
                                                    title: con.bookList[index]
                                                            .title ??
                                                        "",
                                                    imageUrl: con
                                                            .bookList[index]
                                                            .image ??
                                                        "",
                                                    authorName: con
                                                            .bookList[index]
                                                            .authorName ??
                                                        "",
                                                    totalListen: con
                                                        .bookList[index]
                                                        .listenCount
                                                        .toString(),
                                                    saveCount: con
                                                        .bookList[index]
                                                        .saveCount
                                                        .toString(),
                                                    rating: int.parse(con
                                                        .bookList[index].rating!
                                                        .round()
                                                        .toString()),
                                                    caption: con.bookList[index]
                                                            .caption ??
                                                        "",
                                                    categoryName: con
                                                            .bookList[index]
                                                            .categoryName ??
                                                        "",
                                                    showRating: con
                                                                .bookList[index]
                                                                .isSaved!
                                                                .value ==
                                                            true
                                                        ? true
                                                        : false,
                                                    savedOnTap: () {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      if (con.bookList[index]
                                                          .isSaved!.value) {
                                                        con.deleteSavedBookApi(
                                                          index: index,
                                                          bookId: con
                                                              .bookList[index]
                                                              .id,
                                                        );
                                                      } else {
                                                        con.savedBookApi(
                                                          index: index,
                                                          bookId: con
                                                              .bookList[index]
                                                              .id,
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
                                                                  .bookList[
                                                                      index]
                                                                  .id);
                                                      Get.toNamed(
                                                          AppRoutes
                                                              .bookDetailScreen,
                                                          arguments: con
                                                              .bookList[index]
                                                              .id);
                                                    },
                                                  ));
                                            }),
                                      )
                              ],
                            ),
                          ),
                        ),
                        Obx(() => con.showLoading.value
                            ? Container(
                                color: Colors.grey.withOpacity(0.5),
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              )
                            : const SizedBox())
                      ],
                    ),
        ),
      ),
    );
  }
}
