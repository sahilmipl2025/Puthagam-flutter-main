import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:puthagam/podcaster/core/utils/app_utils.dart';
import 'package:puthagam/podcaster/core/widgets/build_loading.dart';
import 'package:puthagam/podcaster/data/datasources/local/app_database.dart';
import 'package:puthagam/podcaster/data/repository/podcaster_impl.dart';
import 'package:puthagam/podcaster/domain/entities/upcoming/upcoming_episodes_response/datum.dart'
    as upcoming;
import 'package:puthagam/podcaster/domain/params/podcast/get_podcast_params.dart';
import 'package:puthagam/podcaster/domain/repository/ipodcaster_repository.dart';
import 'package:puthagam/podcaster/domain/entities/episodes/get_episodes_response/datum.dart'
    as episode;
import 'package:puthagam/podcaster/domain/entities/podcasts/get_podcast_response/datum.dart'
    as podcast;

class PodcastsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final count = 0.obs;
  final IPodcasterRepository repository = PodcasterRepositoryImpl();
  final loading = false.obs;
  final allPodcasts = <podcast.Datum>[].obs;
  final upcomingPodcasts = <upcoming.Datum>[].obs;
  final allEpisodes = <episode.Datum>[].obs;
  final episodesLoading = false.obs;

  final upcomingLoading = false.obs;

  String selectedPodcast = "";
  String selectEpisode = "";
  late TabController tabController;
  final dateTimeFormat = DateFormat("dd MMM,hh:mm:ss a");
  final dateTimeFormatUI = DateFormat("dd MMM, hh:mm a");

  @override
  void onInit() {
    super.onInit();
    log("author id ${LocalStorages.readAuthorID()}");
    tabController = TabController(length: 2, vsync: this);
    getAllPodcasts();
    getAllUpcomingPodcast();
  }

  getAllPodcasts() async {
    try {
      loading.value = true;
      final params = GetPodcastParams(start: 0, length: 10);
      final response = await repository.getPodcasts(params);
      loading.value = false;
      if (response.data != null) {
        allPodcasts.value = response.data?.data ?? [];
      }
      log("message${response.data}");
    } catch (e) {
      log("e $e");
      loading.value = false;
    }
  }

  getAllUpcomingPodcast() async {
    try {
      upcomingLoading.value = true;
      final response = await repository.getUpcomingEpisodes();
      upcomingLoading.value = false;
      if (response.data != null) {
        upcomingPodcasts.value = response.data?.data ?? [];
      }
    } catch (e) {
      log("e $e");
      upcomingLoading.value = false;
    }
  }

  getAllEpisodes(String podcast) async {
    try {
      selectedPodcast = podcast;
      episodesLoading.value = true;
      final response = await repository.getEpisodeByPodcasts(podcast);
      episodesLoading.value = false;
      if (response.data != null) {
        allEpisodes.value = response.data?.data ?? [];
      }
    } catch (e) {
      log("e $e");
      episodesLoading.value = false;
    }
  }

  uploadAudio(String episode) async {
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

      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedMimeTypes: ['audio/*'],
      );
      final path = await FlutterDocumentPicker.openDocument(params: params);
      if (path != null) {
        buildDialogLoadingIndicator();
        File file = File(path);
        // var duration = await baseController!.audioPlayer.setUrl(file.path);
        // final minutes = (duration!.inSeconds / 60).roundToDouble();
        final response = await repository.uploadAudio(
            LocalStorages.readAuthorID(), selectedPodcast, episode, 0, file);
        Get.back();
        if (response.data != null) {
          showToastMessage(title: "Success", message: "Episode uploaded");
        }
      }
    } catch (err) {
      log("err $err");
      Get.back();
    }
  }

  String getDate(String date) {
    return dateTimeFormat.format(DateTime.tryParse(date)!);
  }

  String getUIDate(String date) {
    return dateTimeFormatUI.format(DateTime.tryParse(date)!);
  }

  bool showEpisodeRecordBtn(String startDate, String endDate) {
    bool showRecord = false;
    final currentDateTime = getCurrentDate();
    final startDatetime = dateTimeFormat.parse(getDate(startDate));
    final endDatetime = dateTimeFormat.parse(getDate(endDate));
    if (currentDateTime.isAfter(startDatetime) &&
        currentDateTime.isBefore(endDatetime)) {
      showRecord = true;
    }
    return showRecord;
  }

  DateTime getCurrentDate() =>
      dateTimeFormat.parse(dateTimeFormat.format(DateTime.now()));

  bool showEpisodeUploadBtn(String endDate) {
    bool showUpload = false;
    final currentDateTime = getCurrentDate();
    final endDatetime = dateTimeFormat.parse(getDate(endDate));
    if (currentDateTime.isAfter(endDatetime)) {
      showUpload = true;
    }
    return showUpload;
  }

  String _daysBetween(DateTime from, DateTime to) {
    final days = (to.difference(from).inDays);
    final hours = (to.difference(from).inHours);
    final minuts = (to.difference(from).inMinutes);
    final seconds = (to.difference(from).inSeconds);

    if (days > 0) {
      return "${days.round()} day${days > 0 ? "s" : ""} left";
    } else if (hours > 0) {
      return "${hours.round()} hour${hours > 0 ? "s" : ""} left";
    } else if (minuts > 0) {
      return "${minuts.round()} min${minuts > 0 ? "s" : ""} left";
    } else {
      return "${seconds.round()} sec${seconds > 0 ? "s" : ""} left";
    }
  }

  String findRemainingTime(
    String startDate,
  ) {
    final startDatetime = dateTimeFormat.parse(getDate(startDate));
    return _daysBetween(getCurrentDate(), startDatetime);
  }
}
