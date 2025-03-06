import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/podcast/podcast_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';

class AuthorsPodcast extends StatelessWidget {
  final RxList<AuthorPodcastData> authorsDataList;

  const AuthorsPodcast({
    Key? key,
    required this.authorsDataList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: authorsDataList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return authorsDataList[index].booksList.isEmpty
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
                          "${authorsDataList[index].selectedMenu == 0 ? "Most popular from" : "Recommended from "} ${authorsDataList[index].authorDetail.name}",
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
                      itemCount: authorsDataList[index].booksList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int i) {
                        return Padding(
                          padding: EdgeInsets.all(isTablet ? 5 : 3.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const SizedBox(height: 2),
                              InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  Get.find<BookDetailController>().callApis(
                                      bookID: authorsDataList[index]
                                          .booksList[i]
                                          .id);
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
                                        imageUrl: authorsDataList[index]
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
