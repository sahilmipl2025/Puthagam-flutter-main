import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/auth/intro/intro_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_utils.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class IntroScreen extends StatelessWidget {
  IntroScreen({Key? key}) : super(key: key);

  final IntroController con = Get.put(IntroController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(gradient: verticalGradient),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Obx(
                () => SizedBox(
                  height: Get.height / 1.2,
                  width: Get.width,
                  child: PageView.builder(
                    itemCount: con.getStartedList.length,
                    allowImplicitScrolling: true,
                    physics: const ClampingScrollPhysics(),
                    controller: con.pageController,
                    onPageChanged: (int page) {
                      con.currentPage.value = page;
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          20.heightBox,
                          Container(
                            margin: EdgeInsets.only(top: isTablet ? 36 : 30),
                            alignment: Alignment.center,
                            width: Get.height * 0.4,
                            height: Get.height * 0.4,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                    con.getStartedList[index].image ?? ""),
                              ),
                            ),
                          ),
                          SizedBox(height: isTablet ? 28 : 24),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 48 : 40),
                            alignment: Alignment.center,
                            child: Text(
                              con.getStartedList[index].introTitle ?? "",
                              style: TextStyle(
                                fontSize: isTablet ? 30 : 26,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: isTablet ? 48 : 40),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 44 : 36),
                            child: Text(
                              con.getStartedList[index].introSubTitle ?? "",
                              style: TextStyle(fontSize: isTablet ? 17 : 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: buildPageIndicator(),
                ),
              ),
              SizedBox(height: isTablet ? 38 : 30),
              InkWell(
                onTap: () async {
                  con.timers!.cancel();
                  Get.offAllNamed(AppRoutes.loginScreen);
                },
                child: Container(
                  height: isTablet ? 60 : 50,
                  width: isTablet ? 280 : 250,
                  margin: EdgeInsets.symmetric(horizontal: Get.width * 0.14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                      gradient: verticalGradient),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 20 : 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < con.numPages; i++) {
      list.add(i == con.currentPage.value ? indicator(true) : indicator(false));
    }
    return list;
  }

  Widget indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 5),
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8.0),
      height: isTablet ? 11 : 8.0,
      width: isTablet ? 11 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? buttonColor : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
    );
  }
}
