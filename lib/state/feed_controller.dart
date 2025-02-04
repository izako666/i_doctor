import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_doctor/api/data_classes/product.dart';
import 'package:i_doctor/state/commerce_controller.dart';
import 'package:i_doctor/state/filter_controller.dart';

class FeedController extends GetxController {
  late TextEditingController searchController;
  late FocusNode node;
  RxBool searchFocus = false.obs;
  RxBool skeleton = true.obs;
  RxBool openFeedView = true.obs;
  Rx<String> searchVal = "".obs;
  FilterController? controller;
  @override
  void onInit() {
    super.onInit();
    node = FocusNode();
    node.addListener(() {
      if (node.hasFocus && openFeedView.value) {
        controller = Get.put(
            FilterController(
                categoryType: 2,
                categoriesTotal: Get.find<CommerceController>().categories,
                subCategoriesTotal:
                    Get.find<CommerceController>().subcategories),
            permanent: false);
        controller!.onInit();
        openFeedView.value = false;
      }
      searchFocus.value = node.hasFocus;
    });
    searchController = TextEditingController();
    searchController.addListener(() {
      searchVal.value = searchController.text;
    });
  }

  @override
  void onClose() {
    super.onClose();
    node.dispose();
    searchController.dispose();
  }

  Future<List<Product>> filterSearch(
      List<Product> products, BuildContext context) async {
    if (controller == null) return products;
    List<Product> filteredProducts = controller!.filterProducts(products);

    List<Product> searchedProducts = List.empty(growable: true);

    for (Product prod in filteredProducts) {
      if (prod.name.contains(searchController.text) ||
          prod.description.contains(searchController.text)) {
        searchedProducts.add(prod);
      }
    }
    List<Product> sortedProducts =
        await controller!.sortProducts(searchedProducts, context);

    return sortedProducts;
  }
}
