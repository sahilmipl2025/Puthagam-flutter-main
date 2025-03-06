import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../core/resources/app_resources.dart';
import '../../../core/widgets/build_loading.dart';
import '../../../core/widgets/build_network_image.dart';
import '../../../domain/entities/upcoming/upcoming_episodes_response/datum.dart';
import '../../../domain/params/podcast/go_live_podcast_params.dart';
import '../../live/controllers/live_controller.dart';
import '../../live/views/live_view.dart';
import '../controllers/podcasts_controller.dart';

class BuildUpcomingPocastsTab extends StatelessWidget {
  BuildUpcomingPocastsTab({Key? key}) : super(key: key);

  final PodcastsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(gradient: verticalGradient),
        child: SafeArea(child: Obx(() {
          return controller.upcomingLoading.isTrue
              ? buildLoadingIndicator()
              : controller.upcomingPodcasts.isNotEmpty
                  ? ListView.builder(
                      itemCount: controller.upcomingPodcasts.length,
                      itemBuilder: (ctx, index) {
                        final podcast = controller.upcomingPodcasts[index];
                        return BuildUpcomingPodcast(podcast: podcast);
                      })
                  : "No Upcoming Podcasts found".text.make().centered();
        })),
      ),
    );
  }
}

class BuildUpcomingPodcast extends StatelessWidget {
  BuildUpcomingPodcast({
    Key? key,
    required this.podcast,
  }) : super(key: key);

  final Datum podcast;
  final PodcastsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    log("image ${podcast.podcastImage}");
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.widthBox,
            BuildNetworkImage(
              image: podcast.podcastImage,
              height: 130,
              width: 90,
            ),
            10.widthBox,
            Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.heightBox,
                (podcast.podcastName ?? "n/a").text.size(14).make(),
                5.heightBox,
                (podcast.episodeName ?? "no info available")
                    .text
                    .size(12)
                    .color(text23)
                    .make(),
                5.heightBox,
                "${controller.getUIDate(podcast.startPodcast!)} -  ${controller.getUIDate(podcast.endPodcast!)}"
                    .text
                    .color(text23)
                    .size(12)
                    .make()
              ],
            ).expand(),
            (controller.showEpisodeRecordBtn(
                        podcast.startPodcast!, podcast.endPodcast!) ==
                    true
                ? Container(
                    height: 35,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(25),
                        ),
                        gradient: verticalGradient),
                    child: Row(
                      children: [
                        "Go Live".text.color(text23).size(12).make(),
                        Image.asset(
                          "assets/icons/podcast2.png",
                          width: 20,
                          height: 15,
                        )
                      ],
                    ).onInkTap(() {
                      Get.back();
                      final param = GoLivePodcastParams();
                      param.episodeId = podcast.episodeId;
                      param.podcastId = podcast.podcastId;
                      param.episodeName = podcast.episodeName ?? "";
                      param.podcastName = podcast.podcastName ?? "";
                      param.podcastImage = podcast.podcastImage ?? "";
                      Get.lazyPut<LiveController>(
                        () => LiveController(),
                      );
                      Get.to(const LiveView(), arguments: param);
                    }),
                  )
                : controller.showEpisodeUploadBtn(podcast.endPodcast!)
                    ? Row(
                        children: [
                          Icon(
                            Icons.file_upload_outlined,
                            color: themeColor,
                          ),
                          5.widthBox,
                          "Upload".text.color(themeColor).make()
                        ],
                      ).onInkTap(() {
                        controller.uploadAudio(podcast.episodeId!);
                      })
                    : "".text.make()),
            // : controller
            //     .findRemainingTime(
            //       podcast.startPodcast!,
            //     )
            //     .text
            //     .bold
            //     .make()),
            10.widthBox
          ],
        )
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
    );
  }
}
