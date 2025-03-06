import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:puthagam/main.dart';
import 'package:puthagam/model/library/get_queue_model.dart';

class QueueController extends GetxController {
  RxBool isSearch = false.obs;
  RxList<QueueBook> searchList = <QueueBook>[].obs;
  TextEditingController searchController = TextEditingController();

  searchFilter() {
    searchList.clear();
    for (var element in baseController!.queueList) {
      if (element.title!
          .toLowerCase()
          .trim()
          .contains(searchController.text.toLowerCase())) {
        if (!searchList.contains(element)) {
          searchList.add(element);
        }
      }
    }
  }
}
