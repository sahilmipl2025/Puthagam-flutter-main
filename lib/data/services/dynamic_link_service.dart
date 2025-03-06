import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/utils/app_routes.dart';

abstract class DynamicLinkServices {
  static initDynamicLinks({context}) async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    final PendingDynamicLinkData? dynamicLink =
        await dynamicLinks.getInitialLink();
    getId(dynamicLink?.link, context);

    dynamicLinks.onLink.listen((dynamicLinkData) async {
      await getId(dynamicLinkData.link, context);
    }).onError((error) {
      debugPrint('onLink error');
      debugPrint(error.message);
    });
  }

  static getId(Uri? dynamicLink, context) async {
    if (dynamicLink != null) {
      final Uri deepLink = dynamicLink;

      debugPrint(deepLink.toString());

      if (deepLink.toString().contains('book_detail')) {
        var bookId = deepLink.toString().split('book_detail:').last;

        if (bookId.toString().isNotEmpty && bookId.toString() != "null") {
          if (bookId.toString().isNotEmpty && bookId.toString() != "null") {
            Get.toNamed(AppRoutes.bookDetailScreen, arguments: bookId);
            await Get.find<BookDetailController>().callApis(bookID: bookId);
          }
        }
      }
    }
  }
}

FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
const String dynamicLink = 'https://magictamil.page.link/book_detail:';
const String shareDynamicLink = 'https://magictamil.page.link';

Future<String> createDynamicLink({required String bookId}) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://magictamil.page.link',
    link: Uri.parse(dynamicLink + bookId),
    androidParameters: const AndroidParameters(packageName: 'com.app.puthagam'),
    iosParameters: const IOSParameters(bundleId: 'com.app.puthagam'),
  );
  try {
    Uri url = await dynamicLinks.buildLink(parameters);

    // Print the generated link for debugging
    print("Generated Dynamic Link: $url");

    return url.toString();
  } catch (e) {
    // Print any errors encountered during dynamic link creation
    print("Error generating dynamic link: $e");
    rethrow;
  }


  // Uri url;

  // url = await dynamicLinks.buildLink(parameters);

  // return url.toString();
}

Future<String> createShareDynamicLink() async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://magictamil.page.link',
    link: Uri.parse(shareDynamicLink),
    androidParameters: const AndroidParameters(packageName: 'com.app.puthagam'),
    iosParameters: const IOSParameters(bundleId: 'com.app.puthagam'),
  );

  Uri url;

  url = await dynamicLinks.buildLink(parameters);

  return url.toString();
}

// abstract class DynamicLinkServices {
//   static initDynamicLinks() async {
//     final PendingDynamicLinkData? dynamicLink =
//         await FirebaseDynamicLinks.instance.getInitialLink();
//     getId(dynamicLink);
//
//     FirebaseDynamicLinks.instance.onLink(
//       onSuccess: (dynamicLink) async {
//         await getId(dynamicLink);
//       },
//       onError: (OnLinkErrorException e) async {
//         debugPrint("deeplink error");
//         debugPrint(e.message);
//       },
//     );
//   }
//
//   static getId(PendingDynamicLinkData? dynamicLink) async {
//     if (dynamicLink != null) {
//       final Uri deepLink = dynamicLink.link;
//
//       debugPrint(deepLink.toString());
//
//       /// Videos
//       if (deepLink.toString().contains('book_detail')) {
//         var bookId = deepLink.toString().split('/').last;
//
//         if (bookId.toString().isNotEmpty && bookId.toString() != "null") {
//           await Get.find<BookDetailController>().callApis(bookID: bookId);
//           Get.toNamed(AppRoutes.bookDetailScreen, arguments: bookId);
//         }
//       }
//     }
//   }
// }
//
// Future<String> createDynamicLink(
//     {required String link, required String title, String? description}) async {
//   final DynamicLinkParameters parameters = DynamicLinkParameters(
//     uriPrefix: 'https://magictamil.page.link',
//     link: Uri.parse(link),
//     androidParameters: AndroidParameters(packageName: 'com.app.puthagam'),
//     iosParameters: IosParameters(bundleId: 'com.app.puthagam'),
//   );
//
//   final Uri dynamicUrl = (await parameters.buildShortLink()).shortUrl;
//   return dynamicUrl.toString();
// }
//
// Future<String> createShareDynamicLink(
//     {required String link, required String title, String? description}) async {
//   final DynamicLinkParameters parameters = DynamicLinkParameters(
//     uriPrefix: 'https://magictamil.page.link',
//     link: Uri.parse(link),
//     androidParameters: AndroidParameters(packageName: 'com.app.puthagam'),
//     iosParameters: IosParameters(bundleId: 'com.app.puthagam'),
//   );
//
//   final Uri dynamicUrl = (await parameters.buildShortLink());
//   return dynamicUrl.toString();
// }
