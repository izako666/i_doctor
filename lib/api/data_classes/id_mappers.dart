// Country Data Model
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/state/auth_controller.dart';

class Country {
  final int id;
  final String code;
  final String name1;
  final String name2;
  final String lang1;
  final String lang2;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Country({
    required this.id,
    required this.code,
    required this.name1,
    required this.name2,
    required this.lang1,
    required this.lang2,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['ID'],
      code: json['Code'],
      name1: json['Name1'],
      name2: json['Name2'],
      lang1: json['Lang1'],
      lang2: json['Lang2'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Code': code,
      'Name1': name1,
      'Name2': name2,
      'Lang1': lang1,
      'Lang2': lang2,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  String get name => Get.find<AuthController>().atFirstLocale() ? name1 : name2;
}

// City Data Model
class City {
  final int id;
  final String code;
  final String name1;
  final String name2;
  final int countryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  City({
    required this.id,
    required this.code,
    required this.name1,
    required this.name2,
    required this.countryId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['ID'],
      code: json['Code'],
      name1: json['Name1'],
      name2: json['Name2'],
      countryId: json['CountryID'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Code': code,
      'Name1': name1,
      'Name2': name2,
      'CountryID': countryId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  String get name => Get.find<AuthController>().atFirstLocale() ? name1 : name2;
}

// Nationality Data Model
class Nationality {
  final int id;
  final String? code;
  final String name;
  final String? engName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Nationality({
    required this.id,
    this.code,
    required this.name,
    this.engName,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Nationality.fromJson(Map<String, dynamic> json) {
    return Nationality(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      engName: json['EngName'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'EngName': engName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  String getNationalityName(BuildContext context) {
    switch (name) {
      case "syria":
        return t(context).syria;
      case "egypt":
        return t(context).egypt;
      case "jordan":
        return t(context).jordan;
      case "uae":
        return t(context).uae;
      case "ksa":
        return t(context).ksa;
      case "lebanon":
        return t(context).lebanon;
      default:
        return t(context).syria;
    }
  }
}

// Gender Data Model
class Gender {
  final int id;
  final String code;
  final String? arbName;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Gender({
    required this.id,
    required this.code,
    this.arbName,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(
      id: json['id'],
      code: json['code'],
      arbName: json['ArbName'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'ArbName': arbName,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  String getGenderName(BuildContext context) {
    switch (name) {
      case "Male":
        return t(context).male;
      case "Female":
        return t(context).female;
      default:
        return t(context).male;
    }
  }
}

class Provider {
  final int id;
  final String code;
  final String name1;
  final String? name2;
  final int countryId;
  final int cityId;
  final String district;
  final String? district2;
  final String shortAddress;
  final String? shortAddress2;
  final String buildingNo;
  final String street;
  final String? street2;
  final String secondaryNo;
  final String postalCode;
  final String commercialNo;
  final String vatNo;
  final String location;
  final String deductionRate;
  final int salesId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String photo;
  final String logo;

  Provider(
      {required this.id,
      required this.code,
      required this.name1,
      required this.countryId,
      required this.cityId,
      required this.district,
      required this.shortAddress,
      required this.buildingNo,
      required this.street,
      required this.secondaryNo,
      required this.postalCode,
      required this.commercialNo,
      required this.vatNo,
      required this.location,
      required this.deductionRate,
      required this.salesId,
      required this.createdAt,
      required this.updatedAt,
      required this.deletedAt,
      required this.photo,
      required this.logo,
      required this.name2,
      required this.district2,
      required this.shortAddress2,
      required this.street2});

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
        id: json['id'],
        code: json['Code'],
        name1: json['Name1'],
        name2: json['Name2'],
        countryId: json['CountryID'],
        cityId: json['CityID'],
        district: json['District1'],
        district2: json['District2'],
        shortAddress: json['ShortAddress1'],
        shortAddress2: json['ShortAddress2'],
        buildingNo: json['BuildingNo'],
        street: json['Street1'],
        street2: json['Street2'],
        secondaryNo: json['SecondaryNo'],
        postalCode: json['PostalCode'],
        commercialNo: json['CommercialNo'],
        vatNo: json['VATNo'],
        location: json['Location'],
        deductionRate: json['DeductionRate'],
        salesId: json['SalesID'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        deletedAt: json['deleted_at'],
        photo: json['Photo'],
        logo: json['Logo']);
  }
  String get localName =>
      Get.find<AuthController>().atFirstLocale() ? name1 : name2 ?? name1;
  String get localDistrict => Get.find<AuthController>().atFirstLocale()
      ? district
      : district2 ?? district;
  String get localShortAddress => Get.find<AuthController>().atFirstLocale()
      ? shortAddress
      : shortAddress2 ?? shortAddress;

  String get localStreet =>
      Get.find<AuthController>().atFirstLocale() ? street : street2 ?? street;
}

class ProviderBranch {
  final int id;
  final int spId;
  final String code;
  final String name1;
  final String? name2;
  final int countryId;
  final int cityId;
  final String district;
  final String? district2;
  final String shortAddress;
  final String? shortAddress2;
  final String buildingNo;
  final String street;
  final String? street2;
  final String secondaryNo;
  final String postalCode;
  final String commercialNo;
  final String vatNo;
  final String location;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  ProviderBranch(
      {required this.id,
      required this.spId,
      required this.code,
      required this.name1,
      required this.countryId,
      required this.cityId,
      required this.district,
      required this.shortAddress,
      required this.buildingNo,
      required this.street,
      required this.secondaryNo,
      required this.postalCode,
      required this.commercialNo,
      required this.vatNo,
      required this.location,
      required this.createdAt,
      required this.updatedAt,
      required this.deletedAt,
      required this.name2,
      required this.district2,
      required this.shortAddress2,
      required this.street2});

  factory ProviderBranch.fromJson(Map<String, dynamic> json) {
    return ProviderBranch(
      id: json['id'],
      spId: json['sp_id'],
      code: json['Code'],
      name1: json['Name1'],
      name2: json['Name2'],
      countryId: json['CountryID'],
      cityId: json['CityID'],
      district: json['District1'],
      district2: json['District2'],
      shortAddress: json['ShortAddress1'],
      shortAddress2: json['ShortAddress2'],
      buildingNo: json['BuildingNo'],
      street: json['Street1'],
      street2: json['Street2'],
      secondaryNo: json['SecondaryNo'],
      postalCode: json['PostalCode'],
      commercialNo: json['CommercialNo'],
      vatNo: json['VATNo'],
      location: json['Location'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
  String get localName =>
      Get.find<AuthController>().atFirstLocale() ? name1 : name2 ?? name1;
  String get localDistrict => Get.find<AuthController>().atFirstLocale()
      ? district
      : district2 ?? district;
  String get localShortAddress => Get.find<AuthController>().atFirstLocale()
      ? shortAddress
      : shortAddress2 ?? shortAddress;

  String get localStreet =>
      Get.find<AuthController>().atFirstLocale() ? street : street2 ?? street;
}

class Currency {
  int id;
  String name1;
  String name2;

  Currency({required this.id, required this.name1, required this.name2});

  String get localName =>
      Get.find<AuthController>().atFirstLocale() ? name1 : name2;

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(id: json['id'], name1: json['Name1'], name2: json['Name2']);
  }
}
