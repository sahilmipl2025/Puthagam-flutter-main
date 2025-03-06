import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:puthagam/data/services/dynamic_link_service.dart';
import 'package:puthagam/screen/dashboard/home/home_screen.dart';
import 'package:puthagam/screen/dashboard/library/library_page/library_page.dart';
import 'package:puthagam/screen/dashboard/podcast/podcast_page.dart';
import 'package:puthagam/screen/dashboard/profile/profile_page/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomBarController extends GetxController {
  RxInt selectedIndex = 0.obs;
  bool canback = false;

  List widgetOptions = [
    HomeScreen(),
    const LibrarayPage(),
    PodcastPage(),
    const ProfileScreen()
  ];

  @override
  void onReady() {
    super.onReady();
    fetchDynamicLinks();
    basicStatusCheck();
  }

basicStatusCheck() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  // Fetch and activate Remote Config
  await remoteConfig.fetchAndActivate();

  final isForceUpdate = remoteConfig.getBool("force_update_required");
  if (isForceUpdate) {
    bool allowDismissal = remoteConfig.getBool("show_dismissal");
    String forcedVersion = Platform.isIOS
        ? remoteConfig.getString("force_update_ios_version")
        : remoteConfig.getString("force_update_android_version");

    final newVersion = NewVersionPlus(
      forceAppVersion: forcedVersion,
      iOSId: 'com.app.puthagam',
      androidId: 'com.app.puthagam',
    );

    final version = await newVersion.getVersionStatus();

    if (version != null) {
      print("Local Version: ${version.localVersion}");
      print("Store Version: ${version.storeVersion}");
      print("App Store Link: ${version.appStoreLink}");

      // Only show dialog if local version < forced version
      if (version.localVersion != forcedVersion) {
        newVersion.showUpdateDialog(
          context: Get.context!,
          versionStatus: version,
       //   launchMode: LaunchMode.externalApplication,
          allowDismissal: allowDismissal,
          dialogText:
              'Please install the new version for improved functionality.',
          updateButtonText: 'Upgrade',
          dialogTitle: 'Upgrade MagicTamil app!',
        );
      } else {
        print("App is up to date!");
      }
    } else {
      print("Version information not available");
    }
  }
}

  // basicStatusCheck() async {
  //   final remoteConfig = FirebaseRemoteConfig.instance;
  //   if (remoteConfig.getBool("force_update_required")) {
  //     bool showDismissal = await remoteConfig.getBool("show_dismissal");
  //     final versionForce = Platform.isIOS
  //         ? remoteConfig.getString("force_update_ios_version")
  //         : remoteConfig.getString("force_update_android_version");
  //     final newVersion = NewVersionPlus(
  //       forceAppVersion: versionForce,
  //       iOSId: 'com.app.puthagam',
  //       androidId: 'com.app.puthagam',
  //     );
  //     const simpleBehavior = true;
  //     if (simpleBehavior) {
  //       final version = await newVersion.getVersionStatus();
  //       if (version?.localVersion != versionForce) {
  //         newVersion.showUpdateDialog(
  //             context: Get.context!,
  //             versionStatus: version!,
  //             launchMode: LaunchMode.externalApplication,
  //             allowDismissal: showDismissal,
  //             dialogText:
  //                 'Please install now the new version. We made improvements to functionality that will enhance your experience. ',
  //             updateButtonText: 'Upgrade',
  //             dialogTitle: 'Upgrade MagicTamil app!');
  //       }
  //     }
  //   }
  // }

  fetchDynamicLinks() async {
    await DynamicLinkServices.initDynamicLinks();
  }
}
