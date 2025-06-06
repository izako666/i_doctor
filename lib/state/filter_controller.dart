import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:i_doctor/UI/util/data_from_id.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/data_classes/product.dart';
import 'package:i_doctor/api/data_classes/subcategory.dart';
import 'package:i_doctor/state/commerce_controller.dart';

import '../api/data_classes/category.dart';

class FilterController extends GetxController {
  RxInt pageIndex = 0.obs;
  Rx<DateTime> startTime = DateTime(1950).obs;
  Rx<DateTime> endTime = DateTime.now().add(const Duration(days: 365)).obs;

  RxDouble requiredRating = 0.0.obs;

  RxDouble startPrice = 0.0.obs;
  RxDouble endPrice = 2000.0.obs;
  final List<Category>? categoriesTotal;
  //0 to filter by category, 1 to filter by subcategory, 2 to filter by both
  final int categoryType;
  final List<Subcategory>? subCategoriesTotal;
  List<Provider> totalProviders = List.empty(growable: true);
  RxList<Provider> selectedProviders = RxList.empty(growable: true);
  //just in case category has no subcategories
  Category? mainCategory;

  RxString selectedSortCategory = 'appointment_time'.obs;
  final bool filterServiceProviders;
  FilterController(
      {required this.categoryType,
      this.mainCategory,
      this.subCategoriesTotal,
      this.categoriesTotal,
      this.filterServiceProviders = true});

  @override
  void onInit() {
    super.onInit();
    if (categoryType == 0) {
      categoriesSelected.value = List.empty(growable: true);
    } else if (categoryType == 1) {
      subcategoriesSelected.value = List.empty(growable: true);
    } else {
      subcategoriesSelected.value = List.empty(growable: true);

      categoriesSelected.value = List.empty(growable: true);
    }
  }

  void addProviders(List<Product> prods) {
    totalProviders.clear();
    selectedProviders.clear();

    Set<Provider> uniqueProviders = {};

    for (Product prod in prods) {
      Provider? prov = getProviderFromId(prod.spId ?? -1);

      if (prov != null) {
        uniqueProviders.add(prov);
      }
    }

    totalProviders.addAll(uniqueProviders);
    //selectedProviders.addAll(totalProviders);
  }

  void init() {
    if (categoryType == 0) {
      categoriesSelected.value = List.empty(growable: true);
    } else if (categoryType == 1) {
      subcategoriesSelected.value = List.empty(growable: true);
    } else {
      subcategoriesSelected.value = List.empty(growable: true);

      categoriesSelected.value = List.empty(growable: true);
    }
  }

  RxList<Category> categoriesSelected = List<Category>.from([]).obs;
  RxList<Subcategory> subcategoriesSelected = List<Subcategory>.from([]).obs;

  List<Product> filterProducts(List<Product> products) {
    List<Product> filteredProducts = List.empty(growable: true);
    for (Product prod in products) {
      if (double.parse(prod.idocNet) <= endPrice.value &&
          double.parse(prod.idocNet) >= startPrice.value &&
          DateTime.parse(prod.endDate).compareTo(endTime.value) < 0 &&
          DateTime.parse(prod.startDate).compareTo(startTime.value) > 0 &&
          (selectedProviders
                      .where((test) => test.id == prod.spId)
                      .firstOrNull !=
                  null ||
              prod.spId == null ||
              selectedProviders.isEmpty)) {
        if (categoryType == 0 &&
            (categoriesSelected
                    .where((test) => test.id == prod.catId)
                    .isNotEmpty ||
                categoriesSelected.isEmpty)) {
          filteredProducts.add(prod);
        } else if ((categoryType == 1 &&
                subCategoriesTotal!.isEmpty &&
                mainCategory!.id == prod.catId) ||
            (categoryType == 1 &&
                (subcategoriesSelected
                        .where((test) => test.id == prod.subcatId)
                        .isNotEmpty ||
                    subcategoriesSelected.isEmpty))) {
          filteredProducts.add(prod);
        } else if (categoryType == 2) {
          bool addItem = subcategoriesSelected
                  .where((test) => test.id == prod.subcatId)
                  .isNotEmpty ||
              subcategoriesSelected.isEmpty;
          for (Category cat in (categoriesSelected.isEmpty
              ? categoriesTotal!
              : categoriesSelected)) {
            bool catNoSub = subCategoriesTotal!
                .where((test) => test.catId == cat.id)
                .isEmpty;
            if (catNoSub) {
              if (cat.id == prod.catId && subcategoriesSelected.isEmpty) {
                addItem = true;
                break;
              }
            }
          }
          if (addItem) {
            filteredProducts.add(prod);
          }
        }
      }
    }
    return filteredProducts;
  }

  Future<List<Product>> sortProducts(
      List<Product> products, BuildContext context) async {
    List<Product> sortedProducts = List.empty(growable: true);
    sortedProducts.addAll(products);
    switch (selectedSortCategory.value) {
      case 'distance':
        {
          Position? position = await getCurrentLocation(context);
          if (position == null) {
            break;
          }
          sortedProducts.sort((t1, t2) {
            Provider? prov1 = Get.find<CommerceController>()
                .providers
                .where((test) => test.id == t1.spId)
                .firstOrNull;
            Provider? prov2 = Get.find<CommerceController>()
                .providers
                .where((test) => test.id == t2.spId)
                .firstOrNull;
            if (prov1 == null && prov2 == null) {
              return 0;
            } else if (prov1 == null) {
              return 1;
            } else if (prov2 == null) {
              return -1;
            } else {
              List<double> product1 = prov1.location
                  .split(',')
                  .map((e) => double.parse(e))
                  .toList();
              List<double> product2 = prov2.location
                  .split(',')
                  .map((e) => double.parse(e))
                  .toList();
              List<double> user = [position.latitude, position.longitude];
              double distance1 = Geolocator.distanceBetween(
                  user[0], user[1], product1[0], product1[1]);
              double distance2 = Geolocator.distanceBetween(
                  user[0], user[1], product2[0], product2[1]);

              return distance1.compareTo(
                  distance2); // Returns negative if product1 is closer, positive if product2 is closer, 0 if equal
            }
          });
        }
        break;
      case 'rating':
        {}
        break;
      case 'price_high_first':
        {
          sortedProducts.sort((t1, t2) =>
              -(double.parse(t1.idocPrice) - double.parse(t1.idocDiscountAmt))
                  .compareTo(double.parse(t2.idocPrice) -
                      double.parse(t2.idocDiscountAmt)));
        }
        break;
      case 'price_low_first':
        {
          sortedProducts.sort((t1, t2) =>
              (double.parse(t1.idocPrice) - double.parse(t1.idocDiscountAmt))
                  .compareTo(double.parse(t2.idocPrice) -
                      double.parse(t2.idocDiscountAmt)));
        }
        break;
      case 'appointment_time':
        {
          sortedProducts.sort((t1, t2) => DateTime.parse(t1.startDate)
              .compareTo(DateTime.parse(t2.startDate)));
        }
        break;
      case '':
        {}
        break;
    }

    return sortedProducts;
  }

  void resetValues() {
    startTime.value = DateTime(1950);
    endTime.value = DateTime.now().add(const Duration(days: 365));

    requiredRating.value = 0.0;

    startPrice.value = 0.0;
    endPrice.value = 2000.0;

    selectedSortCategory.value = 'appointment_time';
    selectedProviders.clear();
    selectedProviders.addAll(totalProviders);
    init();
  }
}

Future<Position?> getCurrentLocation(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  // Check permission status
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return null;
  }

  // Get the current location
  return await Geolocator.getCurrentPosition();
}
