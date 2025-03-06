import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puthagam/screen/dashboard/profile/term_sevices/term_service_controller.dart';
import 'package:puthagam/utils/colors.dart';
import 'package:puthagam/utils/themes/global.dart';

class TermConditions extends StatelessWidget {
  TermConditions({Key? key}) : super(key: key);
  final TermServiceController con = Get.put(TermServiceController());

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Get.theme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: GlobalService.to.isDarkModel == true
            ? Colors.grey.withOpacity(.3)
            : Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: GlobalService.to.isDarkModel == true
                  ? Colors.white
                  : Colors.black,
            )),
        title: Text(
          'Terms of service'.tr,
          style: TextStyle(
              color: GlobalService.to.isDarkModel == true
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: context.isTablet ? 26 : 22),
        ),
      ),
      body: SizedBox(
        width: 800,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1,
            child: Card(
              color: theme.cardColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                  style: TextStyle(fontSize: 17, color: headingColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
