import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutController extends GetxController {
  Future<void> launchGmail() async {
    final Uri _url =
        Uri.parse('mailto:smith@example.org?subject=Feedback&body=Nice work!!');
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
