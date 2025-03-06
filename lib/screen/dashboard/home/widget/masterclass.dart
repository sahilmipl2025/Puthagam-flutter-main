import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/api_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/shimmer_tile.dart';

class Master extends StatelessWidget {
  Master({Key? key}) : super(key: key);

  final HomeController con = Get.put(HomeController());
  final BookDetailApiController con2 = Get.find<BookDetailApiController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => con.categoriesPodcast.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 8),
                child: Text(
                  "Popular in Masterclass",
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 14,
                    fontWeight: FontWeight.w500,
                    color: commonBlueColor,
                  ),
                ).paddingOnly(left: 5),
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
                  itemCount: con.categoriesPodcast.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int i) {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          con.categoriesPodcast[i].isPremium ==true ?
                          InkWell(
                            onTap: () {
                              print("bookdetailsscreen ${con.categoriesPodcast[i].id}");
                              FocusScope.of(context).unfocus();
                              Get.find<BookDetailController>().callApis(
                                  bookID: con.categoriesPodcast[i].id);
                              Get.toNamed(AppRoutes.bookDetailScreen,
                                  arguments: con.categoriesPodcast[i].id);
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
                                        con.categoriesPodcast[i].image ?? "",
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
                
              ),
            ),
          ],
        ),
    
                            ),
                          ):
                           InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              Get.find<BookDetailController>().callApis(
                                  bookID: con.categoriesPodcast[i].id);
                              Get.toNamed(AppRoutes.bookDetailScreen,
                                  arguments: con.categoriesPodcast[i].id);
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
                                        con.categoriesPodcast[i].image ?? "",
                                    placeholder: (context, url) => 
                                    ShimmerTile(
                                      margin: EdgeInsets.all(isTablet ? 5 : 3),
                                      width: isTablet ? 165 : 125,
                                      height: isTablet ? 240 : 190,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                    //  ),
                 //   );
                //  },
          //       ),
          //     ),
          //   ],
          // ),
                      //    const SizedBox(height: 8),
                    //    ],
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        :     SizedBox(
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
