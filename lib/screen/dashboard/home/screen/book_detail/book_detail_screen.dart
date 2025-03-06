import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:puthagam/data/api/category/get_subcategory_list_api.dart';
import 'package:puthagam/data/api/category_book/get_category_books_api.dart';
import 'package:puthagam/data/api/category_book/submit_review_api.dart';
import 'package:puthagam/data/api/library/delete_saved_book_api.dart';
import 'package:puthagam/data/api/library/saved_book_api.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/screen/chapter_page.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/screen/images.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/screen/information_page.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/widget/bottom_audio.dart';
import 'package:puthagam/screen/dashboard/home/screen/category_book/category_book_screen.dart';
import 'package:puthagam/screen/dashboard/profile/setting/setting_controller.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/themes/global.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../../utils/shimmer_tile.dart';

class BookDetailScreen extends StatelessWidget {
  BookDetailScreen({Key? key}) : super(key: key);

  final BookDetailController con = Get.put(BookDetailController());

  final SettingController con1 = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    con.getUserProfileApi();

    //   con.getBookDetailApi(bookId: con.bookDetail.value.id.toString(),);
    print("after calling api${con.getreadAccess.value.toString()}");
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(gradient: verticalGradient),
        child: Obx(
          () => con.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : con.bookDetail.value.id == null
                  ? "Detail is not found"
                      .tr
                      .text
                      .make()
                      .marginOnly(top: 20)
                      .centered()
                  : SafeArea(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => Get.back(),
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color:
                                          GlobalService.to.isDarkModel == true
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                  const Spacer(),
                                  const SizedBox(width: 12),
                                  Obx(() => con.bookDetail.value.id
                                              .toString() ==
                                          "null"
                                      ? const SizedBox()
                                      : con.isBookDetail.isFalse
                                          ? favoriteBtn()
                                          : (con.bookDetail.value.isPaid
                                                          .toString() ==
                                                      "true" &&
                                                  baseController!
                                                          .isSubscribed.value
                                                          .toString() ==
                                                      "false")
                                              ? const SizedBox(
                                                  height: 0, width: 0)
                                              : favoriteBtn()),
                                  Obx(
                                    () => con.bookDetail.value.id.toString() ==
                                            "null"
                                        ? const SizedBox()
                                        : con.isBookDetail.isFalse
                                            ? IconButton(
                                                onPressed: () {
                                                  con.con.downloadBooks();
                                                },
                                                icon: Image.asset(
                                                  'assets/icons/downloads.png',
                                                  height: isTablet ? 25 : 20,
                                                  width: isTablet ? 25 : 20,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : (con.bookDetail.value.isPaid
                                                            .toString() ==
                                                        "true" &&
                                                    baseController!
                                                            .isSubscribed.value
                                                            .toString() ==
                                                        "false")
                                                ? const SizedBox(
                                                    height: 0, width: 0)
                                                : con.bookChapterList.isEmpty
                                                    ? const SizedBox()
                                                    : IconButton(
                                                        onPressed: () {
                                                          con.con
                                                              .downloadBooks();
                                                        },
                                                        icon: Image.asset(
                                                          'assets/icons/downloads.png',
                                                          height: isTablet
                                                              ? 25
                                                              : 20,
                                                          width: isTablet
                                                              ? 25
                                                              : 20,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                  ),
                                  Obx(
                                    () => con.bookDetail.value.id.toString() ==
                                            "null"
                                        ? const SizedBox()
                                        : con.isBookDetail.isFalse
                                            ? IconButton(
                                                onPressed: () {
                                                  reviewBottomSheet(
                                                      context: context);
                                                },
                                                icon: Image.asset(
                                                  'assets/icons/review.png',
                                                  height: isTablet ? 22 : 17,
                                                  width: isTablet ? 22 : 17,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : (con.bookDetail.value.isPaid
                                                            .toString() ==
                                                        "true" &&
                                                    baseController!
                                                            .isSubscribed.value
                                                            .toString() ==
                                                        "false")
                                                ? const SizedBox(
                                                    height: 0, width: 0)
                                                : IconButton(
                                                    onPressed: () {
                                                      reviewBottomSheet(
                                                          context: context);
                                                    },
                                                    icon: Image.asset(
                                                      'assets/icons/review.png',
                                                      height:
                                                          isTablet ? 22 : 17,
                                                      width: isTablet ? 22 : 17,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isTablet ? 12 : 8),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: isTablet ? 16 : 12),
                                        child: Row(
                                          children: [
                                            bookImage(),
                                            SizedBox(width: isTablet ? 20 : 16),
                                            Expanded(
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  isTablet
                                                                      ? 8
                                                                      : 5),
                                                      child: Text(
                                                        con.bookDetail.value
                                                                .title ??
                                                            "",
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontSize: isTablet
                                                              ? 16
                                                              : 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              commonBlueColor,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            isTablet ? 8 : 6),
                                                    con.isBookDetail.isFalse
                                                        ? countRow()
                                                        : podcastrow(),
                                                    SizedBox(
                                                        height:
                                                            isTablet ? 10 : 8),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: isTablet
                                                                      ? 10
                                                                      : 8.0),
                                                          child: SizedBox(
                                                            height: isTablet
                                                                ? 18
                                                                : 15,
                                                            width: isTablet
                                                                ? 18
                                                                : 15,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: con
                                                                  .bookDetail
                                                                  .value
                                                                  .categoryImage
                                                                  .toString(),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            width: isTablet
                                                                ? 12
                                                                : 8),
                                                        Expanded(
                                                          child: SizedBox(
                                                            child: Text(
                                                              con
                                                                      .bookDetail
                                                                      .value
                                                                      .categoryName ??
                                                                  "",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    isTablet
                                                                        ? 16
                                                                        : 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        width: isTablet ? 8 : 5,
                                                        height:
                                                            isTablet ? 14 : 10),
                                                    con.isBookDetail.isFalse
                                                        ? actionRow(
                                                            context: context)
                                                        : const SizedBox(),
                                                    SizedBox(
                                                        height:
                                                            isTablet ? 14 : 10),
                                                    Obx(
                                                      () => con.bookDetail.value
                                                                  .id
                                                                  .toString() ==
                                                              "null"
                                                          ? const SizedBox()
                                                          : con
                                                                  .bookDetail
                                                                  .value
                                                                  .amazonLink!
                                                                  .isNotEmpty
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    launchUrl(
                                                                      Uri.parse(con
                                                                              .bookDetail
                                                                              .value
                                                                              .amazonLink ??
                                                                          ""),
                                                                      mode: LaunchMode
                                                                          .externalApplication,
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            4,
                                                                        horizontal:
                                                                            9),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color:
                                                                          commonBlueColor,
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        const Text(
                                                                          "Buy on",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                13,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                6),
                                                                        Image
                                                                            .asset(
                                                                          'assets/icons/amazon.png',
                                                                          height: isTablet
                                                                              ? 22
                                                                              : 18,
                                                                          width: isTablet
                                                                              ? 22
                                                                              : 18,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                    ),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: isTablet ? 20 : 16),
                                      InformationPage(),
                                      Obx(
                                        () => con.bookChapterList.isEmpty
                                            ? const SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: Text(
                                                  con.isBookDetail.isFalse
                                                      ? "Chapters"
                                                      : "Episodes",
                                                  style: TextStyle(
                                                    fontSize:
                                                        isTablet ? 17 : 14,
                                                    color: commonBlueColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                      ),
                                      Obx(
                                        () => con.bookChapterList.isEmpty
                                            ? const SizedBox()
                                            : SizedBox(
                                                height: isTablet ? 20 : 16),
                                      ),
                                      ChapterPage(),
                                      SizedBox(height: isTablet ? 20 : 16),
                                      con.isBookDetail.isFalse
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      isTablet ? 20 : 16),
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: Obx(
                                                  () => Text(
                                                    con.isBookDetail.isFalse
                                                        ? 'Author of the book'
                                                        : "Podcaster",
                                                    style: TextStyle(
                                                      fontSize:
                                                          isTablet ? 17 : 14,
                                                      color: commonBlueColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      SizedBox(height: isTablet ? 20 : 16),
                                      con.isBookDetail.isFalse
                                          ? GestureDetector(
                                              onTap: () {
                                                if (con.isBookDetail.isFalse) {
                                                  Get.toNamed(
                                                      AppRoutes
                                                          .creatorBooksScreen,
                                                      arguments: [
                                                        con.bookDetail.value
                                                            .authorName,
                                                        con.bookDetail.value
                                                            .authorId,
                                                        con.bookDetail.value
                                                            .authorDescription,
                                                      ]);
                                                }
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        isTablet ? 20 : 16),
                                                child: Row(
                                                  children: [
                                                    ClipOval(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      child: Container(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  isTablet
                                                                      ? 5
                                                                      : 3),
                                                          child: ClipOval(
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            child: Container(
                                                              height: isTablet
                                                                  ? 77
                                                                  : 66,
                                                              width: isTablet
                                                                  ? 77
                                                                  : 66,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            NetworkImage(
                                                                          con.bookDetail.value.authorImage ??
                                                                              "",
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )),
                                                            ),
                                                          ),
                                                        ),
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          gradient:
                                                              LinearGradient(
                                                                  colors: [
                                                                Color(
                                                                    0xFFA87F01),
                                                                Color(
                                                                    0xFFAE8601),
                                                                Color(
                                                                    0xFFD4B001),
                                                                Color(
                                                                    0xFFFAD901),
                                                                Color(
                                                                    0xFFF1D001),
                                                              ]),
                                                          // border: Border.all(
                                                          //     color: Colors.amber, width: 2),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            isTablet ? 20 : 16),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            con.bookDetail.value
                                                                    .authorName ??
                                                                "",
                                                            style: TextStyle(
                                                              fontSize: isTablet
                                                                  ? 16
                                                                  : 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: isTablet
                                                                  ? 3
                                                                  : 2),
                                                          ReadMoreText(
                                                            con.bookDetail.value
                                                                    .authorDescription ??
                                                                "",
                                                            style: TextStyle(
                                                              fontSize: isTablet
                                                                  ? 14
                                                                  : 12,
                                                              color: text23,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                            trimLines: 2,
                                                            colorClickableText:
                                                                Colors.pink,
                                                            trimMode:
                                                                TrimMode.Line,
                                                            trimCollapsedText:
                                                                'View more',
                                                            trimExpandedText:
                                                                'View less',
                                                            lessStyle: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    commonBlueColor),
                                                            moreStyle: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    commonBlueColor),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      Obx(
                                          () =>
                                              con.bookDetail.value.isPodcast ==
                                                      true
                                                  ? con.suggestionPodcasts
                                                          .isNotEmpty
                                                      ? Column(
                                                          children: [
                                                            SizedBox(
                                                                height: isTablet
                                                                    ? 20
                                                                    : 16),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          isTablet
                                                                              ? 20
                                                                              : 16),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      "Suggested for you",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize: isTablet
                                                                            ? 17
                                                                            : 14,
                                                                        color:
                                                                            commonBlueColor,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: isTablet
                                                                    ? 15
                                                                    : 12),
                                                            SizedBox(
                                                              height: isTablet
                                                                  ? 240
                                                                  : 210,
                                                              width: double
                                                                  .infinity,
                                                              child: ListView
                                                                  .builder(
                                                                padding: EdgeInsets.only(
                                                                    left:
                                                                        isTablet
                                                                            ? 20
                                                                            : 16,
                                                                    right:
                                                                        isTablet
                                                                            ? 20
                                                                            : 16),
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    const BouncingScrollPhysics(),
                                                                itemCount: con
                                                                    .suggestionPodcasts
                                                                    .length,
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  return con.suggestionPodcasts[index].id ==
                                                                          con
                                                                              .bookDetail
                                                                              .value
                                                                              .id
                                                                      ? const SizedBox()
                                                                      : Padding(
                                                                          padding:
                                                                              EdgeInsets.only(right: isTablet ? 5 : 5.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(height: isTablet ? 3 : 2),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  FocusScope.of(context).unfocus();

                                                                                  Get.find<BookDetailController>().callApis(bookID: con.suggestionPodcasts[index].id);
                                                                                  Get.toNamed(AppRoutes.bookDetailScreen);
                                                                                },
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  child: SizedBox(
                                                                                    width: isTablet ? 145 : 125,
                                                                                    height: isTablet ? 210 : 190,
                                                                                    child: ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      child: CachedNetworkImage(
                                                                                        fit: BoxFit.fill,
                                                                                        imageUrl: con.suggestionPodcasts[index].image ?? "",
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              // 10.heightBox,
                                                                              // "m"
                                                                              //     .text
                                                                              //     .make()
                                                                              //     .onInkTap(() {
                                                                              //   print(con.suggestionPodcasts[index].image);
                                                                              // }),
                                                                              SizedBox(height: isTablet ? 12 : 8),
                                                                            ],
                                                                          ),
                                                                        );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox()
                                                  : con.suggestionBook
                                                          .isNotEmpty
                                                      ? Column(
                                                          children: [
                                                            SizedBox(
                                                                height: isTablet
                                                                    ? 20
                                                                    : 16),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          isTablet
                                                                              ? 20
                                                                              : 16),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      "Suggested for you",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize: isTablet
                                                                            ? 17
                                                                            : 14,
                                                                        color:
                                                                            commonBlueColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  con.suggestionBook
                                                                              .length >
                                                                          5
                                                                      ? InkWell(
                                                                          onTap:
                                                                              () {
                                                                            getSubcategoryApi(con.bookDetail.value.categoryId ??
                                                                                "");
                                                                            getCategoryBooksApi(
                                                                              categoryId: con.bookDetail.value.categoryId ?? "",
                                                                              pagination: false,
                                                                            );
                                                                            Get.to(() => CategoryBookScreen(
                                                                                categoryId: con.bookDetail.value.categoryId.toString(),
                                                                                categoryImage: con.bookDetail.value.categoryImage ?? "",
                                                                                categoryName: con.bookDetail.value.categoryName ?? ""));
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'viewMore'.tr,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: isTablet ? 14 : 12,
                                                                              color: borderColor,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : const SizedBox(),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: isTablet
                                                                    ? 16
                                                                    : 12),
                                                            SizedBox(
                                                              height: isTablet
                                                                  ? 240
                                                                  : 210,
                                                              width: double
                                                                  .infinity,
                                                              child: ListView
                                                                  .builder(
                                                                padding: EdgeInsets.only(
                                                                    left:
                                                                        isTablet
                                                                            ? 20
                                                                            : 16,
                                                                    right:
                                                                        isTablet
                                                                            ? 20
                                                                            : 16),
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    const BouncingScrollPhysics(),
                                                                itemCount: con
                                                                    .suggestionBook
                                                                    .length,
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  return con.suggestionBook[index].id ==
                                                                          con
                                                                              .bookDetail
                                                                              .value
                                                                              .id
                                                                      ? const SizedBox()
                                                                      : Padding(
                                                                          padding:
                                                                              EdgeInsets.only(left: isTablet ? 5 : 3.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(height: isTablet ? 3 : 2),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  FocusScope.of(context).unfocus();

                                                                                  Get.find<BookDetailController>().callApis(bookID: con.suggestionBook[index].id);
                                                                                  Get.toNamed(AppRoutes.bookDetailScreen);
                                                                                },
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  child: SizedBox(
                                                                                    width: isTablet ? 145 : 125,
                                                                                    height: isTablet ? 210 : 190,
                                                                                    child: ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      child: CachedNetworkImage(
                                                                                        fit: BoxFit.fill,
                                                                                        imageUrl: con.suggestionBook[index].image ?? "",
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: isTablet ? 12 : 8),
                                                                            ],
                                                                          ),
                                                                        );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox()),
                                      baseController!
                                                  .booksQueueList.isNotEmpty &&
                                              baseController!
                                                  .booksQueueList[
                                                      baseController!
                                                          .currentPlayingBookIndex
                                                          .value]
                                                  .bookChapter
                                                  .isNotEmpty &&
                                              baseController!
                                                      .currentPlayingIndex
                                                      .value !=
                                                  999 &&
                                              baseController!
                                                  .booksQueueList[baseController!
                                                      .currentPlayingBookIndex
                                                      .value]
                                                  .bookChapter
                                                  .isNotEmpty
                                          ? SizedBox(
                                              height: isTablet ? 130 : 100)
                                          : SizedBox(
                                              height: isTablet ? 34 : 20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          BottomAudio(),
                         
                          Obx(
                            () => con.savedLoading.value
                                ? Container(
                                    color: Colors.grey.withOpacity(0.3),
                                    child: const Center(child: AppLoader()),
                                  )
                                : const SizedBox(height: 0, width: 0),
                          ),
                    //       Obx(() => con.bookDetail.value.booktype.toString() == "3"
                    //       ?    const SizedBox(height: 0, width: 0) :
                          
                          
                    //        Container(

                    //                   height: Get.height,
                    //                   width: Get.width,
                    //                   color: Colors.grey.withOpacity(0.5),
                    //                   child: Column(
                    //                     mainAxisSize: MainAxisSize.min,
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.center,
                    //                     children: [
                    //                       Container(
                    //                         width: Get.width * 0.8,
                    //                         padding: const EdgeInsets.symmetric(
                    //                           vertical: 20,
                    //                           horizontal: 16,
                    //                         ),
                    //                         decoration: BoxDecoration(
                    //                           color: Colors.white,
                    //                           borderRadius:
                    //                               BorderRadius.circular(12),
                    //                         ),
                    //                         child: Column(
                    //                           children: [
                    //                             InkWell(
                    //                               onTap: () {
                    //                                 Get.back();
                    //                                 // con.showDialog.value =
                    //                                 //     true;
                    //                               },
                    //                               child: const Align(
                    //                                 alignment:
                    //                                     Alignment.centerRight,
                    //                                 child: Icon(
                    //                                   Icons.close,
                    //                                   color: Colors.black,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                             Image.asset(
                    //                               "assets/images/logo.png",
                    //                               height: isTablet
                    //                                   ? Get.height * 0.14
                    //                                   : Get.height * 0.1,
                    //                             ),
                    //                             SizedBox(
                    //                                 height: isTablet ? 16 : 12),
                    //                             Text(
                    //                               "Get full access!",
                    //                               style: TextStyle(
                    //                                   fontWeight:
                    //                                       FontWeight.w600,
                    //                                   fontSize:
                    //                                       isTablet ? 21 : 18,
                    //                                   color: textColor),
                    //                             ),
                    //                             SizedBox(
                    //                                 height: isTablet ? 12 : 8),
                    //                             Obx(() => Text(
                    //                                   con.isBookDetail.isFalse
                    //                                       ? "Have unlimited access to all amazing books content."
                    //                                       : "Have unlimited access to listen all new podcasts",
                    //                                   textAlign:
                    //                                       TextAlign.center,
                    //                                   style: TextStyle(
                    //                                     fontSize:
                    //                                         isTablet ? 16 : 14,
                    //                                     color: Colors.grey,
                    //                                   ),
                    //                                 )),
                    //                             SizedBox(
                    //                                 height: isTablet ? 24 : 20),
                    //                             baseController!
                    //                                     .isBetaVersion.value
                    //                                 ? baseController!
                    //                                             .isSubscribed
                    //                                             .value &&
                    //                                         baseController!
                    //                                             .betaVersion
                    //                                             .value
                    //                                     ? const SizedBox()
                    //                                     : Row(
                    //                                         mainAxisAlignment:
                    //                                             MainAxisAlignment
                    //                                                 .end,
                    //                                         children: [
                    //                                           const Text(
                    //                                             "Click here to activate ",
                    //                                             style: TextStyle(
                    //                                                 color: Colors
                    //                                                     .black),
                    //                                           ),
                    //                                           GestureDetector(
                    //                                             onTap: () {
                    //                                               con.showDialog
                    //                                                       .value =
                    //                                                   false;
                    //                                               con.con.getPaymentUrlApi(
                    //                                                   isBeta:
                    //                                                       true);
                    //                                             },
                    //                                             child:
                    //                                                 Container(
                    //                                               padding: const EdgeInsets
                    //                                                   .symmetric(
                    //                                                   vertical:
                    //                                                       4,
                    //                                                   horizontal:
                    //                                                       12),
                    //                                               decoration:
                    //                                                   BoxDecoration(
                    //                                                 color: Colors
                    //                                                     .green
                    //                                                     .shade500,
                    //                                                 borderRadius:
                    //                                                     BorderRadius.circular(
                    //                                                         16),
                    //                                               ),
                    //                                               child:
                    //                                                   const Text(
                    //                                                 "Beta trial",
                    //                                                 style:
                    //                                                     TextStyle(
                    //                                                   fontWeight:
                    //                                                       FontWeight
                    //                                                           .w600,
                    //                                                   color: Colors
                    //                                                       .white,
                    //                                                 ),
                    //                                               ),
                    //                                             ),
                    //                                           ),
                    //                                         ],
                    //                                       )
                    //                                 : const SizedBox(),
                    //                             baseController!.isTried.value
                    //                                 ? const SizedBox()
                    //                                 : baseController!
                    //                                         .isBetaVersion.value
                    //                                     ? const SizedBox()
                    //                                     : const SizedBox(),
                    //                             // SizedBox(
                    //                             //     height: isTablet ? 24 : 20),
                    //                             InkWell(
                    //                               onTap: () {
                    //                                 if (Platform.isIOS) {
                    //                                   Get.toNamed(AppRoutes
                    //                                       .premiumIosScreen);
                    //                                 } else {
                    //                                   Get.toNamed(AppRoutes
                    //                                       .premiumSubscriptionPage);
                    //                                 }
                    //                               },
                    //                               child: Container(
                    //                                 padding:
                    //                                     EdgeInsets.symmetric(
                    //                                         vertical: isTablet
                    //                                             ? 16
                    //                                             : 12,
                    //                                         horizontal: isTablet
                    //                                             ? 20
                    //                                             : 16),
                    //                                 decoration: BoxDecoration(
                    //                                   color: buttonColor,
                    //                                   borderRadius:
                    //                                       BorderRadius.circular(
                    //                                           12),
                    //                                 ),
                    //                                 child: Row(
                    //                                   mainAxisSize:
                    //                                       MainAxisSize.min,
                    //                                   children: [
                    //                                     Center(
                    //                                       child: Text(
                    //                                         "Buy subscription",
                    //                                         style: TextStyle(
                    //                                           color:
                    //                                               Colors.white,
                    //                                           fontSize: isTablet
                    //                                               ? 16
                    //                                               : 14,
                    //                                           fontWeight:
                    //                                               FontWeight
                    //                                                   .w600,
                    //                                         ),
                    //                                       ),
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               ),
                    //                             )
                    //                           ],
                    //                         ),
                    //                       )
                    //                     ],
                    //                   ),
                    //                 ),
                    // ),
                        
                    //     Obx(() => con.bookDetail.value.isPremium == false ? const SizedBox(height: 0, width: 0)
                    //     :    Container(
                    //                   height: Get.height,
                    //                   width: Get.width,
                    //                   color: Colors.grey.withOpacity(0.5),
                    //                   child: Column(
                    //                     mainAxisSize: MainAxisSize.min,
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.center,
                    //                     children: [
                    //                       Container(
                    //                         width: Get.width * 0.8,
                    //                         padding: const EdgeInsets.symmetric(
                    //                           vertical: 20,
                    //                           horizontal: 16,
                    //                         ),
                    //                         decoration: BoxDecoration(
                    //                           color: Colors.white,
                    //                           borderRadius:
                    //                               BorderRadius.circular(12),
                    //                         ),
                    //                         child: Column(
                    //                           children: [
                    //                             InkWell(
                    //                               onTap: () {
                    //                                 Get.back();
                    //                                 // con.showDialog.value =
                    //                                 //     true;
                    //                               },
                    //                               child: const Align(
                    //                                 alignment:
                    //                                     Alignment.centerRight,
                    //                                 child: Icon(
                    //                                   Icons.close,
                    //                                   color: Colors.black,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                             Image.asset(
                    //                               "assets/images/logo.png",
                    //                               height: isTablet
                    //                                   ? Get.height * 0.14
                    //                                   : Get.height * 0.1,
                    //                             ),
                    //                             SizedBox(
                    //                                 height: isTablet ? 16 : 12),
                    //                             Text(
                    //                               "Get full access!",
                    //                               style: TextStyle(
                    //                                   fontWeight:
                    //                                       FontWeight.w600,
                    //                                   fontSize:
                    //                                       isTablet ? 21 : 18,
                    //                                   color: textColor),
                    //                             ),
                    //                             SizedBox(
                    //                                 height: isTablet ? 12 : 8),
                    //                             Obx(() => Text(
                    //                                   con.isBookDetail.isFalse
                    //                                       ? "Have unlimited access to all amazing books content."
                    //                                       : "Have unlimited access to listen all new podcasts",
                    //                                   textAlign:
                    //                                       TextAlign.center,
                    //                                   style: TextStyle(
                    //                                     fontSize:
                    //                                         isTablet ? 16 : 14,
                    //                                     color: Colors.grey,
                    //                                   ),
                    //                                 )),
                    //                             SizedBox(
                    //                                 height: isTablet ? 24 : 20),
                    //                             baseController!
                    //                                     .isBetaVersion.value
                    //                                 ? baseController!
                    //                                             .isSubscribed
                    //                                             .value &&
                    //                                         baseController!
                    //                                             .betaVersion
                    //                                             .value
                    //                                     ? const SizedBox()
                    //                                     : Row(
                    //                                         mainAxisAlignment:
                    //                                             MainAxisAlignment
                    //                                                 .end,
                    //                                         children: [
                    //                                           const Text(
                    //                                             "Click here to activate ",
                    //                                             style: TextStyle(
                    //                                                 color: Colors
                    //                                                     .black),
                    //                                           ),
                    //                                           GestureDetector(
                    //                                             onTap: () {
                    //                                               con.showDialog
                    //                                                       .value =
                    //                                                   false;
                    //                                               con.con.getPaymentUrlApi(
                    //                                                   isBeta:
                    //                                                       true);
                    //                                             },
                    //                                             child:
                    //                                                 Container(
                    //                                               padding: const EdgeInsets
                    //                                                   .symmetric(
                    //                                                   vertical:
                    //                                                       4,
                    //                                                   horizontal:
                    //                                                       12),
                    //                                               decoration:
                    //                                                   BoxDecoration(
                    //                                                 color: Colors
                    //                                                     .green
                    //                                                     .shade500,
                    //                                                 borderRadius:
                    //                                                     BorderRadius.circular(
                    //                                                         16),
                    //                                               ),
                    //                                               child:
                    //                                                   const Text(
                    //                                                 "Beta trial",
                    //                                                 style:
                    //                                                     TextStyle(
                    //                                                   fontWeight:
                    //                                                       FontWeight
                    //                                                           .w600,
                    //                                                   color: Colors
                    //                                                       .white,
                    //                                                 ),
                    //                                               ),
                    //                                             ),
                    //                                           ),
                    //                                         ],
                    //                                       )
                    //                                 : const SizedBox(),
                    //                             baseController!.isTried.value
                    //                                 ? const SizedBox()
                    //                                 : baseController!
                    //                                         .isBetaVersion.value
                    //                                     ? const SizedBox()
                    //                                     : const SizedBox(),
                    //                             // SizedBox(
                    //                             //     height: isTablet ? 24 : 20),
                    //                             InkWell(
                    //                               onTap: () {
                    //                                 if (Platform.isIOS) {
                    //                                   Get.toNamed(AppRoutes
                    //                                       .premiumIosScreen);
                    //                                 } else {
                    //                                   Get.toNamed(AppRoutes
                    //                                       .premiumSubscriptionPage);
                    //                                 }
                    //                               },
                    //                               child: Container(
                    //                                 padding:
                    //                                     EdgeInsets.symmetric(
                    //                                         vertical: isTablet
                    //                                             ? 16
                    //                                             : 12,
                    //                                         horizontal: isTablet
                    //                                             ? 20
                    //                                             : 16),
                    //                                 decoration: BoxDecoration(
                    //                                   color: buttonColor,
                    //                                   borderRadius:
                    //                                       BorderRadius.circular(
                    //                                           12),
                    //                                 ),
                    //                                 child: Row(
                    //                                   mainAxisSize:
                    //                                       MainAxisSize.min,
                    //                                   children: [
                    //                                     Center(
                    //                                       child: Text(
                    //                                         "Buy subscription",
                    //                                         style: TextStyle(
                    //                                           color:
                    //                                               Colors.white,
                    //                                           fontSize: isTablet
                    //                                               ? 16
                    //                                               : 14,
                    //                                           fontWeight:
                    //                                               FontWeight
                    //                                                   .w600,
                    //                                         ),
                    //                                       ),
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               ),
                    //                             )
                    //                           ],
                    //                         ),
                    //                       )
                    //                     ],
                    //                   ),
                    //                 )
                    // ),
                          Obx(() {
                            if (con.bookDetail.value.booktype.toString() == "3"
                              // con.getreadAccess.value == "true" ||
                              //         con.getpodcastacess.value == "true"
                                      ) {
                                      
                              // ignore: prefer_const_constructors
                              return 
                                const SizedBox(height: 0, width: 0);
                              
                            } else if ( con.getreadAccess.value == "true" &&
                                      con.getpodcastacess.value == "false" && con.bookDetail.value.isPodcast == true) {
                              // ignore: prefer_const_constructors
                              return 
                              
                               Obx(() =>
                               
                                con.bookDetail.value.isPaid.toString() ==
                                  "false"
                              ? const SizedBox(height: 0, width: 0)
                              : con.bookDetail.value.isPaid.toString() ==
                                          "true" && con.bookDetail.value.isPremium == false &&
                                      
                                      con.bookDetail.value.booktype == 3
                                  //   && baseController!.getreadAccess.value == true

                                  ? const SizedBox(height: 0, width: 0)
                                  : Container(
                                      height: Get.height,
                                      width: Get.width,
                                      color: Colors.grey.withOpacity(0.5),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: Get.width * 0.8,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 20,
                                              horizontal: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                    // con.showDialog.value =
                                                    //     true;
                                                  },
                                                  child: const Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Image.asset(
                                                  "assets/images/logo.png",
                                                  height: isTablet
                                                      ? Get.height * 0.14
                                                      : Get.height * 0.1,
                                                ),
                                                SizedBox(
                                                    height: isTablet ? 16 : 12),
                                                Text(
                                                  "Get full access!",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          isTablet ? 21 : 18,
                                                      color: textColor),
                                                ),
                                                SizedBox(
                                                    height: isTablet ? 12 : 8),
                                                Obx(() => Text(
                                                      con.isBookDetail.isFalse
                                                          ? "Have unlimited access to all amazing books content."
                                                          : "Have unlimited access to listen all new podcasts",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            isTablet ? 16 : 14,
                                                        color: Colors.grey,
                                                      ),
                                                    )),
                                                SizedBox(
                                                    height: isTablet ? 24 : 20),
                                                baseController!
                                                        .isBetaVersion.value
                                                    ? baseController!
                                                                .isSubscribed
                                                                .value &&
                                                            baseController!
                                                                .betaVersion
                                                                .value
                                                        ? const SizedBox()
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              const Text(
                                                                "Click here to activate ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  con.showDialog
                                                                          .value =
                                                                      false;
                                                                  con.con.getPaymentUrlApi(
                                                                      isBeta:
                                                                          true);
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          4,
                                                                      horizontal:
                                                                          12),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .green
                                                                        .shade500,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    "Beta trial",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                    : const SizedBox(),
                                                baseController!.isTried.value
                                                    ? const SizedBox()
                                                    : baseController!
                                                            .isBetaVersion.value
                                                        ? const SizedBox()
                                                        : const SizedBox(),
                                                // SizedBox(
                                                //     height: isTablet ? 24 : 20),
                                                InkWell(
                                                  onTap: () {
                                                    if (Platform.isIOS) {
                                                      Get.toNamed(AppRoutes
                                                          .premiumIosScreen);
                                                    } else {
                                                      Get.toNamed(AppRoutes
                                                          .premiumSubscriptionPage);
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: isTablet
                                                                ? 16
                                                                : 12,
                                                            horizontal: isTablet
                                                                ? 20
                                                                : 16),
                                                    decoration: BoxDecoration(
                                                      color: buttonColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            "Buy subscription",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: isTablet
                                                                  ? 16
                                                                  : 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                    
                       
                            } else if (con.getreadAccess.value == "false" &&
                                      con.getpodcastacess.value == "false") {
                              return  Container(
                                      height: Get.height,
                                      width: Get.width,
                                      color: Colors.grey.withOpacity(0.5),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: Get.width * 0.8,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 20,
                                              horizontal: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                    // con.showDialog.value =
                                                    //     true;
                                                  },
                                                  child: const Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Image.asset(
                                                  "assets/images/logo.png",
                                                  height: isTablet
                                                      ? Get.height * 0.14
                                                      : Get.height * 0.1,
                                                ),
                                                SizedBox(
                                                    height: isTablet ? 16 : 12),
                                                Text(
                                                  "Get full access!",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          isTablet ? 21 : 18,
                                                      color: textColor),
                                                ),
                                                SizedBox(
                                                    height: isTablet ? 12 : 8),
                                                Obx(() => Text(
                                                      con.isBookDetail.isFalse
                                                          ? "Have unlimited access to all amazing books content."
                                                          : "Have unlimited access to listen all new podcasts",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            isTablet ? 16 : 14,
                                                        color: Colors.grey,
                                                      ),
                                                    )),
                                                SizedBox(
                                                    height: isTablet ? 24 : 20),
                                                baseController!
                                                        .isBetaVersion.value
                                                    ? baseController!
                                                                .isSubscribed
                                                                .value &&
                                                            baseController!
                                                                .betaVersion
                                                                .value
                                                        ? const SizedBox()
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              const Text(
                                                                "Click here to activate ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  con.showDialog
                                                                          .value =
                                                                      false;
                                                                  con.con.getPaymentUrlApi(
                                                                      isBeta:
                                                                          true);
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          4,
                                                                      horizontal:
                                                                          12),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .green
                                                                        .shade500,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    "Beta trial",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                    : const SizedBox(),
                                                baseController!.isTried.value
                                                    ? const SizedBox()
                                                    : baseController!
                                                            .isBetaVersion.value
                                                        ? const SizedBox()
                                                        : const SizedBox(),
                                                // SizedBox(
                                                //     height: isTablet ? 24 : 20),
                                                InkWell(
                                                  onTap: () {
                                                    if (Platform.isIOS) {
                                                      Get.toNamed(AppRoutes
                                                          .premiumIosScreen);
                                                    } else {
                                                      Get.toNamed(AppRoutes
                                                          .premiumSubscriptionPage);
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: isTablet
                                                                ? 16
                                                                : 12,
                                                            horizontal: isTablet
                                                                ? 20
                                                                : 16),
                                                    decoration: BoxDecoration(
                                                      color: buttonColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            "Buy subscription",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: isTablet
                                                                  ? 16
                                                                  : 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                       
                       
                        
                       
                        } else if (con.bookDetail.value.booktype == 3 ||  con.getreadAccess.value == "true" ||
                            con.getpodcastacess.value == "true") {
                              // ignore: prefer_const_constructors
                              return  const SizedBox(height: 0, width: 0);
                               } else if (con.bookDetail.value.booktype.toString() == "2" 
                           ) {
                              // ignore: prefer_const_constructors
                              return 
                               Container(
                                      height: Get.height,
                                      width: Get.width,
                                      color: Colors.grey.withOpacity(0.5),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: Get.width * 0.8,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 20,
                                              horizontal: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                    // con.showDialog.value =
                                                    //     true;
                                                  },
                                                  child: const Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Image.asset(
                                                  "assets/images/logo.png",
                                                  height: isTablet
                                                      ? Get.height * 0.14
                                                      : Get.height * 0.1,
                                                ),
                                                SizedBox(
                                                    height: isTablet ? 16 : 12),
                                                Text(
                                                  "Get full access!",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          isTablet ? 21 : 18,
                                                      color: textColor),
                                                ),
                                                SizedBox(
                                                    height: isTablet ? 12 : 8),
                                                Obx(() => Text(
                                                      con.isBookDetail.isFalse
                                                          ? "Have unlimited access to all amazing books content."
                                                          : "Have unlimited access to listen all new podcasts",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            isTablet ? 16 : 14,
                                                        color: Colors.grey,
                                                      ),
                                                    )),
                                                SizedBox(
                                                    height: isTablet ? 24 : 20),
                                                baseController!
                                                        .isBetaVersion.value
                                                    ? baseController!
                                                                .isSubscribed
                                                                .value &&
                                                            baseController!
                                                                .betaVersion
                                                                .value
                                                        ? const SizedBox()
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              const Text(
                                                                "Click here to activate ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  con.showDialog
                                                                          .value =
                                                                      false;
                                                                  con.con.getPaymentUrlApi(
                                                                      isBeta:
                                                                          true);
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          4,
                                                                      horizontal:
                                                                          12),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .green
                                                                        .shade500,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    "Beta trial",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                    : const SizedBox(),
                                                baseController!.isTried.value
                                                    ? const SizedBox()
                                                    : baseController!
                                                            .isBetaVersion.value
                                                        ? const SizedBox()
                                                        : const SizedBox(),
                                                // SizedBox(
                                                //     height: isTablet ? 24 : 20),
                                                InkWell(
                                                  onTap: () {
                                                    if (Platform.isIOS) {
                                                      Get.toNamed(AppRoutes
                                                          .premiumIosScreen);
                                                    } else {
                                                      Get.toNamed(AppRoutes
                                                          .premiumSubscriptionPage);
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: isTablet
                                                                ? 16
                                                                : 12,
                                                            horizontal: isTablet
                                                                ? 20
                                                                : 16),
                                                    decoration: BoxDecoration(
                                                      color: buttonColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            "Buy subscription",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: isTablet
                                                                  ? 16
                                                                  : 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                    
                       
                               //  const SizedBox(height: 0, width: 0);
                            } else {
                              return 
                            const SizedBox(height: 0, width: 0);
                                        }
                          }),

                       
                        
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  /// Collection Bottom Sheet

  void collectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
        barrierColor: const Color.fromARGB(255, 167, 219, 244).withOpacity(.2),
        isScrollControlled: true,
        context: context,
        constraints: const BoxConstraints(maxWidth: 800),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    gradient: verticalGradient,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    )),
                height: Get.height * 0.45,
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.only(top: isTablet ? 12 : 8),
                      width: Get.width * 0.14,
                      height: 4,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: isTablet ? 14 : 10,
                        right: isTablet ? 14 : 10,
                        top: isTablet ? 16 : 12,
                        bottom: isTablet ? 19 : 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Create collection',
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.29,
                      child: Obx(() => Get.find<HomeController>()
                              .userCollectionList
                              .isEmpty
                          ? Center(
                              child: Text(
                                "No collection found",
                                style: TextStyle(
                                  fontSize: isTablet ? 22 : 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: Get.find<HomeController>()
                                  .userCollectionList
                                  .length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    con.selectedIndex.value = index;
                                    con.selectedCollection.value =
                                        Get.find<HomeController>()
                                            .userCollectionList[index]
                                            .id
                                            .toString();
                                    con.update();
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(isTablet ? 12 : 8.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: Get.width,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(
                                              left: isTablet ? 8 : 5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.menu,
                                                color: textColor,
                                                size: isTablet ? 30 : 25,
                                              ),
                                              SizedBox(
                                                  width: isTablet ? 20 : 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      Get.find<HomeController>()
                                                              .userCollectionList[
                                                                  index]
                                                              .name ??
                                                          "",
                                                      style: TextStyle(
                                                          fontSize: isTablet
                                                              ? 17
                                                              : 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Text(
                                                      Get.find<HomeController>()
                                                                      .userCollectionList[
                                                                          index]
                                                                      .bookCount!
                                                                      .value !=
                                                                  1 &&
                                                              Get.find<HomeController>()
                                                                      .userCollectionList[
                                                                          index]
                                                                      .bookCount!
                                                                      .value !=
                                                                  0
                                                          ? '${Get.find<HomeController>().userCollectionList[index].bookCount ?? ""} Books '
                                                          : '${Get.find<HomeController>().userCollectionList[index].bookCount ?? ""} Book ',
                                                      style: TextStyle(
                                                        fontSize:
                                                            isTablet ? 14 : 12,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            isTablet ? 12 : 8),
                                                    Divider(
                                                        height:
                                                            isTablet ? 3 : 2,
                                                        color: borderColor),
                                                  ],
                                                ),
                                              ),
                                              con.selectedCollection.value ==
                                                      Get.find<HomeController>()
                                                          .userCollectionList[
                                                              index]
                                                          .id
                                                  ? Image.asset(
                                                      'assets/images/checkmark.png',
                                                      height:
                                                          isTablet ? 30 : 25,
                                                      width: isTablet ? 30 : 25,
                                                      fit: BoxFit.cover,
                                                      color:
                                                          Colors.pink.shade700,
                                                    )
                                                  : const SizedBox()
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                    ),
                    SizedBox(height: isTablet ? 12 : 8),
                    InkWell(
                      onTap: () {
                        Get.back();
                        if (con.selectedCollection.value.isNotEmpty) {
                          con.con.addBookToCollectionApi(
                            collectionId: con.selectedCollection.value,
                            bookId: con.bookDetail.value.id,
                            index: con.selectedIndex.value,
                          );
                        } else {
                          addCollection(context);
                        }
                      },
                      child: Container(
                        width: Get.width * 0.7,
                        height: isTablet ? 60 : 45,
                        margin: EdgeInsets.symmetric(
                            horizontal: isTablet ? 40 : 30),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(isTablet ? 70 : 50),
                            ),
                            gradient: verticalGradient),
                        child: Text(
                          con.selectedCollection.value.isNotEmpty
                              ? "Add to collection"
                              : 'Create new collection',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 18 : 14,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  /// Add Collection Bottom Sheet

  void addCollection(BuildContext context) {
    showModalBottomSheet(
        barrierColor: const Color.fromARGB(255, 167, 219, 244).withOpacity(.2),
        isScrollControlled: true,
        context: context,
        constraints: const BoxConstraints(maxWidth: 800),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                gradient: verticalGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      margin: EdgeInsets.only(top: isTablet ? 16 : 12),
                      width: Get.width * 0.14,
                      height: 4,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: isTablet ? 14 : 10,
                          right: isTablet ? 14 : 10,
                          top: isTablet ? 24 : 20,
                          bottom: isTablet ? 19 : 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Create collection',
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(isTablet ? 20 : 16.0),
                      child: Container(
                        height: isTablet ? 140 : 120,
                        padding: EdgeInsets.all(isTablet ? 12 : 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(isTablet ? 12 : 8)),
                        ),
                        child: TextField(
                          controller: con.controller.value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Please enter the collection title',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: isTablet ? 17 : 14,
                            ),
                          ),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: isTablet ? 18 : 15),
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 12 : 8),
                    InkWell(
                      onTap: () {
                        if (con.controller.value.text.trimRight().isNotEmpty) {
                          Get.back();
                          con.con.createCollectionApi(
                              name: con.controller.value.text);
                        } else {
                          toast(" Please enter the collection title", false);
                        }
                      },
                      child: Container(
                        width: Get.width * 0.5,
                        height: isTablet ? 60 : 45,
                        margin: EdgeInsets.symmetric(
                            horizontal: isTablet ? 40 : 30),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                            gradient: verticalGradient),
                        child: Text(
                          'Create',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 17 : 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 20 : 16),
                  ],
                ),
              ),
            );
          });
        });
  }

// /

  podcastrow() {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(left: isTablet ? 12 : 8),
        child: Row(
          children: [
            Icon(
              Icons.mic,
              color: Colors.white,
              size: isTablet ? 20 : 15,
            ),
            SizedBox(width: isTablet ? 12 : 8),
            Text(
              con.bookDetail.value.authorName ?? "",
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 17 : 14,
              ),
            ),
          ],
        ),
      ),
      10.heightBox,
      Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Row(
          children: [
            InkWell(
              onTap: () => con.shareBook(),
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 9 : 6),
                child: Image.asset(
                  "assets/icons/sharing.png",
                  height: isTablet ? 24 : 20,
                  width: isTablet ? 24 : 20,
                ),
              ),
            ),
            SizedBox(width: isTablet ? 20 : 16),
            Icon(
              Icons.headphones_outlined,
              color: Colors.white,
              size: isTablet ? 20 : 15,
            ),
            SizedBox(width: isTablet ? 12 : 8),
            Obx(() {
              return Text(
                con.bookDetail.value.listenCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 17 : 14,
                ),
              );
            }),
          ],
        ),
      ),
    ]);
  }

  /// Count Row

  countRow() {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 12 : 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.headphones_outlined,
                color: Colors.white,
                size: isTablet ? 20 : 15,
              ),
              SizedBox(width: isTablet ? 4 : 2),
              Obx(() {
                return Text(
                  con.bookDetail.value.listenCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 17 : 14,
                  ),
                );
              }),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.circle,
                color: Colors.white,
                size: isTablet ? 7 : 5,
              ),
              8.widthBox,
              Icon(
                Icons.bookmark_outline,
                color: Colors.white,
                size: isTablet ? 20 : 16,
              ),
              SizedBox(width: isTablet ? 3 : 2),
              Obx(() {
                return Text(
                  con.bookDetail.value.saveCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 17 : 14,
                  ),
                );
              }),
            ],
          ),
          Row(children: [
            Icon(
              Icons.circle,
              color: Colors.white,
              size: isTablet ? 7 : 5,
            ),
            8.widthBox,
            Image.asset(
              'assets/icons/downloads.png',
              height: isTablet ? 26 : 22,
              width: isTablet ? 26 : 22,
              color: Colors.white,
            ),
            SizedBox(width: isTablet ? 4 : 2),
            Text(
              con.bookDetail.value.downloadCount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 17 : 14,
              ),
            ),
          ])
        ],
      ),
    );
  }

  /// Action Row

  actionRow({context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => con.shareBook(),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 9 : 6),
            child: Image.asset(
              "assets/icons/sharing.png",
              height: isTablet ? 24 : 20,
              width: isTablet ? 24 : 20,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            con.selectedCollection.value = "";
            collectionBottomSheet(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.add_to_photos,
              color: commonBlueColor,
              size: isTablet ? 28 : 24,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (con.bookDetail.value.isPaid.toString() == "false" ||
                (con.bookDetail.value.isPaid.toString() == "true" &&
                    baseController!.isSubscribed.value.toString() == "true")) {
              if (baseController?.queueList
                      .where(
                          (p0) => p0.id == con.bookDetail.value.id.toString())
                      .isEmpty ==
                  true) {
                con.con.addToQueueApi();
                toast("Added to your queue", true);
              } else {
                toast("Book already added to your queue", false);
              }
            } else {
              con.showDialog.value = true;
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              'assets/icons/Queue.png',
              height: isTablet ? 30 : 24,
              width: isTablet ? 30 : 24,
              color: commonBlueColor,
            ),
          ),
        ),
        Obx(
          () => InkWell(
            onTap: () {
              if (con.bookDetail.value.isPaid.toString() == "false" ||
                  (con.bookDetail.value.isPaid.toString() == "true" &&
                      baseController!.isSubscribed.value.toString() ==
                          "true")) {
                if (con.bookDetail.value.isFavorite!.value) {
                  con.con
                      .deleteFavoriteBookApi(bookId: con.bookDetail.value.id);
                } else {
                  con.con.favoriteBookApi(bookId: con.bookDetail.value.id);
                }
              } else {
                con.showDialog.value = true;
              }
            },
            child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  con.bookDetail.value.isFavorite!.value
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: commonBlueColor,
                  size: isTablet ? 27 : 24,
                )),
          ),
        ),
      ],
    );
  }

  /// Book Image

  Widget bookImage() {
    return Obx(
      () => Container(
        height: isTablet ? 210 : 180,
        width: isTablet ? 150 : 130,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.0),
              spreadRadius: 0,
              blurRadius: 0,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: GestureDetector(
            onTap: () {
              Get.to(() =>
                  BooksImages(bookImage: con.bookDetail.value.image ?? ""));
            },
            child: PinchZoom(
              maxScale: 5,
              onZoomStart: () {},
              onZoomEnd: () {},
              child: con.bookDetail.value.isPremium == true
                  ? InkWell(
                      onTap: () {
                        // print("bookdetailsscreen ${con.categoriesPodcast[i].id}");
                        // FocusScope.of(context).unfocus();
                        // Get.find<BookDetailController>().callApis(
                        //     bookID: con.categoriesPodcast[i].id);
                        // Get.toNamed(AppRoutes.bookDetailScreen,
                        //     arguments: con.categoriesPodcast[i].id);
                      },
                      child: Container(
                        child: Stack(
                          alignment: Alignment
                              .center, // Center the icon on top of the image
                          children: [
                            //  child:
                            SizedBox(
                                width: isTablet ? 165 : 125,
                                height: isTablet ? 240 : 190,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          con.bookDetail.value.image ?? "",
                                      placeholder: (context, url) =>
                                          ShimmerTile(
                                        margin:
                                            EdgeInsets.all(isTablet ? 5 : 3),
                                        width: isTablet ? 165 : 125,
                                        height: isTablet ? 240 : 190,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ))),

                            // The ring with an icon
                            Positioned(
                              top: 5, // Position the ring closer to the bottom
                              right: 5, // Adjust the position to your needs
                              child: Container(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                  "assets/images/premium.png",
                                ),
                                // decoration: BoxDecoration(
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      height: isTablet ? 180 : 140,
                      width: isTablet ? 130 : 110,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: con.bookDetail.value.image ?? "",
                          placeholder: (b, c) {
                            return const SizedBox();
                          },
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
            )),
      ),
    );
  }

  /// Favorite Button

  Widget favoriteBtn() {
    return Obx(
      () => con.bookDetail.value.isSaved!.value == true
          ? IconButton(
              onPressed: () => deleteSavedBookApi(
                  bookId: con.bookDetail.value.id,
                  fromCategory: false,
                  fromSaved: false,
                  fromDetail: true),
              icon: Icon(Icons.bookmark,
                  color: GlobalService.to.isDarkModel == true
                      ? commonBlueColor
                      : buttonColor,
                  size: isTablet ? 24 : 20),
            )
          : IconButton(
              onPressed: () => savedBookApi(
                  bookId: con.bookDetail.value.id,
                  fromCategory: false,
                  fromDetail: true),
              icon: Icon(
                Icons.bookmark_border_outlined,
                color: GlobalService.to.isDarkModel == true
                    ? Colors.white
                    : buttonColor,
                size: isTablet ? 24 : 20,
              ),
            ),
    );
  }

  void reviewBottomSheet({BuildContext? context}) {
    showModalBottomSheet(
        barrierColor: const Color.fromARGB(255, 167, 219, 244).withOpacity(.2),
        isScrollControlled: true,
        context: context!,
        backgroundColor: const Color(0xFF00142D),
        constraints: const BoxConstraints(maxWidth: 800),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: Get.height * 0.92,
              decoration: BoxDecoration(
                color: const Color(0xFF00142D),
                gradient: verticalGradient,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: isTablet ? 16 : 12),
                  Container(
                    width: isTablet ? 60 : 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(height: isTablet ? 30 : 20),
                  Row(
                    children: [
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      Text(
                        "Rate this title",
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      const Spacer(),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 16 : 12),
                    ],
                  ),
                  SizedBox(height: isTablet ? 24 : 20),
                  Divider(
                    height: isTablet ? 2 : 1,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              height: isTablet ? 80 : 60,
                              alignment: Alignment.center,
                              child: RatingBar(
                                initialRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemSize: 34,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                    full: Icon(
                                      Icons.star,
                                      size: 15,
                                      color:
                                          GlobalService.to.isDarkModel == true
                                              ? Colors.amberAccent.shade400
                                              : buttonColor,
                                    ),
                                    half: Icon(
                                      Icons.star_half,
                                      color:
                                          GlobalService.to.isDarkModel == true
                                              ? Colors.amberAccent.shade400
                                              : buttonColor,
                                    ),
                                    empty: Icon(Icons.star,
                                        color: Colors.grey.shade500)),
                                onRatingUpdate: (value) {
                                  con.rating.value = value.toInt();
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextField(
                              controller: con.reviewController.value,
                              maxLines: 5,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: isTablet ? 17 : 15,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Please write your review here',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: isTablet ? 17 : 15,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: isTablet ? 20 : 16),
                          InkWell(
                            onTap: () {
                              if (con.reviewController.value.text
                                  .trim()
                                  .isNotEmpty) {
                                Get.back();
                                submitBookReviewApi();
                              } else {
                                toast("Please enter your comment.", false);
                              }
                            },
                            child: Container(
                              width: Get.width * 0.6,
                              height: isTablet ? 60 : 45,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  gradient: verticalGradient),
                              child: Text(
                                'Send review',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTablet ? 20 : 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: isTablet ? 20 : 16),
                          Obx(
                            () => con.reviewList.isEmpty
                                ? SizedBox(
                                    width: Get.width,
                                    child: Center(
                                      child: Text(
                                        "No reviews found",
                                        style: TextStyle(
                                          fontSize: isTablet ? 23 : 19,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: con.reviewList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(
                                                isTablet ? 20 : 16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      height:
                                                          isTablet ? 52 : 45,
                                                      width: isTablet ? 52 : 45,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey
                                                            .withOpacity(0.2),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: CircleAvatar(
                                                        radius: isTablet
                                                            ? 55
                                                            : 50.0,
                                                        backgroundImage: NetworkImage(con
                                                                .reviewList[
                                                                    index]
                                                                .userImage ??
                                                            (con
                                                                        .reviewList[
                                                                            index]
                                                                        .userId ==
                                                                    LocalStorage
                                                                        .userId
                                                                ? LocalStorage
                                                                    .profileImage
                                                                : "")),
                                                        backgroundColor:
                                                            Colors.transparent,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            isTablet ? 20 : 16),
                                                    Expanded(
                                                      child: Text(
                                                        con.reviewList[index]
                                                                .createdByName ??
                                                            "",
                                                        style: TextStyle(
                                                          fontSize: isTablet
                                                              ? 20
                                                              : 17,
                                                          color: GlobalService
                                                                      .to
                                                                      .isDarkModel ==
                                                                  true
                                                              ? Colors.white
                                                              : headingColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            isTablet ? 4 : 2),
                                                    RatingBar(
                                                      initialRating:
                                                          double.parse(con
                                                              .reviewList[index]
                                                              .rating
                                                              .toString()),
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: false,
                                                      itemSize:
                                                          isTablet ? 18 : 15,
                                                      itemCount: 5,
                                                      ratingWidget:
                                                          RatingWidget(
                                                              full: Icon(
                                                                Icons.star,
                                                                size: isTablet
                                                                    ? 18
                                                                    : 15,
                                                                color: GlobalService
                                                                            .to
                                                                            .isDarkModel ==
                                                                        true
                                                                    ? Colors
                                                                        .amberAccent
                                                                        .shade400
                                                                    : buttonColor,
                                                              ),
                                                              half: Icon(
                                                                Icons.star_half,
                                                                color: GlobalService
                                                                            .to
                                                                            .isDarkModel ==
                                                                        true
                                                                    ? Colors
                                                                        .amberAccent
                                                                        .shade400
                                                                    : buttonColor,
                                                              ),
                                                              empty: Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade500)),
                                                      onRatingUpdate: (value) {
                                                        con.rating.value =
                                                            value.toInt();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: isTablet ? 15 : 12),
                                                Text(
                                                  con.reviewList[index]
                                                          .comment ??
                                                      "",
                                                  style: TextStyle(
                                                    fontSize:
                                                        isTablet ? 16 : 14,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: isTablet ? 20 : 16),
                                            child: const Divider(
                                              height: 2,
                                              color: Colors.white,
                                              indent: 0,
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }
}
