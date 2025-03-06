import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/podcaster/core/widgets/build_network_image.dart';
import 'package:puthagam/podcaster/modules/podcasts/controllers/podcasts_controller.dart';
import 'package:puthagam/podcaster/domain/entities/podcasts/get_podcast_response/datum.dart';
import 'package:puthagam/podcaster/modules/podcasts/views/build_episodes.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class BuildPodcast extends StatelessWidget {
  const BuildPodcast({
    Key? key,
    required this.controller,
    required this.podcast,
  }) : super(key: key);

  final PodcastsController controller;
  final Datum podcast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.getAllEpisodes(podcast.id!);
        Get.bottomSheet(BuildEpisodes(
          controller: controller,
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildNetworkImage(
                image: podcast.image,
                width: 90,
                height: 130,
              ),
              10.widthBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (podcast.title ?? "n/a").text.size(13).make(),
                  5.heightBox,
                  (podcast.info ?? "no info available")
                      .text
                      .size(12)
                      .maxLines(3)
                      .make(),
                  10.heightBox,
                  "${podcast.chapterCount} episodes".text.maxLines(3).make()
                ],
              ).expand(),
              const Icon(Icons.keyboard_arrow_right_outlined)
            ],
          )

              // ListTile(
              //   onTap: () {
              //     controller.getAllEpisodes(podcast.id!);
              //     Get.bottomSheet(BuildEpisodes(
              //       controller: controller,
              //     ));
              //   },
              //   // leading: BuildNetworkImage(
              //   //   image: podcast.image,
              //   //   width: 90,
              //   //   height: 180,
              //   // ),
              //   minLeadingWidth: 10,
              //   title: (podcast.title ?? "n/a").text.size(12).make(),
              //   subtitle: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       (podcast.info ?? "no info available").text.maxLines(3).make(),
              //       10.heightBox,
              //       "${podcast.chapterCount} episodes".text.maxLines(3).make()
              //     ],
              //   ).marginOnly(top: 10, bottom: 10),
              //   trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              // )
              .box
              // .border(color: Vx.gray300)
              .margin(const EdgeInsets.all(10))
              .rounded
              .make(),
          Divider(
            height: 1,
            thickness: 1,
            color: textColor,
          )
        ],
      ),
    );
  }
}
