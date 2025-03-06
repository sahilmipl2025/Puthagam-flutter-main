import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/library/delete_queue_api.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/api_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/widget/book_tile.dart';
import 'package:puthagam/screen/dashboard/library/my_queue/queue_controller.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/base_controller.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class QueueScreen extends StatelessWidget {
  QueueScreen({Key? key}) : super(key: key);

  final QueueController con = Get.put(QueueController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(gradient: verticalGradient),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                searchBar(context: context),
                .10.heightBox,
                Obx(() => baseController!.queueList.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: isTablet ? 9 : 6,
                            horizontal: isTablet ? 16 : 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Enable continuous playback",
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 12,
                                ),
                              ),
                            ),
                            Obx(
                              () => FlutterSwitch(
                                width: isTablet ? 70 : 50,
                                height: isTablet ? 30 : 25,
                                activeIcon: Icon(
                                  Icons.check,
                                  size: isTablet ? 24 : 20,
                                  color: commonBlueColor,
                                ),
                                inactiveIcon: Icon(
                                  Icons.check,
                                  size: isTablet ? 24 : 20,
                                  color: Colors.white,
                                ),
                                inactiveColor: borderColor,
                                padding: 1,
                                activeColor: commonBlueColor,
                                value: baseController!.continueQueue.value,
                                onToggle: (val) {
                                  baseController!.continueQueue.value = val;
                                  if (val == true) {
                                    baseController?.booksQueueList.clear();

                                    Get.find<BookDetailApiController>()
                                        .getMusicPlayerSuggestionApi(
                                            categoryId: baseController!
                                                .queueList[0].categoryId);
                                    for (var element
                                        in baseController!.queueList) {
                                      baseController?.booksQueueList
                                          .add(QueueList(
                                        bookId: element.id.toString(),
                                        bookTitle: element.title.toString(),
                                        bookImage: element.image.toString(),
                                        bookChapter:
                                            element.bookChapterList!.toList(),
                                        isPodcast: element.isPodcast ?? false,
                                        categoryId:
                                            element.categoryId.toString(),
                                      ));
                                    }

                                    baseController!.isTextVisible.value = false;
                                    baseController!.audioPlayer.pause();
                                    baseController!.isPause.value = true;
                                    baseController!.isPlaying.value = false;
                                    baseController!.audioPlayer.dispose();
                                    baseController!.currentPlayingIndex.value =
                                        999;
                                    baseController!.currentPlayingIndex.value =
                                        0;

                                    baseController!
                                        .currentPlayingBookIndex.value = 0;

                                    baseController!.runningBookId.value =
                                        baseController
                                                ?.booksQueueList[baseController!
                                                    .currentPlayingBookIndex
                                                    .value]
                                                .bookId ??
                                            "";

                                    if (baseController!
                                        .queueChapterList.isNotEmpty) {
                                      baseController!.currentPlayingIndex
                                          .value = baseController!
                                              .queueChapterList
                                              .firstWhere((element) =>
                                                  element.bookId ==
                                                  baseController
                                                      ?.booksQueueList[
                                                          baseController!
                                                              .currentPlayingBookIndex
                                                              .value]
                                                      .bookId)
                                              .chapter ??
                                          0;
                                    }

                                    Future.delayed(const Duration(seconds: 2),
                                        () async {
                                      await Get.find<BookDetailController>()
                                          .setAudio(
                                        index: baseController!
                                            .currentPlayingIndex.value,
                                      );

                                      Future.delayed(
                                          const Duration(microseconds: 200),
                                          () {
                                        Get.find<BookDetailController>()
                                            .myQueue(
                                          context: context,
                                          index: baseController!
                                              .currentPlayingIndex.value,
                                        );
                                      });
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
                Obx(() => baseController!.queueList.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            "No book found",
                            style: TextStyle(
                              fontSize: isTablet ? 24 : 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    : con.isSearch.value
                        ? con.searchList.isEmpty
                            ? Expanded(
                                child: Center(
                                  child: Text(
                                    "No book found",
                                    style: TextStyle(
                                      fontSize: isTablet ? 24 : 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: con.searchList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Obx(
                                    () => BookTile(
                                      isPaid: con.searchList[index].isPaid,
                                      isPremium: con.searchList[index].isPremium,
                                      title: con.searchList[index].title ?? "",
                                      imageUrl:
                                          con.searchList[index].image ?? "",
                                      authorName:
                                          con.searchList[index].authorName ??
                                              "",
                                      totalListen: con
                                          .searchList[index].listenCount
                                          .toString(),
                                      saveCount: con.searchList[index].saveCount
                                          .toString(),
                                      rating: int.parse(con
                                          .searchList[index].rating!
                                          .round()
                                          .toString()),
                                      caption:
                                          con.searchList[index].caption ?? "",
                                      categoryName:
                                          con.searchList[index].categoryName ??
                                              "",
                                      playingAudio: index ==
                                              baseController!
                                                  .currentPlayingBookIndex
                                                  .value &&
                                          baseController!.isPlaying.value,
                                      showRating: con.searchList[index].isSaved!
                                                  .value ==
                                              true
                                          ? true
                                          : false,
                                      showDelete: true,
                                      deleteTap: () {
                                        deleteQueue(
                                          context: context,
                                          bookId: con.searchList[index].id,
                                        );
                                      },
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        Get.find<BookDetailController>()
                                            .callApis(
                                                bookID:
                                                    con.searchList[index].id);
                                        Get.toNamed(AppRoutes.bookDetailScreen,
                                            arguments:
                                                con.searchList[index].id);
                                      },
                                      percentage: con.searchList[index]
                                                  .listenChapterIds!.length >
                                              int.parse(con.searchList[index]
                                                  .chapterCount
                                                  .toString())
                                          ? double.parse(con.searchList[index]
                                                  .chapterCount
                                                  .toString()) /
                                              int.parse(con.searchList[index]
                                                  .chapterCount
                                                  .toString())
                                          : con.searchList[index]
                                                  .listenChapterIds!.length /
                                              int.parse(con.searchList[index].chapterCount.toString()),
                                      savedOnTap: () {},
                                    ),
                                  );
                                },
                              )
                        : Flexible(
                            child: ReorderableListView.builder(
                              itemCount: baseController!.queueList.length,
                              onReorder: (int oldIndex, int newIndex) {
                                if (newIndex > oldIndex) {
                                  newIndex = newIndex - 1;
                                }
                                final element = baseController!.queueList
                                    .removeAt(oldIndex);
                                baseController!.queueList
                                    .insert(newIndex, element);
                                baseController!.currentPlayingBookIndex.value =
                                    baseController!.queueList.indexWhere(
                                        (element) =>
                                            element.id.toString() ==
                                            baseController!.runningBookId
                                                .toString());
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  key: ValueKey(index),
                                  child: Obx(
                                    () => BookTile(
                                      isPaid: baseController!
                                          .queueList[index].isPaid,
                                          isPremium: baseController!.queueList[index].isPremium,
                                      title: baseController!
                                              .queueList[index].title ??
                                          "",
                                      imageUrl: baseController!
                                              .queueList[index].image ??
                                          "",
                                      authorName: baseController!
                                              .queueList[index].authorName ??
                                          "",
                                      totalListen: baseController!
                                          .queueList[index].listenCount
                                          .toString(),
                                      saveCount: baseController!
                                          .queueList[index].saveCount
                                          .toString(),
                                      rating: int.parse(baseController!
                                          .queueList[index].rating!
                                          .round()
                                          .toString()),
                                      caption: baseController!
                                              .queueList[index].caption ??
                                          "",
                                      categoryName: baseController!
                                              .queueList[index].categoryName ??
                                          "",
                                      playingAudio: index ==
                                              baseController!
                                                  .currentPlayingBookIndex
                                                  .value &&
                                          baseController!.isPlaying.value,
                                      showRating: baseController!
                                                  .queueList[index]
                                                  .isSaved!
                                                  .value ==
                                              true
                                          ? true
                                          : false,
                                      showDelete: true,
                                      deleteTap: () {
                                        deleteQueue(
                                          context: context,
                                          bookId: baseController!
                                              .queueList[index].id,
                                        );
                                      },
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        Get.find<BookDetailController>()
                                            .callApis(
                                                bookID: baseController!
                                                    .queueList[index].id);
                                        Get.toNamed(AppRoutes.bookDetailScreen,
                                            arguments: baseController!
                                                .queueList[index].id);
                                      },
                                      percentage: baseController!
                                                  .queueList[index]
                                                  .listenChapterIds!
                                                  .length >
                                              int.parse(baseController!
                                                  .queueList[index].chapterCount
                                                  .toString())
                                          ? double.parse(baseController!
                                                  .queueList[index].chapterCount
                                                  .toString()) /
                                              int.parse(baseController!
                                                  .queueList[index].chapterCount
                                                  .toString())
                                          : baseController!.queueList[index]
                                                  .listenChapterIds!.length /
                                              int.parse(baseController!.queueList[index].chapterCount.toString()),
                                      savedOnTap: () {},
                                    ),
                                  ),
                                );
                              },
                            ),
                          ))
              ],
            ),
          ),
          Obx(
            () => baseController!.continueLoading.value
                ? Container(
                    color: Colors.grey.withOpacity(0.3),
                    child: const Center(child: AppLoader()),
                  )
                : const SizedBox(height: 0, width: 0),
          ),
        ],
      ),
    );
  }

  deleteQueue({context, bookId}) {
    showDialog(
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.80),
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 10, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Delete from queue',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Are you sure you want to delete from queue?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: Colors.grey[100],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            border: Border.all(color: buttonColor),
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          child: const Text(
                            "No",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Get.back();
                          baseController!.removeInLocalStorage(bookId: bookId);
                          deleteQueueApi(bookId: bookId);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: buttonColor),
                              borderRadius: BorderRadius.circular(3),
                              color: buttonColor),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: const Text(
                            "Yes",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget searchBar({context}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
      height: isTablet ? 60 : 50,
      decoration: BoxDecoration(
        gradient: horizontalGradient,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Center(
        child: Row(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: isTablet ? 12 : 9, right: isTablet ? 9 : 6),
                child: Image.asset(
                  "assets/icons/search.png",
                  height: isTablet ? 29 : 25,
                  width: isTablet ? 29 : 25,
                )),
            Expanded(
              child: TextField(
                textAlign: TextAlign.left,
                controller: con.searchController,
                style: TextStyle(fontSize: isTablet ? 20 : 18),
                decoration: InputDecoration(
                  hintText: 'Title, Author or Category',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: text23,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
                onChanged: (v) {
                  if (con.searchController.value.text.trim().isEmpty) {
                    con.isSearch.value = false;
                  }
                },
                onEditingComplete: () {
                  if (con.searchController.value.text.trim().isNotEmpty) {
                    con.isSearch.value = true;
                    con.searchFilter();
                  } else {
                    con.isSearch.value = false;
                  }
                },
              ),
            ),
            Obx(() => con.isSearch.value
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () {
                        con.isSearch.value = false;
                        con.searchController.clear();
                        FocusScope.of(context).unfocus();
                        con.searchFilter();
                      },
                      child: Icon(
                        Icons.close,
                        color: smallTextColor,
                        size: isTablet ? 30 : 25,
                      ),
                    ),
                  )
                : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
