import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_repo;
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/dio_controller.dart';

String hostUrl = 'https://best.obadaja.top/api';
String hostUrlBase = 'https://best.obadaja.top';
Future<Response> logIn(String email, String password) async {
  Dio dio = get_repo.Get.find<DioController>().dio;
  String url = '$hostUrl/login';
  Map<String, dynamic> queryParams = {'email': email, 'password': password};
  Response resp = await dio.post(url,
      queryParameters: queryParams,
      options: Options(headers: {
        'Authorization':
            'Bearer ${get_repo.Get.find<AuthController>().masterAuthToken}',
        'Accept': 'application/json'
      }));

  return resp;
}

///  "CustArbName": str,
///  "email": str,
///  "password":str,
///  "NationalityID": int,
/// "Mobile": str,
/// "CountryID": int,
///  "CityID": int,
/// "Gender": int,
///  "DOB": str,
/// "Code": str,
/// "CustEngName": str

Future<Response> register(Map<String, dynamic> registerBlock) async {
  Dio dio = get_repo.Get.find<DioController>().dio;
  String url = '$hostUrl/register';
  Response resp = await dio.post(url,
      data: registerBlock,
      options: Options(headers: {
        'Authorization':
            'Bearer ${get_repo.Get.find<AuthController>().masterAuthToken}',
        'Accept': 'application/json'
      }));

  return resp;
}

Future<Response> getCategories() async {
  Dio dio = get_repo.Get.find<DioController>().dio;
  String url = '$hostUrl/category';
  Response resp = await dio.get(url,
      options: Options(headers: {
        'Authorization':
            'Bearer ${get_repo.Get.find<AuthController>().getAuthToken()}',
        'Accept': 'application/json'
      }));

  return resp;
}

Future<Response> getSubcategories() async {
  Dio dio = get_repo.Get.find<DioController>().dio;
  String url = '$hostUrl/Subcategory';
  Response resp = await dio.get(url,
      options: Options(headers: {
        'Authorization':
            'Bearer ${get_repo.Get.find<AuthController>().getAuthToken()}',
        'Accept': 'application/json'
      }));

  return resp;
}

Future<Response> getProducts(int countryId) async {
  Dio dio = get_repo.Get.find<DioController>().dio;
  String url = '$hostUrl/products/$countryId';
  Response resp = await dio.get(url,
      options: Options(headers: {
        'Authorization':
            'Bearer ${get_repo.Get.find<AuthController>().getAuthToken()}',
        'Accept': 'application/json'
      }));

  return resp;
}

Future<Response> getCountries() async {
  Dio dio = get_repo.Get.find<DioController>().dio;
  String url = '$hostUrl/countries';
  Response resp = await dio.get(url,
      options: Options(headers: {
        'Authorization':
            'Bearer ${get_repo.Get.find<AuthController>().getAuthToken()}',
        'Accept': 'application/json'
      }));

  return resp;
}

Future<Response> getCities(int countryId) async {
  Dio dio = get_repo.Get.find<DioController>().dio;
  String url = '$hostUrl/cities/$countryId';
  Response resp = await dio.get(url,
      options: Options(headers: {
        'Authorization':
            'Bearer ${get_repo.Get.find<AuthController>().getAuthToken()}',
        'Accept': 'application/json'
      }));

  return resp;
}

Future<Response> getNationalities() async {
  Dio dio = get_repo.Get.find<DioController>().dio;
  String url = '$hostUrl/nationalities';
  Response resp = await dio.get(url,
      options: Options(headers: {
        'Authorization':
            'Bearer ${get_repo.Get.find<AuthController>().getAuthToken()}',
        'Accept': 'application/json'
      }));

  return resp;
}

Future<Response> getGender() async {
  Dio dio = get_repo.Get.find<DioController>().dio;
  String url = '$hostUrl/genders';
  Response resp = await dio.get(url,
      options: Options(headers: {
        'Authorization':
            'Bearer ${get_repo.Get.find<AuthController>().getAuthToken()}',
        'Accept': 'application/json'
      }));

  return resp;
}

Future<Response> getProviders(int countryId) async {
  Dio dio = get_repo.Get.find<DioController>().dio;
  String url = '$hostUrl/providers/$countryId';
  Response resp = await dio.get(url,
      options: Options(headers: {
        'Authorization':
            'Bearer ${get_repo.Get.find<AuthController>().getAuthToken()}',
        'Accept': 'application/json'
      }));

  return resp;
}

Future<Response> getBranches(int spId) async {
  Dio dio = get_repo.Get.find<DioController>().dio;
  String url = '$hostUrl/branches/$spId';
  Response resp = await dio.get(url,
      options: Options(headers: {
        'Authorization':
            'Bearer ${get_repo.Get.find<AuthController>().getAuthToken()}',
        'Accept': 'application/json'
      }));

  return resp;
}

Future<Response> getPhotos(int productId, int serviceProviderId) async {
  Dio dio = get_repo.Get.find<DioController>().dio;
  String url = '$hostUrl/product_photos/$productId/$serviceProviderId';
  Response resp = await dio.get(url,
      options: Options(headers: {
        'Authorization':
            'Bearer ${get_repo.Get.find<AuthController>().getAuthToken()}',
        'Accept': 'application/json'
      }));

  return resp;
}

Future<Response> getCurrencies() async {
  Dio dio = get_repo.Get.find<DioController>().dio;
  String url = '$hostUrl/currencies';
  Response resp = await dio.get(url,
      options: Options(headers: {
        'Authorization':
            'Bearer ${get_repo.Get.find<AuthController>().getAuthToken()}',
        'Accept': 'application/json'
      }));

  return resp;
}

Future<Response> getTax(int countryId) async {
  Dio dio = get_repo.Get.find<DioController>().dio;
  String url = '$hostUrl/tax/$countryId';
  Response resp = await dio.get(url,
      options: Options(headers: {
        'Authorization':
            'Bearer ${get_repo.Get.find<AuthController>().getAuthToken()}',
        'Accept': 'application/json'
      }));

  return resp;
}
