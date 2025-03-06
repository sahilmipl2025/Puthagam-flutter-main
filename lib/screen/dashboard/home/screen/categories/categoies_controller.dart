import 'package:get/get.dart';
import 'package:puthagam/model/category/get_category_list_model.dart';

class CategoriesController extends GetxController {
  RxList<Category> categoryList = <Category>[].obs;

  @override
  void onReady() {
    super.onReady();
    categoryList.value = Get.arguments[0];
  }
}
