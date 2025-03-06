import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/library/downloads/book_detail/download_book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/library/downloads/book_detail/screen/download_chapter_page.dart';
import 'package:puthagam/screen/dashboard/library/downloads/book_detail/screen/download_information_page.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/global.dart';

class DownloadBookDetailScreen extends StatelessWidget {
  DownloadBookDetailScreen({Key? key}) : super(key: key);

  final DownloadBookDetailController con =
      Get.put(DownloadBookDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(gradient: verticalGradient),
          child: SafeArea(
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: GlobalService.to.isDarkModel == true
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      SizedBox(height: isTablet ? 12 : 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  children: [
                                    bookImage(),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Text(
                                                jsonDecode(con.data.value[
                                                    'bookDetail'])['title'],
                                                maxLines: 3,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: commonBlueColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 35,
                                                  width: 35,
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  child: Image.file(
                                                    File(con.data.value[
                                                            'bookCategoryImage'] ??
                                                        ""),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: SizedBox(
                                                    child: Text(
                                                      jsonDecode(con.data.value[
                                                                  'bookDetail'])[
                                                              'categoryName'] ??
                                                          "",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                                width: 5, height: 10),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              DownloadInformationPage(),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "Chapters",
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: commonBlueColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              DownloadChapterPage(),
                              const SizedBox(height: 16),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Obx(
                                    () => Text(
                                      jsonDecode(con.data.value['bookDetail'])[
                                                  'isPodcast'] ==
                                              false
                                          ? 'Author of the book'
                                          : "Podcaster",
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                        color: commonBlueColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    ClipOval(
                                      clipBehavior: Clip.antiAlias,
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: ClipOval(
                                            clipBehavior: Clip.antiAlias,
                                            child: Container(
                                              height: 66,
                                              width: 66,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: FileImage(
                                                      File(con.data.value[
                                                          'authorImagePath']),
                                                    ),
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                          ),
                                        ),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(colors: [
                                            Color(0xFFA87F01),
                                            Color(0xFFAE8601),
                                            Color(0xFFD4B001),
                                            Color(0xFFFAD901),
                                            Color(0xFFF1D001),
                                          ]),
                                          // border: Border.all(
                                          //     color: Colors.amber, width: 2),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        jsonDecode(con.data.value[
                                                'bookDetail'])['authorName'] ??
                                            "",
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // BottomAudio(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Book Image

  Widget bookImage() {
    return Obx(
      () => Container(
        height: 190,
        width: 130,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
          image: DecorationImage(
            image: FileImage(File(con.data.value['bookImagePath'] ?? "")),
            fit: BoxFit.cover,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
