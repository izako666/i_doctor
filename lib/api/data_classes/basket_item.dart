import 'package:realm/realm.dart';

part 'basket_item.realm.dart';

@RealmModel()
class _BasketItem {
  @PrimaryKey()
  late String id;
  late int productId;
  late String userId;
  late int catId;
  late int? subcatId;
  late int? spId;
  late int spbId;
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
  late bool isFavorite;
  late String? name2;
  late String? description2;
  late int currency;
}
