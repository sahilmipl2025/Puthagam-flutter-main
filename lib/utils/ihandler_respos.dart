import 'package:geolocator/geolocator.dart';

abstract class BaseCustomPermissionHandler {
  Future<LocationPermission> checkLocationAccessPermission();
}
