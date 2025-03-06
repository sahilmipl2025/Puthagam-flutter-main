import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:just_audio/just_audio.dart';
import 'package:puthagam/data/api/notification/get_notification_count_api.dart';
import 'package:puthagam/data/api/profile/get_profile_api.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/model/book_detail/get_done_chapters_model.dart';
import 'package:puthagam/model/book_detail/get_subscription_model.dart';
import 'package:puthagam/model/category_books/get_book_chapters_model.dart';
import 'package:puthagam/model/category_books/get_category_books_model.dart';
import 'package:puthagam/model/library/get_queue_model.dart';
import 'package:puthagam/model/library/set_queue_model.dart';
import 'package:puthagam/model/podcast/get_podcast_explore_modal.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

class BaseController extends GetxController {
  RxString userName = "".obs;
  RxString userProfile = "".obs;
  RxString userDOB = "".obs;
  RxString premiumId = "".obs;
  RxBool betaVersion = false.obs;
  RxString getpodcastAccess = "false".obs;

  
  RxBool isBetaVersion = false.obs;
  RxBool alreadyPremium = false.obs;
  RxString isPodcaster = "false".obs;
  RxString currentCountry = "India".obs;

  RxList<CategoryBooks> musicSuggestionBook = <CategoryBooks>[].obs;
  RxList<ExplorePodcast> musicSuggestionPodcasts = <ExplorePodcast>[].obs;
  
  RxInt count = 0.obs;

  RxBool isTextVisible = false.obs;

  RxBool isShared = false.obs;
  RxBool isSubscribed = false.obs;
  RxList downloadBooks = [].obs;

  RxBool currentPlayingIsBook = false.obs;
  RxBool isTried = false.obs;
  RxBool trialRunning = false.obs;
  RxString lastPlanId = "".obs;
  RxString planDuration = "".obs;

  RxInt planStartDate = 0.obs;
  RxInt planEndDate = 0.obs;

  /// Books Detail

  RxString runningBookId = "".obs;
  RxBool isBookIdChanged = false.obs;
  RxBool isPlaying = false.obs;
  RxBool isCompleted = false.obs;
  RxBool isPause = false.obs;
  RxInt currentPlayingIndex = 999.obs;
  RxString runningBookImage = "".obs;
  AudioPlayer audioPlayer = AudioPlayer();

  RxInt notificationCount = 0.obs;

  get countryone => null;

  clearData() {
    runningBookId.value = "";
    isPlaying.value = false;
    isCompleted.value = false;
    isPause.value = false;
    currentPlayingIndex.value = 999;
    runningBookImage.value = "";
    audioPlayer.pause();
    audioPlayer.dispose();
    currentPlayingBookIndex.value = 0;
    booksQueueList.clear();
    queueList.clear();
    currentBookChapterList.clear();
    currentBookDoneChapter.clear();
    downloadCurrentBookChapterList.clear();
    downloadBooks.clear();
    notificationCount.value = 0;
  }

  RxList<QueueBook> queueList = <QueueBook>[].obs;

  RxInt currentPlayingBookIndex = 999.obs;
 final currentcountryone =''.obs;
  RxBool continueQueue = false.obs;
  RxBool continueLoading = false.obs;
  RxList<QueueList> booksQueueList = <QueueList>[].obs;
  RxList<BookChapter> currentBookChapterList = <BookChapter>[].obs;
  RxList<Chapter> currentBookDoneChapter = <Chapter>[].obs;

  /// Download Books Detail

  RxList downloadCurrentBookChapterList = [].obs;

  /// Queue Chapter List

  RxList<QueueChapterModel> queueChapterList = <QueueChapterModel>[].obs;

  getValuesFromLocalStorage() {
    final box = GetStorage();

    if (box.read("history") != null) {
      queueChapterList.clear();
      queueChapterList.value = queueChapterModelFromJson(box.read("history"));
    }
  }

  storeInLocalStorage({required QueueChapterModel data}) {
    final box = GetStorage();
    queueChapterList.add(data);
    box.write("history", jsonEncode(queueChapterList.toJson()));
    getValuesFromLocalStorage();
  }

  removeInLocalStorage({required String bookId}) {
    final box = GetStorage();
    queueChapterList.removeWhere((element) => element.bookId == bookId);
    box.write("history", jsonEncode(queueChapterList.toJson()));
    getValuesFromLocalStorage();
  }

  RxString trialDays = "7".obs;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getValuesFromLocalStorage();
    getNotificationCountApi();
    getcountrydata();
    getCountry();
    getSubscriptionPlanList();
    init();
  }

  init() async {
    await _inAppPurchase.restorePurchases();
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (isAvailable == false) {
      if (premiumId.value.isNotEmpty) {
        deletePremiumApi();
      }
    }
  }

  getCountry() async {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      var data = await http.get(Uri.parse('https://api.ipapi.is/'));
      Map data1 = jsonDecode(data.body);
      String country = data1['country'];
   //   currentCountry.value = country.toLowerCase();
      
    }
  }

  Future<void> getcountrydata() async {

  final response = await http.get(Uri.parse('https://api.ipapi.is/'));

  

  if (response.statusCode == 200) {

    // Parse the JSON response

      final Map<String, dynamic> data = json.decode(response.body);
     
      //      String country = data1['country'];
      // currentCountry.value = country.toLowerCase();
      String countryone = data['location']['country'].toString();
     currentcountryone.value  = countryone.toLowerCase();
      print("Countryinapinewww${countryone}");

    // Now you can work with the data

    print("getccountry${response.body}");

  } else {

    // Handle errors

    print('Failed to fetch data: ${response.statusCode}');

  }

}
  // getCountry() async {
  //   bool connection =
  //       await NetworkInfo(connectivity: Connectivity()).isConnected();
  //   if (connection) {
  //     var data = await http.get(Uri.parse('http://ip-api.com/json'));
  //     Map data1 = jsonDecode(data.body);
  //     String country = data1['country'];
  //     currentCountry.value = country.toLowerCase();
      
  //   }
  // }

  deletePremiumApi() async {
    try {
      bool connection =
          await NetworkInfo(connectivity: Connectivity()).isConnected();
      if (connection) {
        http.Response response = await http.delete(
          Uri.parse('${ApiUrls.baseUrl}SubscriptionPlan'),
          body: jsonEncode({
            "userId": LocalStorage.userId,
            "subscriptionId": premiumId.value
          }),
          headers: {
            "accept": "text/plain",
            "Content-Type": "application/json",
          },
        );

        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          LocalStorage.storedToken(decoded, false);
          await getUserProfileApi();
          Get.back();
          toast(decoded['message'], false);
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['message'], false);
        } else {
          toast(decoded['message'], false);
        }
      } else {
        toast("No Internet Connection!", false);
      }
    } catch (e) {
      // toast(e.toString(), false);
    }
  }

  getSubscriptionPlanList() async {
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
                  '${ApiUrls.baseUrl}User/${LocalStorage.userId}/SubscriptionPlans');

          var decoded = jsonDecode(response.body);
          if (response.statusCode == 200 ||
              response.statusCode == 201 ||
              response.statusCode == 202 ||
              response.statusCode == 203 ||
              response.statusCode == 204) {
            var decoded = getSubscriptionModelFromJson(response.body);

            trialDays.value = decoded.trialDays ?? "5";
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
}

class QueueList {
  final String bookId;
  final bool isPodcast;
  final String bookTitle;
  final String bookImage;
  final String categoryId;
  final List<BookChapter> bookChapter;

  QueueList({
    required this.bookId,
    required this.bookTitle,
    required this.isPodcast,
    required this.bookImage,
    required this.bookChapter,
    required this.categoryId,
  });
}
