import 'package:get/get.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/commerce_controller.dart';

Provider? getProviderFromId(int spId) {
  return Get.find<CommerceController>()
      .providers
      .where((test) => test.id == spId)
      .firstOrNull;
}

ProviderBranch? getProviderBranchFromId(int spbId) {
  return Get.find<CommerceController>()
      .branches
      .where((test) => test.id == spbId)
      .firstOrNull;
}

Country? getCountryFromId(int cId) {
  return Get.find<AuthController>()
      .countries!
      .where((test) => test.id == cId)
      .firstOrNull;
}

City? getCityFromId(int cId) {
  return Get.find<AuthController>()
      .cities!
      .where((test) => test.id == cId)
      .firstOrNull;
}

Nationality? getNationalityFromId(int nId) {
  return Get.find<AuthController>()
      .nationalities!
      .where((test) => test.id == nId)
      .firstOrNull;
}

Gender? getGenderFromId(int gId) {
  return Get.find<AuthController>()
      .genders!
      .where((test) => test.id == gId)
      .firstOrNull;
}

Country? getCountryFromIsoCode(String code) {
  return Get.find<AuthController>()
      .countries!
      .where((test) => test.code.toLowerCase() == code)
      .firstOrNull;
}

Currency? getCurrencyFromId(int currId) {
  return Get.find<CommerceController>()
      .currencies
      .where((test) => test.id == currId)
      .firstOrNull;
}
