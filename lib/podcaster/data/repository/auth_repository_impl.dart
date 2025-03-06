import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:puthagam/podcaster/domain/entities/auth/login_response/login_response.dart';
import 'package:puthagam/podcaster/domain/params/auth/login_params.dart';
import 'package:puthagam/podcaster/domain/repository/iauth_repository.dart';

import '../../core/utils/app_utils.dart';

class AuthRepositoryImpl extends IAuthRepositroy {
  @override
  Future<DataState<LoginResponse>> login(LoginParams params) async {
    try {
      log("params $params");

      final httpResponse = await CommonRepository.getApiService().login(params);

      if (httpResponse.response.statusCode == HttpStatus.accepted) {
        return DataSuccess(httpResponse.data);
      }
      return DataFailed(
        DioError(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
          type: DioErrorType.badResponse,
        ),
      );
    } on DioError catch (e) {
      log("DioError ${e.response.toString()}");
      return DataFailed(e);
    }
  }
}
