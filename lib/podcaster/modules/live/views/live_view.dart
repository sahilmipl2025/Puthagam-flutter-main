import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/podcaster/core/widgets/build_network_image.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/live_controller.dart';
import 'audio_player.dart';

class LiveView extends GetView<LiveController> {
  const LiveView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return controller.willPop(context);
      },
      child: Scaffold(
          // appBar: AppBar(
          //   title: "GO LIVE".text.white.make(),
          //   backgroundColor: themeColor,
          //   leading: const Icon(Icons.arrow_back_ios_new_rounded).onInkTap(() {
          //     controller.willPop(context);
          //   }),
          // ),
          body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(gradient: verticalGradient),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(gradient: verticalGradient),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Go live',
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
            ),
            10.heightBox,
            controller.args.podcastName!.text
                .size(18)
                .make()
                .paddingOnly(left: 16, right: 16),
            20.heightBox,
            BuildNetworkImage(
                image: controller.args.podcastImage, width: 120, height: 180),
            20.heightBox,
            controller.args.episodeName!.text.bold
                .size(16)
                .make()
                .paddingOnly(left: 16, right: 16),
            50.heightBox,
            Obx((() {
              return controller.showPlayer.value
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: AudioPlayer(
                            source: controller.audioPath.value,
                            onDelete: () {
                              controller.showPlayer.value = false;
                              controller.audioPath.value = "";
                              controller.recording.value = false;
                            },
                          ),
                        ),
                        50.heightBox,
                        Container(
                          width: Get.width * 0.5,
                          height: 45,
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50),
                              ),
                              gradient: verticalGradient),
                          child: const Text(
                            "Upload podcast",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ).onInkTap(() {
                          controller.uploadAudio();
                        }),
                        // ButtonPrimary(
                        //     title: "UPLOAD PODCAST",

                        //     onPressed: () {
                        //       controller.uploadAudio();
                        //     })
                      ],
                    )
                  : controller.recording.isTrue
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() {
                              return Text(
                                "${controller.min(controller.hours.value)} : ${controller.min(controller.minutes.value)} : ${controller.min(controller.seconds.value)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 32),
                              );
                            }),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: AudioWaveforms(
                                size: const Size(double.infinity, 100),
                                waveStyle: WaveStyle(
                                    showMiddleLine: true,
                                    middleLineThickness: 2,
                                    showDurationLabel: true,
                                    middleLineColor: text23,
                                    extendWaveform: true,
                                    durationStyle: TextStyle(color: text23),
                                    waveCap: StrokeCap.round),
                                recorderController:
                                    controller.recorderController,
                              ),
                            ),
                            80.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.mic_off_sharp,
                                  color: text23,
                                ),
                                10.widthBox,
                                "Stop live".text.color(text23).make()
                              ],
                            ).onInkTap(() {
                              controller.stopStreaming();
                            })
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 35,
                              width: Get.width / 1.8,
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  gradient: verticalGradient),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  "Go Live".text.size(14).color(text23).make(),
                                  8.widthBox,
                                  Image.asset("assets/icons/podcast2.png",
                                      width: 30, height: 80)
                                ],
                              ).onInkTap(() {
                                controller.startStreaming();
                              }),
                            ),
                            10.heightBox,
                            "Press Go Live to go live and start streaming"
                                .text
                                .color(text23)
                                .make()
                          ],
                        );
            }))
          ],
        ).w(double.infinity).h(double.infinity),
      )),
    );
  }
}
