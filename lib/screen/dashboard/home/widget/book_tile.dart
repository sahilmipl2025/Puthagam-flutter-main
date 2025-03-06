import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/global.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../utils/shimmer_tile.dart';

class BookTile extends StatelessWidget {
  final GestureTapCallback onTap;
  final GestureTapCallback savedOnTap;
  final String imageUrl;
  final String title;
  final String authorName;
  final String totalListen;
  final String saveCount;
  final String caption;
  final String categoryName;
  final int rating;
  final bool showRating;
  final bool? showDelete;
  final bool? isPremium;
  final bool? playingAudio;
  final bool? isPaid;
  final double? percentage;
  final GestureTapCallback? deleteTap;

  const BookTile({
    Key? key,
    required this.isPremium,
    required this.onTap,
    required this.savedOnTap,
    required this.imageUrl,
    required this.title,
    required this.authorName,
    required this.totalListen,
    required this.saveCount,
    required this.caption,
    required this.categoryName,
    required this.rating,
    required this.showRating,
    required this.isPaid,
    this.showDelete = false,
    this.playingAudio = false,
    this.deleteTap,
    this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: isTablet ? 150 : 130,
                  width: isTablet ? 110 : 90,
                  child: 
                  isPremium == true ?
                  Stack(
          alignment: Alignment.center, // Center the icon on top of the image
          children: [
           //  child: 
             SizedBox(
                                width: isTablet ? 165 : 125,
                                height: isTablet ? 240 : 190,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl:imageUrl??"",
                                       // con.categoriesPodcast[i].image ?? "",
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
        )
                  //  ClipRRect(
                  //   borderRadius: BorderRadius.circular(8),
                  //   child: CachedNetworkImage(
                  //     imageUrl: imageUrl,
                  //     placeholder: (b, c) {
                  //       return const SizedBox();
                  //     },
                  //     fit: BoxFit.contain,
                  //   ),
                  // )
                  :ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (b, c) {
                        return const SizedBox();
                      },
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: isTablet ? 14 : 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: isTablet ? 7 : 5),
                        child: Row(
                          children: [
                            SizedBox(height: isTablet ? 6 : 4),
                            Expanded(
                              child: Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: isTablet ? 17 : 14,
                                  fontWeight: FontWeight.w500,
                                  color: commonBlueColor,
                                ),
                              ),
                            ),
                            SizedBox(width: isTablet ? 6 : 4),
                            playingAudio == true
                                ? Image.asset(
                                    "assets/images/audio.png",
                                    height: isTablet ? 27 : 24,
                                    width: isTablet ? 27 : 24,
                                    color: GlobalService.to.isDarkModel == true
                                        ? Colors.white
                                        : buttonColor,
                                  )
                                : showDelete == true
                                    ? InkWell(
                                        onTap: deleteTap,
                                        child: Icon(
                                          Icons.delete,
                                          color: commonBlueColor,
                                          size: isTablet ? 22 : 18,
                                        ),
                                      )
                                    :
                                    // isPaid == false ?
                                    InkWell(
                                        onTap: savedOnTap,
                                        child: showRating
                                            ? Icon(
                                                Icons.bookmark,
                                                color: commonBlueColor,
                                                size: isTablet ? 22 : 18,
                                              )
                                            : Icon(
                                                Icons.bookmark_border_outlined,
                                                color: commonBlueColor,
                                                size: isTablet ? 22 : 18,
                                              ),
                                      )
                            // : baseController!.isSubscribed.value &&
                            //         isPaid == true
                            //     ? InkWell(
                            //         onTap: savedOnTap,
                            //         child: showRating
                            //             ? Icon(
                            //                 Icons.bookmark,
                            //                 color: commonBlueColor,
                            //                 size:
                            //                     isTablet ? 22 : 18,
                            //               )
                            //             : Icon(
                            //                 Icons
                            //                     .bookmark_border_outlined,
                            //                 color: commonBlueColor,
                            //                 size:
                            //                     isTablet ? 22 : 18,
                            //               ),
                            //       )
                            //     : Icon(
                            //         Icons.lock,
                            //         color: commonBlueColor,
                            //         size: isTablet ? 22 : 18,
                            //       ),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 11 : 8),
                      Padding(
                        padding: EdgeInsets.only(left: isTablet ? 8 : 5),
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              size: isTablet ? 23 : 20,
                              color: commonBlueColor,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              flex: 4,
                              child: Text(
                                authorName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: isTablet ? 14 : 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 10 : 8),
                      Padding(
                        padding: EdgeInsets.only(left: isTablet ? 8 : 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.headphones_outlined,
                                    color: commonBlueColor,
                                    size: isTablet ? 21 : 18,
                                  ),
                                  SizedBox(width: isTablet ? 5 : 3),
                                  Text(
                                    totalListen,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                                  ),
                                  SizedBox(width: isTablet ? 12 : 10),
                                  Icon(
                                    Icons.circle,
                                    size: isTablet ? 7 : 5,
                                    color: textColor,
                                  ),
                                  5.widthBox,
                                  Icon(
                                    Icons.bookmark_border_outlined,
                                    color: commonBlueColor,
                                    size: isTablet ? 20 : 17,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    saveCount,
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: isTablet ? 24 : 20,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder:
                                    (BuildContext context, int index1) {
                                  return rating > index1
                                      ? Icon(
                                          Icons.star,
                                          size: isTablet ? 17 : 15,
                                          color: Colors.amberAccent.shade400,
                                        )
                                      : Icon(
                                          Icons.star,
                                          size: isTablet ? 17 : 15,
                                          color: Colors.white,
                                        );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: isTablet ? 7 : 5, top: isTablet ? 12 : 10),
                        child: Text(
                          caption,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w400,
                            // color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      percentage != null
                          ? SizedBox(height: isTablet ? 14 : 12)
                          : const SizedBox(height: 0),
                      percentage != null
                          ? LinearPercentIndicator(
                              barRadius: const Radius.circular(16),
                              lineHeight: isTablet ? 7 : 5.0,
                              percent: percentage ?? 0,
                              backgroundColor: Colors.grey.withOpacity(0.4),
                              progressColor: Colors.white,
                            ).paddingOnly(right: isTablet ? 8 : 5)
                          : const SizedBox(),
                    ],
                  ),
                ),
                SizedBox(width: isTablet ? 8 : 5),
              ],
            ),
          ),
          Divider(
            indent: isTablet ? 12 : 10,
            endIndent: isTablet ? 12 : 10,
            thickness: isTablet ? 2 : 1,
            color: text23,
          ),
        ],
      ),
    );
  }
}
