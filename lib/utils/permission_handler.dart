import 'package:geolocator/geolocator.dart';

import 'ihandler_respos.dart';


class CustomPermissionHandler extends BaseCustomPermissionHandler {
  CustomPermissionHandler();
  @override
  Future<LocationPermission> checkLocationAccessPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return permission;
      }
    }
    return permission;
  }
}
