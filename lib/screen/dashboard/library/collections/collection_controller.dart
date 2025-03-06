import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/collection/get_collections_api.dart';
import 'package:puthagam/model/library/get_collection_model.dart';

class CollectionController extends GetxController {
  RxString selectedId = "".obs;
  RxBool isConnected = false.obs;
  RxBool isLoading = false.obs;
  RxBool status1 = false.obs;
  RxBool showLoading = false.obs;
  RxBool themeManager = false.obs;
  int id = 1;

  Rx<TextEditingController> controller = TextEditingController().obs;
  RxList<CollectionModel> collectionList = <CollectionModel>[].obs;

  @override
  void onReady() {
    super.onReady();
    getCollectionList();
  }
}
