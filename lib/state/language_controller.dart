import 'package:get/get.dart';
import 'package:i_doctor/portable_api/local_data/local_data.dart';

class LanguageController extends GetxController {
  RxString locale = "ar".obs;
  Map<String, String> localeLangMap = {'en': "English", 'ar': "عربي"};
  @override
  void onInit() {
    super.onInit();
    locale.value = LocalDataHandler.readData("locale", "en");
  }

  void setLocale(String val) {
    LocalDataHandler.addData("locale", val);
    locale.value = val;
  }
}
