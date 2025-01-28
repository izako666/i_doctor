import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/appointments_page.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/api/data_classes/basket_item.dart';
import 'package:i_doctor/api/data_classes/product.dart';
import 'package:i_doctor/fake_data.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/router.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/commerce_controller.dart';
import 'package:i_doctor/state/realm_controller.dart';
import 'package:realm/realm.dart';

class ConfirmBasketPage extends StatefulWidget {
  const ConfirmBasketPage({super.key});

  @override
  State<ConfirmBasketPage> createState() => _ConfirmBasketPageState();
}

class _ConfirmBasketPageState extends State<ConfirmBasketPage> {
  bool loaded = false;
  bool failed = false;
  bool showErrorDialogue = false;
  double totalPrice = 0;
  double totalDiscount = 0;

  List<BasketItem> basketItems = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    loadAsync().then((_) {
      if (showErrorDialogue) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showErrorDialogue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'تم تحديث بعض المنتجات في السلة، يرجى التحقق قبل المتابعة.')));
        showErrorDialogue = false;
      });
    }
    return Scaffold(
      appBar: const IAppBar(
        title: 'اكد الطلب',
        toolbarHeight: kToolbarHeight,
        hasBackButton: false,
      ),
      body: loaded
          ? failed
              ? const Center(
                  child:
                      Text('حدث خطأ ما، يرجى المحاولة مرة أخرى في وقت لاحق.'))
              : CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 16),
                    ),
                    SliverList.builder(
                      itemBuilder: (ctx, i) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 4),
                        child: BasketCard(
                          isDisplay: true,
                          basketItem: basketItems[i],
                          onDelete: () {},
                        ),
                      ),
                      itemCount: basketItems.length,
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16),
                        child: ElevatedContainer(
                            blackWhite: getBlackWhite(context),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("السعر الاصلي"),
                                        Text('$totalPrice ر.س')
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("الضريبة (ضريبة القيمة المضافة)"),
                                        Text('0 ر.س'),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("الخصم"),
                                        Text('$totalDiscount ر.س'),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const Divider(),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("السعر الإجمالي",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            '${totalPrice - totalDiscount} ر.س',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ]),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 8),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: WideButton(
                            title: Text("تاكيد",
                                style: Theme.of(context).textTheme.titleLarge),
                            onTap: () {
                              context.go('/cart/confirm/purchase_details');
                            }),
                      ),
                    )
                  ],
                )
          : const LoadingIndicator(),
    );
  }

  Future<void> loadAsync() async {
    try {
      // Retrieve products and basket items
      await Get.find<CommerceController>().retrieveProducts();
      RealmController realmController = Get.find<RealmController>();
      AuthController auth = Get.find<AuthController>();

      basketItems = realmController.getItems(auth.currentUser.value!.email);

      // Check if products are available
      List<Product> products = Get.find<CommerceController>().products ?? [];
      if (products.isEmpty) {
        loaded = true;
        failed = true;
        setState(() {});
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
            showErrorDialogue = true;
            continue;
          }

          // Update available purchases if necessary
          if (basketItem.availablePurchases != product.availablePurchases) {
            basketItem.availablePurchases = product.availablePurchases;

            if (basketItem.quantity > product.availablePurchases) {
              basketItem.quantity = product.availablePurchases;
            }

            showErrorDialogue = true;
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
            showErrorDialogue = true;
          }
        } catch (e) {
          showErrorDialogue = true;
          print("Error syncing basket item ID ${basketItem.id}: $e");
        }
        totalPrice += double.parse(basketItem.idocPrice) * basketItem.quantity;
        totalDiscount +=
            double.parse(basketItem.idocDiscountAmt) * basketItem.quantity;
      }
      loaded = true;
      realmController.updateAllItems(basketItems);

      setState(() {});
    } catch (e) {
      loaded = true;
      failed = true;
      print("Failed to load data: $e");
      setState(() {});
    }
  }
}
