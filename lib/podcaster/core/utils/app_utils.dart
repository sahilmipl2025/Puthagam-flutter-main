import 'dart:developer';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import '../../data/datasources/remote/app_apis.dart';

showToastMessage({required String title, required String message}) {
  Get.snackbar(title, message, duration: const Duration(seconds: 1));
}

abstract class DataState<T> {
  final T? data;
  final DioError? error;

  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  DataFailed(DioError error) : super(error: error) {
    debugPrint("error ${error.response.toString()}");
    showToastMessage(
        title: "Error",
        message:
            json.decode(error.response.toString())["message"] ?? error.message);
  }
}

class CommonRepository {
  static AppApis _apiService = AppApis(getDio());

  static AppApis getApiService() {
    return _apiService;
  }

  static setApiService() {
    _apiService = AppApis(getDio());
  }

  static Dio getDio() {
    log("token ${LocalStorage.token}");
    return Dio(
      BaseOptions(
          contentType: 'application/json',
          headers: {'Authorization': 'Bearer ${LocalStorage.token}'}),
    );
  }
}
