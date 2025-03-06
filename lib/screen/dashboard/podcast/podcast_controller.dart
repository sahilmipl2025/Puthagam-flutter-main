import 'dart:convert';
import 'package:puthagam/model/category/get_category_list_model.dart'
    as category;
import 'dart:math';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/api/profile/get_profile_api.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/model/category/get_category_list_model.dart';
import 'package:puthagam/model/live_podcasts_response/datum.dart';
import 'package:puthagam/model/live_podcasts_response/live_podcasts_response.dart';
import 'package:puthagam/model/podcast/get_podcast_categories_model.dart';
import 'package:puthagam/model/podcast/get_podcast_explore_modal.dart';
import 'package:puthagam/model/podcast/get_podcaster_model.dart';
import 'package:puthagam/model/podcast/get_week_podcast_model.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

import '../../../data/handler/api_url.dart';
import '../../../model/category_books/get_category_books_model.dart';

class PodcastController extends GetxController {
  RxBool isSearch = false.obs;
    RxString totalBooks = "0".obs;
   RxBool searchLoader = false.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  final allLivePodcast = <Datum>[].obs;
  final livePodcastLoading = false.obs;
   RxList<CategoryBooks> searchBookList = <CategoryBooks>[].obs;
 //  RxList<PodCastCategories> searchBookLists = <PodCastCategories>[].obs;
  // RxList<PodCastCategories> categoriesPodcast = <PodCastCategories>[].obs;

  @override
  void onReady() {
    super.onReady();
    getCategoriesPodcastApi();
    getExplorePodcastApi();
    getWeekPodcastApi();
    getCategoryListApi();
    // getPodcasterList();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      resumeCallBack: () async {
        await LocalStorage.getData();
        return getLivePodCasts();
      },
    ));
  }

 Future<void> refreshData1() async {
    searchBookList.clear();
    searchController.value.clear();
    isSearch.value = false;
    await  getCategoriesPodcastApi();
    getExplorePodcastApi();
    getWeekPodcastApi();
    getCategoryListApi();
    update();
  }

  callAllApis() async {
    await getLivePodCasts();

    update();
  }

  RxBool isConnected = true.obs;
  RxBool collectionLoading = false.obs;
  RxList<PodCastCategories> categoriesPodcast = <PodCastCategories>[].obs;

  getCategoriesPodcastApi({categoryId, pagination}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        if (connection) {
          await LocalStorage.getData();
          if (LocalStorage.token.toString() != "null" &&
              LocalStorage.token.toString().isNotEmpty &&
              LocalStorage.userId.toString() != "null" &&
              LocalStorage.userId.toString().isNotEmpty) {
            isConnected.value = true;
            collectionLoading.value = true;

            http.Response response = await ApiHandler.post(
                url:
                    '${ApiUrls.baseUrl}Podcast/${LocalStorage.userId}/TopOfCategories',
                body: {
                  "categoryId": '',
                  "start": 0,
                  "length": 60,
                  "searchString": "",
                  "subcategoryIds": "",
                  "authorId": '',
                  "sortBy": ""
                });

            var decoded = jsonDecode(response.body);

            if (response.statusCode == 200 ||
                response.statusCode == 201 ||
                response.statusCode == 202 ||
                response.statusCode == 203 ||
                response.statusCode == 204) {
              var decoded = getPodcastCategoriesModelFromJson(response.body);
              for (var element in decoded.data!) {
                categoriesPodcast.add(element);
              }

              collectionLoading.value = false;
            } else if (response.statusCode == 401) {
              LocalStorage.clearData();
              collectionLoading.value = false;
              Get.offAllNamed(AppRoutes.loginScreen);
              toast(decoded['status']['message'], false);
            } else {
              collectionLoading.value = false;
              toast(decoded['status']['message'], false);
            }
          }
        } else {
          isConnected.value = false;
          collectionLoading.value = false;
          toast("No Internet Connection!", false);
        }
      } else {
        isConnected.value = false;
        collectionLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      collectionLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  /// Get Today For You

  getLivePodCasts() async {
    try {
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().trim().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().trim().isNotEmpty) {
        bool connection =
            await NetworkInfo(connectivity: Connectivity()).isConnected();
        if (connection) {
          isConnected.value = true;
          livePodcastLoading.value = true;
          http.Response response = await ApiHandler.post(
              url:
                  '${ApiUrls.baseUrl}Podcast/${LocalStorage.userId}/LivePodcasts');
          livePodcastLoading.value = false;
          if (response.statusCode == 200) {
            final livepodcasts =
                LivePodcastsResponse.fromJson(json.decode(response.body));
                print("livepodcasts.data${livepodcasts.data!.length}");
            allLivePodcast.value = livepodcasts.data ?? [];
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            livePodcastLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);

            var decoded = jsonDecode(response.body);
            toast(decoded['title'], false);
          } else {
            allLivePodcast.value = [];
          }
          update();
        } else {
          isConnected.value = false;
          livePodcastLoading.value = false;
          update();
        }
      }
    } catch (e) {
      livePodcastLoading.value = false;
      allLivePodcast.value = [];
    }
  }

  /// Explore

  RxBool exploreLoading = false.obs;
  RxList<ExplorePodcast> exploreList = <ExplorePodcast>[].obs;

  getExplorePodcastApi({categoryId, pagination}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        if (connection) {
          await LocalStorage.getData();
          if (LocalStorage.token.toString() != "null" &&
              LocalStorage.token.toString().isNotEmpty &&
              LocalStorage.userId.toString() != "null" &&
              LocalStorage.userId.toString().isNotEmpty) {
            isConnected.value = true;
            collectionLoading.value = true;

            http.Response response = await ApiHandler.post(
                url:
                    '${ApiUrls.baseUrl}Podcast/${LocalStorage.userId}/Podcasts',
                body: {
                  "categoryId": '',
                  "start": 0,
                  "length": 20,
                  "searchString": "",
                  "subcategoryIds": "",
                  "authorId": '',
                  "sortBy": ""
                });

            var decoded = jsonDecode(response.body);

            if (response.statusCode == 200 ||
                response.statusCode == 201 ||
                response.statusCode == 202 ||
                response.statusCode == 203 ||
                response.statusCode == 204) {
              var decoded = getExplorePodcastModelFromJson(response.body);
              for (var element in decoded.data!) {
                exploreList.add(element);
              }

              collectionLoading.value = false;
            } else if (response.statusCode == 401) {
              LocalStorage.clearData();
              collectionLoading.value = false;
              Get.offAllNamed(AppRoutes.loginScreen);
              toast(decoded['status']['message'], false);
            } else {
              collectionLoading.value = false;
              toast(decoded['status']['message'], false);
            }
          }
        } else {
          isConnected.value = false;
          collectionLoading.value = false;
          toast("No Internet Connection!", false);
        }
      } else {
        isConnected.value = false;
        collectionLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      collectionLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  /// New This Week

  RxBool weekLoading = false.obs;
  RxList<WeekPodcast> weekPodcastList = <WeekPodcast>[].obs;

  getWeekPodcastApi({categoryId, pagination}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          if (connection) {
            isConnected.value = true;
            collectionLoading.value = true;

            http.Response response = await ApiHandler.post(
                url:
                    '${ApiUrls.baseUrl}Podcast/${LocalStorage.userId}/NewThisWeek',
                body: {
                  "categoryId": '',
                  "start": 0,
                  "length": 20,
                  "searchString": "",
                  "subcategoryIds": "",
                  "authorId": '',
                  "sortBy": ""
                });

            var decoded = jsonDecode(response.body);

            if (response.statusCode == 200 ||
                response.statusCode == 201 ||
                response.statusCode == 202 ||
                response.statusCode == 203 ||
                response.statusCode == 204) {
              var decoded = getWeekPodcastModelFromJson(response.body);
              for (var element in decoded.data!) {
                weekPodcastList.add(element);
              }

              collectionLoading.value = false;
            } else if (response.statusCode == 401) {
              LocalStorage.clearData();
              collectionLoading.value = false;
              Get.offAllNamed(AppRoutes.loginScreen);
              toast(decoded['status']['message'], false);
            } else {
              collectionLoading.value = false;
              toast(decoded['status']['message'], false);
            }
          }
        }
      } else {
        isConnected.value = false;
        collectionLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      collectionLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  RxBool savedLoading = false.obs;

  getPaymentUrlApi({
    required bool isBeta,
  }) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          savedLoading.value = true;

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
      savedLoading.value = false;
      // toast(e.toString(), false);
    } finally {
      savedLoading.value = false;
    }
  }

  getTrialPaymentUrlApi() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          savedLoading.value = true;

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
      savedLoading.value = false;
      // toast(e.toString(), false);
    } finally {
      savedLoading.value = false;
    }
  }

  RxList<category.Category> categoryList = <category.Category>[].obs;
  RxList<category.Category> categoryList2 = <category.Category>[].obs;

  getCategoryListApi({fromHome = false}) async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          http.Response response = await ApiHandler.get(
            url:
                ApiUrls.baseUrl + ApiUrls.getCategoryList + LocalStorage.userId,
          );

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = getCategoryModelFromJson(response.body);
            categoryList.value = decoded.data!;
            categoryList2.value = decoded.data!;
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
      debugPrint(e.toString());
    } finally {
      getCategoryBooksListApi();
    }
  }

  RxList<CategoryPodcastBooksData> categoryBooksList =
      <CategoryPodcastBooksData>[].obs;

  RxInt selectedMenu = 0.obs;

  getCategoryBooksListApi() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          categoryBooksList.clear();
          Random random = Random();
          int evenOdd = random.nextInt(10);

          if (evenOdd % 2 == 0) {
            selectedMenu.value = 1;
          } else {
            selectedMenu.value = 0;
          }

          for (var element in categoryList) {
            int number = 0;

            for (int j = 0; j <= 9999; j++) {
              number = random.nextInt(categoryList2.length);
              if (categoryList2[number].alreadySelected == false) {
                if (categoryBooksList
                    .where((p0) =>
                        p0.categoryDetail.id == categoryList2[number].id)
                    .isEmpty) {
                  break;
                } else {
                  continue;
                }
              } else {
                continue;
              }
            }

            http.Response response = await ApiHandler.post(
                url:
                    '${ApiUrls.baseUrl}Podcast/${LocalStorage.userId}/Podcasts',
                body: {
                  "categoryId": categoryList2[number].id,
                  "start": 0,
                  "length": 20,
                  "searchString": "",
                  "subcategoryIds": "",
                  "authorId": '',
                  "sortBy": selectedMenu.value == 0 ? "TL" : ""
                });

            var decoded = jsonDecode(response.body);

            if (response.statusCode == 200 ||
                response.statusCode == 201 ||
                response.statusCode == 202 ||
                response.statusCode == 203 ||
                response.statusCode == 204) {
              var decoded = getExplorePodcastModelFromJson(response.body);

              decoded.data!.shuffle();
              decoded.data!.toList().shuffle();
              if (categoryBooksList
                  .where(
                      (p0) => p0.categoryDetail.id == categoryList2[number].id)
                  .isEmpty) {
                categoryBooksList.add(
                  CategoryPodcastBooksData(
                    categoryDetail: categoryList2[number],
                    booksList: decoded.data ?? [],
                    selectedMenu: selectedMenu.value,
                  ),
                );
              }

              if (selectedMenu.value == 0) {
                selectedMenu.value = 1;
              } else {
                selectedMenu.value = 0;
              }

              categoryList2[number].alreadySelected = true;

              update();
              if (categoryBooksList.length == 5) {
                break;
              }
            } else if (response.statusCode == 401) {
              LocalStorage.clearData();
              Get.offAllNamed(AppRoutes.loginScreen);
              toast(decoded['status']['message'], false);
            } else {
              toast(decoded['status']['message'], false);
            }
          }
        }
      } else {
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (categoryBooksList.isEmpty) {
        getCategoryBooksListApi();
      }
      update();
    }
  }

  RxList<Podcaster> podcasterList = <Podcaster>[].obs;

  getPodcasterList() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().trim().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().trim().isNotEmpty) {
          isConnected.value = true;

          http.Response response = await ApiHandler.post(
              url: "${ApiUrls.baseUrl}Podcast/${LocalStorage.userId}/Podcaster",
              body: {
                "start": 0,
                "length": 1000,
              });

          var decoded = jsonDecode(response.body);
          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = getPodcasterFromMap(response.body);
            if (decoded.data.isNotEmpty) {
              for (var element in decoded.data) {
                // if(element.bookCount.toInt() > 0){
                podcasterList.add(element);
                // }
              }
            }
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            Get.offAllNamed(AppRoutes.loginScreen);
          } else {
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        isConnected.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      // toast(e.toString(), false);
    } finally {
      getAuthorBooksListApi();
    }
  }

  RxList<AuthorPodcastData> authorsPodcastList = <AuthorPodcastData>[].obs;
  RxInt evenOdd = 0.obs;

  getAuthorBooksListApi() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        await LocalStorage.getData();
        if (LocalStorage.token.toString() != "null" &&
            LocalStorage.token.toString().isNotEmpty &&
            LocalStorage.userId.toString() != "null" &&
            LocalStorage.userId.toString().isNotEmpty) {
          authorsPodcastList.clear();
          for (int i = 0; i <= 1; i++) {
            for (int j = 0; j < podcasterList.length; j++) {
              Random random = Random();
              evenOdd.value = random.nextInt(podcasterList.length);
              update();
              if (podcasterList[evenOdd.value].bookCount.toInt() > 0) {
                break;
              }
            }

            if (podcasterList.length > i) {
              http.Response response = await ApiHandler.post(
                  url:
                      '${ApiUrls.baseUrl}Podcast/${LocalStorage.userId}/Podcasts',
                  body: {
                    "categoryId": "",
                    "start": 0,
                    "length": 20,
                    "searchString": "",
                    "subcategoryIds": "",
                    "authorId": podcasterList[evenOdd.value].id,
                    "sortBy": i == 0 ? "TL" : ""
                  });

              var decoded = jsonDecode(response.body);

              if (response.statusCode == 200 ||
                  response.statusCode == 201 ||
                  response.statusCode == 202 ||
                  response.statusCode == 203 ||
                  response.statusCode == 204) {
                var decoded = getExplorePodcastModelFromJson(response.body);
                authorsPodcastList.add(AuthorPodcastData(
                  authorDetail: podcasterList[evenOdd.value],
                  booksList: decoded.data ?? [],
                  selectedMenu: i,
                ));
              } else if (response.statusCode == 401) {
                LocalStorage.clearData();
                Get.offAllNamed(AppRoutes.loginScreen);
                toast(decoded['status']['message'], false);
              } else {
                toast(decoded['status']['message'], false);
              }
            } else {
              break;
            }
          }
        }
      } else {
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      // toast(e.toString(), false);
    } finally {
      debugPrint(authorsPodcastList.length.toString());
    }
  }
}

class CategoryPodcastBooksData {
  final category.Category categoryDetail;
  final List<ExplorePodcast> booksList;
  final int selectedMenu;

  CategoryPodcastBooksData({
    required this.categoryDetail,
    required this.booksList,
    required this.selectedMenu,
  });
}

class AuthorPodcastData {
  final Podcaster authorDetail;
  final List<ExplorePodcast> booksList;
  final int selectedMenu;

  AuthorPodcastData({
    required this.authorDetail,
    required this.booksList,
    required this.selectedMenu,
  });
}
