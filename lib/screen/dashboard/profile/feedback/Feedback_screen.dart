// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/profile/feedback/feedback_controller.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/global.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({Key? key}) : super(key: key);
  final FeedbackController con = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: horizontalGradient),
          ),
          leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Feedback',
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 23 : 19,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: Get.width,
                height: Get.height,
                decoration: BoxDecoration(gradient: verticalGradient),
                padding: EdgeInsets.all(isTablet ? 20 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        'Write your review',
                        style: TextStyle(
                          fontSize: isTablet ? 24 : 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      height: isTablet ? 60 : 45,
                      alignment: Alignment.center,
                      child: Text(
                        'Your feedback will help us \nimprove app experience better.',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(isTablet ? 20 : 16.0),
                      child: Container(
                        height: isTablet ? 80 : 60,
                        alignment: Alignment.center,
                        child: RatingBar(
                          initialRating: 4,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemSize: isTablet ? 45 : 38,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                              full: Icon(Icons.star,
                                  size: 15,
                                  color: GlobalService.to.isDarkModel == true
                                      ? Colors.amberAccent.shade400
                                      : buttonColor),
                              half: Icon(Icons.star_half,
                                  color: GlobalService.to.isDarkModel == true
                                      ? Colors.amberAccent.shade400
                                      : buttonColor),
                              empty: Icon(Icons.star,
                                  color: Colors.grey.shade500)),
                          onRatingUpdate: (value) {
                            con.rating.value = value.toInt();
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: isTablet ? 160 : 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(isTablet ? 12 : 8)),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 20 : 16,
                          vertical: isTablet ? 6 : 4),
                      child: TextField(
                        controller: con.reviewController.value,
                        maxLines: 5,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Do you want to write something?',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 34 : 24),
                    InkWell(
                      onTap: () {
                        if (con.reviewController.value.text.trim().isNotEmpty) {
                          con.submitBookReviewApi();
                        } else {
                          toast("Please provide your feedback", false);
                        }
                      },
                      child: Container(
                        height: isTablet ? 60 : 45,
                        margin: EdgeInsets.symmetric(
                            horizontal: isTablet ? 40 : 30),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                            gradient: verticalGradient),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 20 : 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(() => con.savedLoading.value
                ? Container(
                    width: Get.width,
                    height: Get.height,
                    color: Colors.grey.withOpacity(0.4),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox())
          ],
        ));
  }
}
