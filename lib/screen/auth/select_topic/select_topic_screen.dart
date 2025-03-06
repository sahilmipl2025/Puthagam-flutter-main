import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/api/category/update_category_api.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/api_controller.dart';
import 'package:puthagam/screen/dashboard/home/screen/book_detail/book_detail_controller.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/screen/auth/select_topic/select_topic_controller.dart';
import 'package:puthagam/utils/app_loader.dart';

class SelectTopicsScreen extends StatelessWidget {
  SelectTopicsScreen({Key? key}) : super(key: key);

  final SelectTopicController con = Get.put(SelectTopicController());
  final BookDetailApiController apiCon = Get.put(BookDetailApiController());
  final BookDetailController con1 = Get.put(BookDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(gradient: verticalGradient),
        child: Obx(
          () => con.isLoading.value
              ? const Center(child: AppLoader())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(
                      height: Get.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: Get.arguments == true
                                  ? Get.height * 0.05
                                  : Get.height * 0.1),
                          Get.arguments == true
                              ? IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(
                                    Icons.chevron_left,
                                    size: 35,
                                  ),
                                )
                              : const SizedBox(),
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  'selectTopic'.tr,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 30),
                                con.categoryList.isEmpty
                                    ? Expanded(
                                        child: Center(
                                          child: Text(
                                            "noCategoryFound".tr,
                                            style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Flexible(
                                        child: GridView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: con.categoryList.length,
                                            scrollDirection: Axis.vertical,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: isTablet ? 4 : 3,
                                              mainAxisSpacing:
                                                  isTablet ? 15 : 13,
                                              crossAxisSpacing:
                                                  isTablet ? 15 : 13,
                                              childAspectRatio: 0.96,
                                            ),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return InkWell(
                                                  onTap: () {
                                                    if (con.categoryList[index]
                                                        .isSelected!.value) {
                                                      updateCategoryApi(
                                                          categoryId: con
                                                              .categoryList[
                                                                  index]
                                                              .id,
                                                          status: false);
                                                    } else {
                                                      updateCategoryApi(
                                                          categoryId: con
                                                              .categoryList[
                                                                  index]
                                                              .id,
                                                          status: true);
                                                    }
                                                  },
                                                  child: Obx(
                                                    () => Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 12),
                                                      decoration: BoxDecoration(
                                                        border: con
                                                                .categoryList[
                                                                    index]
                                                                .isSelected!
                                                                .value
                                                            ? Border.all(
                                                                color:
                                                                    mainiconColor)
                                                            : Border.all(
                                                                color: Colors
                                                                    .transparent),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Flexible(
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child: FadeInImage
                                                                  .assetNetwork(
                                                                fit:
                                                                    BoxFit.fill,
                                                                placeholder: '',
                                                                image: con
                                                                        .categoryList[
                                                                            index]
                                                                        .image ??
                                                                    "",
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          8),
                                                              child: Text(
                                                                con.categoryList[index]
                                                                        .name ??
                                                                    "",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      isTablet
                                                                          ? 16
                                                                          : 13,
                                                                  color: con
                                                                          .categoryList[
                                                                              index]
                                                                          .isSelected!
                                                                          .value
                                                                      ? mainiconColor
                                                                      : Colors
                                                                          .grey,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ));
                                            }),
                                      ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => con.storeSelectedCategory(),
                            child: Container(
                              height: 45,
                              margin: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.1),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  gradient: verticalGradient),
                              child: Text(
                                'complete'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
