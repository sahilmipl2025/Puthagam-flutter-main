import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:puthagam/data/api/category/get_category_list_api.dart';
import 'package:puthagam/data/api/home/get_continue_api.dart';
import 'package:puthagam/data/api/home/get_explore_list_api.dart';
import 'package:puthagam/data/api/profile/get_profile_api.dart';
import 'package:puthagam/data/api/profile/get_users_purchase_list_api.dart';
import 'package:puthagam/model/category/get_category_list_model.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';

class SelectTopicController extends GetxController {
  RxString selectedId = "".obs;
  RxBool isLoading = false.obs;
  RxBool selectedValue = false.obs;
  RxBool showLoading = false.obs;

  RxList<Category> categoryList = <Category>[].obs;

  @override
  void onReady() {
    super.onReady();
    getCategoryListApi();
    LocalStorage.getData();
  }

  storeSelectedCategory() async {

    List selectedCategory = [];

    for (var element in categoryList) {
      if (element.isSelected!.value) {
        selectedCategory.add(element.id);
        
        print("selectedCategory${selectedCategory.length}");
      }
    }

    if (selectedCategory.isNotEmpty) {
      var box = GetStorage();
      await box.write(Prefs.selectedCategory, jsonEncode(selectedCategory));
      print("categoryaftersaselectcateogry${box}");

      getUserProfileApi();
      getPurchasesListApi();
      if (Get.arguments == false) {
        HomeController hCon = Get.put(HomeController());
        hCon.callAllApis();
        Get.offAllNamed(AppRoutes.bottomBarScreen);
        getExploreListApi();
        getContinueListenListApi();
      } else {
        Get.back();
        getCategoryListApi();
        getExploreListApi();
        getContinueListenListApi();
      }
    } else {
      toast("Select at least one category to continue", false);
    }
  }
}
