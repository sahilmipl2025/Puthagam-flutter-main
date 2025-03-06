import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/podcast/podcast_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';

import '../../../../utils/shimmer_tile.dart';

class PodcastCategoryBooks extends StatelessWidget {
  final RxList<CategoryPodcastBooksData> catDataList;

  const PodcastCategoryBooks({
    Key? key,
    required this.catDataList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: catDataList.length > 5 ? 5 : catDataList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return catDataList[index].booksList.isEmpty
            ? const SizedBox()
            : Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${catDataList[index].selectedMenu == 0 ? "Most popular in" : "Latest in"} ${catDataList[index].categoryDetail.name ?? ""}",
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 14,
                            fontWeight: FontWeight.w500,
                            color: commonBlueColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isTablet ? 16 : 12),
                  SizedBox(
                    height: isTablet ? 260 : 210,
                    width: double.infinity,
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                          left: isTablet ? 12 : 8, right: isTablet ? 20 : 16),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: catDataList[index].booksList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int i) {
                        return Padding(
                          padding: EdgeInsets.all(isTablet ? 5 : 3.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              catDataList[index]
                                                .booksList[i].isPremium ==true ?
                          InkWell(
                            onTap: () {
                            FocusScope.of(context).unfocus();
                                  Get.find<BookDetailController>().callApis(
                                      bookID:
                                          catDataList[index].booksList[i].id);
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
                                    imageUrl: catDataList[index]
                                                .booksList[i]
                                                .image ??
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
                              // const SizedBox(height: 2),
                              InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  Get.find<BookDetailController>().callApis(
                                      bookID:
                                          catDataList[index].booksList[i].id);
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
                                        imageUrl: catDataList[index]
                                                .booksList[i]
                                                .image ??
                                            "",
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
                ],
              );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox();
      },
    );
  }
}
