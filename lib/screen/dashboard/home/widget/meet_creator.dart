import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/shimmer_tile.dart';

class MeetCreator extends StatelessWidget {
  MeetCreator({Key? key}) : super(key: key);

  final HomeController con = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'meetCreator'.tr,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 14,
                    fontWeight: FontWeight.w500,
                    color: commonBlueColor,
                  ),
                ),
                Obx(() => con.meetCreatorList.length > 5
                    ? InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Get.toNamed(AppRoutes.meetCreatorScreen);
                        },
                        child: Row(
                          children: [
                            Text(
                              'viewMore'.tr,
                              style: TextStyle(
                                fontSize: isTablet ? 14 : 12,
                                color: borderColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox())
              ],
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Obx(() => con.categoryLoading.value
              ? SizedBox(
                  height: isTablet ? 170 : 150,
                  width: double.infinity,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return ShimmerTile(
                          margin: EdgeInsets.only(right: isTablet ? 16 : 12),
                          height: isTablet ? 190 : 160,
                          width: isTablet ? 190 : 160,
                        ).marginAll(isTablet ? 14 : 10);
                      }),
                )
              : con.meetCreatorList.isEmpty
                  ? 
                  SizedBox(
                      height: isTablet ? 170 : 150,
                      child: Center(
                        child: Text(
                          "noCreatorFound".tr,
                          style: TextStyle(
                            fontSize: isTablet ? 25 : 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: isTablet ? 170 : 150,
                      width: double.infinity,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: con.meetCreatorList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                
                                FocusScope.of(context).unfocus();
                                Get.toNamed(
                                  AppRoutes.creatorBooksScreen,
                                  arguments: [
                                    con.meetCreatorList[index].name,
                                    con.meetCreatorList[index].id,
                                    con.meetCreatorList[index].description,
                                  ],
                                  
                                );
                               
                              },
                              child: Padding(
                                padding: EdgeInsets.all(isTablet ? 8 : 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: isTablet ? 12 : 8),
                                    ClipOval(
                                      clipBehavior: Clip.antiAlias,
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: ClipOval(
                                            clipBehavior: Clip.antiAlias,
                                            child: Container(
                                              height: isTablet ? 90 : 70,
                                              width: isTablet ? 90 : 70,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      con.meetCreatorList[index]
                                                              .image ??
                                                          "",
                                                    ),
                                                    
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                          ),
                                        ),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(colors: [
                                            Color(0xFFA87F01),
                                            Color(0xFFAE8601),
                                            Color(0xFFD4B001),
                                            Color(0xFFFAD901),
                                            Color(0xFFF1D001),
                                          ]),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 12 : 8),
                                    Container(
                                      width: isTablet ? 110 : 90,
                                      alignment: Alignment.center,
                                      child: Text(
                                        con.meetCreatorList[index].name ?? "",
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: isTablet ? 14 : 12,
                                          color: text23,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )),
        ],
      ),
    );
  }
}
