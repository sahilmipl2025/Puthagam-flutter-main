import 'package:puthagam/podcaster/domain/entities/auth/login_response/login_response.dart';
import 'package:puthagam/podcaster/domain/params/auth/login_params.dart';

import '../../core/utils/app_utils.dart';

abstract class IAuthRepositroy {
  Future<DataState<LoginResponse>> login(LoginParams params);
}
