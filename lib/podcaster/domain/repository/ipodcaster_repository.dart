import 'dart:io';

import '../../core/utils/app_utils.dart';
import '../entities/base_response.dart';
import '../entities/episodes/get_episodes_response/get_episodes_response.dart';
import '../entities/podcasts/get_podcast_response/get_podcast_response.dart';
import '../entities/upcoming/upcoming_episodes_response/upcoming_episodes_response.dart';
import '../params/podcast/get_podcast_params.dart';
import '../params/podcast/podcast_status_params.dart';

abstract class IPodcasterRepository {
  Future<DataState<GetPodcastResponse>> getPodcasts(GetPodcastParams params);

  Future<DataState<GetEpisodesResponse>> getEpisodeByPodcasts(String podcastid);

  Future<DataState<BaseResponse>> goLive(
    PodcastStatusParams params,
  );

  Future<DataState<BaseResponse>> exitLive(
    PodcastStatusParams params,
  );

  Future<DataState<BaseResponse>> uploadAudio(String userId, String podcastId,
      String episodeId, double audioDuration, File? bookAudio);

  Future<DataState<UpcomingEpisodesResponse>> getUpcomingEpisodes();
}
