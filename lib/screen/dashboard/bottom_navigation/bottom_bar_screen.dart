
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/bottom_navigation/bottom_bar_controller.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/screen/dashboard/podcast/podcast_controller.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';

import '../../../data/api/profile/get_profile_api.dart';

class BottomBarScreen extends StatelessWidget {
  BottomBarScreen({Key? key}) : super(key: key);

  final BottomBarController con = Get.put(BottomBarController());
  final HomeController con1 = Get.put(HomeController());
    final PodcastController con3 = Get.put(PodcastController());
  //final PodcastController con2 Get.put(PodcastController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (con.selectedIndex.value != 0) {
          con.selectedIndex.value = 0;
          return false;
        }
        con.selectedIndex.value = 0;

        await showDialog<bool>(
          barrierColor: const Color.fromRGBO(0, 0, 0, 0.80),
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: isTablet ? 20 : 16,
                          top: isTablet ? 14 : 10,
                          right: isTablet ? 20 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Exit Confirmation',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                          SizedBox(height: isTablet ? 4 : 2),
                          Text(
                            'Are you sure you want to exit from the app?',
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Get.width > 550 ? 19 : 16),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 12 : 9,
                          vertical: isTablet ? 8 : 5),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.grey[100],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.0),
                                border: Border.all(color: buttonColor),
                                color: Colors.white,
                              ),
                              margin: EdgeInsets.all(isTablet ? 9 : 6),
                              padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 23 : 20,
                                  vertical: isTablet ? 6 : 4),
                              child: Text(
                                "No",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: isTablet ? 18 : 15),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              con.selectedIndex.value = 0;
                              Get.back();
                              SystemNavigator.pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: buttonColor),
                                  borderRadius:
                                      BorderRadius.circular(isTablet ? 5 : 3),
                                  color: buttonColor),
                              margin: EdgeInsets.symmetric(
                                  vertical: isTablet ? 9 : 6),
                              padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 24 : 20,
                                  vertical: isTablet ? 8 : 5),
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                    fontSize: isTablet ? 17 : 15,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );

        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Obx(() => Container(
            padding: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 6, top: 6),
            decoration: BoxDecoration(gradient: horizontalGradient),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    con.selectedIndex.value = 0;
                   // con1.refreshData();
                   // con3.refreshData1();
                    getUserProfileApi();
                  },
                  //=> con.selectedIndex.value = 0,
                  
                  
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/for you.png',
                        height: isTablet ? 30 : 25,
                        width: isTablet ? 30 : 25,
                        // color: con.selectedIndex.value == 0
                        //     ? mainiconColor
                        //     : Colors.grey,
                      ),
                      SizedBox(height: isTablet ? 6 : 4),
                      Text(
                        "Home",
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w500,
                          color: con.selectedIndex.value == 0
                              ? mainiconColor
                              : Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    con.selectedIndex.value = 1;
                    // con1.refreshData();
                    // con3.refreshData1();
                     getUserProfileApi();
                  },
                  //=> con.selectedIndex.value = 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/library2.png',
                        height: isTablet ? 30 : 25,
                        width: isTablet ? 30 : 25,
                        // color: con.selectedIndex.value == 1
                        //     ? mainiconColor
                        //     : Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Library",
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w500,
                          color: con.selectedIndex.value == 1
                              ? mainiconColor
                              : Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    con.selectedIndex.value = 2;
                   //  con1.refreshData();

                   //   con3.refreshData1();
                      getUserProfileApi();
                  },
                  //=> con.selectedIndex.value = 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/podcast2.png',
                        height: isTablet ? 30 : 25,
                        width: isTablet ? 30 : 25,
                        // color: con.selectedIndex.value == 2
                        //     ? mainiconColor
                        //     : Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Masterclass",
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w500,
                          color: con.selectedIndex.value == 2
                              ? mainiconColor
                              : Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    con.selectedIndex.value = 3;
                    
                   //  con1.refreshData();
                    //
                    //  con3.refreshData1();
                      getUserProfileApi();
                  },
                  // => con.selectedIndex.value = 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/profile.png',
                        height: isTablet ? 30 : 25,
                        width: isTablet ? 30 : 25,
                        // color: con.selectedIndex.value == 2
                        //     ? mainiconColor
                        //     : Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w500,
                          color: con.selectedIndex.value == 3
                              ? mainiconColor
                              : Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ))),
        body: Obx(
          () => SizedBox(
            child: Center(
              child: con.widgetOptions.elementAt(con.selectedIndex.value),
            ),
          ),
        ),
      ),
    );
  }
}
