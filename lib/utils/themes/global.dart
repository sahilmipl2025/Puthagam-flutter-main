import 'package:get/get.dart';

import 'theme.dart';

class GlobalService extends GetxService {
  static GlobalService get to => Get.find();

  // 是否黑暗模式
  final RxBool _isDarkModel = false.obs;

  bool get isDarkModel => _isDarkModel.value;

  // 切换模式
  void switchThemeModel() {
    _isDarkModel.value = !_isDarkModel.value;
    Get.changeTheme(
      _isDarkModel.value == true ? AppTheme.dark : AppTheme.light,
    );
  }

  void switchThemeModel12() {}
}
