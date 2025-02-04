import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/ad_list_page.dart';
import 'package:i_doctor/UI/pages/clinic_list_view.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/filter_sort_sheet.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/api/data_classes/category.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/data_classes/product.dart';
import 'package:i_doctor/api/data_classes/subcategory.dart';
import 'package:i_doctor/fake_data.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/ui/bottom_sheet.dart';
import 'package:i_doctor/state/commerce_controller.dart';
import 'package:i_doctor/state/filter_controller.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key, required this.id});
  final String id;
  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  int pageIndex = 0;

  @override
  void dispose() {
    super.dispose();
    Get.delete<FilterController>();
  }

  @override
  Widget build(BuildContext context) {
    Category? category = (Get.find<CommerceController>().categories ?? [])
        .where((test) => test.id == int.parse(widget.id))
        .firstOrNull;
    if (category == null) {
      return const LoadingIndicator();
    }
    List<Provider> providers = Get.find<CommerceController>()
        .providers
        .where((test) => category.id == int.parse(test.code))
        .toList();
    List<Subcategory> subCategory =
        List.from(Get.find<CommerceController>().subcategories ?? []);
    subCategory =
        subCategory.where((test) => category.id == test.catId).toList();
    FilterController filterController = Get.put(
        FilterController(categoryType: 1, subCategoriesTotal: subCategory));
    List<Product> products = filterController
        .filterProducts(Get.find<CommerceController>().products ?? []);
    return Scaffold(
      appBar: const IAppBar(
        title: "فئة",
        hasBackButton: true,
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          await showIzBottomSheet(
              context: context,
              child: FilterSortSheet(filterController: filterController));
          setState(() {});
        },
        child: Icon(
          Icons.filter_alt,
          color: secondaryColor.darken(0.5),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              width: getScreenWidth(context),
              height: 64,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: pageIndex == 0
                                ? const BorderSide(
                                    color: primaryColor, width: 2)
                                : BorderSide.none),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            pageIndex = 0;
                            setState(() {});
                          },
                          child: Column(
                            children: [
                              Icon(Icons.supervised_user_circle_sharp,
                                  color: pageIndex == 0
                                      ? primaryColor
                                      : Colors.grey),
                              const Text("الخدمات")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: pageIndex == 1
                                  ? const BorderSide(
                                      color: primaryColor, width: 2)
                                  : BorderSide.none)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            pageIndex = 1;
                            setState(() {});
                          },
                          child: Column(
                            children: [
                              Icon(Icons.business,
                                  color: pageIndex == 1
                                      ? primaryColor
                                      : Colors.grey),
                              const Text("العيادات")
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (pageIndex == 0)
            SliverList.builder(
              itemBuilder: (ctx, i) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: BigProductCard(
                    product: products[i],
                    provider: Get.find<CommerceController>()
                        .providers
                        .where((test) => test.name == products[i].spId)
                        .firstOrNull),
              ),
              itemCount: products.length,
            ),
          if (pageIndex == 1)
            SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.7),
              itemBuilder: (ctx, i) => ClinicButton(provider: providers[i]),
              itemCount: providers.length,
            )
        ],
      ),
    );
  }
}
