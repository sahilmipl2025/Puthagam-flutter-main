import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:audio_service/audio_service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart'; 
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/api_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/collection_books/collection_books_controller.dart';
import 'package:puthagam/screen/dashboard/library/downloads/book_detail/download_book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/library/history/history_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/base_controller.dart';
import 'package:puthagam/utils/lang/localization_service.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';
import 'package:puthagam/utils/themes/global.dart';
import 'package:puthagam/utils/themes/theme.dart';
import 'package:http/http.dart' as http;
import 'amplifyconfiguration.dart';

BaseController? baseController;
FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  Stripe.publishableKey = '${dotenv.env['STRIPE_PUBLISH']}';

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Puthagam',
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true,
  );

  baseController = Get.put(BaseController());
  await setFirebase();
  await Firebase.initializeApp();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  await GetStorage.init();
  await LocalStorage.getData();
  LazyBindings().dependencies();
  HttpOverrides.global = MyHttpOverrides();
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(minutes: 1),
  ));
  bool connection = await NetworkInfo(connectivity: Connectivity()).isConnected();
  if (connection) {
    await remoteConfig.fetchAndActivate();
  }
  FirebaseMessaging.instance.getToken().then((value) {
    print("stringtokenvalue${value}");
  });
  appInit();
}

Future<void> setFirebase() async {
  if (kIsWeb) {

    // Facebook authentication initialization for web should be done in the HTML file
    // Refer to the flutter_facebook_auth documentation for more details
 
 
    // await FacebookAuth.i.webInitialize(
    //   appId: "5463265673794150",
    //   cookie: true,
    //   xfbml: true,
    //   version: "v13.0",
    // );
  }
  await Firebase.initializeApp();
  await firebaseMessaging();
}

class LazyBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<DownloadBookDetailController>(() => DownloadBookDetailController(), fenix: true);
    Get.lazyPut<BookDetailController>(() => BookDetailController(), fenix: true);
    Get.lazyPut<BookDetailApiController>(() => BookDetailApiController(), fenix: true);
    Get.lazyPut<HistoryController>(() => HistoryController(), fenix: true);
    Get.lazyPut<CollectionBooksController>(() => CollectionBooksController(), fenix: true);
  }
}

GlobalKey<NavigatorState> navigationKey = GlobalKey(debugLabel: 'Main Navigator');

void appInit() async {
  Get.put<GlobalService>(GlobalService());
  runApp(const AudioServiceWidget(child: MyApp()));
}

class MyApp extends StatefulWidget {
  
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    GlobalService.to.switchThemeModel();
    _configureAmplify();
    fetchLinkData();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      baseController!.audioPlayer.dispose();
    }
  }

  Future<void> _configureAmplify() async {
    final authPlugin = AmplifyAuthCognito();
    final analyticsPlugin = AmplifyAnalyticsPinpoint();
    await amplify_core.Amplify.addPlugins([authPlugin, analyticsPlugin]);

    try {
      await amplify_core.Amplify.configure(amplifyconfig);
    } on amplify_core.AmplifyAlreadyConfiguredException {
      amplify_core.safePrint("Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  void fetchLinkData() async {
    var link = await FirebaseDynamicLinks.instance.getInitialLink();
    handleLinkData(link);

    dynamicLinks.onLink.listen((PendingDynamicLinkData dynamicLink) async {
      handleLinkData(dynamicLink);
    });
  }

  void handleLinkData(PendingDynamicLinkData? data) {
    final Uri? uri = data?.link;
    if (uri != null) {
      final queryParams = uri.queryParameters['room_id'];
      print("My users username is: $queryParams");

      if (queryParams == null) {
        // Get.to(const LaunchScreen(), arguments: [queryParams]);
      } else {
        // fromDeepLink = true;
        // newRoomToJoin = queryParams;
        // Get.to(const LaunchScreen());
        // Get.to(const RoomIdScreen(), arguments: [queryParams]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GetMaterialApp(
      title: 'Magic Tamil',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        fontFamily: 'SF-Pro-Display',
        sliderTheme: const SliderThemeData(showValueIndicator: ShowValueIndicator.never),
      ),
      darkTheme: AppTheme.dark,
      translations: LocalizationService(),
      locale: LocalizationService().getCurrentLocale(),
      fallbackLocale: const Locale('en', 'US'),
      defaultGlobalState: Stripe.setReturnUrlSchemeOnAndroid,
      defaultTransition: Transition.cupertino,
      getPages: AppRoutes.pages,
      initialRoute: AppRoutes.splashScreen,
      initialBinding: LazyBindings(),
      navigatorKey: navigationKey,
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
AndroidNotificationChannel? channel;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message ${message.messageId}');
}

Future<void> firebaseMessaging() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel(
    "high_importance_channel",
    "High Importance Notifications",
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  await flutterLocalNotificationsPlugin!
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);

  await flutterLocalNotificationsPlugin!
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic> payload = message.data;

    if (notification != null) {
      flutterLocalNotificationsPlugin!.show(
        notification.hashCode,
        notification.title ?? "",
        notification.body ?? "",
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel!.id,
            channel!.name,
            channelDescription: channel!.description,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: jsonEncode(payload),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    debugPrint("onMessageOpenedApp Called ");
    await Firebase.initializeApp();

    if (message.toString() != "null") {
      if (message.data.toString() != "null") {
        if (LocalStorage.userId.toString() != "null" && LocalStorage.userId.toString() != "") {
          if (message.data['notificationType'].toString() == "addPodcast") {
            if (message.data['id'].toString() != "" && message.data['id'].toString() != "null") {
              await Get.toNamed(AppRoutes.bookDetailScreen, arguments: message.data['id'].toString());
              await Get.find<BookDetailController>().callApis(bookID: message.data['id'].toString());
            }
          } else if (message.data['notificationType'].toString() == "addBook") {
            if (message.data['id'].toString() != "" && message.data['id'].toString() != "null") {
              await Get.toNamed(AppRoutes.bookDetailScreen, arguments: message.data['id'].toString());
              await Get.find<BookDetailController>().callApis(bookID: message.data['id'].toString());
            }
          }
        }
      }
    }
  });

  FirebaseMessaging.instance.getInitialMessage().then((message) async {
    debugPrint("getInitialMessage Called ");
    if (message != null) {
      await Firebase.initializeApp();
      Future.delayed(const Duration(seconds: 3)).then((val) async {
        if (message.toString() != "null") {
          if (message.data.toString() != "null") {
            if (LocalStorage.userId.toString() != "null" && LocalStorage.userId.toString() != "") {
              if (message.data['notificationType'].toString() == "addPodcast") {
                if (message.data['id'].toString() != "" && message.data['id'].toString() != "null") {
                  await Get.toNamed(AppRoutes.bookDetailScreen, arguments: message.data['id'].toString());
                  await Get.find<BookDetailController>().callApis(bookID: message.data['id'].toString());
                }
              } else if (message.data['notificationType'].toString() == "addBook") {
                if (message.data['id'].toString() != "" && message.data['id'].toString() != "null") {
                  await Get.toNamed(AppRoutes.bookDetailScreen, arguments: message.data['id'].toString());
                  await Get.find<BookDetailController>().callApis(bookID: message.data['id'].toString());
                }
              }
            }
          }
        }
      });
    }
  });
}

Future onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async {
  debugPrint("iOS notification $title $body $payload");
}