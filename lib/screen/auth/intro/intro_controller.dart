import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/common/get_started_api.dart';
import 'package:puthagam/model/get_started_model.dart';

class IntroController extends GetxController {
  PageController pageController = PageController(initialPage: 0);
  int numPages = 3;
  RxInt currentPage = 0.obs;
  RxBool end = false.obs;
  RxBool isLoading = false.obs;
  RxList<GetStartedModel> getStartedList = <GetStartedModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    timer();
  }

  Timer? timers;

  timer() {
    timers = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (currentPage.value == 2) {
        end.value = true;
      } else if (currentPage.value == 0) {
        end.value = false;
      }

      if (end.value == false) {
        currentPage.value++;
      } else {
        currentPage.value = 0;
      }

      if (pageController.hasClients) {
        pageController.animateToPage(
          currentPage.value,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    getStartedApi();
  }
}
