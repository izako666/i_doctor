import 'package:get/get.dart';
import 'package:i_doctor/api/data_classes/product.dart';
import 'package:i_doctor/api/data_classes/subcategory.dart';

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

  FilterController(
      {required this.categoryType,
      this.subCategoriesTotal,
      this.categoriesTotal});

  @override
  void onInit() {
    super.onInit();
    if (categoryType == 0) {
      categoriesSelected.value = List.from(categoriesTotal!);
    } else if (categoryType == 1) {
      subcategoriesSelected.value = List.from(subCategoriesTotal!);
    } else {
      subcategoriesSelected.value = List.from(subCategoriesTotal!);

      categoriesSelected.value = List.from(categoriesTotal!);
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
          DateTime.parse(prod.startDate).compareTo(startTime.value) > 0) {
        if (categoryType == 0 &&
            categoriesSelected
                .where((test) => test.name == prod.catId)
                .isNotEmpty) {
          filteredProducts.add(prod);
        } else if (categoryType == 1 &&
            subcategoriesSelected
                .where((test) => test.name == prod.subcatId)
                .isNotEmpty) {
          filteredProducts.add(prod);
        } else if (subcategoriesSelected
            .where((test) => test.name == prod.subcatId)
            .isNotEmpty) {
          filteredProducts.add(prod);
        }
      }
    }
    return filteredProducts;
  }
}
