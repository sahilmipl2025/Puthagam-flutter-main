import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/api/library/get_queue_chapter_list_api.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/model/category_books/get_book_chapters_model.dart';
import 'package:puthagam/model/library/get_queue_model.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';

getQueueListApi() async {
  // try {
  bool connection =
      await NetworkInfo(connectivity: Connectivity()).isConnected();
  if (connection) {
    await LocalStorage.getData();
    if (LocalStorage.token.toString() != "null" &&
        LocalStorage.token.toString().isNotEmpty &&
        LocalStorage.userId.toString() != "null" &&
        LocalStorage.userId.toString() != "") {
      http.Response response = await ApiHandler.post(
          url: ApiUrls.baseUrl +
              ApiUrls.editProfile +
              LocalStorage.userId +
              '/Queue',
          body: {
            "categoryId": "",
            "start": 0,
            "length": 100,
            "searchString": "",
            "subcategoryIds": "",
            "authorId": "",
            "sortBy": ""
          });

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 203 ||
          response.statusCode == 204) {
        var decoded = getQueueModelFromJson(response.body);
        for (var element in decoded.data!) {
          if (baseController!.queueList
              .where((p0) => p0.id == element.id)
              .isEmpty) {
            RxList<BookChapter> chapter =
                await getQueueBookChaptersApi(bookId: element.id);

            element.bookChapterList = chapter;
            baseController!.queueList.add(element);
          }
        }
      } else if (response.statusCode == 401) {
        LocalStorage.clearData();
      } else {}
    }
  } else {
    toast("No Internet Connection!", false);
  }
  // } catch (e) {
  //   // toast(e.toString(), false);
  // }
}
