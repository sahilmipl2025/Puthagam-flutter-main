import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/home/screen/meet_creator/meet_creator_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/no_internet_screen.dart';

class MeetCreatorScreen extends StatelessWidget {
  MeetCreatorScreen({Key? key}) : super(key: key);

  final MeetCreatorController con = Get.put(MeetCreatorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: horizontalGradient),
        ),
        centerTitle: true,
        title: Text(
          "Meet the Creators",
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 22 : 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(gradient: verticalGradient),
        child: Obx(
          () => con.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : con.isConnected.isFalse
                  ? NoInternetScreen(onTap: () async {
                      bool connection = await checkConnection();
                      if (connection) {
                        con.isConnected.value = true;
                        con.getCreatorList(pagination: false);
                      } else {
                        con.isConnected.value = false;
                      }
                    })
                  : con.creatorList.isEmpty
                      ? Center(
                          child: Text(
                            "No creator found",
                            style: TextStyle(
                              fontSize: isTablet ? 24 : 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          controller: con.newScrollController,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: con.creatorList.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 3.5 / 6.5,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      Get.toNamed(AppRoutes.creatorBooksScreen,
                                          arguments: [
                                            con.creatorList[index].name,
                                            con.creatorList[index].id,
                                            con.creatorList[index].description,
                                          ]);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipOval(
                                            clipBehavior: Clip.antiAlias,
                                            child: Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                child: ClipOval(
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Container(
                                                    height:
                                                        isTablet ? 130 : 100,
                                                    width: isTablet ? 150 : 120,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            con
                                                                    .creatorList[
                                                                        index]
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
                                                gradient:
                                                    LinearGradient(colors: [
                                                  Color(0xFFA87F01),
                                                  Color(0xFFAE8601),
                                                  Color(0xFFD4B001),
                                                  Color(0xFFFAD901),
                                                  Color(0xFFF1D001),
                                                ]),
                                                // border: Border.all(
                                                //     color: Colors.amber, width: 2),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            width: isTablet ? 150 : 120,
                                            alignment: Alignment.center,
                                            child: Text(
                                              con.creatorList[index].name ?? "",
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: isTablet ? 17 : 15,
                                                fontWeight: FontWeight.w500,
                                                overflow: TextOverflow.ellipsis,
                                                color: text23,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          // const SizedBox(height: 8),
                                          // Text(
                                          //   con.creatorList[index]
                                          //           .bookCount
                                          //           .toString() +
                                          //       " " +
                                          //       "books".tr,
                                          //   style: const TextStyle(
                                          //     fontSize: 14,
                                          //   ),
                                          //   textAlign: TextAlign.center,
                                          // )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Obx(() => con.paginationLoading.value
                                  ? const CircularProgressIndicator()
                                  : const SizedBox())
                            ],
                          ),
                        ),
        ),
      ),
    );
  }
}
