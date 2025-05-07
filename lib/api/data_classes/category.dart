import 'package:flutter/material.dart';
import 'package:i_doctor/portable_api/helper.dart';

class Category {
  final int id;
  final String code;
  final String name;
  final String createdAt;
  final String updatedAt;
  Category(
      {required this.id,
      required this.code,
      required this.name,
      required this.createdAt,
      required this.updatedAt});

  factory Category.fromJson(Map<String, dynamic> data) {
    return Category(
        id: data['id'],
        code: data['code'],
        name: data['name'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at']);
  }

  String getCategoryName(BuildContext context) {
    switch (name) {
      case "dental":
        return t(context).dental;
      case "filler_botox":
        return t(context).filler_botox;
      case "laboratory":
        return t(context).laboratory;
      case "laser":
        return t(context).laser;
      case "psychiatry":
        return t(context).psychiatry;
      case "skin":
        return t(context).skin;
      case "spa":
        return t(context).spa;
      default:
        return t(context).dental;
    }
  }
}
