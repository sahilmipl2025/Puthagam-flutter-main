import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';
import 'package:webviewx/webviewx.dart';

class PodcastWebView extends StatefulWidget {
  const PodcastWebView(this.episode, {Key? key}) : super(key: key);
  final String episode;

  @override
  PodCastState createState() => PodCastState();
}

class PodCastState extends State<PodcastWebView> {
  late VideoPlayerController _controller;
  bool isInitialize = false;

  @override
  void initState() {
    super.initState();
    log("'http://65.1.69.207:8000/live/${widget.episode}.flv'");
    _controller = VideoPlayerController.network(
        'http://65.1.69.207:8000/live/${widget.episode}.flv')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          isInitialize = true;
          log("message");
          _controller.play();
        });
      });
  }

  @override
  void dispose() async {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          isInitialize
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
          WebViewX(
            initialContent:
                'https://admin.magic20.co.in/streamplayer/index.html?streamkey=${widget.episode}&bearer=${LocalStorage.token}',
            initialSourceType: SourceType.url,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.alwaysAllow,
            width: Get.width,
            height: Get.height,
            onWebResourceError: (err) {
              log("err $err");
            },
            userAgent:
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12",
            javascriptMode: JavascriptMode.unrestricted,
          ),
          const Icon(Icons.close).onInkTap(() {
            Get.back();
          }).positioned(right: 10, top: 10)
        ],
      ).safeArea(),
    );
  }
}
