import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/model/book_detail/get_book_detail_model.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/api_controller.dart';
import 'package:puthagam/screen/dashboard/library/favorites/favourite_controller.dart';
import 'package:readmore/readmore.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/base_controller.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;


class InformationPage extends StatelessWidget {
  InformationPage({Key? key}) : super(key: key);
  final BookDetailController con = Get.put(BookDetailController());
  final HomeController homeController = Get.put(HomeController());
 final FavouriteController con3 = Get.put(FavouriteController());
 BookDetailApiController con2 = Get.find<BookDetailApiController>();
 dynamic argumentData = Get.arguments;
  RxBool playQueue = false.obs;
  Rx<GetBookDetailModel> bookDetail = GetBookDetailModel().obs;
  RxBool isDark = false.obs;
  RxBool savedLoading = false.obs;
  RxBool colorShow = false.obs;
  RxBool isLoading = false.obs;
  RxBool textIcon = false.obs;
  RxBool isBookDetail = true.obs;
  RxBool musicIcon = false.obs;
  RxBool isVisible = true.obs;
  RxBool showDialog = true.obs;
  RxBool isConnected = false.obs;
  Rx<GetSimpleBookDetailModel> simpleBookDetail =
      GetSimpleBookDetailModel().obs;

  RxString bookId = "".obs;
  
  @override
  Widget build(BuildContext context) {
    
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(bottom: 0),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 20 : 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IntrinsicHeight(
                child: Container(
                  alignment: Alignment.center,
                  width: con.isBookDetail.isFalse ? 350 : 200,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: horizontalGradient,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Obx(() {
                    
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                if ((con.bookDetail.value.isPaid.toString() ==
                                            "false" ||
                                        (con.bookDetail.value.isPaid.toString() ==
                                                "true" &&
                                            baseController!.isSubscribed.value
                                                    .toString() ==
                                                "true")) ||
                                    con.isBookDetail.isFalse) {
                                  if (con.bookChapterList.isNotEmpty) {
                                    if (LocalStorage.autoPlay == true) {
                                      baseController!.audioPlayer.pause();
                                      baseController!.isPause.value = true;
                                      baseController!.isPlaying.value = false;
                                      baseController!.audioPlayer.dispose();
                                      baseController!.currentPlayingIndex.value =
                                          999;

                                      baseController!.currentPlayingIndex.value = 0;
                                      // issues resolved related to plaback speed for different books
                                      baseController!.isBookIdChanged.value =
                                          baseController!.runningBookId.value !=
                                              (con.bookDetail.value.id ?? '');
                                      // issues resolved related to plaback speed for different books
                                      baseController!.runningBookId.value =
                                          con.bookDetail.value.id ?? "";
                                      baseController?.booksQueueList.clear();
                                      baseController?.continueQueue.value = false;
                                      baseController
                                          ?.currentPlayingBookIndex.value = 0;
                                      if (con.bookDetail.value.isPodcast == true) {
                                        baseController!.musicSuggestionPodcasts =
                                            con.suggestionPodcasts;
                                      } else {
                                        baseController!.musicSuggestionBook =
                                            con.suggestionBook;
                                      }
                                      baseController!.isTextVisible.value = false;
                                      baseController?.booksQueueList.add(
                                        QueueList(
                                          bookId:
                                              con.bookDetail.value.id.toString(),
                                          bookTitle:
                                              con.bookDetail.value.title.toString(),
                                          bookImage:
                                              con.bookDetail.value.image.toString(),
                                          bookChapter: con.bookChapterList.toList(),
                                          isPodcast:
                                              con.bookDetail.value.isPodcast ??
                                                  false,
                                          categoryId: con
                                              .bookDetail.value.categoryId
                                              .toString(),
                                        ),
                                      );
                                      // Future.delayed(const Duration(seconds: 2),
                                      //     () async {
                                       // await
                                         con.setAudio(index: 0);
                                        // Future.delayed(
                                        //     const Duration(microseconds: 0), () {
                                          con.myQueue(
                                            context: context,
                                            index: baseController!
                                                .currentPlayingIndex.value,
                                        //  );
                                       // }
                                      );
                                     
                                      
                                      
                                     
                                    } else {
                                      baseController!.isTextVisible.value = false;
                                      con.addMusic(context: context, index: 0);
                                    }
                                  }
                                } else {
                                  con.showDialog.value = true;
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.play_circle_outline,
                                    size: isTablet ? 30 : 25,
                                  ),
                                  SizedBox(width: isTablet ? 12 : 9),
                                  Center(
                                    child: Text(
                                      "Listen",
                                      style: TextStyle(
                                        fontSize: isTablet ? 17 : 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          con.isBookDetail.isFalse
                              ? VerticalDivider(
                                  width: isTablet ? 3 : 2,
                                  color: Colors.white,
                                )
                              : const SizedBox(),
                          con.isBookDetail.isFalse
                              ? Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if ((con.bookDetail.value.isPaid.toString() ==
                                                  "false" ||
                                              (con.bookDetail.value.isPaid
                                                          .toString() ==
                                                      "true" &&
                                                  baseController!.isSubscribed.value
                                                          .toString() ==
                                                      "true")) ||
                                          con.isBookDetail.isFalse) {
                                        if (con.bookChapterList.isNotEmpty) {
                                          if (LocalStorage.autoPlay == true) {
                                            baseController!.audioPlayer.pause();
                                            baseController!.isPause.value = true;
                                            baseController!.isPlaying.value = false;
                                            baseController!.audioPlayer.dispose();
                                            baseController!
                                                .currentPlayingIndex.value = 999;
                                            baseController!
                                                .currentPlayingIndex.value = 0;
                                            baseController!.runningBookId.value =
                                                con.bookDetail.value.id ?? "";
                                            baseController?.booksQueueList.clear();
                                            baseController
                                                ?.currentPlayingBookIndex.value = 0;
                                            baseController?.continueQueue.value =
                                                false;
                                            baseController?.booksQueueList.add(
                                              QueueList(
                                                bookId: con.bookDetail.value.id
                                                    .toString(),
                                                bookTitle: con
                                                    .bookDetail.value.title
                                                    .toString(),
                                                bookImage: con
                                                    .bookDetail.value.image
                                                    .toString(),
                                                bookChapter:
                                                    con.bookChapterList.toList(),
                                                isPodcast: con.bookDetail.value
                                                        .isPodcast ??
                                                    false,
                                                categoryId: con
                                                    .bookDetail.value.categoryId
                                                    .toString(),
                                              ),
                                            );
                                            baseController!.musicSuggestionBook =
                                                con.suggestionBook;
                                            Future.delayed(
                                                const Duration(seconds: 2),
                                                () async {
                                              await con.setAudio(index: 0);
                                              baseController!.audioPlayer.pause();
                                              baseController!.isTextVisible.value =
                                                  true;
                                              Future.delayed(
                                                  const Duration(microseconds: 200),
                                                  () {
                                                con.myQueue(
                                                  context: context,
                                                  index: baseController!
                                                      .currentPlayingIndex.value,
                                                );
                                                baseController!.audioPlayer.pause();
                                              });
                                            });
                                            baseController!.isTextVisible.value =
                                                true;
                                          } else {
                                            baseController!.isTextVisible.value =
                                                true;
                                            con.addMusic(
                                                context: context, index: 0);
                                            baseController!.audioPlayer.pause();
                                          }
                                        }
                                      } else {
                                        con.showDialog.value = true;
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/icons/read-book.png",
                                          height: isTablet ? 26 : 22,
                                          width: isTablet ? 26 : 22,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: isTablet ? 12 : 9),
                                        Center(
                                          child: Text(
                                            "Read",
                                            style: TextStyle(
                                              fontSize: isTablet ? 17 : 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      );
                    }
                  ),
                ),
              ),
              const SizedBox(height: 24),
              con.isBookDetail.isFalse
                  ? IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() => Expanded(
                                child: Center(
                                  child: Row(
                                    children: [
                                      con.isBookDetail.value
                                          ? con.doneChapterList.length ==
                                                      con.bookDetail.value
                                                          .chapterCount &&
                                                  con.bookDetail.value
                                                          .chapterCount
                                                          .toString() !=
                                                      "0"
                                              ? Image.asset(
                                                  'assets/images/checkmark.png',
                                                  height: isTablet ? 30 : 25,
                                                  width: isTablet ? 30 : 25,
                                                  fit: BoxFit.cover,
                                                  color: Colors.grey,
                                                )
                                              : con.doneChapterList.isNotEmpty
                                                  ? Image.asset(
                                                      "assets/images/audio.png",
                                                      height:
                                                          isTablet ? 30 : 25,
                                                      width: isTablet ? 30 : 25,
                                                      color: Colors.grey,
                                                    )
                                                  : Icon(
                                                      Icons.play_circle_outline,
                                                      color: Colors.grey,
                                                      size: isTablet ? 30 : 25,
                                                    )
                                          : con.doneChapterList.length ==
                                                      con.bookDetail.value
                                                          .chapterCount &&
                                                  con.bookDetail.value
                                                          .chapterCount
                                                          .toString() !=
                                                      "0"
                                              ? Image.asset(
                                                  'assets/images/checkmark.png',
                                                  height: isTablet ? 30 : 25,
                                                  width: isTablet ? 30 : 25,
                                                  fit: BoxFit.cover,
                                                  color: Colors.grey,
                                                )
                                              : con.doneChapterList.isNotEmpty
                                                  ? Image.asset(
                                                      "assets/images/audio.png",
                                                      height:
                                                          isTablet ? 30 : 25,
                                                      width: isTablet ? 30 : 25,
                                                      color: Colors.grey,
                                                    )
                                                  : Icon(
                                                      Icons.play_circle_outline,
                                                      color: Colors.grey,
                                                      size: isTablet ? 30 : 25,
                                                    ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Obx(
                                         () {
                                            return Text(
                                              con.isBookDetail.value
                                                  ? baseController!.runningBookId.value ==
                                                          con.bookDetail.value.id
                                                      ? baseController!.currentBookDoneChapter.length ==
                                                              baseController
                                                                  ?.booksQueueList[
                                                                      baseController!
                                                                          .currentPlayingBookIndex
                                                                          .value]
                                                                  .bookChapter
                                                                  .length 

                                                          ? 'Finished'
                                                          : "Running"
                                                      : con.doneChapterList.length ==
                                                                  con
                                                                      .bookDetail
                                                                      .value
                                                                      .chapterCount &&
                                                              con.bookDetail.value.chapterCount.toString() !=
                                                                  "0"
                                                          ? 'Finished'
                                                          : con.doneChapterList
                                                                  .isNotEmpty
                                                              ? "Running"
                                                              : "Not Started"
                                                  : baseController!.runningBookId.value ==
                                                          con.bookDetail.value.id
                                                      ? baseController!.currentBookDoneChapter.length ==
                                                              con.bookDetail.value
                                                                  .chapterCount
                                                          ? 'Finished'
                                                          : "Running"
                                                      : con.doneChapterList.length ==
                                                                  con.bookDetail.value.chapterCount &&
                                                              con.bookDetail.value.chapterCount.toString() != "0"
                                                          ? 'Finished'
                                                          : con.doneChapterList.isNotEmpty
                                                              ? "Running"
                                                              : "Not Started",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: isTablet ? 16 : 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              
                                            );
                                          }
                                        ),
                                      
                                        
                                      ),
//                                    Obx(() {
                                    
                                   
//     try{
// final displayedText = con.isBookDetail.value
//         ? (baseController!.runningBookId.value == con.bookDetail.value.id
//             ? (baseController!.currentBookDoneChapter.length ==
//                     baseController
//                         ?.booksQueueList[
//                             baseController!.currentPlayingBookIndex.value]
//                         .bookChapter
//                         .length 
//                 ? 'Finished'
//                 : "Running")
//             : (con.doneChapterList.length ==
//                         con.bookDetail.value.chapterCount &&
//                     con.bookDetail.value.chapterCount.toString() !=
//                         "0"
//                 ? 'Finished'
//                 : con.doneChapterList.isNotEmpty
//                     ? "Running"
//                     : "Not Started"))
//         : (baseController!.runningBookId.value == con.bookDetail.value.id
//             ? (baseController!.currentBookDoneChapter.length ==
//                     con.bookDetail.value.chapterCount
//                 ? 'Finished'
//                 : "Running")
//             : (con.doneChapterList.length ==
//                         con.bookDetail.value.chapterCount &&
//                     con.bookDetail.value.chapterCount.toString() != "0"
                    
//                 ? 'Finished'
//                 : con.doneChapterList.isNotEmpty
//                     ? "Running"
//                     : "Not Started"));
    
//     if (displayedText == 'Finished'
//   && con.bookDetail.value.isFinished ==false
//      ) {
   
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         con2.listenCount();
       
//                 con2.completeBookApi();
//      //  getBookDetailApi

//      print("etBookDetailApi${bookId}");
//       });
//     }
//     }catch(e){
//       print("errorr${e}");
//     }
    
//     return SizedBox.shrink(); // Return an empty sized box or null widget
//   },
// ),

                                      
                                    ],
                                  ),
                                ),
                              )),
                          VerticalDivider(
                            color: borderColor,
                            thickness: isTablet ? 2 : 1,
                            indent: 5,
                            endIndent: 0,
                          ),
                          Expanded(
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  10.widthBox,
                                  Image.asset(
                                    'assets/icons/timer.png',
                                    height: isTablet ? 26 : 22,
                                    width: isTablet ? 26 : 22,
                                    color: Colors.grey,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      con.bookDetail.value.totalAudioDuration ??
                                          "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isTablet ? 16 : 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: borderColor,
                            thickness: isTablet ? 2 : 1,
                            indent: isTablet ? 7 : 5,
                            endIndent: 0,
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/key.png',
                                  height: isTablet ? 29 : 25,
                                  width: isTablet ? 29 : 25,
                                  color: Colors.grey,
                                  fit: BoxFit.fill,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '${con.bookDetail.value.chapterCount} key ideas',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isTablet ? 17 : 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              SizedBox(height: isTablet ? 20 : 16),
              con.bookDetail.value.info!.trim().isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Description",
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 14,
                              fontWeight: FontWeight.w500,
                              color: commonBlueColor,
                            ),
                          ),
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 2),
                            child: ReadMoreText(
                              con.bookDetail.value.info ?? "",
                              style: TextStyle(
                                fontSize: isTablet ? 14 : 12,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                              trimLines: 2,
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'View more',
                              trimExpandedText: 'View less',
                              lessStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: commonBlueColor),
                              moreStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: commonBlueColor),
                            )

                            //  Text(
                            //   con.bookDetail.value.info ?? "",
                            //   style: TextStyle(
                            //     fontSize: isTablet ? 14 : 12,
                            //     fontWeight: FontWeight.w400,
                            //   ),
                            // ),
                            ),
                      ],
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
