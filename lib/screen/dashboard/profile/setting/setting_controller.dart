import 'package:get/get.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';

class SettingController extends GetxController {
  RxBool status1 = Get.isDarkMode.obs;
  RxBool downloadWithMobile = false.obs;
  RxBool autoPlay = false.obs;
  RxBool colorshow = false.obs;

  @override
  void onReady() {
    super.onReady();
    downloadWithMobile.value = LocalStorage.downloadWithMobileData;
    autoPlay.value = LocalStorage.autoPlay;
  }
}
