import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:puthagam/data/api/collection/get_collections_api.dart';
import 'package:puthagam/data/api/library/get_completed_books_api.dart';
import 'package:puthagam/data/api/library/get_favorite_list_api.dart';
import 'package:puthagam/data/api/library/get_history_api.dart';
import 'package:puthagam/data/api/library/get_saved_book_api.dart';
import 'package:puthagam/screen/dashboard/library/collections/collection_page.dart';
import 'package:puthagam/screen/dashboard/library/completed_books/completed_books_screen.dart';
import 'package:puthagam/screen/dashboard/library/downloads/download_screen.dart';
import 'package:puthagam/screen/dashboard/library/favorites/favourite_screen.dart';
import 'package:puthagam/screen/dashboard/library/history/history_screen.dart';
import 'package:puthagam/screen/dashboard/library/my_queue/queue_screen.dart';
import 'package:puthagam/screen/dashboard/library/saved/saved_screen.dart';
import 'package:puthagam/utils/app_utils.dart';

import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/global.dart';

class LibrarayPage extends StatefulWidget {
  const LibrarayPage({Key? key}) : super(key: key);

  @override
  State<LibrarayPage> createState() => _LibrarayPageState();
}

class _LibrarayPageState extends State<LibrarayPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: horizontalGradient),
            ),
            elevation: 0.0,
            automaticallyImplyLeading: false,
            backgroundColor: GlobalService.to.isDarkModel == true
                ? buttonColor
                : Colors.white,
            centerTitle: true,
            title: Text(
              'library'.tr,
              style: TextStyle(
                color: commonBlueColor,
                fontSize: isTablet ? 22 : 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: commonBlueColor,
              labelColor: commonBlueColor,
              unselectedLabelColor: Colors.white,
              onTap: (v) {
                if (v == 1) {
                  getSavedBookApi(pagination: false);
                } else if (v == 4) {
                  getCollectionList();
                } else if (v == 3) {
                  getFavoriteBookApi(pagination: false);
                } else if (v == 5) {
                  getCompletedBooksApi(pagination: false);
                } else if (v == 6) {
                  getHistoryListApi();
                }
              },
              labelStyle: TextStyle(
                fontSize: isTablet ? 17 : 15,
              ),
              tabs: [
                const Tab(text: 'My queue'),
                Tab(text: 'save'.tr),
                Tab(text: 'download'.tr),
                Tab(text: 'favi'.tr),
                Tab(text: 'coll'.tr),
                const Tab(text: "Finished"),
                const Tab(text: "History"),
                // Tab(text: 'save'.tr),
              ],
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              QueueScreen(),
              SavedScreen(),
              DownloadScreen(),
              FavouriteScreen(),
              CollectionPage(),
              CompletedBooksScreen(),
              HistoryScreen(),
            ],
          ),
        ));
  }
}
