import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/explore_list/explore_list_screen.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/shimmer_tile.dart';

class Explore extends StatelessWidget {
  Explore({Key? key}) : super(key: key);

  final HomeController con = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => con.bookList.isNotEmpty
        ? 
    Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'explore'.tr,
                style: TextStyle(
                  fontSize: isTablet ? 18 : 14,
                  fontWeight: FontWeight.w500,
                  color: commonBlueColor,
                ),
              ),
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Get.to(() => ExploreListScreen());
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
            ],
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),
        Obx(
          () => con.categoryLoading.value
              ? SizedBox(
                  height: isTablet ? 260 : 220,
                  width: double.infinity,
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                        left: isTablet ? 12 : 8, right: isTablet ? 20 : 16),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return ShimmerTile(
                        margin: EdgeInsets.only(
                          right: isTablet ? 12 : 8,
                        ),
                        height: isTablet ? 260 : 220,
                        width: isTablet ? 230 : 190,
                      ).marginAll(isTablet ? 14 : 10);
                    },
                  ),
                )
              : con.bookList.isEmpty
                  ? SizedBox(
                      height: isTablet ? 260 : 220,
                      child: Center(
                        child: Text(
                          "noBooksFound".tr,
                          style: TextStyle(
                            fontSize: isTablet ? 23 : 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: isTablet ? 260 : 210,
                      width: double.infinity,
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                            left: isTablet ? 12 : 8, right: isTablet ? 20 : 16),
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: con.bookList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.all(isTablet ? 5 : 3.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                con.bookList[index].isPremium
                                 //  con.categoriesPodcast[i].isPremium
                                    == true ?
                          InkWell(
                            onTap: () {
                                    FocusScope.of(context).unfocus();
                                    Get.find<BookDetailController>().callApis(
                                        bookID: con.bookList[index].id);
                                    Get.toNamed(AppRoutes.bookDetailScreen);
                                  },
                            child: Container(
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
                                              con.bookList[index].image ?? "",
                                    // imageUrl:
                                    //     con.categoriesPodcast[i].image ?? "",
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
                                // const SizedBox(height: 2),
                                InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    Get.find<BookDetailController>().callApis(
                                        bookID: con.bookList[index].id);
                                    Get.toNamed(AppRoutes.bookDetailScreen);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: SizedBox(
                                      width: isTablet ? 160 : 125,
                                      height: isTablet ? 236 : 190,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl:
                                              con.bookList[index].image ?? "",
                                                 placeholder: (context, url) => ShimmerTile(
                                      margin: EdgeInsets.all(isTablet ? 5 : 3),
                                      width: isTablet ? 165 : 125,
                                      height: isTablet ? 240 : 190,
                                    ),
                                    // errorWidget: (context, url, error) =>
                                    //     Icon(Icons.error),
                                  //  fit: BoxFit.cover,
                                  
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // SizedBox(height: isTablet ? 12 : 8),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
    ):
    SizedBox(
      height: isTablet ? 260 : 210, // Height of the ListView
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
        itemCount: 4, // Number of shimmer tiles
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: ShimmerTile(
              margin: EdgeInsets.all(isTablet ? 5 : 3),
              width: isTablet ? 165 : 125,
              height: isTablet ? 240 : 190,
            ),
          );
        },
      ),
    )
       
          );
  }
}
