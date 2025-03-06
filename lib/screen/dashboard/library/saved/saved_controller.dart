import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/library/get_saved_book_api.dart';
import 'package:puthagam/model/library/get_saved_book_model.dart';

class SavedController extends GetxController {
  RxBool isConnected = false.obs;
  RxBool isSearch = false.obs;
  RxBool showLoading = false.obs;
  RxBool isLoading = false.obs;
  Rx<TextEditingController> textCon = TextEditingController().obs;
  RxList<SavedBook> savedBookList = <SavedBook>[].obs;

  RxBool paginationLoading = false.obs;
  ScrollController newScrollController = ScrollController();
  RxInt page = 0.obs;
  RxBool nextPageStop = false.obs;

  @override
  void onInit() {
    super.onInit();
    manageScrollController();
  }

  @override
  void onReady() {
    super.onReady();
    getSavedBookApi(pagination: false);
  }

  void manageScrollController() async {
    newScrollController.addListener(
      () {
        if (newScrollController.position.maxScrollExtent ==
            newScrollController.position.pixels) {
          if (nextPageStop.isFalse && paginationLoading.isFalse) {
            getSavedBookApi(pagination: true);
          }
        }
      },
    );
  }
}
