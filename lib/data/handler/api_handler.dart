import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/utils/local_storage/app_prefs.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';

class ApiHandler {
  static Future<http.Response> get({required String url}) async {
    var box = GetStorage();
    LocalStorage.token = await box.read(Prefs.token) ?? "";

    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "Access-Control-Allow-Origin/Accept",
        'Authorization': 'Bearer ${LocalStorage.token}'
      },
    );
    return response;
  }

  static Future<http.Response> post(
      {required String url, bool? tokenNeed = false, dynamic body}) async {
    var box = GetStorage();
    LocalStorage.token = await box.read(Prefs.token) ?? "";

    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(body), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${LocalStorage.token}'
    });
    return response;
  }

  static Future<http.Response> put(String url) async {
    var box = GetStorage();
    LocalStorage.token = await box.read(Prefs.token) ?? "";

    http.Response response =
        await http.put(Uri.parse(ApiUrls.baseUrl + url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${LocalStorage.token}'
    });
    return response;
  }

  static Future<http.Response> patch({required String url}) async {
    var box = GetStorage();
    LocalStorage.token = await box.read(Prefs.token) ?? "";

    http.Response response = await http.patch(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${LocalStorage.token}'
    });
    return response;
  }

  static Future<http.Response> delete({required String url}) async {
    var box = GetStorage();
    LocalStorage.token = await box.read(Prefs.token) ?? "";

    http.Response response = await http.delete(
      Uri.parse(url),
      headers: {
        "Content-Type": "text/plain",
        'Authorization': 'Bearer ${LocalStorage.token}'
      },
    );

    return response;
  }
}
