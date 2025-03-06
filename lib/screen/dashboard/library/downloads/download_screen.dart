import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/library/downloads/book_detail/download_book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/library/downloads/download_controller.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:velocity_x/velocity_x.dart';

class DownloadScreen extends StatelessWidget {
  DownloadScreen({Key? key}) : super(key: key);
  final DownloadController con = Get.put(DownloadController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(gradient: verticalGradient),
      child: Obx(() => Stack(
            children: [
              Container(
                height: Get.height,
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
                child: baseController!.downloadBooks.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Anytime, anywhere-even offline!",
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 20 : 16),
                            child: Text(
                              "Download titles and take them with you,internet connection or not!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: isTablet ? 16 : 14,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          10.heightBox,
                          searchBar(context: context),
                          10.heightBox,
                          Expanded(
                            child: ListView.builder(
                              controller: con.newScrollController,
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              itemCount: baseController!.downloadBooks.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    bool connection = await NetworkInfo(
                                            connectivity: Connectivity())
                                        .isConnected();
                                    if (connection) {
                                      FocusScope.of(context).unfocus();
                                      Get.find<BookDetailController>().callApis(
                                          bookID: jsonDecode(baseController!
                                                  .downloadBooks[index]
                                              ['bookDetail'])['_id']);
                                      Get.toNamed(AppRoutes.bookDetailScreen,
                                          arguments: jsonDecode(baseController!
                                                  .downloadBooks[index]
                                              ['bookDetail'])['_id']);
                                    } else {
                                      Get.find<DownloadBookDetailController>()
                                              .data
                                              .value =
                                          baseController!.downloadBooks[index];
                                      Get.find<DownloadBookDetailController>()
                                          .update();
                                      Get.toNamed(
                                          AppRoutes.downloadBookDetailScreen,
                                          arguments: baseController!
                                              .downloadBooks[index]);
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: isTablet ? 20 : 16),
                                    child: Column(
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                height: isTablet ? 150 : 130,
                                                width: isTablet ? 110 : 90,
                                                child: Image.file(
                                                  File(baseController!
                                                          .downloadBooks[index]
                                                      ['bookImagePath']),
                                                  height: isTablet ? 100 : 80,
                                                  width: isTablet ? 100 : 80,
                                                ),
                                              ),
                                              SizedBox(
                                                  width: isTablet ? 20 : 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      jsonDecode(baseController!
                                                                  .downloadBooks[
                                                              index][
                                                          'bookDetail'])['title'],
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize:
                                                            isTablet ? 16 : 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            isTablet ? 6 : 4),
                                                    Text(
                                                      jsonDecode(baseController!
                                                                  .downloadBooks[
                                                              index]['bookDetail'])[
                                                          'caption'],
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: textColor,
                                                        fontSize:
                                                            isTablet ? 15 : 13,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: InkWell(
                                                  onTap: () async {
                                                    await baseController!
                                                        .downloadBooks
                                                        .removeAt(index);
                                                    LocalStorage
                                                            .downloadBooksList =
                                                        baseController!
                                                            .downloadBooks;

                                                    var box = GetStorage();
                                                    await box.write(
                                                      Prefs.downloadBooks,
                                                      jsonEncode(LocalStorage
                                                          .downloadBooksList),
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: commonBlueColor,
                                                    size: isTablet ? 21 : 18,
                                                  ),
                                                ),
                                              )
                                            ]),
                                        Container(
                                          height: isTablet ? 17 : 15,
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: Divider(
                                            indent: 5,
                                            height: 2,
                                            color: textColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          con.paginationLoading.value
                              ? const AppLoader()
                              : const SizedBox()
                        ],
                      ),
              ),
              Obx(
                () => con.downloadLoading.value
                    ? Container(
                        color: Colors.grey.withOpacity(0.3),
                        child: const Center(child: AppLoader()),
                      )
                    : const SizedBox(height: 0, width: 0),
              ),
            ],
          )),
    );
  }

  Widget searchBar({context}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
      height: isTablet ? 70 : 50,
      decoration: BoxDecoration(
        gradient: horizontalGradient,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Center(
        child: Row(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: isTablet ? 12 : 9, right: isTablet ? 8 : 6),
                child: Image.asset(
                  "assets/icons/search.png",
                  height: isTablet ? 29 : 25,
                  width: isTablet ? 29 : 25,
                )),
            Expanded(
              child: TextField(
                textAlign: TextAlign.left,
                // controller: con.searchController.value,
                style: TextStyle(fontSize: isTablet ? 20 : 18),
                decoration: InputDecoration(
                  hintText: 'Title, Author or Category',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: text23,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
                // onChanged: (v) {
                //   if (con.searchController.value.text.trim().isEmpty) {
                //     con.isSearch.value = false;
                //   }
                // },
                onEditingComplete: () {
                  // if (con.searchController.value.text.trim().isNotEmpty) {
                  //   con.isSearch.value = true;
                  //   getSearchListApi();
                  // } else {
                  //   con.isSearch.value = false;
                  // }
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 12),
            //   child: InkWell(
            //     onTap: () {
            //       FocusScope.of(context).unfocus();
            //       // con.isSearch.value = false;
            //       // con.searchController.value.clear();
            //     },
            //     child: Icon(
            //       Icons.close,
            //       color: smallTextColor,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
