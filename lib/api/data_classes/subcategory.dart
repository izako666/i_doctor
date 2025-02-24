import 'package:get/get.dart';
import 'package:i_doctor/state/language_controller.dart';

class Subcategory {
  final int id;
  final String code;
  final String name;
  final String? engName;
  final int catId;
  final String createdAt;
  final String updatedAt;

  Subcategory(
      {required this.id,
      required this.code,
      required this.name,
      this.engName,
      required this.catId,
      required this.createdAt,
      required this.updatedAt});

  factory Subcategory.fromJson(Map<String, dynamic> data) {
    return Subcategory(
        id: data['id'],
        code: data['code'],
        name: data['name'],
        catId: data['cat_id'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at'],
        engName: data['EngName']);
  }
  String get localName => Get.find<LanguageController>().locale.value == "en"
      ? engName ?? name
      : name;
}
