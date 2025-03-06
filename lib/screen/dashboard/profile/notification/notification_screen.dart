import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:puthagam/screen/dashboard/profile/notification/notification_controller.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';

class PushNotification extends StatelessWidget {
  PushNotification({Key? key}) : super(key: key);
  final NotificationController con = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(gradient: verticalGradient),
        child: Stack(
          children: [
            SizedBox(
              height: Get.height,
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(gradient: verticalGradient),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
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
                            const Expanded(
                              child: Center(
                                child: Text(
                                  'Push notification',
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                  gradient: verticalGradient,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      'Habit building',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Divider(color: Colors.white),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  'New book reminder',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  'Get a reminder about every new book from your categories of interest',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Obx(
                                          () => FlutterSwitch(
                                            width: 50,
                                            height: 25,
                                            activeIcon: Icon(
                                              Icons.check,
                                              size: 16,
                                              color: commonBlueColor,
                                            ),
                                            inactiveIcon: const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                            padding: 1,
                                            inactiveColor: borderColor,
                                            activeColor: commonBlueColor,
                                            value: con.status.value,
                                            onToggle: (val) {
                                              con.dailyNotification();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                gradient: verticalGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 16),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          'Updates',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: Divider(color: Colors.white),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      'Products update',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      'New features and improvement to your application',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Obx(
                                              () => FlutterSwitch(
                                                width: 50,
                                                height: 25,
                                                activeIcon: Icon(
                                                  Icons.check,
                                                  size: 16,
                                                  color: commonBlueColor,
                                                ),
                                                inactiveIcon: const Icon(
                                                  Icons.check,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                                padding: 1,
                                                inactiveColor: borderColor,
                                                activeColor: commonBlueColor,
                                                value: con.status2.value,
                                                onToggle: (val) {
                                                  con.status2.value = val;
                                                  var box = GetStorage();

                                                  box.write(Prefs.productUpdate,
                                                      con.status2.value);
                                                  LocalStorage.productUpdate =
                                                      con.status2.value;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(color: Colors.white),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      'Podcasts',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      'Get notified about new podcasts episodes you might like',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Obx(
                                              () => FlutterSwitch(
                                                width: 50,
                                                height: 25,
                                                activeIcon: Icon(
                                                  Icons.check,
                                                  size: 16,
                                                  color: commonBlueColor,
                                                ),
                                                inactiveIcon: const Icon(
                                                  Icons.check,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                                padding: 1,
                                                inactiveColor: borderColor,
                                                activeColor: commonBlueColor,
                                                value: con.status3.value,
                                                onToggle: (val) {
                                                  con.podcastNotification();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => con.savedLoading.value
                ? Container(
                    height: Get.height,
                    width: Get.width,
                    color: Colors.grey.withOpacity(0.4),
                    child: const AppLoader(),
                  )
                : const SizedBox())
          ],
        ),
      ),
    );
  }
}
