import 'package:realm/realm.dart';
import 'dart:io';

part 'basket_item.realm.dart';

@RealmModel()
class _BasketItem {
  @PrimaryKey()
  late String id;
  late int productId;
  late String userId;
  late String catId;
  late String subcatId;
  late String spId;
  late String spbId;
  late String name;
  late String description;
  late String photo;
  late int active;
  late String spPrice;
  late String spTotal;
  late String idocPrice;
  late String idocDiscountAmt;
  late String idocNet;
  late String idocType;
  late String startDate;
  late String endDate;
  late int availablePurchases;
  late String createdAt;
  late String updatedAt;
  late int quantity;
}
