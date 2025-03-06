import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:puthagam/data/api/notification/delete_all_notification.dart';
import 'package:puthagam/data/api/notification/read_single_notifications_api.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/screen/dashboard/notification/notification_controller.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:readmore/readmore.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationListScreen extends StatelessWidget {
  NotificationListScreen({Key? key}) : super(key: key);

  final NotificationListController con = Get.put(NotificationListController());
 final  BookDetailController con2 = Get.put(BookDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(gradient: verticalGradient),
        child: SafeArea(
          child: Column(
            children: [
              10.heightBox,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: isTablet ? 24 : 20,
                      ),
                    ),
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: isTablet ? 22 : 18,
                        color: commonBlueColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Obx(
                      () => con.notificationList.isEmpty
                          ? SizedBox(width: isTablet ? 14 : 10)
                          : InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: HexColor("#065293"),
                                    title: const Text('Confirmation'),
                                    content: const Text(
                                        'Are you sure you want to clear all notifications?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text(
                                          'No',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          deleteNotificationApi();
                                        },
                                        child: const Text(
                                          'Yes',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text(
                                'Clear',
                                style: TextStyle(
                                  fontSize: isTablet ? 17 : 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isTablet ? 20 : 16),
              Container(
                height: 2,
                width: Get.width,
                color: Colors.grey,
              ),
              Expanded(
                  child: Obx(() => con.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : Stack(
                          children: [
                            Column(
                              children: [
                                con.notificationList.isEmpty
                                    ? Expanded(
                                        child: Center(
                                          child: Text(
                                            "No notification found",
                                            style: TextStyle(
                                              fontSize: isTablet ? 20 : 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: SingleChildScrollView(
                                          controller: con.newScrollController,
                                          child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                con.notificationList.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return InkWell(
                                                onTap: () {

                                                  print(' parentEntityId notification screen ${   
                                                          con
                                                                .notificationList[
                                                                    index]
                                                                .parentEntityId
                                                                .toString()} ');

                                                                print('entityId  ${   
                                                          con.notificationList[
                                                                    index]
                                                                .entityId
                                                                .toString()} ');

                                                                
                                                
                                                  if (con
                                                          .notificationList[
                                                              index]
                                                          .isRead!
                                                          .value ==
                                                      false) {
                                                    readNotificationApi(
                                                        notificationId: con
                                                            .notificationList[
                                                                index]
                                                            .id
                                                            .toString());
                                                  }

                                                  if (con.notificationList[
                                                                  index]
                                                              .parentEntityId !=
                                                          null ||
                                                      con.notificationList[
                                                                  index]
                                                              .entityId !=
                                                          null) {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    Get.find<BookDetailController>().callApis(
                                                        bookID: 
                                                        con.notificationList[
                                                                        index]
                                                                    .parentEntityId
                                                                    .toString() !=
                                                                "null"
                                                            ? con
                                                                .notificationList[
                                                                    index]
                                                                .parentEntityId
                                                                .toString()
                                                            : con
                                                                .notificationList[
                                                                    index]
                                                                .entityId
                                                                
                                                                );
                                                    Get.toNamed(
                                                        AppRoutes
                                                            .bookDetailScreen,
                                                        arguments: con
                                                                    .notificationList[
                                                                        index]
                                                                    .parentEntityId.toString() !=
                                                                "null"
                                                            ? con
                                                                .notificationList[
                                                                    index]
                                                                .parentEntityId
                                                                .toString()
                                                            : con
                                                                .notificationList[
                                                                    index]
                                                                .entityId);
                                                              
                                                               //  LocalStorage.clearData();
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    Obx(
                                                      () => con
                                                              .notificationList[
                                                                  index]
                                                              .isRead!
                                                              .value
                                                          ? Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Get.width >
                                                                              550
                                                                          ? 12
                                                                          : 8),
                                                              child: SizedBox(
                                                                height:
                                                                    Get.width >
                                                                            550
                                                                        ? 7
                                                                        : 5,
                                                                width:
                                                                    Get.width >
                                                                            550
                                                                        ? 7
                                                                        : 5,
                                                              ),
                                                            )
                                                          : Container(
                                                              margin: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Get.width >
                                                                              550
                                                                          ? 12
                                                                          : 8),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              height:
                                                                  Get.width >
                                                                          550
                                                                      ? 7
                                                                      : 5,
                                                              width: Get.width >
                                                                      550
                                                                  ? 7
                                                                  : 5,
                                                            ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right:
                                                                    Get.width >
                                                                            550
                                                                        ? 20
                                                                        : 16),
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                                height: 6),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets.all(
                                                                      Get.width >
                                                                              550
                                                                          ? 12
                                                                          : 10),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: HexColor(
                                                                            "#065293")
                                                                        .withOpacity(
                                                                            0.5),
                                                                  ),
                                                                  child: con.notificationList[index].type!
                                                                              .toLowerCase() ==
                                                                          "addbook"
                                                                      ? Image
                                                                          .asset(
                                                                          "assets/icons/read-book.png",
                                                                          height: isTablet
                                                                              ? 22
                                                                              : 20,
                                                                          width: isTablet
                                                                              ? 22
                                                                              : 20,
                                                                          color:
                                                                              Colors.white,
                                                                        )
                                                                      : con.notificationList[index].type!.toLowerCase() == "addpodcast" ||
                                                                              con.notificationList[index].type!.toLowerCase() ==
                                                                                  "addepisode" ||
                                                                              con.notificationList[index].type!.toLowerCase() ==
                                                                                  "addpodcast" ||
                                                                              con.notificationList[index].type!.toLowerCase() ==
                                                                                  "publishepisode"
                                                                          ? Image
                                                                              .asset(
                                                                              'assets/icons/podcast2.png',
                                                                              height: isTablet ? 22 : 20,
                                                                              width: isTablet ? 22 : 20,
                                                                              //color: Colors.white,
                                                                            )
                                                                          : const Icon(
                                                                              Icons.notifications_none_outlined),
                                                                ),
                                                                SizedBox(
                                                                    width: Get.width >
                                                                            550
                                                                        ? 16
                                                                        : 12),
                                                                Expanded(
                                                                  child:
                                                                      ReadMoreText(
                                                                    con.notificationList[index]
                                                                            .content
                                                                            ?.trim() ??
                                                                        "",
                                                                    trimLines:
                                                                        3,
                                                                    style:
                                                                        TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize: Get.width >
                                                                              550
                                                                          ? 17
                                                                          : 15,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                    colorClickableText:
                                                                        Colors
                                                                            .pink,
                                                                    trimMode:
                                                                        TrimMode
                                                                            .Line,
                                                                    trimCollapsedText:
                                                                        ' Show more',
                                                                    trimExpandedText:
                                                                        ' Show less',
                                                                    moreStyle: TextStyle(
                                                                        fontSize: Get.width >
                                                                                550
                                                                            ? 17
                                                                            : 15,
                                                                        color: Colors
                                                                            .green,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    Get.width >
                                                                            550
                                                                        ? 8
                                                                        : 6),
                                                            const Divider(
                                                              thickness: 1.2,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                con.paginationLoading.value
                                    ? const Center(child: AppLoader())
                                    : const SizedBox()
                              ],
                            ),
                            Obx(() => con.showLoading.value
                                ? Container(
                                    color: Colors.grey.withOpacity(0.5),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : const SizedBox())
                          ],
                        )))
            ],
          ),
        ),
      ),
    );
  }
}
