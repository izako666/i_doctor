import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:i_doctor/api/encryption.dart';
import 'package:i_doctor/api/networking/rest_functions.dart';
import 'package:i_doctor/portable_api/local_data/local_data.dart';
import 'package:i_doctor/state/auth_controller.dart';

import '../api/data_classes/user.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;
  String? accessToken;

  TokenInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add the access token to headers if available
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if the status code indicates unauthenticated
    if (err.response?.statusCode == 401) {
      // Attempt to refresh the token
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Update the token

          // Retry the original request
          final options = err.requestOptions;
          options.headers['Authorization'] =
              'Bearer ${Get.find<AuthController>().authToken.value ?? ''}';

          final response = await dio.request(
            options.path,
            options: Options(
              method: options.method,
              headers: options.headers,
            ),
            data: options.data,
            queryParameters: options.queryParameters,
          );

          return handler.resolve(response); // Resolve with the retried response
        }
      } catch (e) {
        // Token refresh failed, pass the error further
        return super.onError(err, handler);
      }
    }
    // If not 401 or token refresh failed, forward the error
    super.onError(err, handler);
  }

  Future<String?> _refreshToken() async {
    try {
      String email = LocalDataHandler.readData<String>('email', '');
      String encryptedPassword =
          LocalDataHandler.readData<String>('password', '');
      String password = await decryptPassword(encryptedPassword);
      var resp = await logIn(email, password);
      AuthController auth = Get.find<AuthController>();
      auth.authToken.value = resp.data['data']['token'];
      auth.currentUser.value = User.fromJson(resp.data['data']);
      return resp.data['data']['token'];
    } catch (e) {
      print('Token refresh failed: $e');
      return null;
    }
  }
}

class DioController extends GetxController {
  late Dio dio;

  @override
  void onInit() {
    super.onInit();
    dio = Dio();
    dio.options.validateStatus = (status) {
      return true;
    };
    dio.interceptors.add(TokenInterceptor(dio));
  }
}
