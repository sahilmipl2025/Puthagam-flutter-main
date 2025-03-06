import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/screen/dashboard/library/downloads/book_detail/download_book_detail_controller.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class DownloadChapterPage extends StatelessWidget {
  DownloadChapterPage({Key? key}) : super(key: key);

  final DownloadBookDetailController con =
      Get.put(DownloadBookDetailController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        gradient: verticalGradient,
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: jsonDecode(con.data.value['chapter']).length,
        itemBuilder: (BuildContext context, int index) {
          return IntrinsicHeight(
            child: InkWell(
              onTap: () {
                Future.delayed(const Duration(seconds: 2), () async {
                  await con.setAudio(index: index);

                  baseController!.currentPlayingIndex.value = index;

                  Future.delayed(const Duration(microseconds: 200), () {
                    con.myQueue(
                      context: context,
                      index: baseController!.currentPlayingIndex.value,
                    );
                  });
                });
              },
              child: Row(
                children: [
                  Obx(
                    () => baseController!.currentPlayingIndex.value != 999 &&
                            baseController!.currentPlayingIndex.value == index
                        ? VerticalDivider(
                            width: 2,
                            thickness: 3,
                            color: commonBlueColor,
                          )
                        : const SizedBox(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              Text(
                                (index + 1).toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      jsonDecode(con.data.value['chapter'])[
                                              index]['name'] ??
                                          "",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Html(
                                      data:
                                          jsonDecode(con.data.value['chapter'])[
                                                  index]['content'] ??
                                              "",
                                      style: {
                                        "body": Style(
                                          fontSize: Platform.isIOS
                                              ?  FontSize(13)
                                              :  FontSize(12),
                                          maxLines: 2,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        )
                                      },
                                    ).h(40)
                                  ],
                                ),
                              ),
                              Obx(
                                () => Row(
                                  children: [
                                    baseController!.currentPlayingIndex.value !=
                                            999
                                        ? baseController!.currentPlayingIndex
                                                    .value ==
                                                index
                                            ? Image.asset(
                                                "assets/images/audio.png",
                                                height: 30,
                                                width: 30,
                                                color: commonBlueColor,
                                              )
                                            : Text(
                                                jsonDecode(con.data.value[
                                                            'chapter'])[index]
                                                        ['audioDuration']
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.left,
                                              )
                                        : Text(
                                            jsonDecode(con.data.value[
                                                        'chapter'])[index]
                                                    ['audioDuration']
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                        index + 1 !=
                                jsonDecode(con.data.value['chapter']).length
                            ? const Divider(
                                height: 1,
                                color: Colors.white,
                              )
                            : const SizedBox()
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
