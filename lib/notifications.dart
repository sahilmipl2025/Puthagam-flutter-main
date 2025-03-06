import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/podcast/podcast_controller.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("====hey");
  showRemoteMessageNotification(message);
}

final PodcastController podcastController = Get.put(PodcastController());

Future<void> showRemoteMessageNotification(RemoteMessage message) async {
  log("receive remote message");
  await LocalStorage.getData();
  podcastController.getLivePodCasts();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Map<String, dynamic> pinpointMessage = message.data;
  log("data $pinpointMessage");
  final String title = pinpointMessage["title"];
  final Map<String, dynamic> body = await json.decode(pinpointMessage["body"]);
  final data = body["data"];
  final rmessage = data["message"];
  return flutterLocalNotificationsPlugin.show(
      math.Random().nextInt(100),
      title,
      rmessage,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // id
          'High Importance Notifications', // title/  ndroid?.smallIcon,
          // other properties...
        ),
      ));
}

class NotificationHandler {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;

  NotificationHandler() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title// description
      importance: Importance.high,
    );
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> firebaseMessagingForegroundHandler(RemoteMessage message) {
    return showRemoteMessageNotification(message);
  }

// Future<void> showBigPictureNotification(
//     Map<String, dynamic> pinpointMessage) async {
//   final String largeIconPath = await _downloadAndSaveFile(
//       pinpointMessage["pinpoint.notification.imageIconUrl"], 'largeIcon');
//   final String bigPicturePath = await _downloadAndSaveFile(
//       pinpointMessage["pinpoint.notification.imageUrl"], 'bigPicture');
//   final BigPictureStyleInformation bigPictureStyleInformation =
//       BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
//           largeIcon: FilePathAndroidBitmap(largeIconPath),
//           contentTitle:
//               '<b>${pinpointMessage["pinpoint.notification.title"]}</b>',
//           htmlFormatContentTitle: true,
//           summaryText: '${pinpointMessage["pinpoint.notification.body"]}',
//           htmlFormatSummaryText: true);
//   final AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//           'big text channel id', 'big text channel name',
//           styleInformation: bigPictureStyleInformation);
//   final NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//       pinpointMessage["pinpoint.campaign.campaign_id"].hashCode,
//       pinpointMessage["pinpoint.notification.title"],
//       pinpointMessage["pinpoint.notification.body"],
//       platformChannelSpecifics);
// }

// Future<void> showBigPictureNotificationHiddenLargeIcon(
//     Map<String, dynamic> pinpointMessage) async {
//   final String bigPicturePath = await _downloadAndSaveFile(
//       pinpointMessage["pinpoint.notification.imageUrl"], 'bigPicture');
//   final BigPictureStyleInformation bigPictureStyleInformation =
//       BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
//           hideExpandedLargeIcon: true,
//           contentTitle:
//               '<b>${pinpointMessage["pinpoint.notification.title"]}</b>',
//           htmlFormatContentTitle: true,
//           summaryText: '${pinpointMessage["pinpoint.notification.body"]}',
//           htmlFormatSummaryText: true);
//   final AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//           'big text channel id', 'big text channel name',
//           styleInformation: bigPictureStyleInformation);
//   final NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//       pinpointMessage["pinpoint.campaign.campaign_id"].hashCode,
//       pinpointMessage["pinpoint.notification.title"],
//       pinpointMessage["pinpoint.notification.body"],
//       platformChannelSpecifics);
// }

// Future<String> _downloadAndSaveFile(String url, String fileName) async {
//   final Directory directory = await getApplicationDocumentsDirectory();
//   final String filePath = '${directory.path}/$fileName';
//   final http.Response response = await http.get(Uri.parse(url));
//   final File file = File(filePath);
//   await file.writeAsBytes(response.bodyBytes);
//   return filePath;
// }
}
