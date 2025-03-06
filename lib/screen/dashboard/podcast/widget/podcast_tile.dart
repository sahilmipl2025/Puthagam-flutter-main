import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/global.dart';
import 'package:velocity_x/velocity_x.dart';

class PodcastTile extends StatelessWidget {
  final GestureTapCallback onTap;
  final GestureTapCallback savedOnTap;
  final String imageUrl;
  final String title;
  final String authorName;
  final String totalListen;
  final String saveCount;
  final String caption;
  final String categoryName;
  final double rating;
  final bool showRating;
  final bool? showDelete;
  final bool? isPaid;
  final GestureTapCallback? deleteTap;

  const PodcastTile({
    Key? key,
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
    this.showDelete = false,
    this.isPaid = false,
    this.deleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 800,
        margin: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 130,
                    width: 90,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (b, c) {
                            return const SizedBox();
                          },
                          fit: BoxFit.contain,
                        )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'SF-Pro-Display-Semibold',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: commonBlueColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            showDelete == true
                                ? InkWell(
                                    onTap: deleteTap,
                                    child: Icon(
                                      Icons.delete,
                                      color: commonBlueColor,
                                      size: 25,
                                    ),
                                  )
                                : isPaid == false
                                    ? InkWell(
                                        onTap: savedOnTap,
                                        child: showRating
                                            ? Icon(
                                                Icons.bookmark,
                                                color: commonBlueColor,
                                                size: 18,
                                              )
                                            : Icon(
                                                Icons.bookmark_border_outlined,
                                                color: commonBlueColor,
                                                size: 18,
                                              ),
                                      )
                                    : baseController!.isSubscribed.value &&
                                            isPaid == true
                                        ? InkWell(
                                            onTap: savedOnTap,
                                            child: showRating
                                                ? Icon(
                                                    Icons.bookmark,
                                                    color: commonBlueColor,
                                                    size: 18,
                                                  )
                                                : Icon(
                                                    Icons
                                                        .bookmark_border_outlined,
                                                    color: commonBlueColor,
                                                    size: 18,
                                                  ),
                                          )
                                        : Icon(
                                            Icons.lock,
                                            color: commonBlueColor,
                                            size: 18,
                                          ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              size: 18,
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
                                  fontWeight: FontWeight.w500,
                                  color: text23,
                                  fontFamily: 'SF-Pro-Display-Medium',
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                categoryName,
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  // color: smallTextColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
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
                                    size: 18,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    totalListen,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: textColor,
                                  ),
                                  5.widthBox,
                                  Icon(
                                    Icons.bookmark_border_outlined,
                                    color: commonBlueColor,
                                    size: 17,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    saveCount,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder:
                                    (BuildContext context, int index1) {
                                  return rating > index1
                                      ? Icon(
                                          Icons.star,
                                          size: 15,
                                          color: GlobalService.to.isDarkModel ==
                                                  true
                                              ? Colors.amberAccent.shade400
                                              : Colors.white,
                                        )
                                      : const Icon(
                                          Icons.star,
                                          size: 15,
                                          color: Colors.white,
                                        );
                                },
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            caption,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              // color: Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 8,
              child: Divider(
                indent: 10,
                endIndent: 10,
                height: 2,
                color: borderColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
