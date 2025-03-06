import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/podcast/screen/podcast_categories/podcast_categories_controller.dart';
import 'package:puthagam/screen/dashboard/podcast/widget/podcast_tile.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/no_internet_screen.dart';

class PodcastCategoriesScreen extends StatelessWidget {
  PodcastCategoriesScreen({Key? key}) : super(key: key);

  final PodcastCategoriesController con =
      Get.put(PodcastCategoriesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: horizontalGradient),
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back,
            size: 28,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Top categories',
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 17 : 14,
          ),
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
        //     child: InkWell(
        //       onTap: () => filterSheet(context: context),
        //       child: Container(
        //         height: 40,
        //         alignment: Alignment.center,
        //         width: 40,
        //         decoration: BoxDecoration(
        //           borderRadius: const BorderRadius.all(Radius.circular(8)),
        //           border: Border.all(
        //             width: 1,
        //             color: borderColor,
        //           ),
        //         ),
        //         child: Icon(
        //           Icons.filter_list,
        //           color: textColor,
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
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
                        con.getCategoriesListApi(pagination: false);
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
                                con.podcastList.isEmpty
                                    ? const Expanded(
                                        child: Center(
                                          child: Text(
                                            "No podcasts found",
                                            style: TextStyle(
                                              fontSize: 25,
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
                                            itemCount: con.podcastList.length,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Obx(() => PodcastTile(
                                                    title: con
                                                            .podcastList[index]
                                                            .title ??
                                                        "",
                                                    imageUrl: con
                                                            .podcastList[index]
                                                            .image ??
                                                        "",
                                                    authorName: con
                                                            .podcastList[index]
                                                            .authorName ??
                                                        "",
                                                    totalListen: con
                                                        .podcastList[index]
                                                        .listenCount
                                                        .toString(),
                                                    saveCount: con
                                                        .podcastList[index]
                                                        .saveCount
                                                        .toString(),
                                                    rating: double.parse(con
                                                        .podcastList[index]
                                                        .rating!
                                                        .round()
                                                        .toString()),
                                                    caption: con
                                                            .podcastList[index]
                                                            .caption ??
                                                        "",
                                                    categoryName: con
                                                            .podcastList[index]
                                                            .categoryName ??
                                                        "",
                                                    showRating: con
                                                                .podcastList[
                                                                    index]
                                                                .isSaved!
                                                                .value ==
                                                            true
                                                        ? true
                                                        : false,
                                                    savedOnTap: () {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      if (con.podcastList[index]
                                                          .isSaved!.value) {
                                                        con.deleteSavedBookApi(
                                                          index: index,
                                                          bookId: con
                                                              .podcastList[
                                                                  index]
                                                              .id,
                                                        );
                                                      } else {
                                                        con.savedBookApi(
                                                          index: index,
                                                          bookId: con
                                                              .podcastList[
                                                                  index]
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
                                                                  .podcastList[
                                                                      index]
                                                                  .id);
                                                      Get.toNamed(
                                                          AppRoutes
                                                              .bookDetailScreen,
                                                          arguments: con
                                                              .podcastList[
                                                                  index]
                                                              .id);
                                                    },
                                                  ));
                                            }),
                                      ),
                                con.paginationLoading.value
                                    ? const Center(child: AppLoader())
                                    : const SizedBox(),
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

  /// Books Filer Sheet

  filterSheet({context}) {
    showModalBottomSheet(
        barrierColor: const Color.fromARGB(255, 167, 219, 244).withOpacity(.2),
        isScrollControlled: true,
        context: context,
        constraints: const BoxConstraints(maxWidth: 800),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: SizedBox(
                  width: 800,
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(isTablet ? 16 : 12.0),
                          child: Container(
                            height: isTablet ? 7 : 5,
                            alignment: Alignment.center,
                            width: isTablet ? 44 : 35,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.4),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: isTablet ? 14 : 10.0,
                            right: isTablet ? 14 : 10.0,
                            top: isTablet ? 24 : 20.0,
                            bottom: isTablet ? 19 : 15.0),
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
                                con.getCategoriesListApi(pagination: false);
                                con.update();
                                Get.back();
                              },
                              child: Text(
                                'reset'.tr,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: isTablet ? 24 : 20,
                                  fontWeight: FontWeight.w500,
                                  // fontFamily: '.SF Pro Display-Regular',
                                ),
                              ),
                            ),
                            Text(
                              'filter'.tr,
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 20,
                                // fontFamily: '.SF Pro Display-Semibold',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                                con.getCategoriesListApi(pagination: false);
                              },
                              child: Text(
                                'done'.tr,
                                style: TextStyle(
                                  color: buttonColor,
                                  fontSize: isTablet ? 25 : 22,
                                  // fontFamily: '.SF Pro Display-Regular',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(height: 2, color: borderColor),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'sortBy'.tr,
                            style: TextStyle(
                              // fontFamily: '.SF Pro Display-Medium',
                              fontSize: isTablet ? 19 : 17,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(isTablet ? 12 : 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'listeners'.tr,
                              style: TextStyle(
                                color: textColor,
                                fontSize: isTablet ? 17 : 15,
                                fontFamily: '.SF Pro Display-Regular',
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: isTablet ? 12 : 10.0),
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
                                  value: con.status1.value,
                                  onToggle: (val) {
                                    con.status1.value = val;
                                    con.status2.value = !val;
                                  },
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: isTablet ? 12 : 8,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'downlods'.tr,
                              style: TextStyle(
                                color: textColor,
                                fontSize: isTablet ? 17 : 15,
                                // fontFamily: '.SF Pro Display-Regular',
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: isTablet ? 13 : 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      padding: 1,
                                      inactiveColor: borderColor,
                                      activeColor: commonBlueColor,
                                      value: con.status2.value,
                                      onToggle: (val) {
                                        con.status2.value = val;
                                        con.status1.value = !val;
                                      },
                                    )),
                                // Container(
                                //   alignment: Alignment.centerRight,
                                //   child: Text(
                                //     "Value: $status1",
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 8),
                      // Divider(height: 2, color: borderColor),
                      // Container(
                      //   alignment: Alignment.centerLeft,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8),
                      //     child: Text(
                      //       'author'.tr,
                      //       style: const TextStyle(
                      //         // fontFamily: '.SF Pro Display-Medium',
                      //         fontSize: 17,
                      //         fontWeight: FontWeight.w700,
                      //       ),
                      //       textAlign: TextAlign.left,
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 130,
                      //   child: ListView.builder(
                      //       itemCount:
                      //           Get.find<HomeController>().creatorList.length,
                      //       scrollDirection: Axis.horizontal,
                      //       itemBuilder: (BuildContext context, int index) {
                      //         return InkWell(
                      //           onTap: () {
                      //             setState(() {
                      //               con.selectedAuthorId.value =
                      //                   Get.find<HomeController>()
                      //                       .creatorList[index]
                      //                       .id
                      //                       .toString();
                      //             });
                      //             con.update();
                      //           },
                      //           child: Container(
                      //             height: 130,
                      //             padding:
                      //                 const EdgeInsets.only(left: 5, right: 12),
                      //             width: 120,
                      //             child: Column(
                      //               children: [
                      //                 Container(
                      //                   height: 75,
                      //                   width: 120,
                      //                   decoration: BoxDecoration(
                      //                       image: DecorationImage(
                      //                           image: NetworkImage(
                      //                               Get.find<HomeController>()
                      //                                       .creatorList[index]
                      //                                       .image ??
                      //                                   ""),
                      //                           fit: BoxFit.contain),
                      //                       borderRadius:
                      //                           const BorderRadius.all(
                      //                               Radius.circular(4)),
                      //                       border: Border.all(
                      //                         width: 2,
                      //                         color: con.selectedAuthorId
                      //                                     .value ==
                      //                                 Get.find<HomeController>()
                      //                                     .creatorList[index]
                      //                                     .id
                      //                             ? buttonColor
                      //                             : Colors.white,
                      //                       )),
                      //                 ),
                      //                 const SizedBox(height: 5),
                      //                 Text(
                      //                   Get.find<HomeController>()
                      //                           .creatorList[index]
                      //                           .name ??
                      //                       "",
                      //                   maxLines: 2,
                      //                   overflow: TextOverflow.ellipsis,
                      //                   style: const TextStyle(fontSize: 15),
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         );
                      //       }),
                      // ),
                      const SizedBox(height: 20)
                    ],
                  )),
            );
          });
        });
  }
}
