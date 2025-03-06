import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/home/search_api.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/home/home_screen.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/widget/search_list.dart';
import 'package:puthagam/screen/dashboard/podcast/components/author_podcast_screen.dart';
import 'package:puthagam/screen/dashboard/podcast/components/podcast_category_screen.dart';
import 'package:puthagam/screen/dashboard/podcast/listen_podcast.dart';
import 'package:puthagam/screen/dashboard/podcast/podcast_controller.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/shimmer_tile.dart';
import 'package:puthagam/utils/themes/no_internet_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class PodcastPage extends StatelessWidget {
  PodcastPage({Key? key}) : super(key: key);
  final BookDetailController con1 = Get.put(BookDetailController());
  final PodcastController con = Get.put(PodcastController());

  @override
  Widget build(BuildContext context) {
 
   //print("proadcastt${ con.refreshData()}");
    return Scaffold(
        body: Obx(() => con.isConnected.isFalse
            ? NoInternetScreen(onTap: () async {
                bool connection = await checkConnection();
                if (connection) {
                  con.isConnected.value = true;
                  con.getCategoriesPodcastApi();
                  con.getExplorePodcastApi();
                  con.getWeekPodcastApi();
                } else {
                  con.isConnected.value = false;
                }
              })
            : RefreshIndicator(
                onRefresh: () => con.callAllApis(),
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  decoration: BoxDecoration(gradient: verticalGradient),
                  child: SafeArea(
                    child: Stack(children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8),
                              decoration:
                                  BoxDecoration(gradient: horizontalGradient),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: isTablet ? 12 : 8),
                                  Image.asset(
                                    'assets/icons/podcast2.png',
                                    height: isTablet ? 34 : 30,
                                    width: isTablet ? 34 : 30,
                                    //  color: Colors.grey,
                                  ),
                                  const SizedBox(width: 10),
                                  Center(
                                    child: Text(
                                      'Masterclass',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: isTablet ? 17 : 14,
                                        fontWeight: FontWeight.w500,
                                        color: commonBlueColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 16),
                            Obx((() {
                              return con.livePodcastLoading.isTrue
                                  ? const CupertinoActivityIndicator()
                                      .centered()
                                  : con.allLivePodcast.isNotEmpty
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Row(
                                            //     mainAxisAlignment:
                                            //         MainAxisAlignment.end,
                                            //     children: [
                                            //       "Refresh".text.gray500.make(),
                                            //       5.widthBox,
                                            //       const Icon(
                                            //         Icons.refresh_rounded,
                                            //         color: Vx.gray500,
                                            //       ),
                                            //       10.widthBox,
                                            //     ]).onInkTap(() {
                                            //   con.getLivePodCasts();
                                            // }).marginAll(8),
                                            con.allLivePodcast.length == 1
                                                ? BuildLivePodcast(
                                                        con.allLivePodcast[0])
                                                    .onInkTap(() {
                                                    if (baseController!
                                                            .isSubscribed.value
                                                            .toString() ==
                                                        "true") {
                                                      Get.to(PodcastWebView(con
                                                              .allLivePodcast[0]
                                                              .episodeId!))
                                                          ?.then((value) {
                                                        con.getLivePodCasts();
                                                      });
                                                    } else {
                                                      // con1.showDialog.value =
                                                      //     true;
                                                      // print("object");
                                                      // toast(
                                                      //     "mnmn", "hbbbc nch");
                                                    }
                                                  })
                                                : ListView.builder(
                                                    itemCount: con
                                                        .allLivePodcast.length,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder: (ctx, index) {
                                                      return BuildLivePodcast(
                                                              con.allLivePodcast[
                                                                  index])
                                                          .onInkTap(() {
                                                        // if (baseController!
                                                        //         .isSubscribed
                                                        //         .value
                                                        //         .toString() ==
                                                        //     "true") {
                                                        Get.to(PodcastWebView(con
                                                                .allLivePodcast[
                                                                    0]
                                                                .episodeId!))
                                                            ?.then((value) {
                                                          con.getLivePodCasts();
                                                        });
                                                        // } else {
                                                        //   print("object");
                                                        // }
                                                        // Get.to(PodcastWebView(con
                                                        //         .allLivePodcast[
                                                        //             index]
                                                        //         .episodeId!))
                                                        //     ?.then((value) {
                                                        //   con.getLivePodCasts();
                                                        // });
                                                      });
                                                    }).h(100),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                              "No live podcasts"
                                                  .text
                                                  .white
                                                  .color(Vx.gray500)
                                                  .make()
                                                  .paddingOnly(top: 8),
                                              10.widthBox,
                                              const Icon(
                                                Icons.refresh_rounded,
                                                color: Vx.gray500,
                                              ).paddingOnly(top: 8)
                                            ]).onInkTap(() {
                                          con.getLivePodCasts();
                                        });
                            })),
                            SizedBox(height: isTablet ? 18 : 14),
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
                                                    "No podcast found".tr,
                                                    style: TextStyle(
                                                      fontSize:
                                                          isTablet ? 25 : 22,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : 
                                        SearchList()
                                    //:  
                                    //  topCategories(),
                                   :
                                    Column(
                                        children: [
                           newThisWeek(),
                            SizedBox(height: isTablet ? 14 : 10),
                            Obx(() => con.categoryBooksList.isNotEmpty
                                ? PodcastCategoryBooks(
                                    catDataList: con.categoryBooksList)
                                : const SizedBox()),
                            Obx(() => con.categoryBooksList.isNotEmpty
                                ? SizedBox(height: isTablet ? 18 : 16)
                                : const SizedBox()),
                            Obx(() => con.authorsPodcastList.isNotEmpty
                                ? AuthorsPodcast(
                                    authorsDataList: con.authorsPodcastList)
                                : const SizedBox()),
                            Obx(() => con.authorsPodcastList.isNotEmpty
                                ? SizedBox(height: isTablet ? 18 : 16)
                                : const SizedBox()),
                            topCategories(),

                            SizedBox(height: isTablet ? 14 : 10),
                            explorePodcasts(),
                            10.heightBox,
                          ],
                       ),
                      ),
                    
                    ]),
                  )]))
                ),
              )));
  }

  Widget newThisWeek() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w500,
                  color: commonBlueColor,
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     Get.toNamed(AppRoutes.weekPodcastScreen);
              //   },
              //   child: const Text(
              //     'View More',
              //     style: TextStyle(
              //       fontSize: 15,
              //       color: Color(0xFF0254A5),
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => con.weekLoading.value
            ? SizedBox(
                height: isTablet ? 220 : 180,
                width: double.infinity,
                child: ListView.builder(
                    padding: EdgeInsets.only(left: isTablet ? 12 : 8),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return ShimmerTile(
                        margin: EdgeInsets.only(right: isTablet ? 16 : 12),
                        height: isTablet ? 220 : 200,
                        width: 160,
                      );
                    }),
              )
            : con.weekPodcastList.isEmpty
                ? SizedBox(
                    height: 190,
                    child: Center(
                      child: Text(
                        "No podcast found",
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: isTablet ? 240 : 210,
                    width: double.infinity,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(left: 8, right: 16),
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: con.weekPodcastList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: const EdgeInsets.all(3),
                              child: InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  FocusScope.of(context).unfocus();
                                  Get.find<BookDetailController>().callApis(
                                      bookID: con.weekPodcastList[index].id);
                                  Get.toNamed(AppRoutes.bookDetailScreen,
                                      arguments: con.weekPodcastList[index].id);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 2),
                                    SizedBox(
                                      width: isTablet ? 145 : 125,
                                      height: isTablet ? 220 : 190,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: con.weekPodcastList[index]
                                                  .image ??
                                              "",
                                          placeholder: (b, c) {
                                            return const SizedBox();
                                          },
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    // const SizedBox(height: 8),
                                    // Container(
                                    //   width: 125,
                                    //   alignment: Alignment.centerLeft,
                                    //   child: Text(
                                    //     con.weekPodcastList[index].title ?? "",
                                    //     maxLines: 2,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     style: const TextStyle(
                                    //       fontSize: 14,
                                    //     ),
                                    //     textAlign: TextAlign.left,
                                    //   ),
                                    // ),

                                    // const Spacer(),
                                    // Text(
                                    //   "${con.weekPodcastList[index].chapterCount ?? 0} Episodes",
                                    //   style: const TextStyle(fontSize: 15),
                                    // )
                                  ],
                                ),
                              ));
                        }),
                  ))
      ],
    );
  }

  /// Top Of Categories

  Widget topCategories() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: isTablet ? 12 : 8, right: isTablet ? 12 : 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Most popular",
                style: TextStyle(
                  fontSize: isTablet ? 17 : 14,
                  fontWeight: FontWeight.w500,
                  color: commonBlueColor,
                ),
              ),
              Obx(() => con.categoriesPodcast.length > 3
                  ? InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.podcastCategoriesScreen);
                      },
                      child: Row(
                        children: [
                          Text(
                            'viewMore'.tr,
                            style: TextStyle(
                              fontSize: isTablet ? 15 : 12,
                              color: borderColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox())
            ],
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),
        Obx(() =>
        // con.collectionLoading.value
        //     ? 
        // SizedBox(
        //         height: isTablet ? 245 : 215,
        //         width: double.infinity,
        //         child: ListView.builder(
        //             padding: const EdgeInsets.only(left: 5, right: 5),
        //             shrinkWrap: true,
        //             physics: const BouncingScrollPhysics(),
        //             itemCount: 10,
        //             scrollDirection: Axis.horizontal,
        //             itemBuilder: (BuildContext context, int index) {
        //               return ShimmerTile(
        //                 margin: EdgeInsets.only(right: isTablet ? 12 : 8),
        //                 height: isTablet ? 245 : 215,
        //                 width: 160,
        //               );
        //             }),
        //       )
           // :
             con.categoriesPodcast.isEmpty
                ? 
                  SizedBox(
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
                // const SizedBox(
                //     height: 215,
                //     child: Center(
                //       child: Text(
                //         "No podcast found",
                //         style: TextStyle(
                //           fontSize: 20,
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //     ),
                //   )
                : 
                //Text("hhhhh")
                
                 SizedBox(
                    height: isTablet ? 295 : 245,
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
                                        imageUrl: con.categoriesPodcast[index]
                                                .image ??
                                            "",
                                        placeholder: (b, c) {
                                          return const SizedBox();
                                        },
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: isTablet ? 145 : 125,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      con.categoriesPodcast[index].title ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: isTablet ? 16 : 14,
                                        // fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                               
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                //  )
        ),
      ],
    );
  }

  /// Explore Podcasts

  Widget explorePodcasts() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: isTablet ? 12 : 8, right: isTablet ? 12 : 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Explore",
                style: TextStyle(
                  fontSize: isTablet ? 17 : 14,
                  color: commonBlueColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Obx(() => con.exploreList.length > 3
                  ? InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.explorePodcastScreen);
                      },
                      child: Row(
                        children: [
                          Text(
                            'viewMore'.tr,
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              color: borderColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox())
            ],
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Obx(() => con.exploreLoading.value
            ? SizedBox(
                height: isTablet ? 230 : 190,
                width: double.infinity,
                child: ListView.builder(
                    padding: EdgeInsets.only(left: isTablet ? 12 : 8),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return ShimmerTile(
                        margin: const EdgeInsets.only(right: 8),
                        height: isTablet ? 210 : 190,
                        width: 160,
                      );
                    }),
              )
            : con.exploreList.isEmpty
                ? SizedBox(
                    height: 190,
                    child: Center(
                      child: Text(
                        "No podcast found",
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                :
                 SizedBox(
                    height: isTablet ? 240 : 210,
                    width: double.infinity,
                    child: ListView.builder(
                        padding: EdgeInsets.only(
                            left: isTablet ? 12 : 8, right: isTablet ? 20 : 16),
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: con.exploreList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(3),
                            child:  con.exploreList[index].isPremium == true ?
                          InkWell(
                            onTap: () {
                                FocusScope.of(context).unfocus();
                                Get.find<BookDetailController>().callApis(
                                    bookID: con.exploreList[index].id);
                                Get.toNamed(AppRoutes.bookDetailScreen,
                                    arguments: con.exploreList[index].id);
                              },
                            child: Container(
                                padding: const EdgeInsets.only(top: 10),
                              child: Stack(
          alignment: Alignment.center, // Center the icon on top of the image
          children: [
           //  child: 
             SizedBox(
                                width: isTablet ? 165 : 125,
                                height: isTablet ? 240 : 190,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                     imageUrl:
                                              con.exploreList[index].image ??
                                                  "",
                                    placeholder: (context, url) => 
                                    ShimmerTile(
                                      margin: EdgeInsets.all(isTablet ? 5 : 3),
                                      width: isTablet ? 165 : 125,
                                      height: isTablet ? 240 : 190,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ))),
            // The background image
            // Container(
            //   width: 200,
            //   height: 200,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: NetworkImage('https://via.placeholder.com/200'), // Replace with your image URL
            //       fit: BoxFit.cover,
            //     ),
            //     borderRadius: BorderRadius.circular(100), // Circular image
            //   ),
            // ),

            // The ring with an icon
            Positioned(
            top: 5, // Position the ring closer to the bottom
              right: 5,  // Adjust the position to your needs
              child: Container(
                width: 20,
                height: 20,
                child:  Image.asset(
                          "assets/images/premium.png",
                ),
                // decoration: BoxDecoration(
                //   shape: BoxShape.circle,
                //   border: Border.all(color: Colors.blue, width: 3), // The ring
                //   color: Colors.red, // Background color of the icon
                // ),
                // child: Icon(
                //   Icons.camera_alt, // Icon inside the ring
                //   size: 30,
                //   color: Colors.blue,
                // ),
              ),
            ),
          ],
        ),
    //  ),
    //);
                              //Text(con.categoriesPodcast[i].isPremium.toString()),
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(5),
                              // ),
                              // child: SizedBox(
                              //   width: isTablet ? 165 : 125,
                              //   height: isTablet ? 240 : 190,
                              //   child: ClipRRect(
                              //     borderRadius: BorderRadius.circular(10),
                              //     child: CachedNetworkImage(
                              //       imageUrl:
                              //           con.categoriesPodcast[i].image ?? "",
                              //       placeholder: (context, url) => 
                              //       ShimmerTile(
                              //         margin: EdgeInsets.all(isTablet ? 5 : 3),
                              //         width: isTablet ? 165 : 125,
                              //         height: isTablet ? 240 : 190,
                              //       ),
                              //       errorWidget: (context, url, error) =>
                              //           Icon(Icons.error),
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),
                              // ),
                            ),
                          ):
                             InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                Get.find<BookDetailController>().callApis(
                                    bookID: con.exploreList[index].id);
                                Get.toNamed(AppRoutes.bookDetailScreen,
                                    arguments: con.exploreList[index].id);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: isTablet ? 220 : 190,
                                    width: isTablet ? 145 : 125,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              con.exploreList[index].image ??
                                                  "",
                                          placeholder: (b, c) {
                                            return const SizedBox();
                                          },
                                          fit: BoxFit.cover,
                                        )),
                                  ),

                                
                                ],
                              ),
                            ),
                          );
                        }),
                  ))
      ],
    );
  }

  Widget searchBar({context}) {
    return Obx(
      () => Container(
        margin: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
        height: isTablet ? 60 : 50,
        decoration: BoxDecoration(
          gradient: horizontalGradient,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      left: isTablet ? 13 : 9, right: isTablet ? 9 : 6),
                  child: Image.asset(
                    "assets/icons/search.png",
                    height: isTablet ? 29 : 25,
                    width: isTablet ? 29 : 25,
                  )),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.left,
                  controller: con.searchController.value,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Title & Podcaster',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: text23,
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                  onChanged: (v) {
                     
                    if (con.searchController.value.text.trim().isEmpty) {
                    
                    
                       print("masterplacetw${con.searchController.value.text.trim().isEmpty}");
                         
                      con.isSearch.value = false;
                     
                      
                    }
                  },
                  onEditingComplete: () {
                    if (con.searchController.value.text.trim().isNotEmpty) {
                      con.isSearch.value = true;
                       print("refreshData${con.searchController.value.text.trim().isEmpty}");
                      getSearchListApi();
                       FocusManager.instance.primaryFocus?.unfocus();
                      

                    } else {
                      con.isSearch.value = false;
                    }
                 //   FocusScope.of(context).unfocus();
                    
                  },
                ),
              ),
              Obx(
                () => con.isSearch.value
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12),
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
