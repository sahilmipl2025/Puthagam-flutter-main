import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:puthagam/screen/auth/forget_pass/forgot_pass_screen.dart';
import 'package:puthagam/screen/auth/intro/intro_screen.dart';
import 'package:puthagam/screen/auth/login/login_screen.dart';
import 'package:puthagam/screen/auth/otp_screen/otp_screen.dart';
import 'package:puthagam/screen/auth/reset_password/reset_pass_screen.dart';
import 'package:puthagam/screen/auth/select_topic/select_topic_screen.dart';
import 'package:puthagam/screen/auth/signup/signup_screen.dart';
import 'package:puthagam/screen/auth/splash/splash_screen.dart';
import 'package:puthagam/screen/auth/verification/verification_screen.dart';
import 'package:puthagam/screen/dashboard/bottom_navigation/bottom_bar_screen.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_screen.dart';
import 'package:puthagam/screen/dashboard/home/screen/collection_books/collection_books_screen.dart';
import 'package:puthagam/screen/dashboard/home/screen/creator_books/creator_books_screen.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/screen/information_page.dart';
import 'package:puthagam/screen/dashboard/home/screen/meet_creator/meet_creator_screen.dart';
import 'package:puthagam/screen/dashboard/library/downloads/book_detail/download_book_detail.dart';
import 'package:puthagam/screen/dashboard/notification/notification_screen.dart';
import 'package:puthagam/screen/dashboard/podcast/screen/explore_podcast/explore_podcast_screen.dart';
import 'package:puthagam/screen/dashboard/podcast/screen/podcast_categories/podcast_categories_screen.dart';
import 'package:puthagam/screen/dashboard/podcast/screen/week_podcast/week_podcast_screen.dart';
import 'package:puthagam/screen/dashboard/premium/failed_screen.dart';
import 'package:puthagam/screen/dashboard/premium/payment_webview_screen.dart';
import 'package:puthagam/screen/dashboard/premium/premium_screen.dart';
import 'package:puthagam/screen/dashboard/premium/success_screen.dart';
import 'package:puthagam/screen/dashboard/profile/abuot_us/about_us.dart';
import 'package:puthagam/screen/dashboard/profile/edit_profile/edit_profile.dart';
import 'package:puthagam/screen/dashboard/profile/feedback/Feedback_screen.dart';
import 'package:puthagam/screen/dashboard/profile/notification/notification_screen.dart';
import 'package:puthagam/screen/dashboard/profile/premium_ios/premium_ios_screen.dart';
import 'package:puthagam/screen/dashboard/profile/privacy_policy/privacy_page.dart';
import 'package:puthagam/screen/dashboard/profile/purchase_list/purchase_list_screen.dart';
import 'package:puthagam/screen/dashboard/profile/redeem_code/redeem_code_screen.dart';
import 'package:puthagam/screen/dashboard/profile/setting/setting_page.dart';
import 'package:puthagam/screen/dashboard/profile/subscription/subcription_page.dart';
import 'package:puthagam/screen/dashboard/profile/term_sevices/term_service.dart';
import 'package:puthagam/screen/dashboard/profile/transaction/transcation_details_screen.dart';
import 'package:puthagam/screen/dashboard/profile/whatsapp_page/whats_app_page.dart';

import '../screen/paymentscreen/payemntscreen.dart';

class AppRoutes {
  static String splashScreen = '/splashScreen';
  static String introScreen = '/introScreen';
  static String loginScreen = '/loginScreen';
  static String otpScreen = '/otpScreen';
  static String signUpScreen = '/signUpScreen';
  static String forgotPasswordScreen = '/forgotPasswordScreen';
  static String verificationScreen = '/verificationScreen';
  static String resetPassScreen = '/resetPassScreen';
  static String selectTopicsScreen = '/selectTopicsScreen';
  static String bottomBarScreen = '/bottomBarScreen';
  static String bookDetailScreen = '/bookDetailScreen';
  static String categoryBookScreen = '/categoryBookScreen ';
  static String informationPage = '/informationPage';
  static String aboutUsPage = '/aboutUsPage';
  static String notificationListScreen = '/notificationListScreen';
  static String editProfilePage = '/editProfilePage';
  static String feedbackPage = '/feedbackPage';
  static String notificationPage = '/notificationPage';
  static String privacyPage = '/privacyPage';
  static String profilePage = '/profilePage';
  static String settingPage = '/settingPage';
  static String subscriptionPage = '/subscriptionPage';
  static String termConditionsPage = '/termConditionsPage';
  static String premiumSubscriptionPage = '/premiumSubscriptionPage';
  static String premiumIosScreen = '/premiumIosScreen';
  static String collectionBooksScreen = '/collectionBooksScreen';
  static String creatorBooksScreen = '/creatorBooksScreen';
  static String meetCreatorScreen = '/meetCreatorScreen';

  // static String collectionListScreen = '/collectionListScreen';
  static String paymentWebViewScreen = '/paymentWebViewScreen';
  static String downloadBookDetailScreen = '/downloadBookDetailScreen';
  static String podcastCategoriesScreen = '/podcastCategoriesScreen';
  static String explorePodcastScreen = '/explorePodcastScreen';
  static String weekPodcastScreen = '/weekPodcastScreen';
  static String redeemCodeScreen = '/redeemCodeScreen';
  static String successScreen = '/successScreen';
  static String failedScreen = '/failedScreen';
  static String whatsappScreen = '/whatsappScreen';
  static String transactionDetailsScreen = '/TransactionDetailsScreen';
  static String purchaseListScreen = '/PurchaseListScreen';
  static String paymentPage = '/PaymentPage';
  static String stripeScreen = '/stripeScreen';
  

  static List<GetPage> pages = [
  //  GetPage(name: stripeScreen, page: () =>stripeScreen()),
    GetPage(name: paymentPage, page: () => PaymentPage()),
     GetPage(name: otpScreen, page: () => OtpScreen()),
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: introScreen, page: () => IntroScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPassScreen()),
    GetPage(name: verificationScreen, page: () => const VerificationScreen()),
    GetPage(name: resetPassScreen, page: () => ResetPassScreen()),
    GetPage(name: selectTopicsScreen, page: () => SelectTopicsScreen()),
    GetPage(name: bottomBarScreen, page: () => BottomBarScreen()),
    GetPage(name: bookDetailScreen, page: () => BookDetailScreen()),
    GetPage(name: informationPage, page: () => InformationPage()),
    GetPage(name: aboutUsPage, page: () => AboutPage()),
    GetPage(name: editProfilePage, page: () => EditProfilePage()),
    GetPage(name: feedbackPage, page: () => FeedbackScreen()),
    GetPage(name: notificationPage, page: () => PushNotification()),
    GetPage(name: privacyPage, page: () => PrivacyPolicy()),
    GetPage(name: settingPage, page: () => const SettingPage()),
    GetPage(name: termConditionsPage, page: () => TermConditions()),
    GetPage(name: subscriptionPage, page: () => SubscriptionPage()),
    GetPage(name: premiumSubscriptionPage, page: () => const PremiumScreen()),
    GetPage(name: premiumIosScreen, page: () => const PremiumIosScreen()),
    GetPage(name: collectionBooksScreen, page: () => CollectionBooksScreen()),
    GetPage(name: creatorBooksScreen, page: () => CreatorBooksScreen()),
    GetPage(name: meetCreatorScreen, page: () => MeetCreatorScreen()),
    // GetPage(name: collectionListScreen, page: () => CollectionListScreen()),
    GetPage(name: paymentWebViewScreen, page: () => PaymentWebViewScreen()),
    GetPage(
        name: downloadBookDetailScreen, page: () => DownloadBookDetailScreen()),
    GetPage(
        name: podcastCategoriesScreen, page: () => PodcastCategoriesScreen()),
    GetPage(name: explorePodcastScreen, page: () => ExplorePodcastScreen()),
    GetPage(name: weekPodcastScreen, page: () => WeekPodcastScreen()),
    GetPage(name: redeemCodeScreen, page: () => RedeemCodeScreen()),
    GetPage(name: notificationListScreen, page: () => NotificationListScreen()),
    GetPage(name: successScreen, page: () => const SuccessScreen()),
    GetPage(name: failedScreen, page: () => const FailedScreen()),
    GetPage(name: whatsappScreen, page: () => const WhatsAppPage()),
    GetPage(
        name: transactionDetailsScreen,
        page: () => const TransactionDetailsScreen()),
    GetPage(name: purchaseListScreen, page: () => PurchaseListScreen()),
  ];
}
