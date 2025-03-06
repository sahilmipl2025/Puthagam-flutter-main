import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:puthagam/podcaster/core/widgets/build_loading.dart';
import 'package:puthagam/podcaster/domain/params/podcast/go_live_podcast_params.dart';
import 'package:puthagam/podcaster/modules/live/controllers/live_controller.dart';
import 'package:puthagam/podcaster/modules/live/views/live_view.dart';
import 'package:puthagam/podcaster/modules/podcasts/controllers/podcasts_controller.dart';
import 'package:puthagam/podcaster/domain/entities/episodes/get_episodes_response/datum.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class BuildEpisodes extends StatelessWidget {
  const BuildEpisodes({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final PodcastsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        "All Episodes".text.bold.size(16).make(),
        10.heightBox,
        Obx(() {
          return controller.episodesLoading.isTrue
              ? buildLoadingIndicator()
              : ListView.separated(
                  itemCount: controller.allEpisodes.length,
                  separatorBuilder: ((context, index) {
                    return const VxDivider();
                  }),
                  itemBuilder: (ctx, index) {
                    final item = controller.allEpisodes[index];
                    return BuildSingleEpisode(
                        episode: item, index: index, controller: controller);
                  }).expand();
        })
      ],
    )
        .marginAll(10)
        .box
        .withDecoration(
          BoxDecoration(
            gradient: verticalGradient,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
        )
        .border()
        .topRounded()
        .make();
  }
}

class BuildSingleEpisode extends StatelessWidget {
  const BuildSingleEpisode({
    Key? key,
    required this.episode,
    required this.index,
    required this.controller,
  }) : super(key: key);

  final Datum episode;
  final PodcastsController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Row(
              children: [
                "${index + 1}.".text.size(14).make(),
                5.widthBox,
                Expanded(
                  child: episode.name!.text
                      .maxLines(2)
                      .size(14)
                      .make()
                      .w60(context)
                      .paddingOnly(right: 5, left: 0),
                ),
                10.widthBox,
                "${controller.getUIDate(episode.startPodcast!)} "
                    .text
                    .size(6)
                    .align(TextAlign.left)
                    .make()
              ],
            ),
            // ("${index + 1}.  ${episode.name!}").text.size(14).make(),
            5.heightBox,
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Html(
                data: (episode.content ?? "n/a"),
                style: {
                  "span": Style(color: text23, fontSize:  FontSize(12))
                },
              ),
            ),
            8.heightBox,
          ],
        ).expand(),
        controller.showEpisodeRecordBtn(
                    episode.startPodcast!, episode.endPodcast!) ==
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
                    "Go Live".text.size(12).color(text23).make(),
                    Image.asset(
                      "assets/icons/podcast2.png",
                      width: 30,
                      height: 20,
                    )
                  ],
                ).onInkTap(() {
                  Get.back();
                  final param = GoLivePodcastParams();
                  final podcast = controller.allPodcasts
                      .firstWhere((p0) => p0.id == controller.selectedPodcast);
                  param.episodeId = episode.id!;
                  param.podcastId = controller.selectedPodcast;
                  param.episodeName = episode.name ?? "";
                  param.podcastName = podcast.title ?? "";
                  param.podcastImage = podcast.image ?? "";
                  Get.lazyPut<LiveController>(
                    () => LiveController(),
                  );
                  Get.to(const LiveView(), arguments: param);
                }),
              )
            : controller.showEpisodeUploadBtn(episode.endPodcast!)
                ? Row(
                    children: [
                      Icon(
                        Icons.file_upload_outlined,
                        color: text23,
                        size: 18,
                      ),
                      4.widthBox,
                      "Upload".text.size(12).color(text23).make()
                    ],
                  ).onInkTap(() {
                    controller.uploadAudio(episode.id!);
                  })
                : "".text.make()
        // controller
        //     .findRemainingTime(
        //       episode.startPodcast!,
        //     )
        //     .text
        //     .bold
        //     .make()
      ],
    )
        .box
        .withDecoration(const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5))))
        .margin(const EdgeInsets.all(8))
        .make();
  }
}
