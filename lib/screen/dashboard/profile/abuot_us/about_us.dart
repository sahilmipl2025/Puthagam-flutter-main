import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/profile/abuot_us/about_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';

class AboutPage extends StatelessWidget {
  AboutPage({Key? key}) : super(key: key);

  final AboutController con = Get.put(AboutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(gradient: verticalGradient),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(gradient: verticalGradient),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20 : 16,
                    vertical: isTablet ? 20 : 16),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'About',
                            style: TextStyle(
                              fontSize: isTablet ? 23 : 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 25 : 20),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(isTablet ? 20 : 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: verticalGradient,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: isTablet ? 16 : 12),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 20 : 16),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.privacyPage,
                                arguments: "privacy");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(isTablet ? 14 : 10),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white54,
                                ),
                                child: Image.asset(
                                  'assets/icons/privacy.png',
                                  height: isTablet ? 20 : 16,
                                  width: isTablet ? 20 : 16,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(width: isTablet ? 20 : 16),
                              Expanded(
                                child: Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    fontSize: isTablet ? 17 : 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => Get.toNamed(
                                    AppRoutes.privacyPage,
                                    arguments: "privacy"),
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: isTablet ? 24 : 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: isTablet ? 6 : 4),
                        child: const Divider(thickness: 1, color: Colors.white),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 20 : 16),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.privacyPage,
                                arguments: "terms");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(isTablet ? 14 : 10),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white54,
                                ),
                                child: Image.asset(
                                  'assets/icons/term&c.png',
                                  height: isTablet ? 20 : 16,
                                  width: isTablet ? 20 : 16,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(width: isTablet ? 20 : 16),
                              Expanded(
                                child: Text(
                                  'Term of service',
                                  style: TextStyle(
                                    fontSize: isTablet ? 16 : 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => Get.toNamed(
                                    AppRoutes.privacyPage,
                                    arguments: "terms"),
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: isTablet ? 24 : 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: isTablet ? 6 : 4),
                        child: const Divider(thickness: 1, color: Colors.white),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 20 : 16),
                        child: InkWell(
                          onTap: () => Get.toNamed(AppRoutes.feedbackPage),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(isTablet ? 14 : 10),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white54,
                                ),
                                child: Image.asset(
                                  'assets/icons/feedback.png',
                                  height: isTablet ? 20 : 16,
                                  width: isTablet ? 20 : 16,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(width: isTablet ? 20 : 16),
                              Expanded(
                                child: Text(
                                  'Feedback',
                                  style: TextStyle(
                                    fontSize: isTablet ? 17 : 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    Get.toNamed(AppRoutes.feedbackPage),
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: isTablet ? 24 : 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 16 : 12),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
