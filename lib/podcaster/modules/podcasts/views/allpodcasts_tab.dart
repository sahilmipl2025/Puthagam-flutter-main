import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../core/widgets/build_loading.dart';
import '../controllers/podcasts_controller.dart';
import 'build_podcast.dart';

class BuildAllEpisodesTab extends StatelessWidget {
  BuildAllEpisodesTab({Key? key}) : super(key: key);
  final PodcastsController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(gradient: verticalGradient),
        child: Column(
          children: [
            Obx(() {
              return controller.loading.isTrue
                  ? buildLoadingIndicator()
                  : ListView.builder(
                      itemCount: controller.allPodcasts.length,
                      itemBuilder: (ctx, index) {
                        final podcast = controller.allPodcasts[index];
                        return BuildPodcast(
                            controller: controller, podcast: podcast);
                      }).expand();
            })
          ],
        ).h(double.infinity).marginAll(10),
      )),
    );
  }
}
