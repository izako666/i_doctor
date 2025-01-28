import 'package:dio/dio.dart';

class HttpHandler {
  static final dio = Dio();
  static const String baseUrl = "";
  static Future<void> post(String command, dynamic body) async {
    await dio.post('$baseUrl/$command', data: body);
  }
}
