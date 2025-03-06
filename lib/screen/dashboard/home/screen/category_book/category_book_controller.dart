import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/category_book/get_category_books_api.dart';

import 'package:puthagam/model/category_books/get_category_books_model.dart';

class CategoryBookController extends GetxController {
  RxString selectedAuthorId = "".obs;
  RxBool isConnected = false.obs;
  RxBool savedLoading = false.obs;

  RxBool status2 = false.obs;
  RxString categoryId = "".obs;
  RxString categoryImage = "".obs;
  RxString categoryName = "".obs;
  RxInt totalBooks = 0.obs;

  RxBool isLoading = false.obs;
  RxBool status1 = false.obs;
  RxList<CategoryBooks> booksList = <CategoryBooks>[].obs;

  RxString selectedSubCatId = "".obs;

  RxBool paginationLoading = false.obs;
  ScrollController newScrollController = ScrollController();
  RxInt page = 0.obs;
  RxBool nextPageStop = false.obs;

  @override
  void onInit() {
    super.onInit();
    manageScrollController();
  }

  void manageScrollController() async {
    newScrollController.addListener(
      () {
        if (newScrollController.position.maxScrollExtent ==
            newScrollController.position.pixels) {
          if (nextPageStop.isFalse && paginationLoading.isFalse) {
            getCategoryBooksApi(
              pagination: true,
              categoryId: categoryId.value,
            );
          }
        }
      },
    );
  }
}
