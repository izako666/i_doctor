import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/data_classes/user.dart';
import 'package:i_doctor/api/encryption.dart';
import 'package:i_doctor/api/networking/rest_functions.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/local_data/local_data.dart';
import 'package:i_doctor/state/commerce_controller.dart';

import 'feed_controller.dart';

class AuthController extends GetxController {
  // TODO: this should be deleted when a real authentication system is set up
  Rx<User?> currentUser = Rx<User?>(null);
  Rx<String?> authToken = Rx<String?>(null);
  Rx<String?> currentEmail = Rx<String?>(null);
  Rx<String?> currentPassword = Rx<String?>(null);
  String masterAuthToken = '';
  //Login keys
  RxString passwordError = ''.obs;
  RxString phoneError = ''.obs;
  RxBool showPassword = false.obs;
  RxBool loaded = false.obs;

  late TextEditingController passwordController;
  late TextEditingController phoneController;

  //signup keys
  RxString sPasswordError = ''.obs;
  RxString rePasswordError = ''.obs;
  RxString emailError = ''.obs;
  RxString sPhoneError = ''.obs;
  RxString firstNameError = ''.obs;
  RxString lastNameError = ''.obs;
  RxInt countryId = (-1).obs;
  RxInt cityId = (-1).obs;
  RxInt genderId = (-1).obs;
  RxInt nationalityId = (-1).obs;
  RxString cityError = ''.obs;
  RxString countryError = ''.obs;
  RxString genderError = ''.obs;
  RxString sEmailError = ''.obs;
  RxString dateOfBirth = ''.obs;
  RxString dateOfBirthError = ''.obs;
  RxString sNationalityError = ''.obs;
  DateTime dateOfBirthDate = DateTime(2020);
  RxBool showSPassword = false.obs;
  RxBool showRePassword = false.obs;
  RxString locale = "ar".obs;

  late TextEditingController sPasswordController;
  late TextEditingController rePasswordController;
  late TextEditingController sPhoneController;
  late TextEditingController emailController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController sEmailController;
  late TextEditingController sNationalityController;

  List<Country>? countries;
  List<City>? cities;
  List<Nationality>? nationalities;
  List<Gender>? genders;
  RxBool loadedSignUpData = false.obs;

  @override
  void onInit() {
    super.onInit();

    passwordController = TextEditingController();
    phoneController = TextEditingController();
    sPasswordController = TextEditingController();
    rePasswordController = TextEditingController();
    sPhoneController = TextEditingController();
    emailController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    sEmailController = TextEditingController();
    sNationalityController = TextEditingController();
    rootBundle.loadString('assets/keys/auth_token.json').then((val) {
      var json = jsonDecode(val);
      masterAuthToken = json['auth_token'];
    });

    String email = LocalDataHandler.readData('email', '');
    String encryptedPassword = LocalDataHandler.readData('password', '');
    locale.value = LocalDataHandler.readData('locale', 'ar');
    if (encryptedPassword.isEmpty || email.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loaded.value = true;
      });
      //return;
    } else {
      decryptPassword(encryptedPassword).then((val) async {
        try {
          var resp = await logIn(email, val);
          authToken.value = resp.data['data']['token'];
          currentUser.value = User.fromJson(resp.data['data']);
        } catch (e) {
          print('log in failed');
        }

        loaded.value = true;
      });
    }
  }

  Future<void> retrieveSignUpData() async {
    await retrieveNationalities();
    await retrieveGenders();
    await retrieveCountries();
    loadedSignUpData.value = true;
    Get.put(CommerceController());
    await Get.find<CommerceController>().retrieveCategories();
    await Get.find<CommerceController>().retrieveSubcategories();
    await Get.find<CommerceController>().retrieveProducts();
    await Get.find<CommerceController>().retrieveProviders();

    Get.find<FeedController>().skeleton.value = false;

    loaded.value = true;
  }

  @override
  void onClose() {
    super.onClose();
    passwordController.dispose();
    phoneController.dispose();
    sPasswordController.dispose();
    rePasswordController.dispose();
    sPhoneController.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    sEmailController.dispose();
    sNationalityController.dispose();
  }

  String validatePassword(String value, BuildContext ctx) {
    if (value.isEmpty) {
      return t(ctx).passwordRequired;
    } else if (value.length < 6) {
      return t(ctx).passwordMustOver6;
    }
    return "";
  }

  String validatePhone(String value, BuildContext context) {
    final phoneRegExp = RegExp(r'^\d{10,15}$');
    if (value.isEmpty) {
      return t(context).phoneRequired;
    } else if (!phoneRegExp.hasMatch(value)) {
      return t(context).incorrectPhoneNumber;
    }
    return "";
  }

  String validateEmail(String value, BuildContext context) {
    if (value.isEmpty) {
      return t(context).emailRequired;
    } else if (!value.contains('@')) {
      return t(context).invalidEmail;
    }
    return "";
  }

  String validateFirstName(String value, BuildContext context) {
    if (value.isEmpty) {
      return t(context).nameRequired;
    } else if (value.length < 2) {
      return t(context).nameRequires2Letters;
    }
    return "";
  }

  String validateLastName(String value, BuildContext context) {
    if (value.isEmpty) {
      return t(context).familyNameRequired;
    } else if (value.length < 2) {
      return t(context).familyNameRequires2Letters;
    }
    return "";
  }

  String validateNationality(String value, BuildContext context) {
    if (value.isEmpty) {
      return t(context).nationalityRequired;
    }
    return "";
  }

  String validateRePassword(
      String password, String rePassword, BuildContext context) {
    if (rePassword.isEmpty) {
      return t(context).confirmPassword;
    } else if (password != rePassword) {
      return t(context).passwordNotSame;
    }
    return "";
  }

  bool validateSignup(BuildContext context) {
    sPasswordError.value = validatePassword(sPasswordController.text, context);
    rePasswordError.value = validateRePassword(
        sPasswordController.text, rePasswordController.text, context);
    sEmailError.value = validateEmail(sEmailController.text, context);
    sPhoneError.value = validatePhone(sPhoneController.text, context);
    firstNameError.value = validateFirstName(firstNameController.text, context);
    lastNameError.value = validateLastName(lastNameController.text, context);
    cityError.value = cityId.value == (-1) ? t(context).cityRequired : '';
    countryError.value =
        countryId.value == (-1) ? t(context).countryRequired : '';
    genderError.value = genderId.value == (-1) ? t(context).genderRequired : '';
    dateOfBirthError.value =
        dateOfBirth.value.isEmpty ? t(context).birthdateRequired : '';

    sNationalityError.value =
        nationalityId.value == (-1) ? t(context).nationalityRequired : "";

    if (sPasswordError.isEmpty &&
        rePasswordError.isEmpty &&
        sEmailError.isEmpty &&
        sPhoneError.isEmpty &&
        firstNameError.isEmpty &&
        lastNameError.isEmpty &&
        cityError.isEmpty &&
        countryError.isEmpty &&
        genderError.isEmpty &&
        dateOfBirth.value.isNotEmpty &&
        sNationalityError.isEmpty) {
      return true;
    }
    return false;
  }

  String getAuthToken() {
    if (currentUser.value == null) {
      return masterAuthToken;
    } else {
      return authToken.value ?? '';
    }
  }

  Future<void> retrieveCountries() async {
    try {
      dio.Response resp = await getCountries();
      print(resp);
      if (resp.statusCode == 200) {
        List<Map<String, dynamic>> dataList =
            (resp.data['data'] as List<dynamic>).cast<Map<String, dynamic>>();

        countries = dataList.map((val) => Country.fromJson(val)).toList();

        for (Country country in countries!) {
          await retrieveCities(country.id);
        }
      }
    } catch (e) {
      print("couldn't retrieve countries: $e");
    }
  }

  Future<void> retrieveCities(int id) async {
    try {
      dio.Response resp = await getCities(id);
      print(resp);
      if (resp.statusCode == 200) {
        List<Map<String, dynamic>> dataList =
            (resp.data['data'] as List<dynamic>).cast<Map<String, dynamic>>();
        if (cities == null) {
          cities = dataList.map((val) => City.fromJson(val)).toList();
        } else {
          cities!.addAll(dataList.map((val) => City.fromJson(val)));
        }
      }
    } catch (e) {
      print("couldn't retrieve cities: $e");
    }
  }

  Future<void> retrieveNationalities() async {
    try {
      dio.Response resp = await getNationalities();
      print(resp);
      if (resp.statusCode == 200) {
        List<Map<String, dynamic>> dataList =
            (resp.data['data'] as List<dynamic>).cast<Map<String, dynamic>>();

        nationalities =
            dataList.map((val) => Nationality.fromJson(val)).toList();
      }
    } catch (e) {
      print("couldn't retrieve nationalities: $e");
    }
  }

  Future<void> retrieveGenders() async {
    try {
      dio.Response resp = await getGender();
      print(resp);
      if (resp.statusCode == 200) {
        List<Map<String, dynamic>> dataList =
            (resp.data['data'] as List<dynamic>).cast<Map<String, dynamic>>();

        genders = dataList.map((val) => Gender.fromJson(val)).toList();
      }
    } catch (e) {
      print("couldn't retrieve nationalities: $e");
    }
  }
}
