import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/api_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/freebookslist/freebooks.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import '../../../../utils/shimmer_tile.dart';

class Freebooks extends StatelessWidget {
  Freebooks({Key? key}) : super(key: key);

  final HomeController con = Get.put(HomeController());
    BookDetailApiController con2 = Get.find<BookDetailApiController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => con.freebooks.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'The Free Shelf'.tr,
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 14,
                        fontWeight: FontWeight.w500,
                        color: commonBlueColor,
                      ),
                    ),
                      GestureDetector(
                onTap: () async {
                    FocusScope.of(context).unfocus();
                  Get.to(() => FreeBooksListScreen());
                  // await Get.toNamed(AppRoutes.selectTopicsScreen,
                  //     arguments: true);
               //   setState(() {});
                },
                child: Text(
                  'View more',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: borderColor,
                  ),
                ),
              ),
                  ],
                ).paddingOnly(left: 5)
              ),
              SizedBox(height: isTablet ? 20 : 16),
              SizedBox(
                height: isTablet ? 260 : 210,
                width: double.infinity,
                child: ListView.builder(
                  padding: EdgeInsets.only(
                      left: isTablet ? 12 : 8, right: isTablet ? 20 : 16),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: con.freebooks.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int i) {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          InkWell(
                            onTap: () {
                                print("today collectionjjjjjjjjjjj");
                              print("today collectionjjjjjjjjjjj${con.freebooks[i].id.toString()}");
                              FocusScope.of(context).unfocus();
                              FocusScope.of(context).unfocus();
                              Get.find<BookDetailController>()
                                    .callApis(bookID: con.freebooks[i].id);
                              Get.toNamed(AppRoutes.bookDetailScreen,
                                  arguments: con.freebooks[i].id);
                                                  
              
                            },     
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: SizedBox(
                                width: isTablet ? 165 : 125,
                                height: isTablet ? 240 : 190,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                      // '${ApiUrls.baseUrl}Book/GetFixSize/${con.todayCollection[i].bookImageName}/310/200/95',
                                      con.freebooks[i].
                                      image
                                         .toString(),
                                      placeholder: (context, url) => 
                           ShimmerTile(
                            margin: EdgeInsets.only(
                              right: isTablet ? 5 : 5,
                              left:  isTablet ? 5 : 5,
                            ),
                            width: isTablet ? 222 : 125,
                            height: isTablet ? 236 : 190,
                          ).marginAll(isTablet ? 0 : 0),
                                      fit: BoxFit.cover,
                                      
                                      //height: 220,
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        :   SizedBox(
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
    ));
       
  }
}


