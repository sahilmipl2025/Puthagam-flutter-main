import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/library/downloads/book_detail/download_book_detail_controller.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/global.dart';

class DownloadReviewPage extends StatelessWidget {
  DownloadReviewPage({Key? key}) : super(key: key);

  final DownloadBookDetailController con =
      Get.put(DownloadBookDetailController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 110),
        child: Center(
          child: SizedBox(
            width: 800,
            child: Column(
              children: [
                jsonDecode(con.data.value['bookReview']).length == 0
                    ? SizedBox(
                        height: Get.height * 0.3,
                        child: const Center(
                          child: Text(
                            "No review found",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )
                    : Obx(
                        () => ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              jsonDecode(con.data.value['bookReview']).length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
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
                                                child: CircleAvatar(
                                                  radius: 65.0,
                                                  backgroundImage: NetworkImage(
                                                      jsonDecode(con.data.value[
                                                                  'bookReview'])[
                                                              index]['userImage'] ??
                                                          ""),
                                                  // backgroundColor:
                                                  //     Colors.transparent,
                                                )),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    jsonDecode(con.data.value[
                                                                    'bookReview'])[
                                                                index]
                                                            ['createdByName'] ??
                                                        "",
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      // color: headingColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    con.hFormat(DateTime.parse(
                                                        jsonDecode(con.data.value[
                                                                        'bookReview'])[
                                                                    index]
                                                                ['createdDate']
                                                            .toString())),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: textColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  jsonDecode(con.data.value[
                                                                      'bookReview'])[
                                                                  index]
                                                              ['rating'] !=
                                                          null
                                                      ? jsonDecode(con.data.value[
                                                                  'bookReview'])[
                                                              index]['rating']
                                                          .toString()
                                                      : "0",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                const SizedBox(width: 4),
                                                Icon(Icons.star,
                                                    color: GlobalService.to
                                                                .isDarkModel ==
                                                            true
                                                        ? Colors.amberAccent
                                                            .shade400
                                                        : buttonColor)
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          jsonDecode(con.data.value[
                                                      'bookReview'])[index]
                                                  ['comment'] ??
                                              "",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
