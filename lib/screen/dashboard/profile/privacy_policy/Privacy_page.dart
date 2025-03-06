import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/profile/privacy_policy/privacy_controller.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicy extends StatelessWidget {
  PrivacyPolicy({Key? key}) : super(key: key);
  final PrivacyController con = Get.put(PrivacyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(gradient: verticalGradient),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(gradient: verticalGradient),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                            con.args == "terms"
                                ? "Terms of service"
                                : con.args == "help"
                                    ? "Help & support"
                                    : "Privacy policy",
                            style: TextStyle(
                              fontSize: isTablet ? 23 : 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 20 : 16),
                child: Obx(
                  () => SingleChildScrollView(
                    child: Html(
                      data: con.privacy.value
                          .replaceAll('font-feature-settings: normal;', ''),
                      onLinkTap: (url, _, __) async {
                        if (await canLaunchUrl(Uri.parse(url.toString()))) {
                          await launch(url.toString());
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      style: {
                        "body": Style(
                          color: Colors.white,
                          fontSize: FontSize(isTablet ? 17 : 15),
                        ),
                        "span": Style(
                          color: Colors.brown.shade300,
                          fontSize: FontSize(isTablet ? 17 : 15),
                        ),
                        "font": Style(
                          color: Colors.brown.shade300,
                          fontSize: FontSize(isTablet ? 17 : 15),
                        ),
                        "div": Style(
                          color: Colors.white,
                          fontSize: FontSize(isTablet ? 17 : 15),
                        ),
                        "li": Style(
                          color: Colors.white,
                          fontSize: FontSize(isTablet ? 17 : 15),
                        ),
                      },
                    ),
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
