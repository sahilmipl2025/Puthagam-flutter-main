import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:swipe_to/swipe_to.dart';

class DownloadBookDetailController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxMap data = {}.obs;

  RxBool showAllReview = false.obs;
  RxBool isVisible = true.obs;
  RxBool isTextVisible = false.obs;

  /// Set Timing

  String hFormat(DateTime date) {
    if (DateTime.now().difference(date).inDays == 1) {
      return "yesterday";
    } else if (DateTime.now().difference(date).inDays > 364) {
      return DateFormat('dd-MM-yyyy').format(date);
    } else if (DateTime.now().difference(date).inDays > 1) {
      return DateFormat('dd-MM-yy').format(date);
    } else {
      return DateFormat('hh:mm a').format(date);
    }
  }

  String? time(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }

  AudioPlayer audioPlayer = AudioPlayer();
  RxDouble customFontSize = 14.0.obs;
  RxBool isPlaying = false.obs;
  RxBool isPause = false.obs;

  // RxInt currentPlayingIndex = 999.obs;

  Rx<Duration> duration = Duration.zero.obs;
  Rx<Duration> position = Duration.zero.obs;

  // @override
  // void onReady() {
  //   super.onReady();
  //   data = Get.arguments;
  // }

  List<AudioSource> songList = [];

  /// Set Audio

  Future setAudio({index}) async {
    baseController!.isPlaying.value = false;

    baseController!.runningBookImage.value = data.value['bookImagePath'];

    baseController!.audioPlayer.pause();
    baseController!.audioPlayer.dispose();
    baseController!.audioPlayer = AudioPlayer();

    songList.clear();

    baseController!.downloadCurrentBookChapterList.clear();
    // baseController!.runningBookId.value = bookDetail.value.id ?? "";

    baseController!.currentBookChapterList.clear();
    jsonDecode(data.value['chapter']).forEach((e) {
      baseController!.downloadCurrentBookChapterList.add(e);
    });

    // var dir = await DownloadsPathProvider.downloadsDirectory;
    var dir = await getApplicationDocumentsDirectory();
    for (var element in jsonDecode(data.value['chapter'])) {
      String saveName = "${element['_id']}.wav";
      String savePath = dir.path +
          "/.${jsonDecode(data.value['bookDetail'])['_id']}/.puthagam/$saveName";
      // bool exist = await Directory(savePath).exists();

      // if (exist == true) {
      songList.add(AudioSource.uri(
        Uri.file(savePath),
        tag: MediaItem(
          playable: true,
          id: element['_id'],
          album: element['title'],
          title: element['name'],
          // artUri: data['bookImagePath'],
        ),
      ));
      // }
    }

    baseController!.currentPlayingIndex.value = index;

    baseController!.audioPlayer
        .setAudioSource(ConcatenatingAudioSource(children: songList))
        .then((value) async {
      baseController!.audioPlayer.play();
      baseController!.isPlaying.value = true;

      if (index != null) {
        await baseController!.audioPlayer.seek(Duration.zero, index: index);
      } else {
        await baseController!.audioPlayer.seek(Duration.zero,
            index: baseController!.currentPlayingIndex.value);
      }
    });

    baseController!.audioPlayer.playerStateStream.listen((PlayerState s) {
      baseController!.isPlaying.value = s.playing;
    });

    baseController!.audioPlayer.playerStateStream.listen((playerState) async {
      if (playerState.processingState == ProcessingState.loading) {
        // savedLoading.value = true;
      }
      if (playerState.processingState == ProcessingState.ready) {
        // savedLoading.value = false;
      }
      if (playerState.processingState == ProcessingState.completed) {
        baseController!.audioPlayer.pause();
        baseController!.isPause.value = true;
        baseController!.isPlaying.value = false;
        baseController!.audioPlayer.dispose();
        baseController!.currentPlayingIndex.value = 999;
      }
    });

    baseController!.audioPlayer.currentIndexStream.listen((event) async {
      if (baseController!.currentPlayingIndex.value != 999) {
        if (event == baseController!.currentBookChapterList.length - 1) {
          /// Last to second index

          if (baseController!.currentBookDoneChapter
              .where((p0) =>
                  p0.chapterId ==
                  baseController!
                      .currentBookChapterList[
                          baseController!.currentPlayingIndex.value]
                      .id)
              .isEmpty) {}

          /// Last Index
          if (baseController!.currentBookDoneChapter
              .where((p0) =>
                  p0.chapterId ==
                  baseController!
                      .currentBookChapterList[
                          baseController!.currentPlayingIndex.value + 1]
                      .id)
              .isEmpty) {}
        } else {
          if (baseController!.currentBookDoneChapter
              .where((p0) =>
                  p0.chapterId ==
                  baseController!
                      .currentBookChapterList[
                          baseController!.currentPlayingIndex.value]
                      .id)
              .isEmpty) {}
        }

        if (event != 0 && baseController!.isPlaying.value) {
          if (event != null) {
            if (baseController!.currentPlayingIndex.value !=
                baseController!.currentBookChapterList.length - 1) {
              baseController!.currentPlayingIndex.value = event;
              if (baseController!.currentBookDoneChapter.length ==
                  baseController!.currentBookChapterList.length) {}
            }
          }
        }
      }
    });

    baseController!.audioPlayer.positionStream.listen((p) {
      position.value = p;
    });

    baseController!.audioPlayer.durationStream.listen((totalDuration) {
      duration.value = totalDuration!;
    });
  }

  RxBool isDark = false.obs;
  RxString currentSpeed = "1.0x".obs;

  void myQueue({required BuildContext context, index}) {
    showModalBottomSheet(
        barrierColor: const Color.fromARGB(255, 167, 219, 244).withOpacity(.2),
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        constraints: const BoxConstraints(maxWidth: 800),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return baseController!.isTextVisible.value
                ? Container(
                    decoration: BoxDecoration(
                      color: isDark.value ? null : const Color(0xFFE2F5FF),
                      gradient: isDark.value ? verticalGradient : null,
                    ),
                    height: Get.height * 0.94,
                    width: Get.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          decoration:
                              BoxDecoration(gradient: horizontalGradient),
                          width: Get.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 65,
                                width: 65,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: FileImage(File(baseController!
                                        .runningBookImage.value)),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: Obx(
                                () => baseController!
                                            .currentPlayingIndex.value !=
                                        999
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Obx(
                                            () => InkWell(
                                              onTap: () => Get.back(),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 1.0),
                                                      child: SizedBox(
                                                        width: Get.width,
                                                        child: Text(
                                                          "Ch ${baseController!.currentPlayingIndex.value + 1} : ${jsonDecode(data.value['chapter'])[baseController!.currentPlayingIndex.value]['name'] ?? ""}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                            color:
                                                                commonBlueColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Icon(
                                                      Icons
                                                          .keyboard_arrow_down_outlined,
                                                      size: 30,
                                                      color: commonBlueColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  if (baseController!
                                                      .isPlaying.value) {
                                                    baseController!.audioPlayer
                                                        .pause();
                                                    baseController!
                                                        .isPause.value = true;
                                                    baseController!.isPlaying
                                                        .value = false;
                                                    setState(() {});
                                                  } else {
                                                    if (baseController!
                                                            .isPause.value ==
                                                        true) {
                                                      baseController!
                                                          .audioPlayer
                                                          .play();

                                                      baseController!.isPlaying
                                                          .value = true;
                                                      baseController!.isPause
                                                          .value = false;
                                                      setState(() {});
                                                    } else {
                                                      baseController!
                                                          .audioPlayer
                                                          .dispose();
                                                      baseController!
                                                              .audioPlayer =
                                                          AudioPlayer();
                                                      baseController!.isPlaying
                                                          .value = false;
                                                      setAudio().then((value) {
                                                        baseController!
                                                            .isPlaying
                                                            .value = true;
                                                        setState(() {});
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Icon(
                                                  baseController!
                                                          .isPlaying.value
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                  color: Colors.grey,
                                                  size: 24,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    baseController!
                                                        .isTextVisible
                                                        .value = false;
                                                    isVisible.value = true;
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.headphones,
                                                  color: Colors.grey,
                                                  size: 24,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              baseController!
                                                      .currentPlayingIsBook
                                                      .value
                                                  ? const SizedBox()
                                                  : InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          if (isDark.value ==
                                                              true) {
                                                            isDark.value =
                                                                false;
                                                          } else {
                                                            isDark.value = true;
                                                          }
                                                        });
                                                      },
                                                      child: Image.asset(
                                                        'assets/images/dark-light.png',
                                                        color: Colors.grey,
                                                        height: 24,
                                                        width: 24,
                                                      ),
                                                    ),
                                            ],
                                          )
                                        ],
                                      )
                                    : SizedBox(
                                        height: Get.height * 0.1,
                                        child: Obx(
                                          () => Center(
                                            child: Text(
                                              baseController!
                                                      .currentPlayingIsBook
                                                      .isFalse
                                                  ? "No more chapters found"
                                                  : "No more episodes found",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              )),
                            ],
                          ),
                        ),
                        isDark.value
                            ? const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                  height: 1.5,
                                  color: Colors.white,
                                  thickness: 1,
                                ),
                              )
                            : const SizedBox(),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              width: Get.width,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (customFontSize.value !=
                                                    10) {
                                                  customFontSize.value =
                                                      customFontSize.value - 2;
                                                  setState(() {});
                                                }
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: const BoxDecoration(),
                                              child: Text(
                                                'A',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: isDark.value
                                                      ? commonBlueColor
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Obx(() => Slider(
                                                  value: customFontSize.value,
                                                  max: 30,
                                                  divisions: 10,
                                                  activeColor: isDark.value
                                                      ? commonBlueColor
                                                      : Colors.black,
                                                  inactiveColor: Colors.grey,
                                                  min: 10,
                                                  onChanged: (double value) {
                                                    customFontSize.value =
                                                        value;
                                                  },
                                                )),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (customFontSize.value != 24) {
                                                customFontSize.value =
                                                    customFontSize.value + 2;
                                                setState(() {});
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: const BoxDecoration(),
                                              child: Text(
                                                'Aa',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color: isDark.value
                                                      ? commonBlueColor
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  SwipeTo(
                                    onRightSwipe: () async {
                                      if (baseController!
                                          .audioPlayer.hasPrevious) {
                                        await baseController!.audioPlayer
                                            .seekToPrevious();
                                        baseController!.audioPlayer.play();

                                        baseController!.isPlaying.value = true;

                                        setState(() {});
                                      }
                                    },
                                    animationDuration:
                                        const Duration(milliseconds: 200),
                                    onLeftSwipe: () {
                                      if (baseController!.audioPlayer.hasNext) {
                                        baseController!.isPlaying.value = false;
                                        baseController!.audioPlayer
                                            .seekToNext();

                                        baseController!.isPlaying.value = true;
                                        baseController!.audioPlayer.play();
                                        setState(() {});
                                      }
                                    },
                                    child: Obx(
                                      () => baseController!
                                                  .currentPlayingIndex.value !=
                                              999
                                          ? Html(
                                              data: jsonDecode(data
                                                          .value['chapter'])[
                                                      baseController!
                                                          .currentPlayingIndex
                                                          .value]['content'] ??
                                                  "",
                                              style: {
                                                "body": Style(
                                                  color: isDark.value
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: FontSize(
                                                      customFontSize.value),
                                                ),
                                              },
                                            )
                                          : const SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: const BoxDecoration(
                            color: Color(0xFF00142D),
                          ),
                          child: IntrinsicHeight(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                gradient: horizontalGradient,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        if (baseController!
                                            .audioPlayer.hasPrevious) {
                                          await baseController!.audioPlayer
                                              .seekToPrevious();
                                          baseController!.audioPlayer.play();

                                          baseController!.isPlaying.value =
                                              true;

                                          setState(() {});
                                        }
                                      },
                                      child: const Center(
                                        child: Text(
                                          "Previous",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const VerticalDivider(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (baseController!
                                            .audioPlayer.hasNext) {
                                          baseController!.isPlaying.value =
                                              false;
                                          baseController!.audioPlayer
                                              .seekToNext();

                                          baseController!.isPlaying.value =
                                              true;
                                          baseController!.audioPlayer.play();
                                          setState(() {});
                                        }
                                      },
                                      child: const Center(
                                        child: Text(
                                          "Next",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: verticalGradient,
                    ),
                    height: Get.height * 0.94,
                    width: Get.width,
                    child: Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => Get.back(),
                          child: Container(
                            height: 4,
                            width: Get.width * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: Get.width,
                                          child: Row(
                                            children: [
                                              baseController!
                                                      .currentPlayingIsBook
                                                      .value
                                                  ? const SizedBox()
                                                  : InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          baseController!
                                                              .isTextVisible
                                                              .value = true;
                                                          isVisible.value =
                                                              false;
                                                        });
                                                      },
                                                      child: Image.asset(
                                                        'assets/icons/aaa.png',
                                                        width: 24,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                              const SizedBox(width: 12),
                                              Obx(() => Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (currentSpeed
                                                                .value ==
                                                            "1.0x") {
                                                          currentSpeed.value =
                                                              "1.25x";
                                                          baseController!
                                                              .audioPlayer
                                                              .setSpeed(1.25);
                                                        } else if (currentSpeed
                                                                .value ==
                                                            "1.25x") {
                                                          currentSpeed.value =
                                                              "1.5x";
                                                          baseController!
                                                              .audioPlayer
                                                              .setSpeed(1.5);
                                                        } else if (currentSpeed
                                                                .value ==
                                                            "1.5x") {
                                                          currentSpeed.value =
                                                              "0.75x";
                                                          baseController!
                                                              .audioPlayer
                                                              .setSpeed(0.75);
                                                        } else {
                                                          currentSpeed.value =
                                                              "1.0x";
                                                          baseController!
                                                              .audioPlayer
                                                              .setSpeed(1.0);
                                                        }
                                                      },
                                                      child: Text(
                                                        currentSpeed.value,
                                                        style: const TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              const SizedBox(width: 12),
                                              const Spacer(),
                                              InkWell(
                                                onTap: () => Get.back(),
                                                child: const Icon(Icons
                                                    .keyboard_arrow_down_outlined),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        SizedBox(
                                          height: 8,
                                          child: Divider(
                                            height: 1,
                                            color: Colors.grey.withOpacity(0.3),
                                            thickness: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        isVisible.value
                                            ? Column(
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    height: Get.height * 0.46,
                                                    width: Get.width * 0.50,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.2),
                                                          spreadRadius: 5,
                                                          blurRadius: 3,
                                                          offset: const Offset(
                                                              0, 2),
                                                        ),
                                                      ],
                                                      image: DecorationImage(
                                                        image: FileImage(File(
                                                            baseController!
                                                                .runningBookImage
                                                                .value)),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  baseController!
                                                              .currentPlayingIndex
                                                              .value !=
                                                          999
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child:
                                                              Obx(() => Center(
                                                                    child: Text(
                                                                      "Ch ${baseController!.currentPlayingIndex.value + 1} ${jsonDecode(data.value['chapter'])[baseController!.currentPlayingIndex.value]['name'] ?? ""}",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        color:
                                                                            commonBlueColor,
                                                                      ),
                                                                    ),
                                                                  )),
                                                        )
                                                      : Text(
                                                          jsonDecode(data.value[
                                                                          'bookDetail'])[
                                                                      'isPodcast'] ==
                                                                  true
                                                              ? "No more chapters found"
                                                              : "No more episodes found",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                  const SizedBox(height: 10),
                                                  Obx(
                                                    () => SliderTheme(
                                                      data: SliderTheme.of(
                                                              context)
                                                          .copyWith(
                                                        activeTrackColor:
                                                            buttonColor,
                                                        inactiveTrackColor:
                                                            Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.3),
                                                        trackShape:
                                                            const RectangularSliderTrackShape(),
                                                        trackHeight: 4,
                                                        thumbColor: Colors.grey,
                                                        thumbShape:
                                                            const RoundSliderThumbShape(
                                                                enabledThumbRadius:
                                                                    10),
                                                        overlayShape:
                                                            const RoundSliderOverlayShape(
                                                                overlayRadius:
                                                                    28),
                                                      ),
                                                      child: Slider(
                                                          value: position
                                                              .value.inSeconds
                                                              .toDouble(),
                                                          activeColor:
                                                              commonBlueColor,
                                                          max: duration
                                                              .value.inSeconds
                                                              .toDouble(),
                                                          onChanged:
                                                              (value) async {
                                                            baseController!
                                                                .audioPlayer
                                                                .seek(Duration(
                                                                    seconds: value
                                                                        .toInt()));
                                                          }),
                                                    ),
                                                  ),
                                                  Obx(() => Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              time(position
                                                                      .value) ??
                                                                  "",
                                                              style: TextStyle(
                                                                  color:
                                                                      buttonColor)),
                                                          Text(
                                                              time(duration
                                                                          .value -
                                                                      position
                                                                          .value) ??
                                                                  "",
                                                              style: TextStyle(
                                                                  color:
                                                                      buttonColor)),
                                                        ],
                                                      )),
                                                  const SizedBox(height: 12),
                                                  Obx(() => Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          baseController!
                                                                      .currentPlayingIndex
                                                                      .value !=
                                                                  0
                                                              ? InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    if (baseController!
                                                                        .isCompleted
                                                                        .isFalse) {
                                                                      if (baseController!
                                                                          .audioPlayer
                                                                          .hasPrevious) {
                                                                        await baseController!
                                                                            .audioPlayer
                                                                            .seekToPrevious();
                                                                        baseController!
                                                                            .audioPlayer
                                                                            .play();
                                                                        baseController!
                                                                            .isPlaying
                                                                            .value = true;

                                                                        setState(
                                                                            () {});
                                                                      }
                                                                    }
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/icons/back.png',
                                                                    height: 30,
                                                                    width: 30,
                                                                  ),
                                                                )
                                                              : const SizedBox(
                                                                  width: 45),
                                                          InkWell(
                                                            onTap: () async {
                                                              if (baseController!
                                                                  .isCompleted
                                                                  .isFalse) {
                                                                if (baseController!
                                                                        .audioPlayer
                                                                        .position
                                                                        .inSeconds <
                                                                    10) {
                                                                  baseController!
                                                                      .audioPlayer
                                                                      .seek(const Duration(
                                                                          seconds:
                                                                              0));
                                                                } else {
                                                                  baseController!
                                                                      .audioPlayer
                                                                      .seek(Duration(
                                                                          seconds:
                                                                              baseController!.audioPlayer.position.inSeconds - 10));
                                                                }

                                                                setState(() {});
                                                              }
                                                            },
                                                            child: Image.asset(
                                                              'assets/images/back-10.png',
                                                              height: 24,
                                                              width: 24,
                                                            ),
                                                          ),
                                                          CircleAvatar(
                                                              backgroundColor:
                                                                  commonBlueColor,
                                                              radius: 25,
                                                              child: IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (baseController!
                                                                      .isCompleted
                                                                      .isFalse) {
                                                                    if (baseController!
                                                                        .isPlaying
                                                                        .value) {
                                                                      baseController!
                                                                          .audioPlayer
                                                                          .pause();
                                                                      baseController!
                                                                          .isPause
                                                                          .value = true;
                                                                      baseController!
                                                                          .isPlaying
                                                                          .value = false;
                                                                      setState(
                                                                          () {});
                                                                    } else {
                                                                      if (baseController!
                                                                              .isPause
                                                                              .value ==
                                                                          true) {
                                                                        baseController!
                                                                            .audioPlayer
                                                                            .play();

                                                                        baseController!
                                                                            .isPlaying
                                                                            .value = true;
                                                                        baseController!
                                                                            .isPause
                                                                            .value = false;
                                                                        setState(
                                                                            () {});
                                                                      } else {
                                                                        baseController!
                                                                            .audioPlayer
                                                                            .dispose();
                                                                        baseController!.audioPlayer =
                                                                            AudioPlayer();
                                                                        baseController!
                                                                            .isPlaying
                                                                            .value = false;
                                                                        setAudio()
                                                                            .then((value) {
                                                                          baseController!
                                                                              .isPlaying
                                                                              .value = true;
                                                                          setState(
                                                                              () {});
                                                                        });
                                                                      }
                                                                    }
                                                                  }
                                                                },
                                                                icon: Icon(
                                                                  baseController!
                                                                          .isPlaying
                                                                          .value
                                                                      ? Icons
                                                                          .pause
                                                                      : Icons
                                                                          .play_arrow,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )),
                                                          InkWell(
                                                            onTap: () {
                                                              if (baseController!
                                                                  .isCompleted
                                                                  .isFalse) {
                                                                if (baseController!
                                                                            .audioPlayer
                                                                            .duration!
                                                                            .inSeconds -
                                                                        baseController!
                                                                            .audioPlayer
                                                                            .position
                                                                            .inSeconds >=
                                                                    10) {
                                                                  baseController!
                                                                      .audioPlayer
                                                                      .seek(Duration(
                                                                          seconds:
                                                                              baseController!.audioPlayer.position.inSeconds + 10));
                                                                } else {
                                                                  baseController!
                                                                      .audioPlayer
                                                                      .seek(Duration(
                                                                          seconds: baseController!
                                                                              .audioPlayer
                                                                              .duration!
                                                                              .inSeconds));
                                                                }
                                                              }
                                                            },
                                                            child: Image.asset(
                                                              'assets/images/forward-10.png',
                                                              height: 24,
                                                              width: 24,
                                                            ),
                                                          ),
                                                          baseController!.currentPlayingIndex
                                                                          .value +
                                                                      1 !=
                                                                  baseController
                                                                      ?.currentBookChapterList
                                                                      .length
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    if (baseController!
                                                                        .isCompleted
                                                                        .isFalse) {
                                                                      if (baseController!
                                                                          .audioPlayer
                                                                          .hasNext) {
                                                                        baseController!
                                                                            .isPlaying
                                                                            .value = false;
                                                                        baseController!
                                                                            .audioPlayer
                                                                            .seekToNext();

                                                                        baseController!
                                                                            .isPlaying
                                                                            .value = true;
                                                                        baseController!
                                                                            .audioPlayer
                                                                            .play();
                                                                        setState(
                                                                            () {});
                                                                      }
                                                                    }
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/nxtbtn.png',
                                                                    height: 30,
                                                                    width: 30,
                                                                  ),
                                                                )
                                                              : const SizedBox(
                                                                  width: 45)
                                                        ],
                                                      )),
                                                  const SizedBox(height: 20),
                                                ],
                                              )
                                            : const SizedBox()

                                        // Row(
                                        //   children: [
                                        //     Container(
                                        //       height: 65,
                                        //       width: 65,
                                        //       decoration: BoxDecoration(
                                        //         boxShadow: [
                                        //           BoxShadow(
                                        //             color: Colors.grey
                                        //                 .withOpacity(0.5),
                                        //             spreadRadius: 5,
                                        //             blurRadius: 7,
                                        //             offset: const Offset(0,
                                        //                 2), // changes position of shadow
                                        //           ),
                                        //         ],
                                        //         image: DecorationImage(
                                        //           image: FileImage(File(
                                        //               baseController!
                                        //                   .runningBookImage
                                        //                   .value)),
                                        //           fit: BoxFit.contain,
                                        //         ),
                                        //         border: Border.all(
                                        //           width: 2,
                                        //           color: backgroundColor,
                                        //         ),
                                        //         borderRadius:
                                        //         const BorderRadius.all(
                                        //             Radius.circular(8)),
                                        //       ),
                                        //     ),
                                        //     const SizedBox(width: 16),
                                        //     Expanded(
                                        //       child: Obx(() =>
                                        //       baseController!
                                        //           .currentPlayingIndex
                                        //           .value !=
                                        //           999
                                        //           ? Column(
                                        //         crossAxisAlignment:
                                        //         CrossAxisAlignment
                                        //             .start,
                                        //         children: [
                                        //           Obx(
                                        //                 () =>
                                        //                 InkWell(
                                        //                   onTap: () =>
                                        //                       Get.back(),
                                        //                   child: Wrap(
                                        //                     children: [
                                        //                       Text(
                                        //                         'Ch ${baseController!
                                        //                             .currentPlayingIndex
                                        //                             .value +
                                        //                             1} : ',
                                        //                         style:
                                        //                         const TextStyle(
                                        //                           // color:
                                        //                           //     Colors.black,
                                        //                           fontSize:
                                        //                           17,
                                        //                         ),
                                        //                       ),
                                        //                       Text(
                                        //                         jsonDecode(
                                        //                             data.value[
                                        //                             'chapter'])[baseController!
                                        //                             .currentPlayingIndex
                                        //                             .value]['name'] ??
                                        //                             "",
                                        //                         maxLines: 2,
                                        //                         overflow:
                                        //                         TextOverflow
                                        //                             .ellipsis,
                                        //                         style:
                                        //                         const TextStyle(
                                        //                           fontSize:
                                        //                           17,
                                        //                           // color:
                                        //                           //     Colors.black,
                                        //                         ),
                                        //                       ),
                                        //                     ],
                                        //                   ),
                                        //                 ),
                                        //           ),
                                        //           const SizedBox(
                                        //               height: 8),
                                        //           Row(
                                        //             children: [
                                        //               InkWell(
                                        //                 onTap: () async {
                                        //                   if (baseController!
                                        //                       .isPlaying
                                        //                       .value) {
                                        //                     baseController!
                                        //                         .audioPlayer
                                        //                         .pause();
                                        //                     baseController!
                                        //                         .isPause
                                        //                         .value = true;
                                        //                     baseController!
                                        //                         .isPlaying
                                        //                         .value = false;
                                        //                     setState(
                                        //                             () {});
                                        //                   } else {
                                        //                     if (baseController!
                                        //                         .isPause
                                        //                         .value ==
                                        //                         true) {
                                        //                       baseController!
                                        //                           .audioPlayer
                                        //                           .play();
                                        //
                                        //                       baseController!
                                        //                           .isPlaying
                                        //                           .value = true;
                                        //                       baseController!
                                        //                           .isPause
                                        //                           .value = false;
                                        //                       setState(
                                        //                               () {});
                                        //                     } else {
                                        //                       baseController!
                                        //                           .audioPlayer
                                        //                           .dispose();
                                        //                       baseController!
                                        //                           .audioPlayer =
                                        //                           AudioPlayer();
                                        //                       baseController!
                                        //                           .isPlaying
                                        //                           .value = false;
                                        //                       setAudio().then(
                                        //                               (value) {
                                        //                             baseController!
                                        //                                 .isPlaying
                                        //                                 .value =
                                        //                             true;
                                        //                             setState(
                                        //                                     () {});
                                        //                           });
                                        //                     }
                                        //                   }
                                        //                 },
                                        //                 child: Container(
                                        //                   height: 30,
                                        //                   width: 30,
                                        //                   decoration: BoxDecoration(
                                        //                       shape: BoxShape
                                        //                           .circle,
                                        //                       color:
                                        //                       buttonColor),
                                        //                   child: Icon(
                                        //                     baseController!
                                        //                         .isPlaying
                                        //                         .value
                                        //                         ? Icons
                                        //                         .pause
                                        //                         : Icons
                                        //                         .play_arrow,
                                        //                     color: Colors
                                        //                         .white,
                                        //                   ),
                                        //                 ),
                                        //               ),
                                        //               const SizedBox(
                                        //                   width: 16),
                                        //               InkWell(
                                        //                 onTap: () {
                                        //                   setState(() {
                                        //                     isTextVisible
                                        //                         .value =
                                        //                     false;
                                        //                     isVisible
                                        //                         .value =
                                        //                     true;
                                        //                   });
                                        //                 },
                                        //                 child: Container(
                                        //                   height: 30,
                                        //                   width: 30,
                                        //                   decoration: BoxDecoration(
                                        //                       shape: BoxShape
                                        //                           .circle,
                                        //                       color:
                                        //                       buttonColor),
                                        //                   child: const Icon(
                                        //                       Icons
                                        //                           .headphones,
                                        //                       color: Colors
                                        //                           .white),
                                        //                 ),
                                        //               ),
                                        //               const SizedBox(
                                        //                   width: 16),
                                        //               InkWell(
                                        //                 onTap: () {
                                        //                   setState(() {
                                        //                     isTextVisible
                                        //                         .value =
                                        //                     true;
                                        //                     isVisible
                                        //                         .value =
                                        //                     false;
                                        //                   });
                                        //                 },
                                        //                 child: Container(
                                        //                     height: 30,
                                        //                     width: 30,
                                        //                     decoration: BoxDecoration(
                                        //                         shape: BoxShape
                                        //                             .circle,
                                        //                         color:
                                        //                         buttonColor),
                                        //                     child: Image
                                        //                         .asset(
                                        //                         'assets/icons/aaa.png')),
                                        //               ),
                                        //               const SizedBox(
                                        //                   width: 16),
                                        //               Obx(
                                        //                     () =>
                                        //                     Align(
                                        //                       alignment: Alignment
                                        //                           .centerRight,
                                        //                       child: Text(
                                        //                         time(duration
                                        //                             .value) ??
                                        //                             "",
                                        //                         style:
                                        //                         TextStyle(
                                        //                           color:
                                        //                           textColor,
                                        //                           fontSize:
                                        //                           18,
                                        //                         ),
                                        //                         textAlign:
                                        //                         TextAlign
                                        //                             .end,
                                        //                       ),
                                        //                     ),
                                        //               )
                                        //             ],
                                        //           )
                                        //         ],
                                        //       )
                                        //           : SizedBox(
                                        //         height: Get.height * 0.1,
                                        //         child: Center(
                                        //           child: Text(
                                        //             jsonDecode(data.value[
                                        //             'bookDetail'])[
                                        //             'isPodcast'] ==
                                        //                 true
                                        //                 ? "No More Episodes Found"
                                        //                 : "No More Chapters Found",
                                        //             style:
                                        //             const TextStyle(
                                        //               // color: Colors.black,
                                        //               fontSize: 18,
                                        //               fontWeight:
                                        //               FontWeight.w600,
                                        //             ),
                                        //           ),
                                        //         ),
                                        //       )),
                                        //     ),
                                        //   ],
                                        // ),
                                        // const SizedBox(height: 16),
                                        // SizedBox(
                                        //   height: 8,
                                        //   child: Divider(
                                        //     height: 1,
                                        //     color: Colors.grey.withOpacity(0.3),
                                        //     thickness: 1,
                                        //   ),
                                        // ),
                                        // const SizedBox(height: 8),
                                        // isTextVisible.value
                                        //     ? Column(
                                        //   children: [
                                        //     Row(
                                        //       mainAxisAlignment:
                                        //       MainAxisAlignment.end,
                                        //       children: [
                                        //         InkWell(
                                        //           onTap: () {
                                        //             setState(() {
                                        //               if (customFontSize
                                        //                   .value !=
                                        //                   10) {
                                        //                 customFontSize
                                        //                     .value =
                                        //                     customFontSize
                                        //                         .value -
                                        //                         2;
                                        //                 setState(() {});
                                        //               }
                                        //             });
                                        //           },
                                        //           child: Container(
                                        //             padding:
                                        //             const EdgeInsets
                                        //                 .all(5),
                                        //             decoration: BoxDecoration(
                                        //                 border: Border.all(
                                        //                   // color:
                                        //                   //     Colors.black
                                        //                 )),
                                        //             child: const Icon(
                                        //                 Icons.remove),
                                        //           ),
                                        //         ),
                                        //         InkWell(
                                        //           onTap: () {
                                        //             if (customFontSize
                                        //                 .value !=
                                        //                 24) {
                                        //               customFontSize
                                        //                   .value =
                                        //                   customFontSize
                                        //                       .value +
                                        //                       2;
                                        //               setState(() {});
                                        //             }
                                        //           },
                                        //           child: Container(
                                        //             padding:
                                        //             const EdgeInsets
                                        //                 .all(5),
                                        //             decoration:
                                        //             BoxDecoration(
                                        //                 border: Border
                                        //                     .all()),
                                        //             child: const Icon(
                                        //                 Icons.add),
                                        //           ),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //     const SizedBox(height: 12),
                                        //     Obx(() =>
                                        //         Html(
                                        //           data: jsonDecode(data
                                        //               .value[
                                        //           'chapter'])[
                                        //           baseController!
                                        //               .currentPlayingIndex
                                        //               .value]['content'] ??
                                        //               "",
                                        //           style: {
                                        //             "body": Style(
                                        //               fontSize: FontSize(
                                        //                   customFontSize
                                        //                       .value),
                                        //             ),
                                        //           },
                                        //         )),
                                        //   ],
                                        // )
                                        //     : const SizedBox(),
                                        // isVisible.value
                                        //     ? Column(
                                        //   children: [
                                        //     Container(
                                        //       alignment:
                                        //       Alignment.topCenter,
                                        //       height: Get.height * 0.46,
                                        //       decoration: BoxDecoration(
                                        //         boxShadow: [
                                        //           BoxShadow(
                                        //             color: Colors.grey
                                        //                 .withOpacity(0.2),
                                        //             spreadRadius: 5,
                                        //             blurRadius: 7,
                                        //             offset: const Offset(
                                        //                 0, 2),
                                        //           ),
                                        //         ],
                                        //         image: DecorationImage(
                                        //           image: FileImage(File(
                                        //               baseController!
                                        //                   .runningBookImage
                                        //                   .value)),
                                        //           fit: BoxFit.contain,
                                        //         ),
                                        //         border: Border.all(
                                        //             width: 2,
                                        //             color:
                                        //             backgroundColor),
                                        //         borderRadius:
                                        //         const BorderRadius
                                        //             .all(
                                        //             Radius.circular(
                                        //                 8)),
                                        //       ),
                                        //     ),
                                        //     const SizedBox(height: 10),
                                        //     Obx(
                                        //           () =>
                                        //           SliderTheme(
                                        //             data: SliderTheme.of(
                                        //                 context)
                                        //                 .copyWith(
                                        //               activeTrackColor:
                                        //               buttonColor,
                                        //               inactiveTrackColor:
                                        //               Colors
                                        //                   .grey
                                        //                   .withOpacity(
                                        //                   0.3),
                                        //               trackShape:
                                        //               const RectangularSliderTrackShape(),
                                        //               trackHeight: 4,
                                        //               thumbColor: Colors.grey,
                                        //               thumbShape:
                                        //               const RoundSliderThumbShape(
                                        //                   enabledThumbRadius:
                                        //                   10),
                                        //               overlayShape:
                                        //               const RoundSliderOverlayShape(
                                        //                   overlayRadius:
                                        //                   28),
                                        //             ),
                                        //             child: Slider(
                                        //                 value: position
                                        //                     .value.inSeconds
                                        //                     .toDouble(),
                                        //                 activeColor:
                                        //                 buttonColor,
                                        //                 max: duration
                                        //                     .value.inSeconds
                                        //                     .toDouble(),
                                        //                 onChanged:
                                        //                     (value) async {
                                        //                   baseController!
                                        //                       .audioPlayer
                                        //                       .seek(Duration(
                                        //                       seconds: value
                                        //                           .toInt()));
                                        //                 }),
                                        //           ),
                                        //     ),
                                        //     const SizedBox(height: 6),
                                        //     Obx(() =>
                                        //         Row(
                                        //           mainAxisAlignment:
                                        //           MainAxisAlignment
                                        //               .spaceBetween,
                                        //           children: [
                                        //             Text(
                                        //                 time(position
                                        //                     .value) ??
                                        //                     "",
                                        //                 style: TextStyle(
                                        //                     color:
                                        //                     buttonColor)),
                                        //             Text(
                                        //                 time(duration
                                        //                     .value -
                                        //                     position
                                        //                         .value) ??
                                        //                     "",
                                        //                 style: TextStyle(
                                        //                     color:
                                        //                     borderColor)),
                                        //           ],
                                        //         )),
                                        //     Obx(() =>
                                        //         Row(
                                        //           mainAxisAlignment:
                                        //           MainAxisAlignment
                                        //               .spaceEvenly,
                                        //           children: [
                                        //             baseController!
                                        //                 .currentPlayingIndex
                                        //                 .value !=
                                        //                 0
                                        //                 ? InkWell(
                                        //               onTap:
                                        //                   () async {
                                        //                 if (baseController!
                                        //                     .audioPlayer
                                        //                     .hasPrevious) {
                                        //                   baseController!
                                        //                       .isPlaying
                                        //                       .value = false;
                                        //                   await baseController!
                                        //                       .audioPlayer
                                        //                       .seekToPrevious();
                                        //                   baseController!
                                        //                       .audioPlayer
                                        //                       .play();
                                        //                   baseController!
                                        //                       .isPlaying
                                        //                       .value = true;
                                        //
                                        //                   // baseController!
                                        //                   //     .currentPlayingIndex
                                        //                   //     .value--;
                                        //
                                        //                   setState(
                                        //                           () {});
                                        //                 }
                                        //               },
                                        //               child:
                                        //               Container(
                                        //                 height: 45,
                                        //                 width: 45,
                                        //                 decoration: BoxDecoration(
                                        //                     color:
                                        //                     backgroundColor,
                                        //                     borderRadius:
                                        //                     const BorderRadius
                                        //                         .all(
                                        //                         Radius.circular(
                                        //                             8))),
                                        //                 child: Image
                                        //                     .asset(
                                        //                     'assets/images/back-10.png'),
                                        //               ),
                                        //             )
                                        //                 : const SizedBox(
                                        //                 width: 45),
                                        //             InkWell(
                                        //               onTap: () async {
                                        //                 if (baseController!
                                        //                     .audioPlayer
                                        //                     .position
                                        //                     .inSeconds <
                                        //                     10) {
                                        //                   baseController!
                                        //                       .audioPlayer
                                        //                       .seek(
                                        //                       const Duration(
                                        //                           seconds:
                                        //                           0));
                                        //                 } else {
                                        //                   baseController!
                                        //                       .audioPlayer
                                        //                       .seek(Duration(
                                        //                       seconds:
                                        //                       baseController!
                                        //                           .audioPlayer
                                        //                           .position
                                        //                           .inSeconds -
                                        //                           10));
                                        //                 }
                                        //
                                        //                 setState(() {});
                                        //               },
                                        //               child: Container(
                                        //                 height: 45,
                                        //                 width: 45,
                                        //                 decoration: BoxDecoration(
                                        //                     color:
                                        //                     backgroundColor,
                                        //                     borderRadius: const BorderRadius
                                        //                         .all(
                                        //                         Radius.circular(
                                        //                             8))),
                                        //                 child: Image.asset(
                                        //                     'assets/images/backbtn.png'),
                                        //               ),
                                        //             ),
                                        //             CircleAvatar(
                                        //                 backgroundColor:
                                        //                 buttonColor,
                                        //                 radius: 25,
                                        //                 child: IconButton(
                                        //                   onPressed:
                                        //                       () async {
                                        //                     if (baseController!
                                        //                         .isPlaying
                                        //                         .value) {
                                        //                       baseController!
                                        //                           .audioPlayer
                                        //                           .pause();
                                        //                       baseController!
                                        //                           .isPause
                                        //                           .value = true;
                                        //                       baseController!
                                        //                           .isPlaying
                                        //                           .value = false;
                                        //                       setState(
                                        //                               () {});
                                        //                     } else {
                                        //                       if (baseController!
                                        //                           .isPause
                                        //                           .value ==
                                        //                           true) {
                                        //                         baseController!
                                        //                             .audioPlayer
                                        //                             .play();
                                        //
                                        //                         baseController!
                                        //                             .isPlaying
                                        //                             .value = true;
                                        //                         baseController!
                                        //                             .isPause
                                        //                             .value =
                                        //                         false;
                                        //                         setState(
                                        //                                 () {});
                                        //                       } else {
                                        //                         baseController!
                                        //                             .audioPlayer
                                        //                             .dispose();
                                        //                         baseController!
                                        //                             .audioPlayer =
                                        //                             AudioPlayer();
                                        //                         baseController!
                                        //                             .isPlaying
                                        //                             .value =
                                        //                         false;
                                        //                         setAudio()
                                        //                             .then(
                                        //                                 (value) {
                                        //                               baseController!
                                        //                                   .isPlaying
                                        //                                   .value =
                                        //                               true;
                                        //                               setState(
                                        //                                       () {});
                                        //                             });
                                        //                       }
                                        //                     }
                                        //                   },
                                        //                   icon: Icon(
                                        //                     baseController!
                                        //                         .isPlaying
                                        //                         .value
                                        //                         ? Icons
                                        //                         .pause
                                        //                         : Icons
                                        //                         .play_arrow,
                                        //                     color: Colors
                                        //                         .white,
                                        //                   ),
                                        //                 )),
                                        //             InkWell(
                                        //               onTap: () {
                                        //                 if (baseController!
                                        //                     .audioPlayer
                                        //                     .duration!
                                        //                     .inSeconds -
                                        //                     baseController!
                                        //                         .audioPlayer
                                        //                         .position
                                        //                         .inSeconds >=
                                        //                     10) {
                                        //                   baseController!
                                        //                       .audioPlayer
                                        //                       .seek(Duration(
                                        //                       seconds:
                                        //                       baseController!
                                        //                           .audioPlayer
                                        //                           .position
                                        //                           .inSeconds +
                                        //                           10));
                                        //                 } else {
                                        //                   baseController!
                                        //                       .audioPlayer
                                        //                       .seek(Duration(
                                        //                       seconds: baseController!
                                        //                           .audioPlayer
                                        //                           .duration!
                                        //                           .inSeconds));
                                        //                 }
                                        //               },
                                        //               child: Container(
                                        //                 height: 45,
                                        //                 width: 45,
                                        //                 decoration: BoxDecoration(
                                        //                     color:
                                        //                     backgroundColor,
                                        //                     borderRadius: const BorderRadius
                                        //                         .all(
                                        //                         Radius.circular(
                                        //                             8))),
                                        //                 child: Image.asset(
                                        //                     'assets/images/forward-10.png'),
                                        //               ),
                                        //             ),
                                        //             baseController!
                                        //                 .currentPlayingIndex
                                        //                 .value +
                                        //                 1 !=
                                        //                 baseController!
                                        //                     .downloadCurrentBookChapterList
                                        //                     .length
                                        //                 ? InkWell(
                                        //               onTap: () {
                                        //                 if (baseController!
                                        //                     .audioPlayer
                                        //                     .hasNext) {
                                        //                   baseController!
                                        //                       .isPlaying
                                        //                       .value = false;
                                        //                   baseController!
                                        //                       .audioPlayer
                                        //                       .seekToNext();
                                        //                   baseController!
                                        //                       .currentPlayingIndex
                                        //                       .value++;
                                        //                   baseController!
                                        //                       .isPlaying
                                        //                       .value = true;
                                        //                   baseController!
                                        //                       .audioPlayer
                                        //                       .play();
                                        //                   setState(
                                        //                           () {});
                                        //                 }
                                        //               },
                                        //               child:
                                        //               Container(
                                        //                 height: 45,
                                        //                 width: 45,
                                        //                 decoration: BoxDecoration(
                                        //                     color:
                                        //                     backgroundColor,
                                        //                     borderRadius:
                                        //                     const BorderRadius
                                        //                         .all(
                                        //                         Radius.circular(
                                        //                             8))),
                                        //                 child: Image
                                        //                     .asset(
                                        //                     'assets/images/nxtbtn.png'),
                                        //               ),
                                        //             )
                                        //                 : const SizedBox(
                                        //                 width: 45)
                                        //           ],
                                        //         )),
                                        //     const SizedBox(height: 20),
                                        //   ],
                                        // )
                                        //     : const SizedBox()
                                      ])),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  );
          });
        });
  }
}
