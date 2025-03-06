import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/notification/get_notification_api.dart';
import 'package:puthagam/model/notification/get_notification_model.dart';

class NotificationListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool showLoading = false.obs;
  RxBool paginationLoading = false.obs;
  RxBool isConnected = false.obs;
  RxBool nextPageStop = false.obs;
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;
  RxInt page = 0.obs;
  ScrollController newScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    manageScrollController();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getNotificationsApi(pagination: false);
  }

  void manageScrollController() async {
    newScrollController.addListener(
      () {
        if (newScrollController.position.maxScrollExtent ==
            newScrollController.position.pixels) {
          if (nextPageStop.isFalse) {
            getNotificationsApi(pagination: true);
          }
        }
      },
    );
  }
}
