import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:puthagam/data/api/library/get_queue_list_api.dart';
import 'package:puthagam/data/api/profile/get_profile_api.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/model/book_detail/get_done_chapters_model.dart';
import 'package:puthagam/model/category_books/get_category_books_model.dart';
import 'package:puthagam/model/collection/get_collection_list_modal.dart';
import 'package:puthagam/model/library/set_queue_model.dart';
import 'package:puthagam/model/podcast/get_podcast_explore_modal.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/collection_books/collection_books_controller.dart';
import 'package:puthagam/screen/dashboard/library/history/history_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

class BookDetailApiController extends GetxController {
  /// Get suggestion book list

  getCategoryBooksApi({categoryId}) async {
      print("Checking network connection...");
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();

      if (connection) {
         print("Connected to internet. Fetching local data...");
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          Get.find<BookDetailController>().suggestionBook.clear();

          http.Response response = await ApiHandler.post(
              url: "${ApiUrls.baseUrl}Book/${LocalStorage.userId}",
              body: {
                "categoryId": categoryId,
                "length": 10,
                "searchString": "",
                "subcategoryIds": "",
                "authorId": "",
                "sortBy": "",
                "isFinished": false,
              });
           print("Response Status Code: ${response.statusCode}");
        var decoded = jsonDecode(response.body);
        print("Decoded Response: $decoded");
       //   var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = getCategoryBooksModelFromJson(response.body);
            if (decoded.data!.isNotEmpty) {
              for (var element in decoded.data!) {
                if (Get.find<BookDetailController>()
                        .suggestionBook
                        .contains(element) ==
                    false) {
                  Get.find<BookDetailController>().suggestionBook.add(element);
                }
              }
            } 
            Get.find<BookDetailController>().update();
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

  getCategoryPodcastsApi({categoryId}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();

      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          Get.find<BookDetailController>().suggestionPodcasts.clear();

          http.Response response = await ApiHandler.post(
              url: "${ApiUrls.baseUrl}Podcast/${LocalStorage.userId}/Podcasts",
              body: {
                "categoryId": categoryId,
                "start": 0,
                "length": 10,
                "searchString": "",
                "subcategoryIds": "",
                "authorId": "",
                "sortBy": "",
              });

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = getExplorePodcastModelFromJson(response.body);
            if (decoded.data!.isNotEmpty) {
              for (var element in decoded.data!) {
                if (Get.find<BookDetailController>()
                        .suggestionPodcasts
                        .contains(element) ==
                    false) {
                  Get.find<BookDetailController>()
                      .suggestionPodcasts
                      .add(element);
                }
              }
            }
            Get.find<BookDetailController>().update();
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

  /// Get suggestion for music player

  getMusicPlayerPodcastsSuggestionApi({categoryId}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();

      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          baseController!.musicSuggestionBook.clear();

          http.Response response = await ApiHandler.post(
              url: "${ApiUrls.baseUrl}Podcast/${LocalStorage.userId}/Podcasts",
              body: {
                "categoryId": categoryId,
                "start": 0,
                "length": 10,
                "searchString": "",
                "subcategoryIds": "",
                "authorId": "",
                "sortBy": "",
              });

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = getExplorePodcastModelFromJson(response.body);
            if (decoded.data!.isNotEmpty) {
              for (var element in decoded.data!) {
                baseController!.musicSuggestionPodcasts.add(element);
              }
            }
            Get.find<BookDetailController>().update();
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

  getMusicPlayerSuggestionApi({categoryId}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();

      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          baseController!.musicSuggestionBook.clear();

          http.Response response = await ApiHandler.post(
              url: "${ApiUrls.baseUrl}Book/${LocalStorage.userId}",
              body: {
                "categoryId": categoryId,
                "start": 0,
                "length": 10,
                "searchString": "",
                "subcategoryIds": "",
                "authorId": "",
                "sortBy": "",
              });

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = getCategoryBooksModelFromJson(response.body);
            if (decoded.data!.isNotEmpty) {
              for (var element in decoded.data!) {
                baseController!.musicSuggestionBook.add(element);
              }
            }
            Get.find<BookDetailController>().update();
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

  getPaymentUrlApi({
    required bool isBeta,
  }) async {
    BookDetailController bookCon = Get.put(BookDetailController());

    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          bookCon.savedLoading.value = true;

          http.Response response = await ApiHandler.post(
              url: '${ApiUrls.baseUrl}SubscriptionPlan/SubscriptionPlan',
              body: {
                "userId": LocalStorage.userId,
                "subscriptionPlanId": 'BETA',
                "paymentGatewayType": 'BETA',
              });
          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            await getUserProfileApi();
            toast("Your beta trial has been activated", true);
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
      bookCon.savedLoading.value = false;
      // toast(e.toString(), false);
    } finally {
      bookCon.savedLoading.value = false;
    }
  }

  getTrialPaymentUrlApi() async {
    BookDetailController bookCon = Get.put(BookDetailController());

    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          bookCon.savedLoading.value = true;

          http.Response response = await ApiHandler.post(
              url: '${ApiUrls.baseUrl}SubscriptionPlan/SubscriptionPlan',
              body: {
                "userId": LocalStorage.userId,
                "subscriptionPlanId": 'TRIAL',
                "paymentGatewayType": 'TRIAL',
                "couponCode": "",
                "timeZone": 0,
              });
          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            await getUserProfileApi();
            toast("Your trial has been activated", true);
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
      bookCon.savedLoading.value = false;
      // toast(e.toString(), false);
    } finally {
      bookCon.savedLoading.value = false;
    }
  }

  /// Get Done Chapters List

  getDoneChaptersApi({bookId}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          Get.find<BookDetailController>().doneChapterList.clear();

          http.Response response = await ApiHandler.get(
            url:
                "${ApiUrls.baseUrl}Book/${LocalStorage.userId}/ChapterHistory/$bookId",
          );

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var dec = getDoneChaptersModelFromJson(response.body);

            for (var element in dec.data!) {
              if (Get.find<BookDetailController>()
                  .doneChapterList
                  .where((p0) => p0.chapterId == element.chapterId)
                  .isEmpty) {
                Get.find<BookDetailController>().doneChapterList.add(element);
              }
            }
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            toast(decoded['message'], false);
          }
        }
      } else {
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      // toast(e.toString(), false);
    }
  }

  completeBookApi({bookId}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          // Get.find<BookDetailController>().savedLoading.value = true;

          http.Response response = await ApiHandler.post(
            url:
                "${ApiUrls.baseUrl}Book/${LocalStorage.userId}/Listened/${Get.find<BookDetailController>().bookDetail.value.id}",
          );

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            Get.find<BookDetailController>().savedLoading.value = false;
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            Get.find<BookDetailController>().savedLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            Get.find<BookDetailController>().savedLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        Get.find<BookDetailController>().savedLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      Get.find<BookDetailController>().savedLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  doneChaptersApi({bookId, chapterId}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          // Get.find<BookDetailController>().savedLoading.value = true;

          http.Response response = await ApiHandler.post(
              url:
                  "${ApiUrls.baseUrl}Book/${LocalStorage.userId}/ChapterHistory",
              body: {
                "userId": LocalStorage.userId,
                "bookId": bookId,
                "chapterId": chapterId,
                "listenTimeSec": 10,
              });

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            if (Get.find<HomeController>()
                    .continueBookList
                    .firstWhere((element) =>
                        element.id ==
                        baseController
                            ?.booksQueueList[
                                baseController!.currentPlayingBookIndex.value]
                            .bookId)
                    .listenChapterIds!
                    .contains(chapterId) ==
                false) {
              Get.find<HomeController>()
                  .continueBookList
                  .firstWhere((element) =>
                      element.id ==
                      baseController
                          ?.booksQueueList[
                              baseController!.currentPlayingBookIndex.value]
                          .bookId)
                  .listenChapterIds!
                  .add(chapterId);

              if (Get.find<HomeController>()
                      .continueBookList
                      .firstWhere((element) =>
                          element.id ==
                          baseController
                              ?.booksQueueList[
                                  baseController!.currentPlayingBookIndex.value]
                              .bookId)
                      .chapterCount ==
                  Get.find<HomeController>()
                      .continueBookList
                      .firstWhere((element) =>
                          element.id ==
                          baseController
                              ?.booksQueueList[
                                  baseController!.currentPlayingBookIndex.value]
                              .bookId)
                      .listenChapterIds!
                      .length) {
                Get.find<HomeController>().continueBookList.removeWhere(
                    (element) =>
                        element.id ==
                        baseController
                            ?.booksQueueList[
                                baseController!.currentPlayingBookIndex.value]
                            .bookId);
              }
            }

            if (Get.find<CollectionBooksController>()
                    .bookList
                    .firstWhere((element) =>
                        element.id ==
                        baseController
                            ?.booksQueueList[
                                baseController!.currentPlayingBookIndex.value]
                            .bookId)
                    .listenChapterIds!
                    .contains(chapterId) ==
                false) {
              Get.find<CollectionBooksController>()
                  .bookList
                  .firstWhere((element) =>
                      element.id ==
                      baseController
                          ?.booksQueueList[
                              baseController!.currentPlayingBookIndex.value]
                          .bookId)
                  .listenChapterIds!
                  .add(chapterId);
              Get.find<CollectionBooksController>().update();
            }

            if (Get.find<HistoryController>()
                    .continueBookList
                    .firstWhere((element) =>
                        element.id ==
                        baseController
                            ?.booksQueueList[
                                baseController!.currentPlayingBookIndex.value]
                            .bookId)
                    .listenChapterIds!
                    .contains(chapterId) ==
                false) {
              Get.find<HistoryController>()
                  .continueBookList
                  .firstWhere((element) =>
                      element.id ==
                      baseController
                          ?.booksQueueList[
                              baseController!.currentPlayingBookIndex.value]
                          .bookId)
                  .listenChapterIds!
                  .add(chapterId);
              Get.find<HistoryController>().update();

              if (Get.find<HistoryController>()
                      .continueBookList
                      .firstWhere((element) =>
                          element.id ==
                          baseController
                              ?.booksQueueList[
                                  baseController!.currentPlayingBookIndex.value]
                              .bookId)
                      .chapterCount ==
                  Get.find<HistoryController>()
                      .continueBookList
                      .firstWhere((element) =>
                          element.id ==
                          baseController
                              ?.booksQueueList[
                                  baseController!.currentPlayingBookIndex.value]
                              .bookId)
                      .listenChapterIds!
                      .length) {
                Get.find<HistoryController>().continueBookList.removeWhere(
                    (element) =>
                        element.id ==
                        baseController
                            ?.booksQueueList[
                                baseController!.currentPlayingBookIndex.value]
                            .bookId);
              }
            }

            if (baseController!.currentBookDoneChapter
                .where((p0) => p0.chapterId == chapterId)
                .isEmpty) {
              if (baseController!.runningBookId.value ==
                  Get.find<BookDetailController>().bookDetail.value.id) {
                Get.find<BookDetailController>().doneChapterList.add(Chapter(
                    bookId: bookId,
                    userId: LocalStorage.userId,
                    chapterId: chapterId));
              }
              baseController!.currentBookDoneChapter.add(Chapter(
                  bookId: bookId,
                  userId: LocalStorage.userId,
                  chapterId: chapterId));
            }

            if (baseController!.queueList
                    .firstWhere((element) =>
                        element.id ==
                        baseController
                            ?.booksQueueList[
                                baseController!.currentPlayingBookIndex.value]
                            .bookId)
                    .listenChapterIds!
                    .contains(chapterId) ==
                false) {
              baseController!.queueList
                  .firstWhere((element) =>
                      element.id ==
                      baseController
                          ?.booksQueueList[
                              baseController!.currentPlayingBookIndex.value]
                          .bookId)
                  .listenChapterIds!
                  .add(chapterId);
            }

            Get.find<BookDetailController>().savedLoading.value = false;
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            Get.find<BookDetailController>().savedLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            Get.find<BookDetailController>().savedLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        Get.find<BookDetailController>().savedLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      Get.find<BookDetailController>().savedLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  addToQueueApi() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          Get.find<BookDetailController>().savedLoading.value = true;

          http.Response response = await ApiHandler.post(
            url:
                "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Queue/${Get.find<BookDetailController>().bookDetail.value.id}",
          );

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            Get.find<BookDetailController>().savedLoading.value = false;
            getQueueListApi();
            baseController!.storeInLocalStorage(
              data: QueueChapterModel(
                bookId: Get.find<BookDetailController>().bookDetail.value.id,
                chapter: 0,
              ),
            );
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            Get.find<BookDetailController>().savedLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            Get.find<BookDetailController>().savedLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        Get.find<BookDetailController>().savedLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      Get.find<BookDetailController>().savedLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  ///

  listenCount() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          // savedLoading.value = true;

          http.Response response = await ApiHandler.get(
            url:
                "${ApiUrls.baseUrl}Book/${LocalStorage.userId}/Listened/${Get.find<BookDetailController>().bookDetail.value.id}",
          );

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            // savedLoading.value = false;
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            // savedLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['message'], false);
          } else {
            // savedLoading.value = false;
            toast(decoded['message'], false);
          }
        }
      } else {
        // savedLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      // savedLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  /// Download Books Api

  downloadBooksApi({collectionId, bookId, index}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          Get.find<BookDetailController>().savedLoading.value = true;

          http.Response response = await ApiHandler.post(
              url:
                  "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Download/$bookId");

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            toast(decoded['message'], true);
            Get.find<BookDetailController>().savedLoading.value = false;
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            Get.find<BookDetailController>().savedLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            Get.find<BookDetailController>().savedLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        Get.find<BookDetailController>().savedLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      Get.find<BookDetailController>().savedLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  /// Create Collection

  createCollectionApi({name}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          Get.find<BookDetailController>().savedLoading.value = true;

          http.Response response = await ApiHandler.post(
              url: "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Collections",
              body: {
                "_id": "00000000-0000-0000-0000-000000000000",
                "userId": LocalStorage.userId,
                "name": name
              });

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var data = CollectionBook(
                id: decoded['data']['_id'],
                name: decoded['data']['name'],
                image: decoded['data']['image'],
                bookCount: 0.obs,
                bookIds: decoded['data']['bookIds'] == null
                    ? [].obs
                    : decoded['data']['bookIds'].obs,
                userId: decoded['data']['userId']);
            Get.find<HomeController>().userCollectionList.add(data);

            Get.find<BookDetailController>().controller.value.clear();
            Get.find<HomeController>().update();

            update();
            Get.find<BookDetailController>().savedLoading.value = false;
            toast(decoded['status']['message'], true);
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            Get.find<BookDetailController>().savedLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            Get.find<BookDetailController>().savedLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        Get.find<BookDetailController>().savedLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      Get.find<BookDetailController>().savedLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  /// Add Book to Collection

  addBookToCollectionApi({collectionId, bookId, index}) async {
    // try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        Get.find<BookDetailController>().savedLoading.value = true;

        http.Response response = await ApiHandler.post(
            url:
                "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Collections/$collectionId/books/$bookId");

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          if (Get.find<HomeController>()
                  .userCollectionList[index]
                  .bookIds!
                  .contains(bookId) ==
              false) {
            Get.find<HomeController>()
                .userCollectionList[index]
                .bookIds
                ?.add(bookId);
            Get.find<HomeController>()
                .userCollectionList[index]
                .bookCount!
                .value += 1;
          }
          Get.find<BookDetailController>().savedLoading.value = false;
          toast(decoded['message'], true);
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          Get.find<BookDetailController>().savedLoading.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          Get.find<BookDetailController>().savedLoading.value = false;
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      Get.find<BookDetailController>().savedLoading.value = false;
      toast("No Internet Connection!", false);
    }
    // } catch (e) {
    //   savedLoading.value = false;
    //   toast(e.toString(), false);
    // }
  }

  /// Delete Favorite

  deleteFavoriteBookApi({bookId}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          Get.find<BookDetailController>().savedLoading.value = true;

          http.Response response = await ApiHandler.delete(
              url:
                  "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Favourites/$bookId");

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            Get.find<BookDetailController>()
                .bookDetail
                .value
                .isFavorite!
                .value = false;
            Get.find<BookDetailController>().savedLoading.value = false;
            toast(decoded['message'], true);
            // toast("Removed from favorite successfully", true);
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            Get.find<BookDetailController>().savedLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            Get.find<BookDetailController>().savedLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        Get.find<BookDetailController>().savedLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      Get.find<BookDetailController>().savedLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  /// Saved Book

  favoriteBookApi({bookId}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          Get.find<BookDetailController>().savedLoading.value = true;

          http.Response response = await ApiHandler.post(
              url:
                  "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Favourites/$bookId");

          var decoded = jsonDecode(response.body);
          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            Get.find<BookDetailController>()
                .bookDetail
                .value
                .isFavorite!
                .value = true;
            Get.find<BookDetailController>().savedLoading.value = false;
            toast(decoded['message'], true);
            // toast("Added to favorite successfully", true);
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            Get.find<BookDetailController>().savedLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            toast(decoded['status']['message'], false);
          } else {
            Get.find<BookDetailController>().savedLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        Get.find<BookDetailController>().savedLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      Get.find<BookDetailController>().savedLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  /// Download Books

  downloadBooks() async {
    try {
      ConnectivityResult status = await Connectivity().checkConnectivity();
      if ((LocalStorage.downloadWithMobileData == true &&
              status == ConnectivityResult.wifi) ||
          status == ConnectivityResult.wifi) {
        Map<Permission, PermissionStatus> statuses =
            await [Permission.storage].request();

        // if (statuses[Permission.storage]!.isGranted) {
        var dir = await getApplicationDocumentsDirectory();
       // debugPrint('directory$DownloadsPathProvider');       //sahil edited
        toast("This may take a moment  to download, please wait", true);



        Get.find<BookDetailController>().savedLoading.value = true;

        for (var element in Get.find<BookDetailController>().bookChapterList) {
          String saveName = "${element.id}.wav";

          String savePath = dir.path +
              "/.${Get.find<BookDetailController>().bookDetail.value.id}/.puthagam/$saveName";

          debugPrint(element.audioUrl);
          try {
            if (element.audioUrl != null) {
              await Dio().download(await element.audioUrl ?? "", savePath,
                  onReceiveProgress: (received, total) {
                debugPrint(((received / total) * 100).toString());
              });
            }
          } catch (e) {
            debugPrint(element.id);
            debugPrint("Book audio  $e");
            rethrow;
          }
        }

        var savePath1 = "";

        try {
          if (Get.find<BookDetailController>().bookDetail.value.image != null) {
            String bookImagePath = "bookImage.jpg";
            savePath1 = dir.path +
                "/.${Get.find<BookDetailController>().bookDetail.value.id}/.puthagam/$bookImagePath";

            await Dio().download(
                Get.find<BookDetailController>().bookDetail.value.image ?? "",
                savePath1,
                onReceiveProgress: (received, total) {});
          }
        } catch (e) {
          debugPrint("Book Image $e");
          rethrow;
        }

        var categoryImagePath = "";

        try {
          if (Get.find<BookDetailController>().bookDetail.value.categoryImage !=
              null) {
            String categoryImage = "categoryImage.jpg";
            categoryImagePath = dir.path +
                "/.${Get.find<BookDetailController>().bookDetail.value.id}/.puthagam/$categoryImage";

            await Dio().download(
                Get.find<BookDetailController>()
                        .bookDetail
                        .value
                        .categoryImage ??
                    "",
                categoryImagePath,
                onReceiveProgress: (received, total) {});
          }
        } catch (e) {
          rethrow;
        }

        var authorImagePath = "";

        try {
          if (Get.find<BookDetailController>().bookDetail.value.authorImage !=
              null) {
            String authorImage = "authorImage.jpg";
            authorImagePath = dir.path +
                "/.${Get.find<BookDetailController>().bookDetail.value.id}/.puthagam/$authorImage";

            await Dio().download(
                Get.find<BookDetailController>().bookDetail.value.authorImage ??
                    "",
                authorImagePath,
                onReceiveProgress: (received, total) {});
          }
        } catch (e) {
          debugPrint("Author  $e");
          rethrow;
        }

        await downloadBooksApi(
            bookId: Get.find<BookDetailController>().bookDetail.value.id);

        var downloadModel = {
          'bookDetail': json.encode(
              Get.find<BookDetailController>().simpleBookDetail.value.toJson()),
          'chapter': json.encode(
              Get.find<BookDetailController>().bookChapterList.toJson()),
          'bookReview':
              json.encode(Get.find<BookDetailController>().reviewList.toJson()),
          'authorImagePath': authorImagePath,
          'bookImagePath': savePath1,
          'bookCategoryImage': categoryImagePath,
        };

        baseController!.downloadBooks.removeWhere((element) =>
            jsonDecode(element['bookDetail'])['_id'] ==
            Get.find<BookDetailController>().bookDetail.value.id);

        baseController!.downloadBooks.add(downloadModel);

        LocalStorage.downloadBooksList = baseController!.downloadBooks;

        var box = GetStorage();
        await box.write(
            Prefs.downloadBooks, jsonEncode(LocalStorage.downloadBooksList));

        Get.find<BookDetailController>().savedLoading.value = false;
        // } else {
        //   toast("Provide permission to download files", false);
        //   Get.find<BookDetailController>().savedLoading.value = false;
        // }
      } else {
        toast("Please Turn on WIFI for Download Books", false);
      }
      // });
    } catch (e) {
      Get.find<BookDetailController>().savedLoading.value = false;
      rethrow;
    } finally {
      Get.find<BookDetailController>().savedLoading.value = false;
    }
  }
}
