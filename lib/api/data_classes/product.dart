import 'package:get/get.dart';
import 'package:i_doctor/state/auth_controller.dart';

class Product {
  final int id;
  final int catId;
  final int? subcatId;
  final int? spId;
  final int spbId;
  final int countryId;
  final int cityId;
  final int currency;
  final String name;
  final String? name2;
  final String description;
  final String? description2;
  final String photo;
  final int active;
  final String spPrice;
  final dynamic spDiscountPercent;
  final dynamic spDiscountAmount;
  final String spTotal;
  final String idocPrice;
  final String idocDiscountAmt;
  final String idocNet;
  final String idocType;
  final String startDate;
  final String endDate;
  final int availablePurchases;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.catId,
    required this.subcatId,
    required this.spId,
    required this.spbId,
    required this.name,
    required this.name2,
    required this.description,
    required this.description2,
    required this.photo,
    required this.active,
    required this.spPrice,
    required this.spDiscountPercent,
    required this.spDiscountAmount,
    required this.spTotal,
    required this.idocPrice,
    required this.idocDiscountAmt,
    required this.idocNet,
    required this.idocType,
    required this.startDate,
    required this.endDate,
    required this.availablePurchases,
    required this.countryId,
    required this.cityId,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> data) {
    return Product(
        id: data['pro_id'],
        catId: data['cat_id'],
        subcatId: data['subcat_id'],
        spId: data['sp_id'],
        spbId: data['spb_id'],
        name: data['Name1'],
        name2: data['Name2'],
        description: data['Description1'],
        description2: data['Description2'],
        photo: data['Photo'],
        active: data['active'],
        spPrice: data['sp_price'],
        spDiscountPercent: data['sp_discount_percent'],
        spDiscountAmount: data['sp_discount_amount'],
        spTotal: data['sp_total'],
        idocPrice: data['idoc_price'],
        idocDiscountAmt: data['idoc_discount_amount'],
        idocNet: data['idoc_net'],
        idocType: data['idoc_type'],
        startDate: data['start_date'],
        endDate: data['end_date'],
        availablePurchases: data['available_purchase'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at'],
        countryId: data['country_id'],
        cityId: data['city_id'],
        currency: data['currency']);
  }

  String get localName =>
      Get.find<AuthController>().atFirstLocale() ? name : name2 ?? name;
  String get localDesc => Get.find<AuthController>().atFirstLocale()
      ? description
      : description2 ?? description;
}
