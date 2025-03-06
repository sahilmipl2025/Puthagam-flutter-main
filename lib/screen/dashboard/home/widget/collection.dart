import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/collection_books/collection_books_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/shimmer_tile.dart';
import 'package:velocity_x/velocity_x.dart';

class Collection extends StatelessWidget {
  Collection({Key? key}) : super(key: key);

  final HomeController con = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
  return Obx(() => con.collectionList.isNotEmpty
        ? 
   
     Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
          child: Text(
            'collection'.tr,
            style: TextStyle(
              fontSize: isTablet ? 18 : 14,
              fontWeight: FontWeight.w500,
              color: commonBlueColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => con.categoryLoading.value
            ? SizedBox(
             // child: Text("hhh"),
            )
         
            : con.collectionList.isEmpty
                ? SizedBox(
                    height: isTablet ? 280 : 220,
                    child: Center(
                      child: Text(
                        "noCollectionFound".tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: isTablet ? 335 : 280,
                    width: double.infinity,
                    child: ListView.builder(
                        padding: EdgeInsets.only(
                            left: isTablet ? 12 : 8, right: isTablet ? 20 : 16),
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: con.collectionList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              Get.find<CollectionBooksController>()
                                  .collectionId
                                  .value = con.collectionList[index].id!;
                              Get.find<CollectionBooksController>().name.value =
                                  con.collectionList[index].name!;
                              Get.find<CollectionBooksController>()
                                  .showDelete
                                  .value = false;
                              Get.find<CollectionBooksController>()
                                      .totalCount
                                      .value =
                                  con.collectionList[index].bookCount?.value ??
                                      0;
                              Get.find<CollectionBooksController>()
                                  .getExploreListApi();
                              Get.toNamed(AppRoutes.collectionBooksScreen);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(isTablet ? 5 : 3.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: isTablet ? 12 : 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: SizedBox(
                                      height: isTablet ? 230 : 190,
                                      width: isTablet ? 160 : 125,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl:
                                              con.collectionList[index].image ??
                                                  "",
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
                                  SizedBox(height: isTablet ? 12 : 8),
                                  Container(
                                    width: isTablet ? 140 : 125,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      con.collectionList[index].name ?? "",
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: isTablet ? 16 : 14,
                                        color: text23,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  10.heightBox,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 18,
                                        width: isTablet ? 140 : 100,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          con.collectionList[index]
                                                      .bookCount! <=
                                                  1
                                              ? con.collectionList[index]
                                                      .bookCount
                                                      .toString() +
                                                  " " +
                                                  "Book"
                                              : con.collectionList[index]
                                                      .bookCount
                                                      .toString() +
                                                  " " +
                                                  "books".tr,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: text23,
                                            fontSize: isTablet ? 14 : 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ))
      ],
    ):  SizedBox(
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
