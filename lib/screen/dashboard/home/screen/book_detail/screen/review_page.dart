import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/category_book/submit_review_api.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/global.dart';

class ReviewPage extends StatelessWidget {
  ReviewPage({Key? key}) : super(key: key);

  final BookDetailController con = Get.put(BookDetailController());

  final HomeController con1 = Get.put(HomeController());

  // var image;

  @override
  Widget build(BuildContext context) {
    // ThemeData theme = Get.theme;
    return Obx(() => con.chapterLoading.value
        ? SizedBox(
            width: Get.width,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SingleChildScrollView(
            controller: con.newScrollController,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 110),
              child: Center(
                child: Column(
                  children: [
                    writeReview(),
                    const SizedBox(height: 16),
                    Obx(
                      () => con.reviewList.isEmpty
                          ? SizedBox(
                              width: Get.width,
                              height: Get.height * 0.2,
                              child: const Center(
                                child: Text(
                                  "No reviews found",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: con.showAllReview.value
                                  ? con.reviewList.length
                                  : con.reviewList.length > 3
                                      ? 3
                                      : con.reviewList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: GlobalService.to.isDarkModel == true
                                      ? Colors.grey.withOpacity(.5)
                                      : Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: con.reviewList[index]
                                                                  .userImage
                                                                  .toString() !=
                                                              "null" &&
                                                          con
                                                              .reviewList[index]
                                                              .userImage!
                                                              .isNotEmpty
                                                      ? CircleAvatar(
                                                          radius: 65.0,
                                                          backgroundImage:
                                                              NetworkImage(con
                                                                      .reviewList[
                                                                          index]
                                                                      .userImage ??
                                                                  ""),
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                        )
                                                      : const CircleAvatar(
                                                          radius: 65.0,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                        ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        con.reviewList[index]
                                                                .createdByName ??
                                                            "",
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          color: GlobalService
                                                                      .to
                                                                      .isDarkModel ==
                                                                  true
                                                              ? Colors.white
                                                              : headingColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        con.hFormat(
                                                            DateTime.parse(con
                                                                .reviewList[
                                                                    index]
                                                                .createdDate
                                                                .toString())),
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: GlobalService
                                                                      .to
                                                                      .isDarkModel ==
                                                                  true
                                                              ? Colors.white
                                                              : textColor,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      con.reviewList[index]
                                                                  .rating !=
                                                              null
                                                          ? con
                                                              .reviewList[index]
                                                              .rating
                                                              .toString()
                                                          : "0",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: GlobalService
                                                                      .to
                                                                      .isDarkModel ==
                                                                  true
                                                              ? textColor
                                                              : headingColor),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Icon(Icons.star,
                                                        color: GlobalService.to
                                                                    .isDarkModel ==
                                                                true
                                                            ? Colors.amberAccent
                                                                .shade400
                                                            : Colors.white)
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              con.reviewList[index].comment ??
                                                  "",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: GlobalService
                                                            .to.isDarkModel ==
                                                        true
                                                    ? borderColor
                                                    : headingColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // con.reviewList.length - 1 != index
                                      //     ? Divider(
                                      //         height: 2,
                                      //         color: borderColor,
                                      //         indent: 0,
                                      //       )
                                      //     : const SizedBox(),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 45,
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                            gradient: verticalGradient),
                        child: const Text(
                          'Send review',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ));
  }

  Widget writeReview() {
    return SizedBox(
      width: 800,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                alignment: Alignment.center,
                child: const Text(
                  'Write your review',
                  style: TextStyle(
                    fontSize: 17,
                    // color: headingColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                height: 45,
                alignment: Alignment.center,
                child: Text(
                  'Your feedback will help us \nimprove app experience better.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: RatingBar(
                    initialRating: 4,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemSize: 38,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                        full: Icon(
                          Icons.star,
                          size: 15,
                          color: GlobalService.to.isDarkModel == true
                              ? Colors.amberAccent.shade400
                              : Colors.white,
                        ),
                        half: Icon(
                          Icons.star_half,
                          color: GlobalService.to.isDarkModel == true
                              ? Colors.amberAccent.shade400
                              : Colors.white,
                        ),
                        empty: Icon(Icons.star, color: Colors.grey.shade500)),
                    onRatingUpdate: (value) {
                      con.rating.value = value.toInt();
                    },
                  ),
                ),
              ),
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: con.reviewController.value,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Do you want to write something?',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  if (con.reviewController.value.text.trim().isNotEmpty) {
                    submitBookReviewApi();
                  } else {
                    toast("Please enter your comment.", false);
                  }
                },
                child: Container(
                  height: 45,
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: const Text(
                    'Send review',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
