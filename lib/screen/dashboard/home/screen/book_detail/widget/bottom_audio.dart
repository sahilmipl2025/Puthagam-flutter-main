import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/global.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

class BottomAudio extends StatelessWidget {
  BottomAudio({Key? key}) : super(key: key);

  final BookDetailController con = Get.put(BookDetailController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => baseController!.booksQueueList.isNotEmpty &&
            baseController!
                .booksQueueList[baseController!.currentPlayingBookIndex.value]
                .bookChapter
                .isNotEmpty &&
            baseController!.currentPlayingIndex.value != 999 &&
            baseController!
                .booksQueueList[baseController!.currentPlayingBookIndex.value]
                .bookChapter
                .isNotEmpty
        ? Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                padding: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  border: Border.all(width: .2, color: textColor),
                  gradient: horizontalGradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
                height: isTablet ? 85 : 75,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: isTablet ? 14 : 10,
                        right: isTablet ? 16 : 12,
                        top: isTablet ? 14 : 10,
                        bottom: isTablet ? 16 : 12,
                      ),
                      child: Row(
                        children: [
                          Obx(() => InkWell(
                                onTap: () {
                                  con.myQueue(
                                    context: context,
                                    index: baseController!
                                        .currentPlayingIndex.value,
                                  );
                                },
                                child: SquarePercentIndicator(
                                  width: isTablet ? 50 : 40,
                                  height: isTablet ? 50 : 40,
                                  startAngle: StartAngle.topLeft,
                                  reverse: true,
                                  borderRadius: 12,
                                  shadowWidth: 2,
                                  progressWidth: 5,
                                  shadowColor: Colors.grey,
                                  progressColor:
                                      GlobalService.to.isDarkModel == true
                                          ? Colors.white
                                          : Colors.orange,
                                  progress: con.position.value.inSeconds /
                                      con.duration.value.inSeconds,
                                  child: Container(
                                    height: isTablet ? 50 : 46,
                                    width: isTablet ? 50 : 46,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(baseController!
                                                .runningBookImage.value),
                                            fit: BoxFit.contain),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12))),
                                  ),
                                ),
                              )),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                con.myQueue(
                                    context: context,
                                    index: baseController!
                                        .currentPlayingIndex.value);
                              },
                              child: Wrap(
                                children: [
                                  Text(
                                    con.isBookDetail.isFalse
                                        ? 'Ch ${baseController!.currentPlayingIndex.value + 1}: ' +
                                            baseController!
                                                .booksQueueList[baseController!
                                                    .currentPlayingBookIndex
                                                    .value]
                                                .bookChapter[baseController!
                                                    .currentPlayingIndex.value]
                                                .name
                                                .toString()
                                        : 'Episode ${baseController!.currentPlayingIndex.value + 1}: ' +
                                            baseController!
                                                .booksQueueList[baseController!
                                                    .currentPlayingBookIndex
                                                    .value]
                                                .bookChapter[baseController!
                                                    .currentPlayingIndex.value]
                                                .name
                                                .toString(),
                                    maxLines: 2,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.white,
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: isTablet ? 10 : 6),
                          Obx(
                            () => CircleAvatar(
                              backgroundColor:
                                  GlobalService.to.isDarkModel == true
                                      ? Colors.grey.withOpacity(.3)
                                      : buttonColor,
                              radius: isTablet ? 22 : 18,
                              child: IconButton(
                                onPressed: () async {
                                  if (baseController!.isPlaying.value) {
                                    baseController!.audioPlayer.pause();
                                    baseController!.isPause.value = true;
                                    baseController!.isPlaying.value = false;
                                  } else {
                                    if (baseController!.isPause.value == true) {
                                      baseController!.audioPlayer.play();

                                      baseController!.isPlaying.value = true;
                                      baseController!.isPause.value = false;
                                    } else {
                                      baseController!.audioPlayer.dispose();
                                      baseController!.audioPlayer =
                                          AudioPlayer();

                                      baseController!.audioPlayer.pause();
                                      con.setAudio().then((value) {
                                        baseController!.isPlaying.value = true;
                                      });
                                    }
                                  }
                                },
                                icon: Icon(
                                  baseController!.isPlaying.value
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: isTablet ? 24 : 18,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: isTablet ? 6 : 4),
                          CircleAvatar(
                            backgroundColor:
                                GlobalService.to.isDarkModel == true
                                    ? Colors.grey.withOpacity(.3)
                                    : buttonColor,
                            radius: isTablet ? 22 : 18,
                            child: IconButton(
                              onPressed: () async {
                                baseController!.audioPlayer.pause();
                                baseController!.isPause.value = true;
                                baseController!.isPlaying.value = false;
                                baseController!.audioPlayer.dispose();
                                baseController!.currentPlayingIndex.value = 999;
                                baseController!.booksQueueList.clear();
                                baseController?.continueQueue.value = false;
                              },
                              icon: Icon(
                                Icons.stop,
                                color: Colors.white,
                                size: isTablet ? 24 : 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )))
        : const SizedBox());
  }
}
