import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:puthagam/screen/dashboard/profile/setting/setting_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final SettingController con = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: verticalGradient),
        width: Get.width,
        height: Get.height,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(gradient: verticalGradient),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20 : 16,
                    vertical: isTablet ? 20 : 16),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 24 : 20),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: isTablet ? 20 : 16),
                      Container(
                        decoration: BoxDecoration(
                          gradient: verticalGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: isTablet ? 20 : 16),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 20 : 16),
                                  child: Text(
                                    'Notification',
                                    style: TextStyle(
                                      fontSize: isTablet ? 18 : 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(height: isTablet ? 6 : 4),
                                const Divider(color: Colors.white),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: isTablet ? 20 : 16),
                                  child: InkWell(
                                    onTap: () =>
                                        Get.toNamed(AppRoutes.notificationPage),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Push notifications',
                                          style: TextStyle(
                                            fontSize: isTablet ? 17 : 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        IconButton(
                                          onPressed: () => Get.toNamed(
                                              AppRoutes.notificationPage),
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            size: isTablet ? 24 : 20,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: isTablet ? 6 : 4),
                                const Divider(color: Colors.white),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: isTablet ? 20 : 16),
                                  child: InkWell(
                                    onTap: () => Get.toNamed(
                                        AppRoutes.whatsappScreen,
                                        arguments: false),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Whatsapp Notification',
                                          style: TextStyle(
                                            fontSize: isTablet ? 17 : 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Get.toNamed(
                                              AppRoutes.whatsappScreen,
                                              arguments: false,
                                            );
                                          },
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            size: isTablet ? 24 : 20,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: isTablet ? 6 : 4),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 20 : 16),
                      Container(
                        decoration: BoxDecoration(
                          gradient: verticalGradient,
                          borderRadius:
                              BorderRadius.circular(isTablet ? 16 : 12),
                        ),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: isTablet ? 20 : 16),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 20 : 16),
                                  child: Text(
                                    'Audio settings',
                                    style: TextStyle(
                                      fontSize: isTablet ? 17 : 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(height: isTablet ? 12 : 8),
                                const Divider(color: Colors.white),
                                SizedBox(height: isTablet ? 12 : 8),
                                InkWell(
                                  onTap: () async {
                                    con.autoPlay.toggle();

                                    var box = GetStorage();

                                    await box.write(
                                        Prefs.autoPlay, con.autoPlay.value);
                                    LocalStorage.autoPlay = con.autoPlay.value;
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: isTablet ? 20 : 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                bottom: isTablet ? 12 : 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'autoPlay'.tr,
                                                  style: TextStyle(
                                                    fontSize:
                                                        isTablet ? 17 : 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(
                                                    height: isTablet ? 6 : 4),
                                                Text(
                                                  'autoplaytxt'.tr,
                                                  style: TextStyle(
                                                    fontSize:
                                                        isTablet ? 15 : 13,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        IconButton(
                                          icon: Obx(() => Image.asset(
                                                'assets/images/checkmark.png',
                                                height: isTablet ? 30 : 25,
                                                width: isTablet ? 30 : 25,
                                                color: con.autoPlay.value
                                                    ? Colors.green
                                                    : Colors.white,
                                              )),
                                          onPressed: () async {
                                            con.autoPlay.toggle();

                                            var box = GetStorage();

                                            await box.write(Prefs.autoPlay,
                                                con.autoPlay.value);
                                            LocalStorage.autoPlay =
                                                con.autoPlay.value;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(color: Colors.white),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 20 : 16),
                                  child: InkWell(
                                    onTap: () async {
                                      con.downloadWithMobile.toggle();

                                      var box = GetStorage();

                                      await box.write(
                                          Prefs.downloadWithMobileData,
                                          con.downloadWithMobile.value);
                                      LocalStorage.downloadWithMobileData =
                                          con.downloadWithMobile.value;
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Download with mobile data ',
                                            style: TextStyle(
                                              fontSize: isTablet ? 17 : 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        SizedBox(width: isTablet ? 16 : 12),
                                        IconButton(
                                          icon: Obx(() => Image.asset(
                                                'assets/images/checkmark.png',
                                                height: isTablet ? 30 : 25,
                                                width: isTablet ? 30 : 25,
                                                color:
                                                    con.downloadWithMobile.value
                                                        ? Colors.green
                                                        : Colors.white,
                                              )),
                                          onPressed: () async {
                                            con.downloadWithMobile.toggle();

                                            var box = GetStorage();

                                            await box.write(
                                                Prefs.downloadWithMobileData,
                                                con.downloadWithMobile.value);
                                            LocalStorage
                                                    .downloadWithMobileData =
                                                con.downloadWithMobile.value;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: isTablet ? 12 : 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 30 : 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
