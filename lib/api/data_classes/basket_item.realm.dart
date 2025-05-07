// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket_item.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class BasketItem extends _BasketItem
    with RealmEntity, RealmObjectBase, RealmObject {
  BasketItem(
    String id,
    int productId,
    String userId,
    int catId,
    int spbId,
    String name,
    String description,
    String photo,
    int active,
    String spPrice,
    String spTotal,
    String idocPrice,
    String idocDiscountAmt,
    String idocNet,
    String idocType,
    String startDate,
    String endDate,
    int availablePurchases,
    String createdAt,
    String updatedAt,
    int quantity,
    bool isFavorite,
    int currency, {
    int? subcatId,
    int? spId,
    String? name2,
    String? description2,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'productId', productId);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'catId', catId);
    RealmObjectBase.set(this, 'subcatId', subcatId);
    RealmObjectBase.set(this, 'spId', spId);
    RealmObjectBase.set(this, 'spbId', spbId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'photo', photo);
    RealmObjectBase.set(this, 'active', active);
    RealmObjectBase.set(this, 'spPrice', spPrice);
    RealmObjectBase.set(this, 'spTotal', spTotal);
    RealmObjectBase.set(this, 'idocPrice', idocPrice);
    RealmObjectBase.set(this, 'idocDiscountAmt', idocDiscountAmt);
    RealmObjectBase.set(this, 'idocNet', idocNet);
    RealmObjectBase.set(this, 'idocType', idocType);
    RealmObjectBase.set(this, 'startDate', startDate);
    RealmObjectBase.set(this, 'endDate', endDate);
    RealmObjectBase.set(this, 'availablePurchases', availablePurchases);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'quantity', quantity);
    RealmObjectBase.set(this, 'isFavorite', isFavorite);
    RealmObjectBase.set(this, 'name2', name2);
    RealmObjectBase.set(this, 'description2', description2);
    RealmObjectBase.set(this, 'currency', currency);
  }

  BasketItem._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  int get productId => RealmObjectBase.get<int>(this, 'productId') as int;
  @override
  set productId(int value) => RealmObjectBase.set(this, 'productId', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  int get catId => RealmObjectBase.get<int>(this, 'catId') as int;
  @override
  set catId(int value) => RealmObjectBase.set(this, 'catId', value);

  @override
  int? get subcatId => RealmObjectBase.get<int>(this, 'subcatId') as int?;
  @override
  set subcatId(int? value) => RealmObjectBase.set(this, 'subcatId', value);

  @override
  int? get spId => RealmObjectBase.get<int>(this, 'spId') as int?;
  @override
  set spId(int? value) => RealmObjectBase.set(this, 'spId', value);

  @override
  int get spbId => RealmObjectBase.get<int>(this, 'spbId') as int;
  @override
  set spbId(int value) => RealmObjectBase.set(this, 'spbId', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String get photo => RealmObjectBase.get<String>(this, 'photo') as String;
  @override
  set photo(String value) => RealmObjectBase.set(this, 'photo', value);

  @override
  int get active => RealmObjectBase.get<int>(this, 'active') as int;
  @override
  set active(int value) => RealmObjectBase.set(this, 'active', value);

  @override
  String get spPrice => RealmObjectBase.get<String>(this, 'spPrice') as String;
  @override
  set spPrice(String value) => RealmObjectBase.set(this, 'spPrice', value);

  @override
  String get spTotal => RealmObjectBase.get<String>(this, 'spTotal') as String;
  @override
  set spTotal(String value) => RealmObjectBase.set(this, 'spTotal', value);

  @override
  String get idocPrice =>
      RealmObjectBase.get<String>(this, 'idocPrice') as String;
  @override
  set idocPrice(String value) => RealmObjectBase.set(this, 'idocPrice', value);

  @override
  String get idocDiscountAmt =>
      RealmObjectBase.get<String>(this, 'idocDiscountAmt') as String;
  @override
  set idocDiscountAmt(String value) =>
      RealmObjectBase.set(this, 'idocDiscountAmt', value);

  @override
  String get idocNet => RealmObjectBase.get<String>(this, 'idocNet') as String;
  @override
  set idocNet(String value) => RealmObjectBase.set(this, 'idocNet', value);

  @override
  String get idocType =>
      RealmObjectBase.get<String>(this, 'idocType') as String;
  @override
  set idocType(String value) => RealmObjectBase.set(this, 'idocType', value);

  @override
  String get startDate =>
      RealmObjectBase.get<String>(this, 'startDate') as String;
  @override
  set startDate(String value) => RealmObjectBase.set(this, 'startDate', value);

  @override
  String get endDate => RealmObjectBase.get<String>(this, 'endDate') as String;
  @override
  set endDate(String value) => RealmObjectBase.set(this, 'endDate', value);

  @override
  int get availablePurchases =>
      RealmObjectBase.get<int>(this, 'availablePurchases') as int;
  @override
  set availablePurchases(int value) =>
      RealmObjectBase.set(this, 'availablePurchases', value);

  @override
  String get createdAt =>
      RealmObjectBase.get<String>(this, 'createdAt') as String;
  @override
  set createdAt(String value) => RealmObjectBase.set(this, 'createdAt', value);

  @override
  String get updatedAt =>
      RealmObjectBase.get<String>(this, 'updatedAt') as String;
  @override
  set updatedAt(String value) => RealmObjectBase.set(this, 'updatedAt', value);

  @override
  int get quantity => RealmObjectBase.get<int>(this, 'quantity') as int;
  @override
  set quantity(int value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  bool get isFavorite => RealmObjectBase.get<bool>(this, 'isFavorite') as bool;
  @override
  set isFavorite(bool value) => RealmObjectBase.set(this, 'isFavorite', value);

  @override
  String? get name2 => RealmObjectBase.get<String>(this, 'name2') as String?;
  @override
  set name2(String? value) => RealmObjectBase.set(this, 'name2', value);

  @override
  String? get description2 =>
      RealmObjectBase.get<String>(this, 'description2') as String?;
  @override
  set description2(String? value) =>
      RealmObjectBase.set(this, 'description2', value);

  @override
  int get currency => RealmObjectBase.get<int>(this, 'currency') as int;
  @override
  set currency(int value) => RealmObjectBase.set(this, 'currency', value);

  @override
  Stream<RealmObjectChanges<BasketItem>> get changes =>
      RealmObjectBase.getChanges<BasketItem>(this);

  @override
  Stream<RealmObjectChanges<BasketItem>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<BasketItem>(this, keyPaths);

  @override
  BasketItem freeze() => RealmObjectBase.freezeObject<BasketItem>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'productId': productId.toEJson(),
      'userId': userId.toEJson(),
      'catId': catId.toEJson(),
      'subcatId': subcatId.toEJson(),
      'spId': spId.toEJson(),
      'spbId': spbId.toEJson(),
      'name': name.toEJson(),
      'description': description.toEJson(),
      'photo': photo.toEJson(),
      'active': active.toEJson(),
      'spPrice': spPrice.toEJson(),
      'spTotal': spTotal.toEJson(),
      'idocPrice': idocPrice.toEJson(),
      'idocDiscountAmt': idocDiscountAmt.toEJson(),
      'idocNet': idocNet.toEJson(),
      'idocType': idocType.toEJson(),
      'startDate': startDate.toEJson(),
      'endDate': endDate.toEJson(),
      'availablePurchases': availablePurchases.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
      'quantity': quantity.toEJson(),
      'isFavorite': isFavorite.toEJson(),
      'name2': name2.toEJson(),
      'description2': description2.toEJson(),
      'currency': currency.toEJson(),
    };
  }

  static EJsonValue _toEJson(BasketItem value) => value.toEJson();
  static BasketItem _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'productId': EJsonValue productId,
        'userId': EJsonValue userId,
        'catId': EJsonValue catId,
        'spbId': EJsonValue spbId,
        'name': EJsonValue name,
        'description': EJsonValue description,
        'photo': EJsonValue photo,
        'active': EJsonValue active,
        'spPrice': EJsonValue spPrice,
        'spTotal': EJsonValue spTotal,
        'idocPrice': EJsonValue idocPrice,
        'idocDiscountAmt': EJsonValue idocDiscountAmt,
        'idocNet': EJsonValue idocNet,
        'idocType': EJsonValue idocType,
        'startDate': EJsonValue startDate,
        'endDate': EJsonValue endDate,
        'availablePurchases': EJsonValue availablePurchases,
        'createdAt': EJsonValue createdAt,
        'updatedAt': EJsonValue updatedAt,
        'quantity': EJsonValue quantity,
        'isFavorite': EJsonValue isFavorite,
        'currency': EJsonValue currency,
      } =>
        BasketItem(
          fromEJson(id),
          fromEJson(productId),
          fromEJson(userId),
          fromEJson(catId),
          fromEJson(spbId),
          fromEJson(name),
          fromEJson(description),
          fromEJson(photo),
          fromEJson(active),
          fromEJson(spPrice),
          fromEJson(spTotal),
          fromEJson(idocPrice),
          fromEJson(idocDiscountAmt),
          fromEJson(idocNet),
          fromEJson(idocType),
          fromEJson(startDate),
          fromEJson(endDate),
          fromEJson(availablePurchases),
          fromEJson(createdAt),
          fromEJson(updatedAt),
          fromEJson(quantity),
          fromEJson(isFavorite),
          fromEJson(currency),
          subcatId: fromEJson(ejson['subcatId']),
          spId: fromEJson(ejson['spId']),
          name2: fromEJson(ejson['name2']),
          description2: fromEJson(ejson['description2']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(BasketItem._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, BasketItem, 'BasketItem', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('productId', RealmPropertyType.int),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('catId', RealmPropertyType.int),
      SchemaProperty('subcatId', RealmPropertyType.int, optional: true),
      SchemaProperty('spId', RealmPropertyType.int, optional: true),
      SchemaProperty('spbId', RealmPropertyType.int),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('photo', RealmPropertyType.string),
      SchemaProperty('active', RealmPropertyType.int),
      SchemaProperty('spPrice', RealmPropertyType.string),
      SchemaProperty('spTotal', RealmPropertyType.string),
      SchemaProperty('idocPrice', RealmPropertyType.string),
      SchemaProperty('idocDiscountAmt', RealmPropertyType.string),
      SchemaProperty('idocNet', RealmPropertyType.string),
      SchemaProperty('idocType', RealmPropertyType.string),
      SchemaProperty('startDate', RealmPropertyType.string),
      SchemaProperty('endDate', RealmPropertyType.string),
      SchemaProperty('availablePurchases', RealmPropertyType.int),
      SchemaProperty('createdAt', RealmPropertyType.string),
      SchemaProperty('updatedAt', RealmPropertyType.string),
      SchemaProperty('quantity', RealmPropertyType.int),
      SchemaProperty('isFavorite', RealmPropertyType.bool),
      SchemaProperty('name2', RealmPropertyType.string, optional: true),
      SchemaProperty('description2', RealmPropertyType.string, optional: true),
      SchemaProperty('currency', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
