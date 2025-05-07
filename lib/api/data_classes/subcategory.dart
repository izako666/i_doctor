import 'package:flutter/material.dart';
import 'package:i_doctor/portable_api/helper.dart';

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
  String getSubCategoryName(BuildContext context) {
    switch (name) {
      case "Areas laser":
        return t(context).areasLaser;
      case "Complete laser":
        return t(context).completeLaser;

      case "Cosmetic dental":
        return t(context).cosmeticDental;

      case "Dental cleaning":
        return t(context).dentalCleaning;

      case "Dental crowns":
        return t(context).dentalCrowns;

      case "Dental treatment":
        return t(context).dentalTreatment;

      case "Orthodontics":
        return t(context).orthodontics;

      case "X-ray":
        return t(context).xRay;

      case "رجال":
        return t(context).men;

      case "نساء":
        return t(context).women;
      default:
        return t(context).areasLaser;
    }
  }
}
