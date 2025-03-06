import 'dart:io';
import 'package:puthagam/podcaster/domain/entities/auth/login_response/login_response.dart';
import 'package:puthagam/podcaster/domain/entities/episodes/get_episodes_response/get_episodes_response.dart';
import 'package:puthagam/podcaster/domain/entities/upcoming/upcoming_episodes_response/upcoming_episodes_response.dart';
import 'package:puthagam/podcaster/domain/params/podcast/podcast_status_params.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/base_response.dart';
import '../../../domain/entities/podcasts/get_podcast_response/get_podcast_response.dart';
import '../../../domain/params/auth/login_params.dart';
import '../../../domain/params/podcast/get_podcast_params.dart';

part 'app_apis.g.dart';

@RestApi(baseUrl: serverBaseUrl)
abstract class AppApis {
  factory AppApis(Dio dio, {String baseUrl}) = _AppApis;

  @POST("Auth/Signin")
  Future<HttpResponse<LoginResponse>> login(@Body() LoginParams params);

  @POST("Podcast/{id}")
  Future<HttpResponse<GetPodcastResponse>> getPodcasts(
      @Body() GetPodcastParams params, @Path("id") String authorid);

  @GET("Podcast/{author}/{podcast}/Episodes")
  Future<HttpResponse<GetEpisodesResponse>> getPodcastEpisodes(
      @Path("author") String author, @Path("podcast") String podcast);

  @GET("Podcast/{author}/UpcomingPodcastEpisodes")
  Future<HttpResponse<UpcomingEpisodesResponse>> getUpcomingPodcastEpisodes(
    @Path("author") String author,
  );

  @POST("Podcast/GoLivePodcast")
  Future<HttpResponse<BaseResponse>> goLive(
    @Body() PodcastStatusParams params,
  );

  @POST("Podcast/EndLivePodcast")
  Future<HttpResponse<BaseResponse>> exitLive(
    @Body() PodcastStatusParams params,
  );

  @MultiPart()
  @POST(
      "/Podcast/{authorId}/{podcastId}/{episodeId}/{audioDuration}/UploadEpisodeAudio")
  Future<HttpResponse<BaseResponse>> uploadAudio(
      @Path('authorId') String authorId,
      @Path('podcastId') String podcastId,
      @Path('episodeId') String episodeId,
      @Path('audioDuration') double? audioDuration,
      @Part(name: 'bookAudio') File? bookAudio);
}
