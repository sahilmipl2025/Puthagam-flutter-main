import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/category_book/category_book_controller.dart';
import 'package:puthagam/screen/dashboard/library/saved/saved_controller.dart';
import 'package:puthagam/screen/dashboard/podcast/screen/explore_podcast/explore_podcast_controller.dart';
import 'package:puthagam/screen/dashboard/podcast/screen/podcast_categories/podcast_categories_controller.dart';
import 'package:puthagam/screen/dashboard/podcast/screen/week_podcast/week_podcast_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;

import '../../handler/api_url.dart';

deleteSavedBookApi(
    {bookId,
    index,
    bool? fromSaved = false,
    bool? fromCategory = false,
    bool? fromDetail = false}) async {
  SavedController savedController = Get.put(SavedController());
  CategoryBookController categoryBookController =
      Get.put(CategoryBookController());
  BookDetailController bookDetailController = Get.put(BookDetailController());
  PodcastCategoriesController podcastCategoriesController =
      Get.put(PodcastCategoriesController());
  WeekPodcastController weekPodcastController =
      Get.put(WeekPodcastController());
  ExplorePodcastController explorePodcastController =
      Get.put(ExplorePodcastController());

  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        if (fromSaved == true) {
          savedController.showLoading.value = true;
        } else if (fromCategory == true) {
          categoryBookController.savedLoading.value = true;
        } else if (fromDetail == true) {
          bookDetailController.savedLoading.value = true;
        }

        http.Response response = await ApiHandler.delete(
          url: "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Save/$bookId",
        );

        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          if (fromSaved == true) {
            savedController.savedBookList.removeAt(index);
            savedController.showLoading.value = false;
          } else if (fromCategory == true) {
            categoryBookController.savedLoading.value = false;
            categoryBookController.booksList[index].isSaved!.value = false;
            savedController.savedBookList.removeWhere((element) =>
                element.id == categoryBookController.booksList[index].id);
          } else if (fromDetail == true) {
            bookDetailController.bookDetail.value.isSaved!.value = false;
            bookDetailController.savedLoading.value = false;

            /// Remove From Category Books

            categoryBookController.booksList.asMap().forEach((key, value) {
              if (bookDetailController.bookDetail.value.id ==
                  categoryBookController.booksList[key].id) {
                categoryBookController.booksList[key].isSaved!.value = false;
              }
            });

            /// Remove From Podcast Categories

            if (podcastCategoriesController.podcastList.isNotEmpty) {
              podcastCategoriesController.podcastList
                  .asMap()
                  .forEach((key, value) {
                if (bookDetailController.bookDetail.value.id ==
                    podcastCategoriesController.podcastList[key].id) {
                  podcastCategoriesController.podcastList[key].isSaved!.value =
                      false;
                }
              });
            }

            /// Remove From Week Podcast

            if (weekPodcastController.podcastList.isNotEmpty) {
              weekPodcastController.podcastList.asMap().forEach((key, value) {
                if (bookDetailController.bookDetail.value.id ==
                    weekPodcastController.podcastList[key].id) {
                  weekPodcastController.podcastList[key].isSaved!.value = false;
                }
              });
            }

            /// Remove From Explore Podcast

            if (explorePodcastController.podcastList.isNotEmpty) {
              explorePodcastController.podcastList
                  .asMap()
                  .forEach((key, value) {
                if (bookDetailController.bookDetail.value.id ==
                    explorePodcastController.podcastList[key].id) {
                  explorePodcastController.podcastList[key].isSaved!.value =
                      false;
                }
              });
            }

            /// Remove From Saves List

            savedController.savedBookList.removeWhere((element) =>
                element.id == bookDetailController.bookDetail.value.id);
          }
          toast(decoded['message'], true);
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          if (fromSaved == true) {
            savedController.showLoading.value = false;
          } else if (fromCategory == true) {
            categoryBookController.savedLoading.value = false;
          } else if (fromDetail == true) {
            bookDetailController.savedLoading.value = false;
          }
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['message'], false);
        } else {
          if (fromSaved == true) {
            savedController.showLoading.value = false;
          } else if (fromCategory == true) {
            categoryBookController.savedLoading.value = false;
          } else if (fromDetail == true) {
            bookDetailController.savedLoading.value = false;
          }
          toast(decoded['message'], false);
        }
      } else {
        if (fromSaved == true) {
          savedController.showLoading.value = false;
        } else if (fromCategory == true) {
          categoryBookController.savedLoading.value = false;
        } else if (fromDetail == true) {
          bookDetailController.savedLoading.value = false;
        }
      }
    } else {
      if (fromSaved == true) {
        savedController.showLoading.value = false;
      } else if (fromCategory == true) {
        categoryBookController.savedLoading.value = false;
      } else if (fromDetail == true) {
        bookDetailController.savedLoading.value = false;
      }
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    if (fromSaved == true) {
      savedController.showLoading.value = false;
    } else if (fromCategory == true) {
      categoryBookController.savedLoading.value = false;
    } else if (fromDetail == true) {
      bookDetailController.savedLoading.value = false;
    }
    // toast(e.toString(), false);
  }
}
