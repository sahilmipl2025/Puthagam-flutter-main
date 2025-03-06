import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:puthagam/data/api/category_book/get_book_chapters_api.dart';
import 'package:puthagam/data/api/category_book/get_book_review_api.dart';
import 'package:puthagam/data/api/library/delete_queue_api.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/data/services/dynamic_link_service.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/model/book_detail/get_done_chapters_model.dart';
import 'package:puthagam/model/category_books/get_book_chapters_model.dart';
import 'package:puthagam/model/book_detail/get_book_detail_model.dart';
import 'package:puthagam/model/category_books/get_book_review_model.dart';
import 'package:puthagam/model/category_books/get_category_books_model.dart';
import 'package:puthagam/model/library/set_queue_model.dart';
import 'package:puthagam/model/podcast/get_podcast_explore_modal.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/api_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/screen/images.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/base_controller.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/utils/themes/global.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../../utils/local_storage/app_prefs.dart';

class BookDetailController extends GetxController {

  final BookDetailApiController con = Get.put(BookDetailApiController());


  dynamic argumentData = Get.arguments;
  RxBool playQueue = false.obs;
  Rx<GetBookDetailModel> bookDetail = GetBookDetailModel().obs;
  RxBool isDark = false.obs;

  RxBool savedLoading = false.obs;
  RxBool colorShow = false.obs;
  RxBool isLoading = false.obs;
  RxBool textIcon = false.obs;
  RxBool musicIcon = false.obs;
  RxBool isVisible = true.obs;
  RxBool showDialog = true.obs;

  RxList<Chapter> doneChapterList = <Chapter>[].obs;
  Rx<TextEditingController> controller = TextEditingController().obs;
  RxList<BookReview> reviewList = <BookReview>[].obs;
  RxBool showAllReview = false.obs;
  Rx<TextEditingController> reviewController = TextEditingController().obs;
  RxInt rating = 4.obs;
  RxInt currentIndex = 0.obs;
  RxString selectedCollection = "".obs;
  RxInt selectedIndex = 0.obs;
  RxBool chapterLoading = false.obs;

  RxBool reviewLoading = false.obs;
  RxBool isBookDetail = true.obs;
  RxBool nextPageStop = false.obs;
  RxInt page = 0.obs;
  RxString getreadAccess ="false".obs;
  RxString getpodcastacess ="false".obs;


  RxList<CategoryBooks> suggestionBook = <CategoryBooks>[].obs;
  RxList<ExplorePodcast> suggestionPodcasts = <ExplorePodcast>[].obs;

  /// Download

  Rx<GetSimpleBookDetailModel> simpleBookDetail =
      GetSimpleBookDetailModel().obs;

  /// Set Timing

  String hFormat(DateTime date) {
    if (DateTime.now().difference(date).inDays == 1) {
      return "yesterday";
    } else if (DateTime.now().difference(date).inDays > 364) {
      return DateFormat('dd-MM-yyyy').format(date);
    } else if (DateTime.now().difference(date).inDays > 1) {
      return DateFormat('dd-MM-yy').format(date);
    } else {
      return DateFormat('hh:mm a').format(date);
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      baseController!.audioPlayer.dispose();
    }
  }

  /// Share Book

  shareBook() async {
    var link = await createDynamicLink(
      bookId: bookDetail.value.id.toString(),
    );
    Share.share("What I just discovered - ${bookDetail.value.title}\n$link");
  }

  /// Chapters

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  RxDouble customFontSize = 14.0.obs;

  Rx<Duration> duration = Duration.zero.obs;
  Rx<Duration> position = Duration.zero.obs;

  RxBool isConnected = false.obs;
  RxString bookId = "".obs;

  callApis({
    bookID,
    bool fromContinues = false,
    List<String>? listenChapterId,
  }) async {
     print("Starting callApis with bookID: $bookID, fromContinues: $fromContinues");
   // bookDetail.value = GetBookDetailModel();
    //bookDetail.value = getBookDetailModelFromJson("");
    //simpleBookDetail.value = getSimpleBookDetailModelFromJson("");

    showDialog.value = true;
    reviewController.value.clear();
    bookId.value = bookID;
    currentIndex.value = 0;
    savedLoading.value = false;
      print("Initializing HomeController and fetching user collection list.");

    HomeController homeCon = Get.put(HomeController());
    homeCon.getUserCollectionList();
    await getBookDetailApi(bookId: bookID);
     print("Calling getBookDetailApi for bookID: $bookID");
      print("Book Detail: ${bookDetail.value}");
    if (bookDetail.value.isPodcast == true) {
          print("Fetching category podcasts for categoryId");

      con.getCategoryPodcastsApi(
          categoryId: bookDetail.value.categoryId.toString());
              print("Fetching category books for categoryId333333333333:");

    } else {
      con.getCategoryBooksApi(
          categoryId: bookDetail.value.categoryId.toString());
           print("Fetching category books for categoryId4444444444444444444:");
    }

    await getBookChaptersApi(bookId: bookID);
    getBookReviewApi(bookId: bookID, pagination: false);
    if (fromContinues == true) {
         print("Continuing from where user left off.");
      if (bookDetail.value.isPaid.toString() == "false" ||
          (bookDetail.value.isPaid.toString() == "true" &&
              baseController!.isSubscribed.value.toString() == "true")) {
        await con.getDoneChaptersApi(bookId: bookID);

        // if (LocalStorage.autoPlay == true) {
        baseController!.isTextVisible.value = false;
        baseController!.audioPlayer.pause();
        baseController!.isPause.value = true;
        baseController!.isPlaying.value = false;
        baseController!.audioPlayer.dispose();
        baseController!.currentPlayingIndex.value = 999;

        if (bookChapterList.length != listenChapterId!.length) {
          for (int i = 0; i < bookChapterList.length; i++) {
            if (!listenChapterId.contains(bookChapterList[i].id.toString())) {
              if (i != 0) {
                baseController!.currentPlayingIndex.value = i - 1;
              } else {
                baseController!.currentPlayingIndex.value = i;
              }

              break;
            }
          }
        } else {
          baseController!.currentPlayingIndex.value = 0;
        }

        if (baseController!.currentPlayingIndex.value == 999) {
          baseController!.currentPlayingIndex.value = 0;
        }

        baseController!.runningBookId.value = bookDetail.value.id ?? "";

        baseController?.booksQueueList.clear();

        baseController?.currentPlayingBookIndex.value = 0;

        baseController?.booksQueueList.add(
          QueueList(
            bookId: bookDetail.value.id.toString(),
            bookTitle: bookDetail.value.title.toString(),
            bookImage: bookDetail.value.image.toString(),
            bookChapter: bookChapterList.toList(),
            isPodcast: bookDetail.value.isPodcast ?? false,
            categoryId: bookDetail.value.categoryId.toString(),
          ),
        );
        print("bookidfortexting only check purpose${bookId}");

        baseController!.musicSuggestionBook = suggestionBook;

        Future.delayed(const Duration(seconds: 2), () async {
          await setAudio(index: baseController!.currentPlayingIndex.value);

          Future.delayed(const Duration(microseconds: 100), () {
            myQueue(
              context: Get.context!,
              index: baseController!.currentPlayingIndex.value,
            );
          });
        });
      }
    } else {
      con.getDoneChaptersApi(bookId: bookID);
         print("bookid  value${bookId}");
    }

    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    getUserProfileApi();
     print("Initializing controller...");

    // getBookDetailApi(bookId:bookId);
    // print("boookdetails${getBookDetailApi(bookId:bookId)}");
    //gettokenapi();
    manageScrollController();
  }

  ScrollController newScrollController = ScrollController();

  void manageScrollController() async {
    newScrollController.addListener(
      () {
        if (newScrollController.position.maxScrollExtent ==
            newScrollController.position.pixels) {
          if (nextPageStop.isFalse) {
            getBookReviewApi(bookId: bookId.value, pagination: true);
          }
        }
      },
    );
  }

  RxList<BookChapter> bookChapterList = <BookChapter>[].obs;

  @override
  void dispose() {
    bookDetail.close();
    super.dispose();
  }

  List<AudioSource> songList = [];

  RxString currentSpeed = "1.0x".obs;

  /// Set Audio

  RxBool loading = false.obs;

  Future setAudio({index, bool fromQueue = false}) async {
    try {
      savedLoading.value = true;
      baseController!.isPlaying.value = false;

      baseController!.runningBookImage.value = baseController
              ?.booksQueueList[fromQueue == true
                  ? (baseController!.currentPlayingBookIndex.value)
                  : baseController!.currentPlayingBookIndex.value]
              .bookImage ??
          "";

      baseController!.audioPlayer.pause();

      await baseController!.audioPlayer.dispose();

      baseController!.audioPlayer = AudioPlayer();

      baseController!.currentPlayingIsBook.value = baseController
              ?.booksQueueList[fromQueue == true
                  ? (baseController!.currentPlayingBookIndex.value)
                  : baseController!.currentPlayingBookIndex.value]
              .isPodcast ??
          false;

      songList.clear();
      baseController!.isCompleted.value = false;

      baseController!.currentBookDoneChapter.clear();
      baseController!.currentBookDoneChapter.value += doneChapterList;

      baseController!.runningBookId.value = baseController
              ?.booksQueueList[fromQueue == true
                  ? (baseController!.currentPlayingBookIndex.value)
                  : baseController!.currentPlayingBookIndex.value]
              .bookId ??
          "";

      for (var element in baseController!
          .booksQueueList[fromQueue == true
              ? (baseController!.currentPlayingBookIndex.value)
              : baseController!.currentPlayingBookIndex.value]
          .bookChapter) {
        songList.add(AudioSource.uri(
          Uri.parse(element.audioUrl.toString()),
          tag: MediaItem(
            playable: true,
            id: '${element.id}',
            album: baseController
                ?.booksQueueList[fromQueue == true
                    ? (baseController!.currentPlayingBookIndex.value)
                    : baseController!.currentPlayingBookIndex.value]
                .bookTitle,
            title: element.name ?? "",
            artUri: Uri.parse(baseController
                    ?.booksQueueList[fromQueue == true
                        ? (baseController!.currentPlayingBookIndex.value)
                        : baseController!.currentPlayingBookIndex.value]
                    .bookImage ??
                ""),
          ),
        ));
      }

      baseController?.audioPlayer
          .setAudioSource(ConcatenatingAudioSource(children: songList))
          .then((value) async {
        if (baseController!.isTextVisible.isFalse) {
          baseController?.audioPlayer.play();
          baseController?.isPlaying.value = true;
        }

        if (index != null) {
          await baseController?.audioPlayer.seek(Duration.zero, index: index);
        } else {
          await baseController!.audioPlayer.seek(Duration.zero,
              index: fromQueue == true
                  ? (baseController!.currentPlayingBookIndex.value)
                  : baseController?.currentPlayingBookIndex.value);
        }
        if (fromQueue == true) {
          // baseController!.currentPlayingBookIndex.value++;
          if (baseController!
                  .booksQueueList[baseController!.currentPlayingBookIndex.value]
                  .isPodcast ==
              true) {
            con.getMusicPlayerPodcastsSuggestionApi(
                categoryId: baseController!
                    .booksQueueList[
                        baseController!.currentPlayingBookIndex.value]
                    .categoryId);
          } else {
            con.getMusicPlayerSuggestionApi(
                categoryId: baseController!
                    .booksQueueList[
                        baseController!.currentPlayingBookIndex.value]
                    .categoryId);
          }
        }
      });

      baseController!.audioPlayer.playerStateStream.listen((PlayerState s) {
        baseController!.isPlaying.value = s.playing;
      });

      await baseController!.audioPlayer.playerStateStream
          .listen((playerState) async {
        if (playerState.processingState == ProcessingState.idle) {
          savedLoading.value = true;
        }
        if (playerState.processingState == ProcessingState.loading) {
          savedLoading.value = true;
        }
        if (playerState.processingState == ProcessingState.ready) {
          savedLoading.value = false;
          baseController!.isCompleted.value = false;
        }

        if (playerState.processingState == ProcessingState.completed) {
          await baseController!.audioPlayer.pause();
          await baseController!.audioPlayer.dispose();

          if (baseController!.booksQueueList.length - 1 ==
              baseController!.currentPlayingBookIndex.value) {
            baseController!.musicSuggestionBook.removeWhere(
                (element) => element.id == baseController!.runningBookId.value);
            baseController!.audioPlayer.pause();
            baseController!.isPause.value = true;
            baseController!.isPlaying.value = false;
            baseController!.isCompleted.value = true;
            baseController!.audioPlayer.dispose();
            if (baseController!.continueQueue.value) {
              baseController!.removeInLocalStorage(
                  bookId: baseController!
                      .booksQueueList[
                          baseController!.currentPlayingBookIndex.value]
                      .bookId);
              await deleteQueueApi(
                  bookId: baseController!
                      .booksQueueList[
                          baseController!.currentPlayingBookIndex.value]
                      .bookId);
              if (baseController!.queueChapterList.isNotEmpty) {
                baseController!.currentPlayingIndex.value = baseController!
                        .queueChapterList
                        .firstWhere((element) =>
                            element.bookId ==
                            baseController?.booksQueueList.first.bookId)
                        .chapter ??
                    0;
              }
            }
            baseController!.currentPlayingIndex.value = 999;
            baseController!.booksQueueList.clear();
            baseController!.continueQueue.value = false;
          } else {
            if (baseController!.continueQueue.value) {
              baseController!.removeInLocalStorage(
                  bookId: baseController!
                      .booksQueueList[
                          baseController!.currentPlayingBookIndex.value]
                      .bookId);
              await deleteQueueApi(
                  bookId: baseController!
                      .booksQueueList[
                          baseController!.currentPlayingBookIndex.value]
                      .bookId);
              baseController!.currentPlayingIndex.value = baseController!
                      .queueChapterList
                      .firstWhere((element) =>
                          element.bookId ==
                          baseController?.booksQueueList.first.bookId)
                      .chapter ??
                  0;
            }

            await baseController!.audioPlayer.pause();
            await baseController!.audioPlayer.dispose();

            baseController!.currentPlayingBookIndex.value = 0;

            Future.delayed(const Duration(seconds: 2), () async {
              await setAudio(index: 0, fromQueue: true).then((value) async {
                await durationFind();
              });
            });
          }
        }
      });

      if (fromQueue == false) {
        await durationFind();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      savedLoading.value = false;
    }
  }

  durationFind() {
    baseController!.audioPlayer.currentIndexStream.listen((event) async {
      if (baseController!.currentPlayingIndex.value != 999) {
        if (event ==
            (baseController!
                    .booksQueueList[
                        baseController!.currentPlayingBookIndex.value]
                    .bookChapter
                    .length) -
                1) {
          /// Last to second index

          if (baseController!.currentBookDoneChapter
              .where((p0) =>
                  p0.chapterId ==
                  baseController
                      ?.booksQueueList[
                          baseController!.currentPlayingBookIndex.value]
                      .bookChapter[baseController!.currentPlayingIndex.value]
                      .id)
              .isEmpty) {
            await con.doneChaptersApi(
              bookId: baseController!.runningBookId.value,
              chapterId: baseController
                  ?.booksQueueList[
                      baseController!.currentPlayingBookIndex.value]
                  .bookChapter[baseController!.currentPlayingIndex.value]
                  .id,
            );
          }

          if (baseController!.continueQueue.value) {
            await baseController!.removeInLocalStorage(
              bookId: baseController!
                  .booksQueueList[baseController!.currentPlayingBookIndex.value]
                  .bookId,
            );

            await baseController!.storeInLocalStorage(
              data: QueueChapterModel(
                bookId: baseController!
                    .booksQueueList[
                        baseController!.currentPlayingBookIndex.value]
                    .bookId,
                chapter: baseController!
                    .booksQueueList[
                        baseController!.currentPlayingBookIndex.value]
                    .bookChapter
                    .length,
              ),
            );
          }

          /// Last Index
          if (baseController!.currentBookDoneChapter
              .where((p0) =>
                  p0.chapterId ==
                  baseController
                      ?.booksQueueList[
                          baseController!.currentPlayingBookIndex.value]
                      .bookChapter[
                          baseController!.currentPlayingIndex.value + 1]
                      .id)
              .isEmpty) {
            await con.doneChaptersApi(
              bookId: baseController!.runningBookId.value,
              chapterId: baseController
                  ?.booksQueueList[
                      baseController!.currentPlayingBookIndex.value]
                  .bookChapter[baseController!.currentPlayingIndex.value + 1]
                  .id,
            );
          }
        } else {
          if (baseController!.currentBookDoneChapter
              .where((p0) =>
                  p0.chapterId ==
                  baseController
                      ?.booksQueueList[
                          baseController!.currentPlayingBookIndex.value]
                      .bookChapter[baseController!.currentPlayingIndex.value]
                      .id)
              .isEmpty) {
            await con.doneChaptersApi(
              bookId: baseController!.runningBookId.value,
              chapterId: baseController
                  ?.booksQueueList[
                      baseController!.currentPlayingBookIndex.value]
                  .bookChapter[baseController!.currentPlayingIndex.value]
                  .id,
            );
          }
        }

        if (event != 0 && baseController!.isPlaying.value) {
          if (event != null) {
            if (baseController!.currentPlayingIndex.value !=
                (baseController!
                        .booksQueueList[
                            baseController!.currentPlayingBookIndex.value]
                        .bookChapter
                        .length) -
                    1) {
              baseController!.currentPlayingIndex.value = event;

              if (baseController!.continueQueue.value) {
                await baseController!.removeInLocalStorage(
                  bookId: baseController!
                      .booksQueueList[
                          baseController!.currentPlayingBookIndex.value]
                      .bookId,
                );

                await baseController!.storeInLocalStorage(
                  data: QueueChapterModel(
                    bookId: baseController!
                        .booksQueueList[
                            baseController!.currentPlayingBookIndex.value]
                        .bookId,
                    chapter: event,
                  ),
                );
              }

              if (baseController!.currentBookDoneChapter.length ==
                  baseController
                      ?.booksQueueList[
                          baseController!.currentPlayingBookIndex.value]
                      .bookChapter
                      .length) {
                // con.listenCount();
                // con.completeBookApi();
              }
            }
          }
        } else {
          baseController!.currentPlayingIndex.value = 0;
        }
      }
    });

    baseController!.audioPlayer.positionStream.listen((p) {
      position.value = p;
    });

    baseController!.audioPlayer.durationStream.listen((totalDuration) {
      duration.value = totalDuration ?? const Duration(seconds: 0);
    });
  }

  String? time(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }

  /// Get Book Detail

  getBookDetailApi({bookId}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();

      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          isConnected.value = true;
          isLoading.value = true;

          http.Response response = await ApiHandler.get(
            url: "${ApiUrls.baseUrl}Book/${LocalStorage.userId}/$bookId",
          );

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            bookDetail.value = getBookDetailModelFromJson(response.body);

            print("useriidddd${bookDetail.value.authorName}");
                print("book details id${bookDetail.value.id}");
            simpleBookDetail.value =
                getSimpleBookDetailModelFromJson(response.body);
            isBookDetail.value = simpleBookDetail.value.isPodcast!;
            print("simpleBookDetail.value.isPodcast!${simpleBookDetail.value.isPodcast!}");

            update();
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();

            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            toast(decoded['message'], false);
          }
        } else {
          bookDetail.value.id = "null";
          simpleBookDetail.value.id = "null";
          bookDetail.value = getBookDetailModelFromJson("");
          simpleBookDetail.value = getSimpleBookDetailModelFromJson("");
          isConnected.value = false;

          // toast("No Internet Connection!", false);
        }
      }
    } catch (e) {
      print("getbook details apis issue${e}");
      // toast(e.toString(), false);
    }
  }


getUserProfileApi({bool? forBeta = false}) async {
  try {
   // log("get user profile");
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      final InAppPurchase _inAppPurchase = InAppPurchase.instance;
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        http.Response response = await ApiHandler.get(
          url: ApiUrls.baseUrl + ApiUrls.editProfile + LocalStorage.userId,
        );
        print("get user profile ${ApiUrls.baseUrl + ApiUrls.editProfile + LocalStorage.userId}");
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          LocalStorage.storedToken(decoded, false);
          var box = GetStorage();

          baseController!.isBetaVersion.value =
              decoded['isBetaVersion'] ?? false;

          if (decoded['subscriptionPlan'].toString() != "null" &&
              decoded['subscriptionPlan'].toString() != "{}" &&
              decoded['subscriptionPlan'].toString() != "") {
            await box.write(Prefs.isPremium, true);
            LocalStorage.isPremium = true;
            baseController!.isSubscribed.value = true;

            if (decoded['subscriptionPlan'] != null) {
              baseController!.premiumId.value =
                  decoded['subscriptionPlan']['id'] ?? "";
          print("home screen${decoded['subscriptionPlan']['readAccess'].toString()}");
      
          // baseController!.getpodcastAccess.value = decoded['subscriptionPlan']['podcastAccess'] ?? "";
              getreadAccess.value = decoded['subscriptionPlan']['readAccess'].toString() ?? "";
                
                print("afterprintvalue${getreadAccess.value.toString()}");
                   print("readacess${decoded['subscriptionPlan']['readAccess']}");
                  //  

               // print("getreadAccess${baseController!.getpodcastAccess.value}");
                 //  print("getpodcast${baseController!.getreadAccess.value}");
                getpodcastacess.value = decoded['subscriptionPlan']['podcastAccess'].toString() ?? "";
              if (decoded['subscriptionPlan']['plan_id'] == "BETA" &&
                  decoded['isBetaVersion'] == true) {
                baseController!.betaVersion.value = true;
              } else {
                baseController!.betaVersion.value = false;
              }
              baseController!.trialRunning.value =
                  jsonDecode(response.body)['subscriptionPlan']['isTrial'];
            } else {
              baseController!.premiumId.value =
                  decoded['subscriptionPlan']['id'] ?? "";
              baseController!.trialRunning.value = false;
              baseController!.betaVersion.value = false;
            }

            baseController!.planStartDate.value =
                jsonDecode(response.body)['subscriptionPlan']['current_start'];
            baseController!.planEndDate.value =
                jsonDecode(response.body)['subscriptionPlan']['current_end'];

            baseController!.isTried.value = decoded['isTrial'];
            baseController!.lastPlanId.value = decoded['planId'];
          } else {
            if (Platform.isIOS) {
              if (forBeta == true) {
                await box.write(Prefs.isPremium, false);
                LocalStorage.isPremium = false;
                baseController!.trialRunning.value = false;
                baseController!.isTried.value = decoded['isTrial'];
                baseController!.lastPlanId.value = decoded['planId'];
                baseController!.isSubscribed.value = false;
              } else {
                await _inAppPurchase.restorePurchases();
                final bool isAvailable = await _inAppPurchase.isAvailable();
                // if (isAvailable == true) {
                //   baseController!.isSubscribed.value = true;
                //   await box.write(Prefs.isPremium, true);
                //   LocalStorage.isPremium = true;
                // } else {
                await box.write(Prefs.isPremium, false);
                LocalStorage.isPremium = false;
                baseController!.trialRunning.value = false;
                baseController!.isTried.value = decoded['isTrial'];
                baseController!.lastPlanId.value = decoded['planId'];
                baseController!.isSubscribed.value = false;
                // }
              }
            } else {
              await box.write(Prefs.isPremium, false);
              LocalStorage.isPremium = false;
              baseController!.betaVersion.value = false;
              baseController!.trialRunning.value = false;
              baseController!.isTried.value = decoded['isTrial'];
              baseController!.lastPlanId.value = decoded['planId'];
              baseController!.isSubscribed.value = false;
            }
          }
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    // toast(e.toString(), false);
  }
}


  getBookDetailApilistencount({bookId}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();

      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          isConnected.value = true;
          isLoading.value = true;

          http.Response response = await ApiHandler.get(
            url: "${ApiUrls.baseUrl}Book/${LocalStorage.userId}/$bookId",
          );

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            bookDetail.value = getBookDetailModelFromJson(response.body);
            simpleBookDetail.value =
                getSimpleBookDetailModelFromJson(response.body);
            isBookDetail.value = simpleBookDetail.value.isPodcast!;
            isLoading.value = false;

            update();
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();

            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            toast(decoded['message'], false);
          }
        } else {
          bookDetail.value.id = "null";
          simpleBookDetail.value.id = "null";
          bookDetail.value = getBookDetailModelFromJson("");
          simpleBookDetail.value = getSimpleBookDetailModelFromJson("");
          isConnected.value = false;

          // toast("No Internet Connection!", false);
        }
      }
    } catch (e) {
      // toast(e.toString(), false);
    }
  }

  void addMusic({BuildContext? context, index}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context!,
        barrierColor: const Color.fromARGB(255, 167, 219, 244).withOpacity(.2),
        backgroundColor: GlobalService.to.isDarkModel == true
            ? Colors.grey.withOpacity(.3)
            : buttonColor,
        constraints: const BoxConstraints(maxWidth: 800),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
                child: InkWell(
              onTap: () {
                //   callApis(bookID: bookId);
                if (baseController!.currentPlayingIndex.value == index) {
                  myQueue(context: context, index: index);
                }
              },
              child: SizedBox(
                  // height: 120,
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      left: isTablet ? 14 : 10,
                      right: isTablet ? 14 : 10,
                      top: isTablet ? 24 : 20,
                      bottom: isTablet ? 19 : 15,
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: FadeInImage.assetNetwork(
                            fit: BoxFit.fill,
                            // placeholder: 'assets/images/fade.png',
                            placeholder: '',
                            image: bookDetail.value.image ?? "",
                            width: isTablet ? 75 : 65,
                            height: isTablet ? 75 : 65,
                          ),
                        ),
                        SizedBox(width: isTablet ? 20 : 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style:
                                      TextStyle(fontSize: isTablet ? 40 : 36),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Ch ${index + 1}: ',
                                        style: TextStyle(
                                            fontSize: isTablet ? 20 : 17,
                                            color: headingColor)),
                                    TextSpan(
                                        text: bookChapterList[index].name ?? "",
                                        style: TextStyle(
                                            fontSize: isTablet ? 20 : 17,
                                            color: headingColor)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => CircleAvatar(
                            backgroundColor: buttonColor,
                            radius: isTablet ? 29 : 25,
                            child: IconButton(
                              onPressed: () async {
                                if (baseController!.isCompleted.isFalse) {
                                  if (baseController!
                                          .currentPlayingIndex.value !=
                                      index) {
                                    baseController!.audioPlayer.pause();
                                    baseController!.isPause.value = true;
                                    baseController!.isPlaying.value = false;
                                    baseController!.audioPlayer.dispose();
                                    baseController!.currentPlayingIndex.value =
                                        999;
                                    setState(() {});
                                    baseController!.currentPlayingIndex.value =
                                        index;
                                    baseController!.runningBookId.value =
                                        bookDetail.value.id ?? "";

                                    Future.delayed(const Duration(seconds: 1),
                                        () async {
                                      await setAudio();
                                      Get.back();
                                    });
                                  } else {
                                    if (baseController!.isPlaying.value) {
                                      baseController!.audioPlayer.pause();
                                      baseController!.isPause.value = true;
                                      baseController!.isPlaying.value = false;
                                      setState(() {});
                                    } else {
                                      if (baseController!.isPause.value ==
                                          true) {
                                        setState(() {
                                          baseController!.audioPlayer.play();
                                        });
                                        baseController!.isPlaying.value = true;
                                        baseController!.isPause.value = false;
                                      } else {
                                        baseController!.audioPlayer =
                                            AudioPlayer();

                                        baseController!.audioPlayer.pause();

                                        setAudio().then((value) {
                                          baseController!.isPlaying.value =
                                              true;
                                          setState(() {});
                                        });
                                        Get.back();
                                      }
                                    }
                                  }
                                }
                              },
                              icon: Icon(
                                baseController!.currentPlayingIndex.value !=
                                        index
                                    ? Icons.play_arrow
                                    : baseController!.isPlaying.value
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                color: Colors.white,
                                size: isTablet ? 29 : 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ));
          });
        });
  }

  PageController pageCon = PageController();

  void myQueue({required BuildContext context, index}) {
    if (baseController!.isBookIdChanged.value) {
      currentSpeed.value = "1.0x";
      baseController!.audioPlayer.setSpeed(1.0);
      baseController!.isBookIdChanged.value = false;
    } else {
      if (currentSpeed.value == "1.0x") {
        currentSpeed.value = "1.0x";
        baseController!.audioPlayer.setSpeed(1.0);
      } else if (currentSpeed.value == "s") {
        currentSpeed.value = "1.25x";
        baseController!.audioPlayer.setSpeed(1.25);
      } else if (currentSpeed.value == "1.5x") {
        currentSpeed.value = "1.5x";
        baseController!.audioPlayer.setSpeed(1.5);
      } else if (currentSpeed.value == "0.75x") {
        currentSpeed.value = "0.75x";
        baseController!.audioPlayer.setSpeed(0.75);
      } else {
        currentSpeed.value = "1.0x";
        baseController!.audioPlayer.setSpeed(1.0);
      }
    }

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        constraints: const BoxConstraints(maxWidth: 800),
        builder: (context) {
          Future.delayed(Duration.zero, () {
              callApis(bookID: bookId.value).toString();
          });
       //   print("showmodal111${callApis(bookID: bookId)}");
          print('showmoda2222222${bookId}');

          if (bookDetail.value.isFinished == false) {
            print("showmoda2222222${bookDetail.value.isFinished}");
            con.listenCount();

            print('showmodbookdetailcount${bookDetail.value.listenCount}');
            Future.delayed(Duration(seconds: 2), () {
              getBookDetailApilistencount(bookId: bookId);
              // print("listenCountincreasebook${getBookDetailApi(bookId: bookId)}");
              // print('secondbookdetailcount${bookDetail.value.listenCount}');
              // code to be executed after 2 seconds
            });
            Future.delayed(Duration(seconds: 5), () {
              // getBookDetailApi(bookId: bookId);
              // print("listenCountincreasebook${getBookDetailApi(bookId: bookId)}");
              print('secondbookdetailcount${bookDetail.value.listenCount}');
              // code to be executed after 2 seconds
            });
            // getBookDetailApi(bookId: bookId);
          }
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Obx(() => baseController!.isTextVisible.value
                ? Container(
                    decoration: BoxDecoration(
                      color: isDark.value ? null : const Color(0xFFE2F5FF),
                      gradient: isDark.value ? verticalGradient : null,
                    ),
                    height: Get.height * 0.94,
                    width: Get.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 24 : 20,
                              horizontal: isTablet ? 20 : 16),
                          decoration:
                              BoxDecoration(gradient: horizontalGradient),
                          width: Get.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: isTablet ? 90 : 75,
                                width: isTablet ? 60 : 50,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        baseController!.runningBookImage.value),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(width: isTablet ? 20 : 16),
                              Expanded(
                                  child: Obx(
                                () => baseController!
                                            .currentPlayingIndex.value !=
                                        999
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Obx(
                                            () => InkWell(
                                              onTap: () => Get.back(),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 1.0),
                                                      child: SizedBox(
                                                        width: Get.width,
                                                        child: Text(
                                                          "Ch ${baseController!.currentPlayingIndex.value + 1} :${baseController?.booksQueueList[baseController!.currentPlayingBookIndex.value].bookChapter[baseController!.currentPlayingIndex.value].name ?? ""}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: isTablet
                                                                ? 16
                                                                : 14,
                                                            color:
                                                                commonBlueColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Icon(
                                                      Icons
                                                          .keyboard_arrow_down_outlined,
                                                      size: isTablet ? 34 : 30,
                                                      color: commonBlueColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  if (baseController!
                                                      .isPlaying.value) {
                                                    baseController!.audioPlayer
                                                        .pause();
                                                    baseController!
                                                        .isPause.value = true;
                                                    baseController!.isPlaying
                                                        .value = false;
                                                    setState(() {});
                                                  } else {
                                                    if (baseController!
                                                            .isPause.value ==
                                                        true) {
                                                      baseController!
                                                          .audioPlayer
                                                          .play();

                                                      baseController!.isPlaying
                                                          .value = true;
                                                      baseController!.isPause
                                                          .value = false;
                                                      setState(() {});
                                                    } else {
                                                      baseController!
                                                          .audioPlayer
                                                          .dispose();
                                                      baseController!
                                                              .audioPlayer =
                                                          AudioPlayer();
                                                      baseController!.isPlaying
                                                          .value = false;
                                                      setAudio().then((value) {
                                                        baseController!
                                                            .isPlaying
                                                            .value = true;
                                                        setState(() {});
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Icon(
                                                  baseController!
                                                          .isPlaying.value
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                  color: Colors.grey,
                                                  size: isTablet ? 28 : 24,
                                                ),
                                              ),
                                              SizedBox(
                                                  width: isTablet ? 20 : 16),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    baseController!
                                                        .isTextVisible
                                                        .value = false;
                                                    isVisible.value = true;
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.headphones,
                                                  color: Colors.grey,
                                                  size: isTablet ? 28 : 24,
                                                ),
                                              ),
                                              SizedBox(
                                                  width: isTablet ? 20 : 16),
                                              baseController!
                                                      .currentPlayingIsBook
                                                      .value
                                                  ? const SizedBox()
                                                  : InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          if (isDark.value ==
                                                              true) {
                                                            isDark.value =
                                                                false;
                                                          } else {
                                                            isDark.value = true;
                                                          }
                                                        });
                                                      },
                                                      child: Image.asset(
                                                        'assets/images/dark-light.png',
                                                        color: Colors.grey,
                                                        height:
                                                            isTablet ? 28 : 24,
                                                        width:
                                                            isTablet ? 28 : 24,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : SizedBox(
                                        height: Get.height * 0.1,
                                        child: Obx(() => Center(
                                                child: Text(
                                              isBookDetail.isFalse
                                                  ? "No more chapters found"
                                                  : "No more episodes found",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: isTablet ? 22 : 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ))),
                                      ),
                              )),
                            ],
                          ),
                        ),
                        isDark.value
                            ? const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                  height: 1.5,
                                  color: Colors.white,
                                  thickness: 1,
                                ),
                              )
                            : const SizedBox(),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              width: Get.width,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          20.widthBox,
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (customFontSize.value !=
                                                    10) {
                                                  customFontSize.value =
                                                      customFontSize.value - 2;
                                                  setState(() {});
                                                }
                                              });
                                            },
                                            child: Text(
                                              'A',
                                              style: TextStyle(
                                                fontSize: isTablet ? 14 : 12,
                                                color: isDark.value
                                                    ? commonBlueColor
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Obx(() => Slider(
                                                  value: customFontSize.value,
                                                  max: 30,
                                                  divisions: 10,
                                                  activeColor: isDark.value
                                                      ? commonBlueColor
                                                      : Colors.black,
                                                  inactiveColor: Colors.grey,
                                                  min: 10,
                                                  onChanged: (double value) {
                                                    customFontSize.value =
                                                        value;
                                                  },
                                                )),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (customFontSize.value != 24) {
                                                customFontSize.value =
                                                    customFontSize.value + 2;
                                                setState(() {});
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 30),
                                              child: Text(
                                                'A',
                                                style: TextStyle(
                                                  fontSize: isTablet ? 23 : 20,
                                                  color: isDark.value
                                                      ? commonBlueColor
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: isTablet ? 16 : 12),
                                  SwipeTo(
                                    onRightSwipe: () async {
                                      if (baseController!
                                          .audioPlayer.hasPrevious) {
                                        await baseController!.audioPlayer
                                            .seekToPrevious();
                                        baseController!.audioPlayer.play();

                                        baseController!.isPlaying.value = true;

                                        setState(() {});
                                      }
                                    },
                                    animationDuration:
                                        const Duration(milliseconds: 200),
                                    onLeftSwipe: () {
                                      if (baseController!.audioPlayer.hasNext) {
                                        baseController!.isPlaying.value = false;
                                        baseController!.audioPlayer
                                            .seekToNext();

                                        baseController!.isPlaying.value = true;
                                        baseController!.audioPlayer.play();
                                        setState(() {});
                                      }
                                    },
                                    child: Obx(
                                      () => baseController!
                                                  .currentPlayingIndex.value !=
                                              999
                                          ? Html(
                                              data: baseController
                                                      ?.booksQueueList[
                                                          baseController!
                                                              .currentPlayingBookIndex
                                                              .value]
                                                      .bookChapter[baseController!
                                                          .currentPlayingIndex
                                                          .value]
                                                      .content!
                                                      .replaceAll(
                                                          'font-feature-settings: normal;',
                                                          '') ??
                                                  "",
                                              style: {
                                                "body": Style(
                                                  color: isDark.value
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: FontSize(
                                                      customFontSize.value),
                                                ),
                                                "span": Style(
                                                  color: isDark.value
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: FontSize(
                                                      customFontSize.value),
                                                ),
                                                "div": Style(
                                                  color: isDark.value
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: FontSize(
                                                      customFontSize.value),
                                                ),
                                                "li": Style(
                                                  color: isDark.value
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: FontSize(
                                                      customFontSize.value),
                                                ),
                                                "font": Style(
                                                  color: isDark.value
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: FontSize(
                                                      customFontSize.value),
                                                ),
                                              },
                                            )
                                          : const SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: Get.width,
                          padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 20 : 16),
                          decoration: const BoxDecoration(
                            color: Color(0xFF00142D),
                          ),
                          child: IntrinsicHeight(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 28 : 24),
                              padding: EdgeInsets.symmetric(
                                  vertical: isTablet ? 16 : 12),
                              decoration: BoxDecoration(
                                gradient: horizontalGradient,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        if (baseController!
                                            .audioPlayer.hasPrevious) {
                                          await baseController!.audioPlayer
                                              .seekToPrevious();
                                          baseController!.audioPlayer.play();

                                          baseController!.isPlaying.value =
                                              true;

                                          setState(() {});
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          "Previous",
                                          style: TextStyle(
                                            fontSize: isTablet ? 16 : 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    width: isTablet ? 3 : 2,
                                    color: Colors.white,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (baseController!
                                            .audioPlayer.hasNext) {
                                          baseController!.isPlaying.value =
                                              false;
                                          baseController!.audioPlayer
                                              .seekToNext();

                                          baseController!.isPlaying.value =
                                              true;
                                          baseController!.audioPlayer.play();
                                          setState(() {});
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          "Next",
                                          style: TextStyle(
                                            fontSize: isTablet ? 16 : 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    height: Get.height * 0.94,
                    decoration: BoxDecoration(gradient: verticalGradient),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: isTablet ? 16 : 12),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: isTablet ? 16 : 12),
                            child: InkWell(
                              onTap: () => Get.back(),
                              child: Container(
                                height: isTablet ? 6 : 4,
                                width: Get.width * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.4),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(isTablet ? 12 : 8)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.all(isTablet ? 20 : 16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: Get.width,
                                          child: Row(
                                            children: [
                                              baseController!
                                                      .currentPlayingIsBook
                                                      .value
                                                  ? const SizedBox()
                                                  : InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          baseController!
                                                              .isTextVisible
                                                              .value = true;
                                                          isVisible.value =
                                                              false;
                                                        });
                                                      },
                                                      child: Image.asset(
                                                        'assets/icons/aaa.png',
                                                        width:
                                                            isTablet ? 28 : 24,
                                                        height:
                                                            isTablet ? 28 : 24,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                              SizedBox(
                                                  width: isTablet ? 16 : 12),
                                              isBookDetail.isFalse
                                                  ? Obx(() => Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (currentSpeed
                                                                    .value ==
                                                                "1.0x") {
                                                              currentSpeed
                                                                      .value =
                                                                  "1.25x";
                                                              baseController!
                                                                  .audioPlayer
                                                                  .setSpeed(
                                                                      1.25);
                                                            } else if (currentSpeed
                                                                    .value ==
                                                                "1.25x") {
                                                              currentSpeed
                                                                      .value =
                                                                  "1.5x";
                                                              baseController!
                                                                  .audioPlayer
                                                                  .setSpeed(
                                                                      1.5);
                                                            } else if (currentSpeed
                                                                    .value ==
                                                                "1.5x") {
                                                              currentSpeed
                                                                      .value =
                                                                  "0.75x";
                                                              baseController!
                                                                  .audioPlayer
                                                                  .setSpeed(
                                                                      0.75);
                                                            } else {
                                                              currentSpeed
                                                                      .value =
                                                                  "1.0x";
                                                              baseController!
                                                                  .audioPlayer
                                                                  .setSpeed(
                                                                      1.0);
                                                            }
                                                          },
                                                          child: Text(
                                                            currentSpeed.value,
                                                            style: TextStyle(
                                                              fontSize: isTablet
                                                                  ? 19
                                                                  : 17,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ))
                                                  : Obx(() => Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (currentSpeed
                                                                    .value ==
                                                                "1.0x") {
                                                              currentSpeed
                                                                      .value =
                                                                  "1.25x";
                                                              baseController!
                                                                  .audioPlayer
                                                                  .setSpeed(
                                                                      1.25);
                                                            } else if (currentSpeed
                                                                    .value ==
                                                                "1.25x") {
                                                              currentSpeed
                                                                      .value =
                                                                  "1.5x";
                                                              baseController!
                                                                  .audioPlayer
                                                                  .setSpeed(
                                                                      1.5);
                                                            } else if (currentSpeed
                                                                    .value ==
                                                                "1.5x") {
                                                              currentSpeed
                                                                      .value =
                                                                  "0.75x";
                                                              baseController!
                                                                  .audioPlayer
                                                                  .setSpeed(
                                                                      0.75);
                                                            } else {
                                                              currentSpeed
                                                                      .value =
                                                                  "1.0x";
                                                              baseController!
                                                                  .audioPlayer
                                                                  .setSpeed(
                                                                      1.0);
                                                            }
                                                          },
                                                          child: Text(
                                                            currentSpeed.value,
                                                            style: TextStyle(
                                                              fontSize: isTablet
                                                                  ? 19
                                                                  : 17,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                              SizedBox(
                                                  width: isTablet ? 15 : 12),
                                              const Spacer(),
                                              InkWell(
                                                onTap: () => Get.back(),
                                                child: const Icon(Icons
                                                    .keyboard_arrow_down_outlined),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: isTablet ? 6 : 4),
                                        SizedBox(
                                          height: isTablet ? 12 : 8,
                                          child: Divider(
                                            height: 1,
                                            color: Colors.grey.withOpacity(0.3),
                                            thickness: 1,
                                          ),
                                        ),
                                        SizedBox(height: isTablet ? 12 : 8),
                                        baseController!.isTextVisible.value
                                            ? Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            if (customFontSize
                                                                    .value !=
                                                                10) {
                                                              customFontSize
                                                                      .value =
                                                                  customFontSize
                                                                          .value -
                                                                      2;
                                                              setState(() {});
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  isTablet
                                                                      ? 8
                                                                      : 5),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black)),
                                                          child: Text(
                                                            'A',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    isTablet
                                                                        ? 17
                                                                        : 14,
                                                                color: isDark
                                                                        .value
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Obx(() => Slider(
                                                              value:
                                                                  customFontSize
                                                                      .value,
                                                              max: 30,
                                                              divisions: 10,
                                                              min: 10,
                                                              onChanged: (double
                                                                  value) {
                                                                customFontSize
                                                                        .value =
                                                                    value;
                                                              },
                                                            )),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          if (customFontSize
                                                                  .value !=
                                                              24) {
                                                            customFontSize
                                                                    .value =
                                                                customFontSize
                                                                        .value +
                                                                    2;
                                                            setState(() {});
                                                          }
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black)),
                                                          child: Text(
                                                            'A',
                                                            style: TextStyle(
                                                              fontSize: isTablet
                                                                  ? 17
                                                                  : 15,
                                                              color: isDark
                                                                      .value
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              isDark.value =
                                                                  false;
                                                            });
                                                          },
                                                          child: Container(
                                                            height: isTablet
                                                                ? 52
                                                                : 45,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: isDark.value ==
                                                                            true
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .grey
                                                                            .withOpacity(.3))),
                                                            child: Text(
                                                              'A',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isTablet
                                                                          ? 19
                                                                          : 17,
                                                                  color: isDark
                                                                          .value
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: isTablet
                                                              ? 24
                                                              : 20),
                                                      Expanded(
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              isDark.value =
                                                                  true;
                                                            });
                                                          },
                                                          child: Container(
                                                            height: isTablet
                                                                ? 54
                                                                : 45,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        .3),
                                                                border: Border.all(
                                                                    color: isDark.value ==
                                                                            false
                                                                        ? Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                .3)
                                                                        : Colors
                                                                            .white)),
                                                            child: Text(
                                                              'A',
                                                              style: TextStyle(
                                                                  color: isDark
                                                                          .value
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  SwipeTo(
                                                    onRightSwipe: () async {
                                                      if (baseController!
                                                          .audioPlayer
                                                          .hasPrevious) {
                                                        await baseController!
                                                            .audioPlayer
                                                            .seekToPrevious();

                                                        baseController!
                                                            .audioPlayer
                                                            .play();
                                                        baseController!
                                                            .isPlaying
                                                            .value = true;

                                                        setState(() {});
                                                      }
                                                    },
                                                    animationDuration:
                                                        const Duration(
                                                            milliseconds: 200),
                                                    onLeftSwipe: () {
                                                      if (baseController!
                                                          .audioPlayer
                                                          .hasNext) {
                                                        baseController!
                                                            .isPlaying
                                                            .value = false;
                                                        baseController!
                                                            .audioPlayer
                                                            .seekToNext();

                                                        baseController!
                                                            .isPlaying
                                                            .value = true;
                                                        baseController!
                                                            .audioPlayer
                                                            .play();
                                                        setState(() {});
                                                      }
                                                    },
                                                    child: Obx(
                                                      () => baseController!
                                                                  .currentPlayingIndex
                                                                  .value !=
                                                              999
                                                          ? Html(
                                                              data: baseController
                                                                      ?.booksQueueList[baseController!
                                                                          .currentPlayingBookIndex
                                                                          .value]
                                                                      .bookChapter[baseController!
                                                                          .currentPlayingIndex
                                                                          .value]
                                                                      .content!
                                                                      .replaceAll(
                                                                          'font-feature-settings: normal;',
                                                                          '') ??
                                                                  "",
                                                              style: {
                                                                "body": Style(
                                                                  color: isDark
                                                                          .value
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                  fontSize: FontSize(
                                                                      customFontSize
                                                                          .value),
                                                                ),
                                                              },
                                                            )
                                                          : const SizedBox(),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        isVisible.value
                                            ? Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(() => BooksImages(
                                                          bookImage:
                                                              baseController!
                                                                  .runningBookImage
                                                                  .value));
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      height:
                                                          isTablet ? 250 : 210,
                                                      width: 180,
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 5,
                                                            blurRadius: 3,
                                                            offset:
                                                                const Offset(
                                                                    0, 2),
                                                          ),
                                                        ],
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                baseController!
                                                                    .runningBookImage
                                                                    .value),
                                                            fit: BoxFit.fill,
                                                            filterQuality:
                                                                FilterQuality
                                                                    .high),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  baseController!.currentPlayingIndex
                                                                  .value !=
                                                              999 &&
                                                          baseController
                                                                  ?.booksQueueList
                                                                  .isNotEmpty ==
                                                              true
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Center(
                                                            child: Text(
                                                              isBookDetail
                                                                      .isFalse
                                                                  ? "Ch ${baseController!.currentPlayingIndex.value + 1} : ${baseController?.booksQueueList[baseController!.currentPlayingBookIndex.value].bookChapter[baseController!.currentPlayingIndex.value].name ?? ""}"
                                                                  : "Ep ${baseController!.currentPlayingIndex.value + 1} : ${baseController?.booksQueueList[baseController!.currentPlayingBookIndex.value].bookChapter[baseController!.currentPlayingIndex.value].name ?? ""}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    isTablet
                                                                        ? 16
                                                                        : 14,
                                                                color:
                                                                    commonBlueColor,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : InkWell(
                                                          onTap: () {},
                                                          child: Text(
                                                            isBookDetail.isFalse
                                                                ? "No more chapters found"
                                                                : "No more episodes found",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: isTablet
                                                                  ? 20
                                                                  : 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                  SizedBox(
                                                      height:
                                                          isTablet ? 14 : 10),
                                                  Obx(
                                                    () => SliderTheme(
                                                      data: SliderTheme.of(
                                                              context)
                                                          .copyWith(
                                                        activeTrackColor:
                                                            buttonColor,
                                                        inactiveTrackColor:
                                                            Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.3),
                                                        trackShape:
                                                            const RectangularSliderTrackShape(),
                                                        trackHeight:
                                                            isTablet ? 6 : 4,
                                                        thumbColor: Colors.grey,
                                                        thumbShape:
                                                            const RoundSliderThumbShape(
                                                                enabledThumbRadius:
                                                                    10),
                                                        overlayShape:
                                                            const RoundSliderOverlayShape(
                                                                overlayRadius:
                                                                    28),
                                                      ),
                                                      child: Slider(
                                                          value: position
                                                              .value.inSeconds
                                                              .toDouble(),
                                                          activeColor:
                                                              commonBlueColor,
                                                          max: duration
                                                              .value.inSeconds
                                                              .toDouble(),
                                                          onChanged:
                                                              (value) async {
                                                            baseController!
                                                                .audioPlayer
                                                                .seek(Duration(
                                                                    seconds: value
                                                                        .toInt()));
                                                          }),
                                                    ),
                                                  ),
                                                  Obx(() => Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              time(position
                                                                      .value) ??
                                                                  "",
                                                              style: TextStyle(
                                                                  color: GlobalService
                                                                              .to
                                                                              .isDarkModel ==
                                                                          true
                                                                      ? borderColor
                                                                      : buttonColor)),
                                                          Text(
                                                              time(duration
                                                                          .value -
                                                                      position
                                                                          .value) ??
                                                                  "",
                                                              style: TextStyle(
                                                                  color: GlobalService
                                                                              .to
                                                                              .isDarkModel ==
                                                                          true
                                                                      ? textColor
                                                                      : buttonColor)),
                                                        ],
                                                      )),
                                                  SizedBox(
                                                      height:
                                                          isTablet ? 16 : 12),
                                                  Obx(() => baseController!
                                                              .currentPlayingIndex
                                                              .value !=
                                                          999
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            baseController!
                                                                        .currentPlayingIndex
                                                                        .value !=
                                                                    0
                                                                ? InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      if (baseController!
                                                                          .isCompleted
                                                                          .isFalse) {
                                                                        if (baseController!
                                                                            .audioPlayer
                                                                            .hasPrevious) {
                                                                          await baseController!
                                                                              .audioPlayer
                                                                              .seekToPrevious();
                                                                          baseController!
                                                                              .audioPlayer
                                                                              .play();
                                                                          baseController!
                                                                              .isPlaying
                                                                              .value = true;

                                                                          setState(
                                                                              () {});
                                                                        }
                                                                      }
                                                                    },
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/icons/back.png',
                                                                      height: isTablet
                                                                          ? 35
                                                                          : 30,
                                                                      width: isTablet
                                                                          ? 35
                                                                          : 30,
                                                                    ),
                                                                  )
                                                                : const SizedBox(
                                                                    width: 45),
                                                            InkWell(
                                                              onTap: () async {
                                                                if (baseController!
                                                                    .isCompleted
                                                                    .isFalse) {
                                                                  if (baseController!
                                                                          .audioPlayer
                                                                          .position
                                                                          .inSeconds <
                                                                      10) {
                                                                    baseController!
                                                                        .audioPlayer
                                                                        .seek(const Duration(
                                                                            seconds:
                                                                                0));
                                                                  } else {
                                                                    baseController!
                                                                        .audioPlayer
                                                                        .seek(Duration(
                                                                            seconds:
                                                                                baseController!.audioPlayer.position.inSeconds - 10));
                                                                  }

                                                                  setState(
                                                                      () {});
                                                                }
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/back-10.png',
                                                                height: isTablet
                                                                    ? 28
                                                                    : 24,
                                                                width: isTablet
                                                                    ? 28
                                                                    : 24,
                                                              ),
                                                            ),
                                                            CircleAvatar(
                                                                backgroundColor:
                                                                    commonBlueColor,
                                                                radius: isTablet
                                                                    ? 30
                                                                    : 25,
                                                                child:
                                                                    IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (baseController!
                                                                        .isCompleted
                                                                        .isFalse) {
                                                                      if (baseController!
                                                                          .isPlaying
                                                                          .value) {
                                                                        baseController!
                                                                            .audioPlayer
                                                                            .pause();
                                                                        baseController!
                                                                            .isPause
                                                                            .value = true;
                                                                        baseController!
                                                                            .isPlaying
                                                                            .value = false;
                                                                        setState(
                                                                            () {});
                                                                      } else {
                                                                        if (baseController!.isPause.value ==
                                                                            true) {
                                                                          baseController!
                                                                              .audioPlayer
                                                                              .play();

                                                                          baseController!
                                                                              .isPlaying
                                                                              .value = true;
                                                                          baseController!
                                                                              .isPause
                                                                              .value = false;
                                                                          setState(
                                                                              () {});
                                                                        } else {
                                                                          baseController!
                                                                              .audioPlayer
                                                                              .dispose();
                                                                          baseController!.audioPlayer =
                                                                              AudioPlayer();
                                                                          baseController!
                                                                              .isPlaying
                                                                              .value = false;
                                                                          setAudio()
                                                                              .then((value) {
                                                                            baseController!.isPlaying.value =
                                                                                true;
                                                                            setState(() {});
                                                                          });
                                                                        }
                                                                      }
                                                                    }
                                                                  },
                                                                  icon: Icon(
                                                                    baseController!
                                                                            .isPlaying
                                                                            .value
                                                                        ? Icons
                                                                            .pause
                                                                        : Icons
                                                                            .play_arrow,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                )),
                                                            InkWell(
                                                              onTap: () {
                                                                if (baseController!
                                                                    .isCompleted
                                                                    .isFalse) {
                                                                  if (baseController!
                                                                              .audioPlayer
                                                                              .duration!
                                                                              .inSeconds -
                                                                          baseController!
                                                                              .audioPlayer
                                                                              .position
                                                                              .inSeconds >=
                                                                      10) {
                                                                    baseController!
                                                                        .audioPlayer
                                                                        .seek(Duration(
                                                                            seconds:
                                                                                baseController!.audioPlayer.position.inSeconds + 10));
                                                                  } else {
                                                                    baseController!
                                                                        .audioPlayer
                                                                        .seek(Duration(
                                                                            seconds:
                                                                                baseController!.audioPlayer.duration!.inSeconds));
                                                                  }
                                                                }
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/forward-10.png',
                                                                height: isTablet
                                                                    ? 28
                                                                    : 24,
                                                                width: isTablet
                                                                    ? 28
                                                                    : 24,
                                                              ),
                                                            ),
                                                            baseController?.booksQueueList
                                                                            .isNotEmpty ==
                                                                        true &&
                                                                    baseController!.currentPlayingIndex.value +
                                                                            1 !=
                                                                        baseController
                                                                            ?.booksQueueList[baseController!
                                                                                .currentPlayingBookIndex.value]
                                                                            .bookChapter
                                                                            .length
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      if (baseController!
                                                                          .isCompleted
                                                                          .isFalse) {
                                                                        if (baseController!
                                                                            .audioPlayer
                                                                            .hasNext) {
                                                                          baseController!
                                                                              .isPlaying
                                                                              .value = false;
                                                                          baseController!
                                                                              .audioPlayer
                                                                              .seekToNext();
                                                                          // baseController!
                                                                          //     .currentPlayingIndex
                                                                          //     .value++;
                                                                          baseController!
                                                                              .isPlaying
                                                                              .value = true;
                                                                          baseController!
                                                                              .audioPlayer
                                                                              .play();
                                                                          setState(
                                                                              () {});
                                                                        }
                                                                      }
                                                                    },
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/nxtbtn.png',
                                                                      height: isTablet
                                                                          ? 34
                                                                          : 30,
                                                                      width: isTablet
                                                                          ? 34
                                                                          : 30,
                                                                    ),
                                                                  )
                                                                : SizedBox(
                                                                    width:
                                                                        isTablet
                                                                            ? 52
                                                                            : 45)
                                                          ],
                                                        )
                                                      : const SizedBox()),
                                                  SizedBox(
                                                      height:
                                                          isTablet ? 24 : 20),
                                                  Obx(() => baseController!
                                                              .booksQueueList
                                                              .isNotEmpty &&
                                                          (baseController!
                                                                  .booksQueueList[
                                                                      baseController!
                                                                          .currentPlayingBookIndex
                                                                          .value]
                                                                  .isPodcast ==
                                                              true)
                                                      ? baseController!
                                                              .musicSuggestionPodcasts
                                                              .isNotEmpty
                                                          ? Column(
                                                              children: [
                                                                SizedBox(
                                                                    height:
                                                                        isTablet
                                                                            ? 20
                                                                            : 16),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: 0,
                                                                      right: isTablet
                                                                          ? 20
                                                                          : 16),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Text(
                                                                          "Suggested for you",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize: isTablet
                                                                                ? 17
                                                                                : 14,
                                                                            color:
                                                                                commonBlueColor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        isTablet
                                                                            ? 14
                                                                            : 12),
                                                                SizedBox(
                                                                  height:
                                                                      isTablet
                                                                          ? 240
                                                                          : 210,
                                                                  width: double
                                                                      .infinity,
                                                                  child: ListView
                                                                      .builder(
                                                                    padding: EdgeInsets.only(
                                                                        left: 0,
                                                                        right: isTablet
                                                                            ? 20
                                                                            : 16),
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        const BouncingScrollPhysics(),
                                                                    itemCount: baseController!
                                                                        .musicSuggestionPodcasts
                                                                        .length,
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return baseController!.musicSuggestionPodcasts[index].id ==
                                                                              baseController!.booksQueueList[baseController!.currentPlayingBookIndex.value].bookId
                                                                          ? const SizedBox()
                                                                          : Padding(
                                                                              padding: EdgeInsets.all(isTablet ? 5 : 3.0),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SizedBox(height: isTablet ? 4 : 2),
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      FocusScope.of(context).unfocus();
                                                                                      Get.back();
                                                                                      Get.find<BookDetailController>().callApis(bookID: baseController!.musicSuggestionPodcasts[index].id);
                                                                                      Get.toNamed(AppRoutes.bookDetailScreen);
                                                                                    },
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                      ),
                                                                                      child: SizedBox(
                                                                                        width: isTablet ? 140 : 125,
                                                                                        height: isTablet ? 210 : 190,
                                                                                        child: ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          child: CachedNetworkImage(
                                                                                            fit: BoxFit.fill,
                                                                                            imageUrl: baseController!.musicSuggestionPodcasts[index].image ?? "",
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: isTablet ? 12 : 8),
                                                                                ],
                                                                              ),
                                                                            );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox()
                                                      : baseController!
                                                              .musicSuggestionBook
                                                              .isNotEmpty
                                                          ? Column(
                                                              children: [
                                                                SizedBox(
                                                                    height:
                                                                        isTablet
                                                                            ? 20
                                                                            : 16),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: 0,
                                                                      right: isTablet
                                                                          ? 20
                                                                          : 16),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Text(
                                                                          "Suggested for you",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize: isTablet
                                                                                ? 17
                                                                                : 14,
                                                                            color:
                                                                                commonBlueColor,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        isTablet
                                                                            ? 16
                                                                            : 12),
                                                                SizedBox(
                                                                  height:
                                                                      isTablet
                                                                          ? 240
                                                                          : 210,
                                                                  width: double
                                                                      .infinity,
                                                                  child: ListView
                                                                      .builder(
                                                                    padding: EdgeInsets.only(
                                                                        left: 0,
                                                                        right: isTablet
                                                                            ? 20
                                                                            : 16),
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        const BouncingScrollPhysics(),
                                                                    itemCount: baseController!
                                                                        .musicSuggestionBook
                                                                        .length,
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return baseController!.booksQueueList.isNotEmpty &&
                                                                              baseController!.musicSuggestionBook[index].id == baseController!.booksQueueList[baseController!.currentPlayingBookIndex.value].bookId
                                                                          ? const SizedBox()
                                                                          : Padding(
                                                                              padding: EdgeInsets.all(isTablet ? 5 : 3.0),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SizedBox(height: isTablet ? 4 : 2),
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      FocusScope.of(context).unfocus();
                                                                                      Get.back();
                                                                                      Get.find<BookDetailController>().callApis(bookID: baseController!.musicSuggestionBook[index].id);
                                                                                      Get.toNamed(AppRoutes.bookDetailScreen);
                                                                                    },
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                      ),
                                                                                      child: SizedBox(
                                                                                        width: isTablet ? 140 : 125,
                                                                                        height: isTablet ? 210 : 190,
                                                                                        child: ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                          child: CachedNetworkImage(
                                                                                            fit: BoxFit.fill,
                                                                                            imageUrl: baseController!.musicSuggestionBook[index].image ?? "",
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: isTablet ? 10 : 8),
                                                                                ],
                                                                              ),
                                                                            );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox()),
                                                  SizedBox(
                                                      height:
                                                          isTablet ? 24 : 20),
                                                ],
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ));
          });
        });
  }
}
