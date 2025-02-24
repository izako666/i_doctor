// Country Data Model
import 'package:get/get.dart';
import 'package:i_doctor/state/language_controller.dart';

class Country {
  final int id;
  final String code;
  final String arbName;
  final String engName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Country({
    required this.id,
    required this.code,
    required this.arbName,
    required this.engName,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['ID'],
      code: json['Code'],
      arbName: json['ArbName'],
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
      'ID': id,
      'Code': code,
      'ArbName': arbName,
      'EngName': engName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  String get name =>
      Get.find<LanguageController>().locale.value == "en" ? engName : arbName;
}

// City Data Model
class City {
  final int id;
  final String code;
  final String arbName;
  final String engName;
  final int countryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  City({
    required this.id,
    required this.code,
    required this.arbName,
    required this.engName,
    required this.countryId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['ID'],
      code: json['Code'],
      arbName: json['ArbName'],
      engName: json['EngName'],
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
      'ArbName': arbName,
      'EngName': engName,
      'CountryID': countryId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  String get name =>
      Get.find<LanguageController>().locale.value == "en" ? engName : arbName;
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

  String get localName => Get.find<LanguageController>().locale.value == "en"
      ? engName ?? name
      : name;
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

  String get localName => Get.find<LanguageController>().locale.value == "en"
      ? name
      : arbName ?? name;
}

class Provider {
  final int id;
  final String code;
  final String name;
  final int countryId;
  final int cityId;
  final String district;
  final String shortAddress;
  final String buildingNo;
  final String street;
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
      required this.name,
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
      required this.logo});

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
        id: json['id'],
        code: json['Code'],
        name: json['Name'],
        countryId: json['CountryID'],
        cityId: json['CityID'],
        district: json['District'],
        shortAddress: json['ShortAddress'],
        buildingNo: json['BuildingNo'],
        street: json['Street'],
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
}
