import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/collection/create_collection_api.dart';
import 'package:puthagam/data/api/collection/delete_collection_api.dart';
import 'package:puthagam/data/api/collection/get_collections_api.dart';
import 'package:puthagam/screen/dashboard/home/screen/collection_books/collection_books_controller.dart';
import 'package:puthagam/screen/dashboard/library/collections/collection_controller.dart';
import 'package:puthagam/utils/app_loader.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/no_internet_screen.dart';

class CollectionPage extends StatelessWidget {
  CollectionPage({Key? key}) : super(key: key);
  final CollectionController con = Get.put(CollectionController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(gradient: verticalGradient),
      child: Obx(() => con.isLoading.value
          ? const Center(child: AppLoader())
          : con.isConnected.isFalse
              ? NoInternetScreen(onTap: () async {
                  bool connection = await checkConnection();
                  if (connection) {
                    con.isConnected.value = true;
                    getCollectionList();
                  } else {
                    con.isConnected.value = false;
                  }
                })
              : SingleChildScrollView(
                  child: Stack(
                    children: [
                      Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: isTablet ? 12 : 8),
                              Obx(() => con.collectionList.isEmpty
                                  ? SizedBox(
                                      height: Get.height * 0.4,
                                      child: Center(
                                        child: Text(
                                          "No collection found",
                                          style: TextStyle(
                                            fontSize: isTablet ? 29 : 25,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: con.collectionList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            Get.find<CollectionBooksController>()
                                                    .collectionId
                                                    .value =
                                                con.collectionList[index].id!;
                                            Get.find<CollectionBooksController>()
                                                    .name
                                                    .value =
                                                con.collectionList[index].name!;
                                            Get.find<
                                                    CollectionBooksController>()
                                                .showDelete
                                                .value = true;
                                            Get.find<
                                                    CollectionBooksController>()
                                                .totalCount
                                                .value = con
                                                    .collectionList[index]
                                                    .bookCount
                                                    ?.value ??
                                                0;
                                            Get.find<
                                                    CollectionBooksController>()
                                                .getExploreListApi();
                                            Get.toNamed(AppRoutes
                                                .collectionBooksScreen);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                gradient: verticalGradient),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: isTablet ? 20 : 16,
                                              vertical: isTablet ? 16 : 12,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: isTablet ? 20 : 16,
                                                vertical: isTablet ? 10 : 6,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                            height: isTablet
                                                                ? 12
                                                                : 8),
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            con
                                                                    .collectionList[
                                                                        index]
                                                                    .name ??
                                                                "",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  Get.width >
                                                                          550
                                                                      ? 16
                                                                      : 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: isTablet
                                                                ? 6
                                                                : 4),
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Obx(
                                                            () => Text(
                                                              con.collectionList[index].bookCount!.value !=
                                                                          0 &&
                                                                      con.collectionList[index].bookCount!.value !=
                                                                          1
                                                                  ? con
                                                                          .collectionList[
                                                                              index]
                                                                          .bookCount!
                                                                          .value
                                                                          .toString() +
                                                                      ' Books'
                                                                  : con
                                                                          .collectionList[
                                                                              index]
                                                                          .bookCount!
                                                                          .value
                                                                          .toString() +
                                                                      ' Book',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    Get.width >
                                                                            550
                                                                        ? 14
                                                                        : 12,
                                                                color:
                                                                    borderColor,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: isTablet
                                                                ? 12
                                                                : 8),
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          barrierColor:
                                                              const Color
                                                                      .fromRGBO(
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  0.80),
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Dialog(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: SizedBox(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left: isTablet
                                                                              ? 20
                                                                              : 16,
                                                                          top: isTablet
                                                                              ? 14
                                                                              : 10,
                                                                          right: isTablet
                                                                              ? 20
                                                                              : 16),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'Delete collection',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: isTablet ? 16 : 14,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              height: isTablet ? 4 : 2),
                                                                          Text(
                                                                            'Are you sure you want to delete this collection?',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: isTablet ? 14 : 12,
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height: Get.width >
                                                                                550
                                                                            ? 19
                                                                            : 16),
                                                                    Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: isTablet
                                                                              ? 12
                                                                              : 9,
                                                                          vertical: isTablet
                                                                              ? 8
                                                                              : 5),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            const BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(10),
                                                                          bottomRight:
                                                                              Radius.circular(10),
                                                                        ),
                                                                        color: Colors
                                                                            .grey[100],
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Get.back();
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(2.0),
                                                                                border: Border.all(color: buttonColor),
                                                                                color: Colors.white,
                                                                              ),
                                                                              margin: EdgeInsets.all(isTablet ? 9 : 6),
                                                                              padding: EdgeInsets.symmetric(horizontal: isTablet ? 23 : 20, vertical: isTablet ? 6 : 4),
                                                                              child: Text(
                                                                                "No",
                                                                                style: TextStyle(color: Colors.black, fontSize: isTablet ? 18 : 15),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              Get.back();
                                                                              deleteCollectionApi(index: index, collectionId: con.collectionList[index].id);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(border: Border.all(color: buttonColor), borderRadius: BorderRadius.circular(isTablet ? 5 : 3), color: buttonColor),
                                                                              margin: EdgeInsets.symmetric(vertical: isTablet ? 9 : 6),
                                                                              padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 20, vertical: isTablet ? 8 : 5),
                                                                              child: Text(
                                                                                "Yes",
                                                                                style: TextStyle(fontSize: isTablet ? 17 : 15, color: Colors.white),
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
                                                      },
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: commonBlueColor,
                                                        size:
                                                            isTablet ? 22 : 18,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })),
                              SizedBox(height: isTablet ? 20 : 16),
                              InkWell(
                                onTap: () {
                                  addCollection(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  isTablet ? 12 : 8))),
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius:
                                            Radius.circular(isTablet ? 14 : 10),
                                        color: borderColor,
                                        strokeWidth: 2,
                                        dashPattern: const [10, 6],
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            size: isTablet ? 29 : 25,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: isTablet ? 20 : 16),
                                    Text(
                                      'Create new collection',
                                      style: TextStyle(
                                        fontSize: isTablet ? 20 : 16,
                                        color: Colors.grey.shade400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: isTablet ? 20 : 16),
                            ],
                          ),
                        ),
                      ),
                      Obx(() => con.showLoading.value
                          ? Container(
                              color: Colors.grey.withOpacity(0.2),
                              height: Get.height * 0.8,
                              child: const Center(child: AppLoader()),
                            )
                          : const SizedBox())
                    ],
                  ),
                )),
    );
  }

  void addCollection(BuildContext context) {
    showModalBottomSheet(
        barrierColor: const Color.fromARGB(255, 167, 219, 244).withOpacity(.2),
        isScrollControlled: true,
        context: context,
        constraints: const BoxConstraints(maxWidth: 800),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  gradient: verticalGradient,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.only(top: isTablet ? 16 : 12),
                      width: Get.width * 0.14,
                      height: isTablet ? 6 : 4,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: isTablet ? 16 : 10,
                          right: isTablet ? 16 : 10,
                          top: isTablet ? 24 : 20,
                          bottom: isTablet ? 20 : 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Create Collection',
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(isTablet ? 20 : 16.0),
                      child: Container(
                        height: isTablet ? 160 : 120,
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: TextField(
                          controller: con.controller.value,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Please enter the collection title',
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: isTablet ? 16 : 14)),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: isTablet ? 18 : 15),
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 12 : 8),
                    InkWell(
                      onTap: () {
                        if (con.controller.value.text.trim().isNotEmpty) {
                          Get.back();
                          createCollectionApi(name: con.controller.value.text);
                        } else {
                          toast("Please enter the collection title", false);
                        }
                      },
                      child: Container(
                        height: isTablet ? 60 : 45,
                        width: Get.width * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                          gradient: verticalGradient,
                        ),
                        child: Center(
                          child: Text(
                            'Create',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 17 : 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 20 : 16),
                  ],
                ),
              ),
            );
          });
        });
  }

  Widget searchBar({context}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        gradient: horizontalGradient,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Center(
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 9, right: 6),
                child: Image.asset(
                  "assets/icons/search.png",
                  height: 25,
                  width: 25,
                )),
            Expanded(
              child: TextField(
                textAlign: TextAlign.left,
                // controller: con.searchController.value,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Title, Author or Category',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: text23,
                    fontSize: 14,
                  ),
                ),
                // onChanged: (v) {
                //   if (con.searchController.value.text.trim().isEmpty) {
                //     con.isSearch.value = false;
                //   }
                // },
                onEditingComplete: () {
                  // if (con.searchController.value.text.trim().isNotEmpty) {
                  //   con.isSearch.value = true;
                  //   getSearchListApi();
                  // } else {
                  //   con.isSearch.value = false;
                  // }
                },
              ),
            ),
            // Padding(
            //   padding:  EdgeInsets.only(right: 12),
            //   child: InkWell(
            //     onTap: () {
            //       FocusScope.of(context).unfocus();
            //       // con.isSearch.value = false;
            //       // con.searchController.value.clear();
            //     },
            //     child: Icon(
            //       Icons.close,
            //       color: smallTextColor,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
