import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/base_controller.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:velocity_x/velocity_x.dart';

class ChapterPage extends StatelessWidget {
  ChapterPage({Key? key}) : super(key: key);

  final BookDetailController con = Get.put(BookDetailController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(isTablet ? 12 : 8)),
        gradient: verticalGradient,
      ),
      child: Obx(() => con.chapterLoading.value
          ? SizedBox(
              width: Get.width,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : con.bookChapterList.isEmpty
              ? const SizedBox()
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: con.bookChapterList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        if ((con.bookDetail.value.isPaid.toString() ==
                                    "false" ||
                                (con.bookDetail.value.isPaid.toString() ==
                                        "true" &&
                                    baseController!.isSubscribed.value
                                            .toString() ==
                                        "true")) ||
                            con.isBookDetail.isFalse) {
                          con.savedLoading.value = true;
                          if (LocalStorage.autoPlay == true) {
                            con.isVisible.value = true;
                            baseController!.isTextVisible.value = false;
                            baseController!.audioPlayer.pause();
                            baseController!.isPause.value = true;
                            baseController!.isPlaying.value = false;
                            baseController!.audioPlayer.dispose();
                            baseController!.currentPlayingIndex.value = 999;
                            baseController!.currentPlayingIndex.value = index;
                            // issues resolved related to plaback speed for different books
                            baseController!.isBookIdChanged.value =
                                baseController!.runningBookId.value !=
                                    (con.bookDetail.value.id ?? '');
                            // issues resolved related to plaback speed for different books
                            baseController!.runningBookId.value =
                                con.bookDetail.value.id ?? "";

                            baseController?.booksQueueList.clear();

                            baseController?.currentPlayingBookIndex.value = 0;
                            baseController?.continueQueue.value = false;
                            baseController?.booksQueueList.add(
                              QueueList(
                                bookId: con.bookDetail.value.id.toString(),
                                bookTitle:
                                    con.bookDetail.value.title.toString(),
                                bookImage:
                                    con.bookDetail.value.image.toString(),
                                bookChapter: con.bookChapterList.toList(),
                                isPodcast:
                                    con.bookDetail.value.isPodcast ?? false,
                                categoryId:
                                    con.bookDetail.value.categoryId.toString(),
                              ),
                            );

                            if (con.bookDetail.value.isPodcast == true) {
                              baseController!.musicSuggestionPodcasts =
                                  con.suggestionPodcasts;
                            } else {
                              baseController!.musicSuggestionBook =
                                  con.suggestionBook;
                            }

                            baseController!.musicSuggestionBook.removeWhere(
                                (element) =>
                                    element.id ==
                                    baseController!.runningBookId.value);

                            Future.delayed(const Duration(seconds: 2),
                                () async {
                              await con.setAudio(index: index);

                              Future.delayed(const Duration(microseconds: 200),
                                  () {
                                con.myQueue(
                                  context: context,
                                  index:
                                      baseController!.currentPlayingIndex.value,
                                );
                              });
                            });
                          } else {
                            con.isVisible.value = true;
                            baseController!.isTextVisible.value = false;
                            con.savedLoading.value = true;
                            con.addMusic(context: context, index: index);
                          }
                        } else {
                          con.showDialog.value = true;
                        }
                      },
                      child: Row(
                        children: [
                          Obx(
                            () => baseController!.booksQueueList.isNotEmpty &&
                                    baseController!
                                        .booksQueueList[baseController!
                                            .currentPlayingBookIndex.value]
                                        .bookChapter
                                        .isNotEmpty &&
                                    (baseController!
                                                .currentPlayingIndex.value ==
                                            index &&
                                        baseController
                                                ?.booksQueueList[baseController!
                                                    .currentPlayingBookIndex
                                                    .value]
                                                .bookChapter[baseController!
                                                    .currentPlayingIndex.value]
                                                .id ==
                                            con.bookChapterList[index].id)
                                ? VerticalDivider(
                                    width: 2,
                                    thickness: 3,
                                    color: commonBlueColor,
                                  )
                                : const SizedBox(),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                8.heightBox,
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 16,
                                        height: 8,
                                      ),
                                      Text(
                                        (index + 1).toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: isTablet ? 16 : 14,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              con.bookChapterList[index].name ??
                                                  "",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: isTablet ? 16 : 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textAlign: TextAlign.left,
                                            ).paddingOnly(left: 5),
                                         // InkWell(onTap: (){
                                            // print("printdatahtml     ${con.bookChapterList[index].content![0]}");
                                            //  print("printdatahtmlsecond       ${con.bookChapterList[index].content![1]}");
                                            //   print("printdatahtmlsecond         ${con.bookChapterList[index].content![2]}");
                                            //    print("printdatahtmlthird          ${con.bookChapterList[index].content![3]}");
                                            //     print("printdatahtmlfourth           ${con.bookChapterList[index].content![4]}");
                                                
                                            //              },
                                            // child: Text("HYyyyy")),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Html(
                                                data: con.bookChapterList[index]
                                                    .content!.trim()
                                                    .replaceAll(
                                                        'font-feature-settings: normal;',
                                                        ''),
                                                style: {
                                                  "body": Style(
                                                    fontSize: Platform.isIOS
                                                        ? FontSize(
                                                            isTablet ? 12 : 10)
                                                        : FontSize(
                                                            isTablet ? 12 : 10),
                                                    maxLines: 1,
                                                    color: text23,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                  ),
                                                  "span": Style(
                                                    fontSize: Platform.isIOS
                                                        ? FontSize(
                                                            isTablet ? 12 : 10)
                                                        : FontSize(
                                                            isTablet ? 12 : 10),
                                                    maxLines: 1,
                                                    color: text23,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                  ),
                                                  "font": Style(
                                                    color: Colors.white,
                                                    fontSize: FontSize(
                                                        isTablet ? 17 : 15),
                                                  ),
                                                  "div": Style(
                                                    color: Colors.white,
                                                    fontSize: FontSize(
                                                        isTablet ? 17 : 15),
                                                  ),
                                                  "li": Style(
                                                    color: Colors.white,
                                                    fontSize: FontSize(
                                                        isTablet ? 17 : 15),
                                                  ),
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Obx(
                                        () => Row(
                                          children: [
                                            baseController!.currentPlayingIndex
                                                        .value !=
                                                    999
                                                ? baseController!
                                                                .currentPlayingIndex
                                                                .value ==
                                                            index &&
                                                        baseController!
                                                            .booksQueueList
                                                            .isNotEmpty &&
                                                        baseController!
                                                            .booksQueueList[
                                                                baseController!
                                                                    .currentPlayingBookIndex
                                                                    .value]
                                                            .bookChapter
                                                            .isNotEmpty &&
                                                        baseController!
                                                                .booksQueueList[
                                                                    baseController!
                                                                        .currentPlayingBookIndex
                                                                        .value]
                                                                .bookChapter[
                                                                    baseController!
                                                                        .currentPlayingIndex
                                                                        .value]
                                                                .id ==
                                                            con
                                                                .bookChapterList[
                                                                    index]
                                                                .id
                                                    ? Image.asset(
                                                        "assets/images/audio.png",
                                                        height:
                                                            isTablet ? 30 : 24,
                                                        width:
                                                            isTablet ? 30 : 24,
                                                        color: commonBlueColor,
                                                      )
                                                    : Text(
                                                        replaceTime(con
                                                            .bookChapterList[
                                                                index]
                                                            .audioDuration
                                                            .toString()),
                                                        style: TextStyle(
                                                          fontSize: isTablet
                                                              ? 16
                                                              : 14,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      )
                                                : Text(
                                                    replaceTime(con
                                                        .bookChapterList[index]
                                                        .audioDuration
                                                        .toString()),
                                                    style: TextStyle(
                                                      fontSize:
                                                          isTablet ? 14 : 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: isTablet ? 20 : 16),
                                    ],
                                  ),
                                ),
                                index + 1 != con.bookChapterList.length
                                    ? Divider(
                                        height: isTablet ? 2 : 1,
                                        color: Colors.white,
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )),
    );
  }

  replaceTime(value) {
    if (value[0] == "0" && value[1] == "0" && value[2] == ":") {
      var test = value.toString().replaceFirst('0', '');
      var test1 = test.toString().replaceFirst('0', '');
      return test1.toString().replaceFirst(':', '');
    } else {
      return value;
    }
  }
}
