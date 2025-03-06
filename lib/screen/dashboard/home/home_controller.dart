import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/category/get_category_list_api.dart';
import 'package:puthagam/data/api/home/get_continue_api.dart';
import 'package:puthagam/data/api/home/get_explore_list_api.dart';
import 'package:puthagam/data/api/home/get_meetcreator_list_api.dart';
import 'package:puthagam/data/api/library/get_queue_list_api.dart';
import 'package:puthagam/data/api/profile/get_users_purchase_list_api.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/services/dynamic_link_service.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/model/book_detail/get_collection_for_today_model.dart';
import 'package:puthagam/model/category/get_category_list_model.dart'
    as category;
import 'package:puthagam/model/category/get_subcategory_model.dart';
import 'package:puthagam/model/category_books/get_category_books_model.dart';
import 'package:puthagam/model/collection/get_collection_list_modal.dart';
import 'package:puthagam/model/explore/get_explore_list_model.dart';
import 'package:puthagam/model/meet_creator/get_meet_creator_modal.dart';
import 'package:puthagam/model/podcast/get_podcast_categories_model.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:http/http.dart' as http;
import '../../../data/handler/api_url.dart';
import '../podcast/podcast_controller.dart';
import 'screen/book_detail/book_detail_controller.dart';

class HomeController extends GetxController {
  RxBool isSearch = false.obs;

  Rx<TextEditingController> searchController = TextEditingController().obs;
  RxBool isheight = false.obs;
  RxBool isConnected = false.obs;
  RxBool showLoading = false.obs;
  RxBool categoryLoading = false.obs;
  RxBool exploreLoading = false.obs;
  RxBool collectionLoading = false.obs;
  RxBool todayLoading = false.obs;
  RxBool meetCreatorLoading = false.obs;
  RxList<category.Category> categoryList = <category.Category>[].obs;
  RxList<category.Category> categoryList2 = <category.Category>[].obs;
  RxList<CategoryBooks> bookList = <CategoryBooks>[].obs;
  RxList<CollectionBook> collectionList = <CollectionBook>[].obs;

  RxBool continueLoading = false.obs;
  RxList<CategoryBooks> 
  continueBookList = <CategoryBooks>[].obs;

  RxList<MeetCreator> meetCreatorList = <MeetCreator>[].obs;
  RxList<MeetCreator> creatorList = <MeetCreator>[].obs;
  RxList<SubCategory> subCategoryList = <SubCategory>[].obs;

  RxList<CollectionBook> userCollectionList = <CollectionBook>[].obs;

  RxBool searchLoader = false.obs;
  RxString totalBooks = "0".obs;
  RxList<CategoryBooks> searchBookList = <CategoryBooks>[].obs;

  static final HomeController _homeController = HomeController._internal();
 BookDetailController con = Get.put(BookDetailController());

 PodcastController podcastcon = Get.put(PodcastController());
  HomeController._internal();

  factory HomeController() => _homeController;

  @override
  void onInit() {
    super.onInit();
    getPurchasesListApi();

    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      resumeCallBack: () async {
        await LocalStorage.getData();
      },
    ));

    fetchDynamicLinks();
  }



  fetchDynamicLinks() async {
    await DynamicLinkServices.initDynamicLinks();
  }

  Future<void> refreshData() async {
    searchBookList.clear();
    searchController.value.clear();
    isSearch.value = false;
    await callAllApis(fromHome: true);
    update();
  }

   Future<void> meetrefreshData() async {
   await   getMeetCreator();
  }

  

  callAllApis({bool fromHome = false}) {
    if (fromHome == false) {
      getCategoryListApi(fromHome: true);
    }
    getCategoryListApi(fromHome: true);
    getfreebooks();
    getTodayForYou();
    getExploreListApi();
    getContinueListenListApi();
    getCollectionList();
    getMeetCreator();
    getCreatorList(fromHome: false);
    getUserCollectionList();
    getCategoriesPodcastApi();
    update();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getQueueListApi();
    baseController!.getSubscriptionPlanList();
  }

  List<TodayForYou> todayCollection = <TodayForYou>[].obs;

  getTodayForYou() async {
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
          todayLoading.value = true;
          // todayCollection.clear();

          http.Response response = await ApiHandler.get(
              url:
                  '${ApiUrls.baseUrl}User/${LocalStorage.userId}/CollectionsForToday');
                  print("tokenforlogin${LocalStorage.userId}");
          var decoded = jsonDecode(response.body);
          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = getCollectionForTodayModelFromJson(response.body);
            if (decoded.data!.isNotEmpty) {
              for (var element in decoded.data!)
               {
                if (todayCollection
                
                    .where((p0) => p0.id == element.id)
                    .isEmpty) {
                  todayCollection.add(element);
                }
              }
            }
             todayLoading.value = false;
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            todayLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
          } else {
            todayLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        isConnected.value = false;
        todayLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      todayLoading.value = false;
      // toast(e.toString(), false);
    }
  }
RxBool freeLoading2 = false.obs;
  RxList<PodCastCategories> freebooks = <PodCastCategories>[].obs;

getfreebooks() async {
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
            freeLoading2.value = true;
             freebooks.clear();
           
            http.Response response = await ApiHandler.post(
                url:
                   '${ApiUrls.baseUrl}Book/${LocalStorage.userId}',
                body: {
                       "length" : "10",
                       "bookType" : "3"

                });

            var decoded = jsonDecode(response.body);

            print("free books  ${jsonDecode(response.body)}");
            print("localuserid${LocalStorage.userId}");

            if (response.statusCode == 200 ||
                response.statusCode == 201 ||
                response.statusCode == 202 ||
                response.statusCode == 203 ||
                response.statusCode == 204) {
              var decoded = getPodcastCategoriesModelFromJson(response.body);
              for (var element in decoded.data!) {
                freebooks.add(element);
              }

              freeLoading2.value = false;

              
            } else if (response.statusCode == 401) {
               LocalStorage.clearData();
              freeLoading2.value = false;
              Get.offAllNamed(AppRoutes.loginScreen);
              toast(decoded['status']['message'], false);
            } else {
              collectionLoading2.value = false;
              toast(decoded['status']['message'], false);
            }
          }
        } else {
          isConnected.value = false;
               freeLoading2.value = false;
          toast("No Internet Connection!", false);
        }
      } else {
        isConnected.value = false;
        freeLoading2.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
         freeLoading2.value = false;
      // toast(e.toString(), false);
    }
  }





  RxBool collectionLoading2 = false.obs;
  RxList<PodCastCategories> categoriesPodcast = <PodCastCategories>[].obs;

   


  getCategoriesPodcastApi() async {
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
            collectionLoading2.value = true;
             categoriesPodcast.clear();
           
            http.Response response = await ApiHandler.post(
                url:
                    '${ApiUrls.baseUrl}Podcast/${LocalStorage.userId}/TopOfCategories',
                body: {
                  "categoryId": '',
                  "start": 0,
                  "length": 12,
                  "searchString": "",
                  "subcategoryIds": "",
                  "authorId": '',
                  "sortBy": ""
                });

            var decoded = jsonDecode(response.body);
            print("prodcastresponse${jsonDecode(response.body)}");

            if (response.statusCode == 200 ||
                response.statusCode == 201 ||
                response.statusCode == 202 ||
                response.statusCode == 203 ||
                response.statusCode == 204) {
              var decoded = getPodcastCategoriesModelFromJson(response.body);
              for (var element in decoded.data!) {
                categoriesPodcast.add(element);
              }

              collectionLoading2.value = false;

              
            } else if (response.statusCode == 401) {
               LocalStorage.clearData();
              collectionLoading2.value = false;
              Get.offAllNamed(AppRoutes.loginScreen);
              toast(decoded['status']['message'], false);
            } else {
              collectionLoading2.value = false;
              toast(decoded['status']['message'], false);
            }
          }
        } else {
          isConnected.value = false;
          collectionLoading2.value = false;
          toast("No Internet Connection!", false);
        }
      } else {
        isConnected.value = false;
        collectionLoading2.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      collectionLoading2.value = false;
      // toast(e.toString(), false);
    }
  }

  /// Get Collection List API

  getCollectionList() async {
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
          collectionLoading.value = true;
          collectionList.clear();
          http.Response response = await ApiHandler.get(
              url:
                  '${ApiUrls.baseUrl}User/${LocalStorage.userId}/Collections/false');
          var decoded = jsonDecode(response.body);
          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = getCollectionModelFromJson(response.body);
            if (decoded.data!.isNotEmpty) {
              for (var element in decoded.data!) {
                collectionList.add(element);
              }
            }

            collectionLoading.value = false;
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            collectionLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
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
    } catch (e) {
      collectionLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  /// Save Bookmark API

  savedBookApi({bookId, index}) async {
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
          showLoading.value = true;

          http.Response response = await ApiHandler.post(
            url: "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Save/$bookId",
          );

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            searchBookList[index].isSaved!.value = true;
            showLoading.value = false;
            toast(decoded['message'], true);
            // toast("Saved to your library", true);
            // toast(decoded['message'], true);
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            showLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            // toast(decoded['status']['message'], false);
            // toast(decoded['title'], false);
          } else {
            showLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        isConnected.value = false;
        showLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      showLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  /// Remove Book Api

  deleteSavedBookApi({bookId, index}) async {
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
          showLoading.value = true;

          http.Response response = await ApiHandler.delete(
            url: "${ApiUrls.baseUrl}User/${LocalStorage.userId}/Save/$bookId",
          );

          var decoded = jsonDecode(response.body);

          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            searchBookList[index].isSaved!.value = false;
            showLoading.value = false;
            toast(decoded['message'], true);
            // toast("Remove Saved Successfully", true);
          } else if (response.statusCode == 401) {
            LocalStorage.clearData();
            showLoading.value = false;
            Get.offAllNamed(AppRoutes.loginScreen);
            // toast(decoded['status']['message'], false);
            // toast(decoded['title'], false);
          } else {
            showLoading.value = false;
            toast(decoded['status']['message'], false);
          }
        }
      } else {
        isConnected.value = false;
        showLoading.value = false;
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      showLoading.value = false;
      // toast(e.toString(), false);
    }
  }

  getCreatorList({required bool fromHome}) async {
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
              url:
                  "${ApiUrls.baseUrl}Book/${LocalStorage.userId}/MeetTheCreator",
              body: {
                "categoryId": "",
                "start": 0,
                "length": 1000,
                "searchString": "",
                "subcategoryIds": "",
                "authorId": "",
                "sortBy": ""
              });

          var decoded = jsonDecode(response.body);
          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = getMeetCreatorModelFromJson(response.body);
            if (decoded.data!.isNotEmpty) {
              for (var element in decoded.data!) {
                creatorList.add(element);
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
      if (fromHome == false) {
        getAuthorBooksListApi();
      }
    }
  }

  /// Get Collection API

  getUserCollectionList() async {
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
          userCollectionList.clear();

          http.Response response = await ApiHandler.get(
              url:
                  '${ApiUrls.baseUrl}User/${LocalStorage.userId}/Collections/true');

          var decoded = jsonDecode(response.body);
          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = getCollectionModelFromJson(response.body);
            if (decoded.data!.isNotEmpty) {
              for (var element in decoded.data!) {
                userCollectionList.add(element);
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
    }
  }

  RxList<AuthorBooksData> authorsBooksList = <AuthorBooksData>[].obs;
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
          List<MeetCreator> creatorList2 = [];
          creatorList2 =
              creatorList.where((p0) => p0.bookCount!.toInt() >= 4).toList();
          authorsBooksList.clear();
          for (int i = 0; i <= 1; i++) {
            for (int j = 0; j < 10000000; j++) {
              Random random = Random();
              evenOdd.value = random.nextInt(creatorList2.length);
              update();


              if (authorsBooksList
                  .where((p0) =>
                      p0.authorDetail.id == creatorList2[evenOdd.value].id)
                  .isEmpty) {
                break;
              }
            }

            if (creatorList2.length > i) {
              http.Response response = await ApiHandler.post(
                  url: "${ApiUrls.baseUrl}Book/${LocalStorage.userId}",
                  body: {
                    "categoryId": "",
                    "start": 0,
                    "length": 20,
                    "searchString": "",
                    "subcategoryIds": "",
                    "authorId": creatorList2[evenOdd.value].id,
                    "sortBy": i == 0 ? "TL" : "",
                    "isFinished": false,
                    "isContinues": false,
                  });

              var decoded = jsonDecode(response.body);

              if (response.statusCode == 200 ||
                  response.statusCode == 201 ||
                  response.statusCode == 202 ||
                  response.statusCode == 203 ||
                  response.statusCode == 204) {
                var decoded = getExploreListModelFromJson(response.body);
                authorsBooksList.add(AuthorBooksData(
                  authorDetail: creatorList2[evenOdd.value],
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
    }
  }

  RxList<CategoryBooksData> categoryBooksList = <CategoryBooksData>[].obs;
  RxList<CategoryBooks> bookListt = <CategoryBooks>[].obs;

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

          // ignore: unused_local_variable
          for (var element in categoryList) {
            int number = 0;

            for (int j = 0; j <= 9999999; j++) {
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
                url: "${ApiUrls.baseUrl}Book/${LocalStorage.userId}",
                body: {
                  "categoryId": categoryList2[number].id,
                  "start": 0,
                  "length": 20,
                  "searchString": "",
                  "subcategoryIds": "",
                  "authorId": "",
                  "sortBy": selectedMenu.value == 0 ? "TL" : "",
                  "isFinished": false,
                  "isContinues": false,
                });

            var decoded = jsonDecode(response.body);

            if (response.statusCode == 200 ||
                response.statusCode == 201 ||
                response.statusCode == 202 ||
                response.statusCode == 203 ||
                response.statusCode == 204) {
              categoryList2[number].alreadySelected = true;
             print(" categoryList2.first.isPremium.toString()${bookList.first.isPremium.toString()}");
              var decoded = getExploreListModelFromJson(response.body);

              decoded.data!.shuffle();
              decoded.data!.toList().shuffle();
              if (categoryBooksList
                      .where((p0) =>
                          p0.categoryDetail.id == categoryList2[number].id)
                      .isEmpty &&
                  decoded.data!.length >= 5) {
                categoryBooksList.add(
                  CategoryBooksData(
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
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;

  LifecycleEventHandler({
    required this.resumeCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}

class CategoryBooksData {
  final category.Category categoryDetail;
  final List<CategoryBooks> booksList;
  final int selectedMenu;
  

  CategoryBooksData({
    required this.categoryDetail,
    required this.booksList,
    required this.selectedMenu,
  });
}

class AuthorBooksData {
  final MeetCreator authorDetail;
  final List<CategoryBooks> booksList;
  final int selectedMenu;

  AuthorBooksData({
    required this.authorDetail,
    required this.booksList,
    required this.selectedMenu,
  });
}
