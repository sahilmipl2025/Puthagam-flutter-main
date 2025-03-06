import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/library/downloads/book_detail/download_book_detail_controller.dart';
import 'package:puthagam/utils/colors.dart';

class DownloadInformationPage extends StatelessWidget {
  DownloadInformationPage({Key? key}) : super(key: key);
  final DownloadBookDetailController con =
      Get.put(DownloadBookDetailController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: horizontalGradient,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.play_circle_outline),
                            const SizedBox(width: 9),
                            InkWell(
                              onTap: () async {
                                Future.delayed(const Duration(seconds: 2),
                                    () async {
                                  await con.setAudio(index: 0);

                                  baseController!.isTextVisible.value = false;

                                  Future.delayed(
                                      const Duration(microseconds: 200), () {
                                    baseController
                                        ?.currentPlayingBookIndex.value = 0;
                                    con.myQueue(
                                      context: context,
                                      index: 0,
                                    );
                                  });
                                });
                              },
                              child: const Center(
                                child: Text(
                                  "Listen",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        width: 2,
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/read-book.png",
                              height: 24,
                              width: 24,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 9),
                            InkWell(
                              onTap: () async {
                                Future.delayed(const Duration(seconds: 2),
                                    () async {
                                  await con.setAudio(index: 0);

                                  baseController!.isTextVisible.value = true;

                                  Future.delayed(
                                      const Duration(microseconds: 200), () {
                                    baseController
                                        ?.currentPlayingBookIndex.value = 0;
                                    con.myQueue(
                                      context: context,
                                      index: 0,
                                    );
                                    baseController!.audioPlayer.pause();
                                  });
                                });
                              },
                              child: const Center(
                                child: Text(
                                  "Read",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/review.png',
                              height: 24,
                              width: 24,
                              color: Colors.grey,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                jsonDecode(con.data.value['bookDetail'])[
                                        'totalAudioDuration'] ??
                                    "",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
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
                      thickness: 2,
                      indent: 5,
                      endIndent: 0,
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/key.png',
                            height: 30,
                            width: 30,
                            color: Colors.grey,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${jsonDecode(con.data.value['bookDetail'])['chapterCount']} Key ideas',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: commonBlueColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  jsonDecode(con.data.value['bookDetail'])['info'] ?? "",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
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
