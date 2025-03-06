import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/podcaster/modules/podcasts/views/allpodcasts_tab.dart';
import 'package:puthagam/podcaster/modules/podcasts/views/upcoming_podcasts_tab.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../data/datasources/local/app_database.dart';
import '../controllers/podcasts_controller.dart';

class PodcastsView extends GetView<PodcastsController> {
  const PodcastsView({Key? key}) : super(key: key);

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
            "Hi, ${LocalStorages.readName()}".text.size(22).bold.make(),
            20.heightBox,
            "Select your podcast".text.white.make(),
            20.heightBox,
            TabBar(
              unselectedLabelColor: text23,
              labelColor: commonBlueColor,
              tabs: const [
                Tab(
                  text: 'Upcoming Podcast',
                ),
                Tab(
                  text: 'All Podcast',
                )
              ],
              controller: controller.tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [BuildUpcomingPocastsTab(), BuildAllEpisodesTab()],
              ),
            ),
          ],
        ).h(double.infinity).marginAll(10),
      )),
    );
  }
}
