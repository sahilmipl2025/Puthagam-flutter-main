// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:puthagam/data/api/auth/signout_api.dart';
import 'package:puthagam/data/api/category/get_category_list_api.dart';
import 'package:puthagam/data/api/home/get_continue_api.dart';
import 'package:puthagam/data/api/home/get_explore_list_api.dart';
import 'package:puthagam/data/api/home/get_meetcreator_list_api.dart';
import 'package:puthagam/data/api/notification/get_notification_count_api.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/model/live_podcasts_response/datum.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/widget/bottom_audio.dart';
import 'package:puthagam/screen/dashboard/home/widget/authors_books.dart';
import 'package:puthagam/screen/dashboard/home/widget/categories.dart';
import 'package:puthagam/screen/dashboard/home/widget/category_books.dart';
import 'package:puthagam/screen/dashboard/home/widget/collection.dart';
import 'package:puthagam/screen/dashboard/home/widget/explore.dart';
import 'package:puthagam/screen/dashboard/home/widget/freebooks.dart';
import 'package:puthagam/screen/dashboard/home/widget/homesearchlist.dart';
import 'package:puthagam/screen/dashboard/home/widget/masterclass.dart';
import 'package:puthagam/screen/dashboard/home/widget/meet_creator.dart';
import 'package:puthagam/screen/dashboard/home/widget/proadsearchapi.dart';
import 'package:puthagam/screen/dashboard/home/widget/today_for_you.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/shimmer_tile.dart';
import 'package:puthagam/utils/themes/global.dart';
import 'package:puthagam/utils/themes/no_internet_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'screen/book_detail/api_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController con = Get.put(HomeController());
  BookDetailApiController con2 = Get.find<BookDetailApiController>();
  final ScrollController _scrollController =
      ScrollController(); // Added ScrollController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => con.isConnected.isFalse
            ? NoInternetScreen(
                onTap: () async {
                  // ... your existing logic
                },
              )
            : Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () => con.refreshData(),
                    child: Container(
                      height: Get.height,
                      width: Get.width,
                      decoration: BoxDecoration(gradient: verticalGradient),
                      child: ListView(
                        controller:
                            _scrollController, // Add scroll controller here
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // InkWell(
                          //   onTap: () {
                          //   //  con.getCategoriesPodcastApi();
                          //   },
                          //  // child: Text("hhhhhhhhhh")),
                          topBar(context),
                          SizedBox(height: isTablet ? 24 : 20),
                          continueListening(context: context),
                          SizedBox(height: isTablet ? 20 : 16),
                          searchBar(context: context),
                          SizedBox(height: isTablet ? 20 : 16),
                          Obx(
                            () => con.isSearch.value
                                ? con.searchLoader.value
                                    ? SizedBox(
                                        height: Get.height * 0.5,
                                        child: const Center(
                                          child: AppLoader(),
                                        ),
                                      )
                                    : con.searchBookList.isEmpty
                                        ? SizedBox(
                                            height: Get.height * 0.5,
                                            child: Center(
                                              child: Text(
                                                "No records found".tr,
                                                style: TextStyle(
                                                  fontSize: isTablet ? 25 : 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          )
                                        : SearchListt()
                                : Column(
                                    children: [
                                      Categories(),
                                      SizedBox(height: isTablet ? 18 : 16),
                                      Freebooks(),
                                      Master(),
                                      SizedBox(height: isTablet ? 18 : 16),
                                      TodayForYou(),
                                      Obx(
                                        () => con.categoryBooksList.isNotEmpty
                                            ? CategoryBooks(
                                                catDataList:
                                                    con.categoryBooksList,
                                                // loadingStates: con
                                                //     .loadingStates, // Pass loadingStates here
                                              )
                                            : SizedBox(
                                              
                                                ),
                                      ),
                                      Obx(
                                        () => con.categoryBooksList.isNotEmpty
                                            ? SizedBox(
                                                height: isTablet ? 18 : 16)
                                            : const SizedBox(),
                                      ),
                                      Obx(
                                        () {
                                          //  print("obx run authorsDataList.}");
                                          return con.authorsBooksList.isNotEmpty
                                              ? AuthorsBooks(
                                                  authorsDataList:
                                                      con.authorsBooksList)
                                              : const SizedBox(
                                                  // child: Text("No data"),
                                                  );
                                        },
                                      ),
                                      Obx(() => con.authorsBooksList.isNotEmpty
                                          ? SizedBox(height: isTablet ? 18 : 16)
                                          : SizedBox(
                                              height: isTablet
                                                  ? 260
                                                  : 230, // Height of the ListView
                                              child: ListView.builder(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        isTablet ? 12 : 8),
                                                itemCount:
                                                    4, // Number of shimmer tiles
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: ShimmerTile(
                                                      margin: EdgeInsets.all(
                                                          isTablet ? 5 : 3),
                                                      width:
                                                          isTablet ? 165 : 125,
                                                      height:
                                                          isTablet ? 240 : 220,
                                                    ),
                                                  );
                                                },
                                              ),
                                            )),
                                      SizedBox(height: isTablet ? 18 : 16),
                                      Explore(),
                                      SizedBox(height: isTablet ? 18 : 16),
                                      Collection(),
                                      SizedBox(height: isTablet ? 18 : 16),
                                      MeetCreator(),
                                      SizedBox(height: isTablet ? 18 : 16),
                                    ],
                                  ),

                            //   ],
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BottomAudio(),
                ],
              ),
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return PopupMenuItem(
      child: Text(
        title,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
      onTap: onTap,
    );
  }

  /// Continue Listening

  Widget continueListening({context}) {
    return Obx(() => con.continueBookList.isEmpty && con.continueLoading.isFalse
        ? const SizedBox()
        : Container(
            margin: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        //  final _appticsFlutterPlugin = AppticsFlutter();

                        FirebaseMessaging.instance.getToken();

                        //con. getCategoriesPodcastApi();
                        //   getContinueListenListApi();
                        // con.getCategoriesPodcastApi();
                        // print("getCategoriesPodcastApi${con.getCategoriesPodcastApi()}");
                      },
                      child: Text(
                        'Continue listening',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 14,
                          fontWeight: FontWeight.w500,
                          color: commonBlueColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 16 : 12),
                Obx(() => con.continueLoading.value
                    ? SizedBox(
                        height: isTablet ? 130 : 110,
                        width: double.infinity,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 5,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return ShimmerTile(
                                margin:
                                    EdgeInsets.only(right: isTablet ? 20 : 16),
                                height: isTablet ? 130 : 110,
                                width: isTablet ? 300 : 250,
                              );
                            }),
                      )
                    : con.continueBookList.length != 1
                        ? SizedBox(
                            height: isTablet ? 130 : 110,
                            width: double.infinity,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: con.continueBookList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  print(
                                      "podcasttlength${con.continueBookList.length}");
                                  return Container(
                                    width: isTablet ? 300 : 250,
                                    margin: EdgeInsets.only(
                                        right: isTablet ? 16 : 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: horizontalGradient,
                                    ),
                                    padding: EdgeInsets.all(isTablet ? 16 : 12),
                                    child: InkWell(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        Get.find<BookDetailController>()
                                            .callApis(
                                          bookID:
                                              con.continueBookList[index].id,
                                          fromContinues: true,
                                          listenChapterId: con
                                              .continueBookList[index]
                                              .listenChapterIds,
                                        );
                                        Get.toNamed(AppRoutes.bookDetailScreen);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: isTablet ? 12 : 8),
                                          Container(
                                            height: isTablet ? 120 : 100,
                                            width: isTablet ? 86 : 70,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(con
                                                        .continueBookList[index]
                                                        .image ??
                                                    ""),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  child: Text(
                                                    con.continueBookList[index]
                                                            .title ??
                                                        "",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize:
                                                          isTablet ? 16 : 14,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: isTablet ? 3 : 2),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: isTablet ? 10 : 8),
                                                  child: Text(
                                                    con.continueBookList[index]
                                                            .categoryName ??
                                                        "",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize:
                                                          isTablet ? 13 : 12,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: text23,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: isTablet ? 13 : 10),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Obx(
                                                            () => Text(
                                                              "${((con.continueBookList[index].listenChapterIds!.length / int.parse(con.continueBookList[index].chapterCount.toString())) * 100).toStringAsFixed(0)}%",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      Get.width >
                                                                              550
                                                                          ? 12
                                                                          : 10.0),
                                                            ),
                                                          ),
                                                          5.widthBox,
                                                          Text(
                                                            "completed",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    Get.width >
                                                                            550
                                                                        ? 12
                                                                        : 10.0),
                                                          ),
                                                        ],
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 6),
                                                          child: Icon(
                                                            Icons.play_circle,
                                                            size: isTablet
                                                                ? 24
                                                                : 20,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: isTablet ? 4 : 2),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Obx(
                                                    () =>
                                                        LinearPercentIndicator(
                                                      alignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      barRadius:
                                                          const Radius.circular(
                                                              16),
                                                      lineHeight:
                                                          isTablet ? 9 : 7,
                                                      percent: con
                                                                  .continueBookList[
                                                                      index]
                                                                  .listenChapterIds!
                                                                  .length >
                                                              int.parse(con
                                                                  .continueBookList[
                                                                      index]
                                                                  .chapterCount
                                                                  .toString())
                                                          ? double.parse(con.continueBookList[index].chapterCount.toString()) /
                                                              int.parse(con
                                                                  .continueBookList[
                                                                      index]
                                                                  .chapterCount
                                                                  .toString())
                                                          : con
                                                                  .continueBookList[index]
                                                                  .listenChapterIds!
                                                                  .length /
                                                              int.parse(con.continueBookList[index].chapterCount.toString()),
                                                      backgroundColor: Colors
                                                          .grey
                                                          .withOpacity(0.4),
                                                      progressColor:
                                                          Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: horizontalGradient,
                            ),
                            padding: const EdgeInsets.all(12),
                            child: InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                Get.find<BookDetailController>().callApis(
                                  bookID: con.continueBookList[0].id,
                                  fromContinues: true,
                                  listenChapterId:
                                      con.continueBookList[0].listenChapterIds,
                                );

                                Get.toNamed(AppRoutes.bookDetailScreen);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: isTablet ? 12 : 8),
                                  Container(
                                    height: isTablet ? 110 : 90,
                                    width: isTablet ? 90 : 70,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            con.continueBookList[0].image ??
                                                ""),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: isTablet ? 14 : 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: isTablet ? 12 : 10),
                                          child: Text(
                                            con.continueBookList[0].title ?? "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: isTablet ? 16 : 14,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        SizedBox(height: isTablet ? 4 : 2),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: isTablet ? 12 : 8),
                                          child: Text(
                                            con.continueBookList[0]
                                                    .categoryName ??
                                                "",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: isTablet ? 14 : 12,
                                              overflow: TextOverflow.ellipsis,
                                              color: text23,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        SizedBox(height: isTablet ? 14 : 10),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: isTablet ? 12 : 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Obx(
                                                    () => Text(
                                                      "${((con.continueBookList[0].listenChapterIds!.length / int.parse(con.continueBookList[0].chapterCount.toString())) * 100).toStringAsFixed(0)}%",
                                                      style: TextStyle(
                                                          fontSize: isTablet
                                                              ? 12
                                                              : 10.0),
                                                    ),
                                                  ),
                                                  5.widthBox,
                                                  Text(
                                                    "completed",
                                                    style: TextStyle(
                                                        fontSize: isTablet
                                                            ? 12
                                                            : 10.0),
                                                  ),
                                                ],
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: isTablet ? 8 : 6),
                                                  child: Icon(
                                                    Icons.play_circle,
                                                    size: isTablet ? 24 : 20,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: isTablet ? 6 : 4),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Obx(
                                            () => LinearPercentIndicator(
                                              alignment:
                                                  MainAxisAlignment.start,
                                              barRadius:
                                                  const Radius.circular(16),
                                              lineHeight: isTablet ? 9 : 7.0,
                                              percent: con
                                                          .continueBookList[0]
                                                          .listenChapterIds!
                                                          .length >
                                                      int.parse(con
                                                          .continueBookList[0]
                                                          .chapterCount
                                                          .toString())
                                                  ? double.parse(con
                                                          .continueBookList[0]
                                                          .chapterCount
                                                          .toString()) /
                                                      int.parse(con
                                                          .continueBookList[0]
                                                          .chapterCount
                                                          .toString())
                                                  : con
                                                          .continueBookList[0]
                                                          .listenChapterIds!
                                                          .length /
                                                      int.parse(con.continueBookList[0].chapterCount.toString()),
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.4),
                                              progressColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
              ],
            ),
          ));
  }

  Widget topBar(context) {
    return Container(
      margin: EdgeInsets.only(top: isTablet ? 0 : 0),
      padding: EdgeInsets.only(right: isTablet ? 10 : 6),
      decoration: BoxDecoration(gradient: horizontalGradient),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => InkWell(
                        onTap: () {
                          con.getTodayForYou();
                          // con2.getDoneChaptersApi();
                        },
                        child: SizedBox(
                          child: Text(
                            'hey'.tr + baseController!.userName.value,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              color: commonBlueColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 4 : 2),
                    Text(
                      'goodDay'.tr,
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: Colors.white.withOpacity(.70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          baseController!.betaVersion.value
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade500,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    "Beta trial",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                )
              : const SizedBox(),
          baseController!.betaVersion.value
              ? SizedBox(width: isTablet ? 8 : 5)
              : const SizedBox(),
          Stack(
            children: [
              InkWell(
                onTap: () async {
                  await Get.toNamed(AppRoutes.notificationListScreen);
                  getNotificationCountApi();
                },
                child: Icon(
                  Icons.notifications_none_outlined,
                  size: isTablet ? 34 : 30,
                  color: commonBlueColor,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Obx(() => baseController!.notificationCount.value > 0
                    ? Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Text(
                          baseController!.notificationCount.value.toString(),
                          style: TextStyle(
                            fontSize: isTablet ? 12 : 10,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const SizedBox()),
              )
            ],
          ),
          SizedBox(width: isTablet ? 5 : 3),
          PopupMenuButton(
            color: Colors.white,
            itemBuilder: (BuildContext ctx) {
              return [
                _buildPopupMenuItem(
                    title: "Edit profile",
                    onTap: () {
                      Future.delayed(
                          const Duration(seconds: 0),
                          () => Get.toNamed(AppRoutes.editProfilePage)!
                              .then((value) => con.update()));
                    }),
                _buildPopupMenuItem(
                  title: "Log out",
                  onTap: () async => await logout(),
                ),
              ];
            },
            icon: baseController!.userProfile.value.toString() != "null" ||
                    baseController!.userProfile.value.isNotEmpty
                ? Obx(() => CircleAvatar(
                      radius: isTablet ? 26 : 22,
                      backgroundImage:
                          NetworkImage(baseController!.userProfile.value),
                      backgroundColor: Colors.grey.shade400,
                    ))
                : CircleAvatar(
                    radius: isTablet ? 26 : 22,
                    backgroundImage: const AssetImage("assets/images/user.png"),
                    backgroundColor: Colors.grey.shade400,
                  ),
          ),
          SizedBox(width: isTablet ? 9 : 6),
        ],
      ),
    );
  }

  /// Search Bar

  Widget searchBar({context}) {
    return Obx(
      () => Container(
        margin: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
        height: isTablet ? 54 : 50,
        decoration: BoxDecoration(
          gradient: horizontalGradient,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 9, right: 6),
                  child: Image.asset(
                    "assets/icons/search.png",
                    height: isTablet ? 30 : 25,
                    width: isTablet ? 30 : 25,
                  )),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.left,
                  controller: con.searchController.value,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Title, Author, Category or Podcaster',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: text23,
                      fontSize: isTablet ? 17 : 14,
                    ),
                  ),
                  onChanged: (v) {
                    if (con.searchController.value.text.trim().isEmpty) {
                      print(
                          "proddddd${con.searchController.value.text.trim().isEmpty}");
                      con.isSearch.value = false;
                    }
                  },
                  onEditingComplete: () {
                    if (con.searchController.value.text.trim().isNotEmpty) {
                      con.isSearch.value = true;
                      print(
                          "refreshData${con.searchController.value.text.trim().isEmpty}");
                      getSearchListApi1();
                      FocusManager.instance.primaryFocus?.unfocus();
                    } else {
                      con.isSearch.value = false;
                    }
                    //   FocusScope.of(context).unfocus();
                  },
                ),
              ),
              //     onEditingComplete: () {
              //       if (con.searchController.value.text.trim().isNotEmpty) {
              //         con.isSearch.value = true;
              //          print("prosecond${con.searchController.value.text.trim().isEmpty}");
              //         getSearchListApi1();

              //         FocusManager.instance.primaryFocus?.unfocus();
              //        // con.searchBookList.clear();
              //      //    FocusScope.of(context).unfocus();
              //       } else {
              //         con.isSearch.value = false;
              //       }
              //     },
              //   ),
              // ),
              Obx(
                () => con.isSearch.value
                    ? Padding(
                        padding: EdgeInsets.only(right: isTablet ? 16 : 12),
                        child: InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            con.isSearch.value = false;
                            con.searchController.value.clear();
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
    );
  }
}

/// Top Of Categories

Widget topCategories({required HomeController con}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding:
            EdgeInsets.only(left: isTablet ? 12 : 8, right: isTablet ? 12 : 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Popular in Masterclass",
              style: TextStyle(
                fontSize: isTablet ? 17 : 14,
                fontWeight: FontWeight.w500,
                color: commonBlueColor,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: isTablet ? 16 : 12),
      Obx(() => con.collectionLoading.value
          ? SizedBox(
              height: isTablet ? 245 : 215,
              width: double.infinity,
              child: ListView.builder(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return ShimmerTile(
                      margin: EdgeInsets.only(right: isTablet ? 12 : 8),
                      height: isTablet ? 245 : 215,
                      width: 160,
                    );
                  }),
            )
          : con.categoriesPodcast.isEmpty
              ? const SizedBox(
                  height: 215,
                  child: Center(
                    child: Text(
                      "No podcast found",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: isTablet ? 295 : 220,
                  width: double.infinity,
                  child: ListView.builder(
                      padding: const EdgeInsets.only(left: 8, right: 16),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: con.categoriesPodcast.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(3),
                          child: InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              Get.find<BookDetailController>().callApis(
                                  bookID: con.categoriesPodcast[index].id);
                              Get.toNamed(AppRoutes.bookDetailScreen,
                                  arguments: con.categoriesPodcast[index].id);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                SizedBox(
                                  height: isTablet ? 230 : 190,
                                  width: isTablet ? 145 : 125,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          con.categoriesPodcast[index].image ??
                                              "",
                                      placeholder: (b, c) {
                                        return const SizedBox();
                                      },
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                //  const SizedBox(height: 8),
                                // Container(
                                //   width: isTablet ? 145 : 125,
                                //   alignment: Alignment.centerLeft,
                                //   child: Text(
                                //     con.categoriesPodcast[index].title ?? "",
                                //     maxLines: 2,
                                //     overflow: TextOverflow.ellipsis,
                                //     style: TextStyle(
                                //       fontSize: isTablet ? 16 : 14,
                                //       // fontWeight: FontWeight.w600,
                                //     ),
                                //     textAlign: TextAlign.left,
                                //   ),
                                // ),
                                // const Spacer(),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: [
                                //     Container(
                                //       height: 25,
                                //       width: 25,
                                //       decoration: BoxDecoration(
                                //           shape: BoxShape.circle,
                                //           image: DecorationImage(
                                //               image: NetworkImage(
                                //                   con.categoriesPodcast[index]
                                //                           .categoryImage ??
                                //                       ""),
                                //               fit: BoxFit.cover)),
                                //     ),
                                //     const SizedBox(width: 5),
                                //     Container(
                                //       width: 90,
                                //       height: 30,
                                //       alignment: Alignment.centerLeft,
                                //       child: Text(
                                //         con.categoriesPodcast[index]
                                //                 .authorName ??
                                //             "",
                                //         style: const TextStyle(
                                //           fontSize: 15,
                                //           // fontWeight: FontWeight.w500,
                                //         ),
                                //         overflow: TextOverflow.visible,
                                //         maxLines: 1,
                                //         textAlign: TextAlign.left,
                                //       ),
                                //     )
                                //   ],
                                // )
                              ],
                            ),
                          ),
                        );
                      }),
                ))
    ],
  );
}

class BuildLivePodcast extends StatelessWidget {
  const BuildLivePodcast(this.podcast, {Key? key}) : super(key: key);
  final Datum podcast;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
      decoration: BoxDecoration(
        gradient: horizontalGradient,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: GlobalService.to.isDarkModel == true
            ? Colors.grey.withOpacity(.3)
            : buttonColor,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Container(
              height: 70,
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: podcast.podcastImage!,
                    placeholder: (b, c) {
                      return const SizedBox();
                    },
                    fit: BoxFit.fill,
                    height: 60,
                    width: 50,
                  )),
            ),
          ),
          const SizedBox(height: 5),
          16.widthBox,
          Expanded(
            child: Text(
              "${podcast.authorName ?? "n/a"} is live ..",
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontFamily: 'SF-Pro-Display-Semibold',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              maxLines: 2,
            ),
          ),
          40.widthBox,

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              clipBehavior: Clip.antiAlias,
              child: Container(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: ClipOval(
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              podcast.authorImage ?? "",
                            ),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    Color(0xFFA87F01),
                    Color(0xFFAE8601),
                    Color(0xFFD4B001),
                    Color(0xFFFAD901),
                    Color(0xFFF1D001),
                  ]),
                  // border: Border.all(
                  //     color: Colors.amber, width: 2),
                ),
              ),
            ),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.arrow_forward_ios,
          //     color: Colors.white,
          //   ),
          // )
        ],
      ),
    );
  }
}
