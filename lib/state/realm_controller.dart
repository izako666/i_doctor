import 'package:get/get.dart';
import 'package:i_doctor/api/data_classes/basket_item.dart';
import 'package:realm/realm.dart';

class RealmController extends GetxController {
  late final Realm realm;
  @override
  void onInit() {
    super.onInit();
    var config = Configuration.local([BasketItem.schema], schemaVersion: 2);

    realm = Realm(config);
  }

  @override
  void onClose() {
    super.onClose();
    realm.close();
  }

  List<BasketItem> getItems(String userId) {
    return realm.all<BasketItem>().query(r'userId == $0', [userId]).toList();
  }

  void addItem(BasketItem basketItem) {
    realm.write(() {
      realm.add(basketItem);
    });
  }

  void deleteItem(BasketItem basketItem) {
    realm.write(() {
      realm.delete(basketItem);
    });
  }

  void updateItem(BasketItem item) {
    realm.write(() {
      realm.add(item, update: true);
    });
  }

  void updateQuantity(BasketItem item, int newQuantity) {
    realm.write(() {
      item.quantity = newQuantity;
      realm.add(item, update: true);
    });
  }

  void updateAllItems(List<BasketItem> items) {
    realm.write(() {
      realm.addAll(items, update: true);
    });
  }

  bool containsBasketItem(BasketItem basketItem, String userId) {
    return !realm.all<BasketItem>().query(r'userId == $0 AND productId == $1',
        [userId, basketItem.productId]).isEmpty;
  }

  Stream<RealmResultsChanges<BasketItem>> listenStream(String userId) {
    return realm.all<BasketItem>().query(r'userId == $0', [userId]).changes;
  }
}
