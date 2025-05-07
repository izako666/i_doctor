import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:i_doctor/api/data_classes/basket_item.dart';
import 'package:i_doctor/api/data_classes/category.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/data_classes/product.dart';
import 'package:i_doctor/api/data_classes/subcategory.dart';
import 'package:i_doctor/api/networking/rest_functions.dart' as rest;
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/realm_controller.dart';

class CommerceController extends GetxController {
  RxList<Category> categories = RxList.empty(growable: true);
  RxList<Subcategory> subcategories = RxList.empty(growable: true);
  RxList<Product> products = RxList.empty(growable: true);
  RxList<Provider> providers = RxList.empty(growable: true);
  RxList<ProviderBranch> branches = RxList.empty(growable: true);
  RxList<Currency> currencies = RxList.empty(growable: true);

  Future<void> retrieveCategories() async {
    try {
      dio.Response resp = await rest.getCategories();
      print(resp);
      if (resp.statusCode == 200) {
        List<Map<String, dynamic>> dataList =
            (resp.data['data']['resource'] as List<dynamic>)
                .cast<Map<String, dynamic>>();

        categories.value =
            dataList.map((val) => Category.fromJson(val)).toList();
      }
    } catch (e) {
      print("couldn't retrieve categories: $e");
    }
  }

  Future<void> retrieveSubcategories() async {
    try {
      dio.Response resp = await rest.getSubcategories();
      print(resp);
      if (resp.statusCode == 200) {
        List<Map<String, dynamic>> dataList =
            (resp.data['data']['resource'] as List<dynamic>)
                .cast<Map<String, dynamic>>();

        subcategories.value =
            dataList.map((val) => Subcategory.fromJson(val)).toList();
      }
    } catch (e) {
      print("couldn't retrieve subcategories: $e");
    }
  }

  Future<void> retrieveProducts(int countryId) async {
    try {
      dio.Response resp = await rest.getProducts(countryId);
      if (resp.statusCode == 200) {
        List<Map<String, dynamic>> dataList =
            (resp.data['data'] as List<dynamic>).cast<Map<String, dynamic>>();

        products.value = dataList.map((val) => Product.fromJson(val)).toList();
      }
    } catch (e) {
      print("couldn't retrieve products: $e");
    }
  }

  Future<void> retrieveProviders(int countryId) async {
    try {
      dio.Response resp = await rest.getProviders(countryId);
      print(resp);

      if (resp.statusCode == 200) {
        List<Map<String, dynamic>> dataList =
            (resp.data['data'] as List<dynamic>).cast<Map<String, dynamic>>();

        providers.value =
            dataList.map((val) => Provider.fromJson(val)).toList();
      }
    } catch (e) {
      print("couldn't retrieve providers: $e");
    }
  }

  Future<void> resyncBasket() async {
    RealmController realmController = Get.find<RealmController>();
    AuthController auth = Get.find<AuthController>();
    if (auth.currentUser.value == null) {
      return;
    }
    try {
      List<BasketItem> basketItems = List.empty(growable: true);
      // Retrieve products and basket items
      basketItems = realmController.getItems(auth.currentUser.value!.email);

      // Check if products are available
      List<Product> products = Get.find<CommerceController>().products;
      if (products.isEmpty) {
        return;
      }

      // Sync basket items with products
      for (BasketItem basketItem in basketItems) {
        try {
          Product? product =
              products.where((p) => p.id == basketItem.productId).firstOrNull;

          // Validate product
          if (product == null ||
              DateTime.now().isAfter(DateTime.parse(product.endDate)) ||
              product.active == 0) {
            continue;
          }

          // Update available purchases if necessary
          if (basketItem.availablePurchases != product.availablePurchases) {
            basketItem.availablePurchases = product.availablePurchases;

            if (basketItem.quantity > product.availablePurchases) {
              basketItem.quantity = product.availablePurchases;
            }
          }

          // Update other product details if necessary
          if (basketItem.idocNet != product.idocNet ||
              basketItem.idocDiscountAmt != product.idocDiscountAmt ||
              basketItem.idocPrice != product.idocPrice ||
              basketItem.idocType != product.idocType) {
            basketItem.idocNet = product.idocNet;
            basketItem.idocDiscountAmt = product.idocDiscountAmt;
            basketItem.idocPrice = product.idocPrice;
            basketItem.idocType = product.idocType;
          }
        } catch (e) {
          print("Error syncing basket item ID ${basketItem.id}: $e");
        }
        realmController.updateAllItems(basketItems);
      }
    } catch (e) {
      print("Failed to resync basket: $e");
    }
  }

  Future<void> retrieveBranches(int spId) async {
    try {
      dio.Response resp = await rest.getBranches(spId);
      print(resp);

      if (resp.statusCode == 200) {
        List<Map<String, dynamic>> dataList =
            (resp.data['data'] as List<dynamic>).cast<Map<String, dynamic>>();
        branches.addAll(
            dataList.map((val) => ProviderBranch.fromJson(val)).toList());
      }
    } catch (e) {
      print("couldn't retrieve branches: $e");
    }
  }

  Future<void> retrieveCurrencies() async {
    try {
      dio.Response resp = await rest.getCurrencies();
      print(resp);
      if (resp.statusCode == 200) {
        List<Map<String, dynamic>> dataList =
            (resp.data['data'] as List<dynamic>).cast<Map<String, dynamic>>();

        currencies
            .addAll(dataList.map((val) => Currency.fromJson(val)).toList());
      }
    } catch (e) {
      print("couldn't retrieve currencies: $e");
    }
  }
}
