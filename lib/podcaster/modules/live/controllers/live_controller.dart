import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_audio_streaming/flutter_audio_streaming.dart';
import 'package:get/get.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:puthagam/podcaster/core/widgets/build_loading.dart';
import 'package:puthagam/podcaster/data/datasources/local/app_database.dart';
import 'package:puthagam/podcaster/data/repository/podcaster_impl.dart';
import 'package:puthagam/podcaster/domain/params/podcast/go_live_podcast_params.dart';
import 'package:puthagam/podcaster/domain/params/podcast/podcast_status_params.dart';
import 'package:puthagam/podcaster/domain/repository/ipodcaster_repository.dart';
import 'package:puthagam/podcaster/modules/podcasts/controllers/podcasts_controller.dart';
import 'package:puthagam/utils/colors.dart';

import '../../../core/utils/app_utils.dart';

class LiveController extends GetxController with WidgetsBindingObserver {
  final count = 0.obs;

  //FlutterRtmpStreamer? streamer;
  final showPlayer = false.obs;
  final recording = false.obs;
  final audioPath = "".obs;
  late final RecorderController recorderController;
  final IPodcasterRepository repository = PodcasterRepositoryImpl();
  final PodcastsController mainController = Get.find();
  final params = PodcastStatusParams();
  late final GoLivePodcastParams args;
  StreamingController controller = StreamingController();

  bool get isStreaming => controller.value.isStreaming ?? false;
  Timer? _timer;
  final seconds = 0.obs;
  final minutes = 0.obs;
  final hours = 0.obs;

  String min(int _) {
    if (_ < 10) return "0$_";
    return _.toString();
  }

  @override
  void onInit() {
    super.onInit();
    KeepScreenOn.turnOn();
    recorderController = RecorderController();
    //  WidgetsBinding.instance.addObserver(this);
    initializeStreaming();
    log("author id ${LocalStorages.readAuthorID()}");
    getPodcastStatusParams();
  }

  checkMicrophonePermissionGranted() async {
    if (!(await Permission.microphone.request().isGranted)) {
      showToastMessage(
          title: "Permission required",
          message: "We need microphone permission to stream");
      return;
    }
  }

  void initializeStreaming() async {
    await checkMicrophonePermissionGranted();

    controller.addListener(() async {
      log("listen");
      if (controller.value.hasError) {
        showToastMessage(
            title: "Error",
            message: 'Streaming Error ${controller.value.errorDescription}');
        await stopStreaming();
      } else {
        try {
          if (controller.value.event == null) return;
          final Map<dynamic, dynamic> event =
              controller.value.event as Map<dynamic, dynamic>;

          final String eventType = event['eventType'] as String;

          switch (eventType) {
            case StreamingController.ERROR:
              break;
            case StreamingController.RTMP_STOPPED:
              break;
            case StreamingController.RTMP_RETRY:
              if (isStreaming) {
                await stopStreaming();
              }
              break;
          }
        } catch (e) {
          log('initialize: $e');
        }
      }
    });
    await controller.initialize();
    controller.prepare();
  }

  @override
  void dispose() async {
    log("ondespose");
    _timer?.cancel();
    _timer = null;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    if (isStreaming) stopStreaming();
    controller.dispose();
  }

  Future<bool> willPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Are you sure?',
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              'You want to exit live?',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: commonBlueColor,
                      borderRadius: const BorderRadius.all(Radius.circular(6))),
                  width: 60,
                  height: 35,
                  child: TextButton(
                    onPressed: () async {
                      Get.back();
                      if (isStreaming) {
                        await stopStreaming();
                      }
                      Get.back();
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  startStreaming() async {
    try {
      await checkMicrophonePermissionGranted();
      Get.dialog(buildLoadingIndicator(), barrierDismissible: false);
      log("params ${params.toJson()}");
      final response = await repository.goLive(params);
      Get.back();
      if (response.data != null) {
        final url = await checkAudioStreaming();
        if (url.isNotEmpty) {
          recording.value = true;
          await recorderController.record();
        }
      }
    } catch (err) {
      log("start streaming err $err");
      showToastMessage(title: "Error", message: err.toString());
      Get.back();
      stopStreaming();
    }
  }

  Future<String> checkAudioStreaming() async {
    if (!controller.value.isInitialized!) {
      showToastMessage(title: "Error", message: 'Something is wrong');
      return '';
    }
    if (isStreaming) {
      showToastMessage(
          title: "Error", message: 'Already streaming stop and start again.');
      return '';
    }
    // Open up a dialog for the url
    String url = "rtmp://65.1.69.207:1935/live/${args.episodeId}";
    await controller.start(url);
    hours.value = 0;
    minutes.value = 0;
    seconds.value = 0;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        seconds.value = seconds.value + 1;
        if (seconds > 59) {
          minutes.value += 1;
          seconds.value = 0;
          if (minutes > 59) {
            hours.value += 1;
            minutes.value = 0;
          }
        }
      },
    );
    return url;
  }

  getPodcastStatusParams() {
    args = Get.arguments;
    params.autorId = LocalStorages.readAuthorID();
    params.episodeId = args.episodeId;
    params.podcastId = args.podcastId;
  }

  stopStreaming() async {
    try {
      Get.dialog(buildLoadingIndicator(), barrierDismissible: false);
      await repository.exitLive(params);
      Get.back();
      await controller.stop();
      _timer?.cancel();
      _timer = null;
      recording.value = false;
      showPlayer.value = true;
      audioPath.value = await recorderController.stop() ?? "";
    } catch (err) {
      log("stop streaming err $err");
      Get.back();
    }
  }

  uploadAudio() async {
    try {
      final status = await Permission.manageExternalStorage.request();
      if (status.isPermanentlyDenied) {
        openAppSettings();
        return;
      }
      if (!(status.isGranted)) {
        showToastMessage(
            title: "Permission required",
            message: "We need storage permission to upload audio");
        return;
      }

      buildDialogLoadingIndicator();
      File file = File(audioPath.value);
      // var duration = await baseController!.audioPlayer.setUrl(audioPath.value);
      // final minutes = (duration!.inSeconds / 60).roundToDouble();
      final response = await repository.uploadAudio(
          LocalStorages.readAuthorID(),
          params.podcastId!,
          params.episodeId!,
          0,
          file);
      Get.back();
      if (response.data != null) {
        showToastMessage(title: "Success", message: "Episode uploaded");
      }
    } catch (err) {
      log("err $err");
      Get.back();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if ((state == AppLifecycleState.detached ||
            state == AppLifecycleState.paused) &&
        recorderController.isRecording) {
      stopStreaming();
    }
    log('dddddddddddd state = $state');
  }

  void increment() => count.value++;
}
