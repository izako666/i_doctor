import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/appointments_page.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/data_from_id.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/api/data_classes/basket_item.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/data_classes/product.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/commerce_controller.dart';
import 'package:i_doctor/state/realm_controller.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t(context).basketItemsUpdated)));
        showErrorDialogue = false;
      });
    }
    return Scaffold(
      appBar: IAppBar(
        title: t(context).confirmOrder,
        toolbarHeight: kToolbarHeight,
        hasBackButton: false,
      ),
      body: loaded
          ? failed
              ? Center(child: Text(t(context).errorOccuredTryLater))
              : CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 16),
                    ),
                    SliverList.builder(
                      itemBuilder: (ctx, i) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 4),
                        child: CartCard(
                          isDisplay: true,
                          basketItem: basketItems[i],
                          onDelete: () {},
                        ),
                      ),
                      itemCount: basketItems.length,
                    ),
                    if (basketItems.isNotEmpty)
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
                                          Text(t(context).originalPrice),
                                          Text(formatPrice(
                                              totalPrice,
                                              getCurrencyFromId(basketItems[0]
                                                      .currency) ??
                                                  Currency(
                                                      id: 0,
                                                      name1: "SAR",
                                                      name2: "س.ر.")))
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(t(context).tax),
                                          Text(formatPrice(
                                            0.0,
                                            getCurrencyFromId(
                                                    basketItems[0].currency) ??
                                                Currency(
                                                    id: 0,
                                                    name1: "SAR",
                                                    name2: "س.ر."),
                                          )),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(t(context).discount),
                                          Text(formatPrice(
                                              totalDiscount,
                                              getCurrencyFromId(basketItems[0]
                                                      .currency) ??
                                                  Currency(
                                                      id: 0,
                                                      name1: "SAR",
                                                      name2: "س.ر."))),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      const Divider(),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(t(context).totalPrice,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              formatPrice(
                                                  (totalPrice - totalDiscount),
                                                  getCurrencyFromId(
                                                          basketItems[0]
                                                              .currency) ??
                                                      Currency(
                                                          id: 0,
                                                          name1: "SAR",
                                                          name2: "س.ر.")),
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
                            title: Text(t(context).confirm,
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
      AuthController auth = Get.find<AuthController>();
      if (auth.currentCountry.value != null) {
        await Get.find<CommerceController>()
            .retrieveProducts(auth.currentCountry.value!.id);
      }
      RealmController realmController = Get.find<RealmController>();

      basketItems = realmController.getItems(auth.currentUser.value!.email);

      // Check if products are available
      List<Product> products = Get.find<CommerceController>().products;
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
