import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/filter_sort_sheet.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/UI/util/price_text.dart';
import 'package:i_doctor/api/data_classes/basket_item.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/data_classes/product.dart';
import 'package:i_doctor/api/networking/rest_functions.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/maps/map_utils.dart';
import 'package:i_doctor/portable_api/ui/bottom_sheet.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/commerce_controller.dart';
import 'package:i_doctor/state/filter_controller.dart';
import 'package:i_doctor/state/realm_controller.dart';
import 'package:realm/realm.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdListPage extends StatefulWidget {
  const AdListPage({super.key, required this.id, this.hasBackButton = true});
  final String id;
  final bool hasBackButton;
  @override
  State<AdListPage> createState() => _AdListPageState();
}

class _AdListPageState extends State<AdListPage> {
  bool loaded = true;
  bool loading = false;
  bool favorited = false;
  List<Product> products = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    CommerceController commerceController = Get.find<CommerceController>();

    FilterController filterController = Get.put(FilterController(
        categoryType: 0, categoriesTotal: commerceController.categories ?? []));
    filterController.onInit();
    products = commerceController.products ?? [];
    filterController.addProviders(products);

    products = filterController.filterProducts(products);
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<FilterController>();
  }

  @override
  Widget build(BuildContext context) {
    CommerceController commerceController = Get.find<CommerceController>();
    FilterController filterController;
    if (!Get.isRegistered<FilterController>()) {
      filterController = Get.put(FilterController(
          categoryType: 0,
          categoriesTotal: commerceController.categories ?? []));
      filterController.onInit();
      products = commerceController.products ?? [];
      filterController.addProviders(products);

      products = filterController.filterProducts(products);
    }
    filterController = Get.find<FilterController>();

    //filterController.filterProducts(commerceController.products ?? []);
    return Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: loading
            ? null
            : FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () async {
                  await showIzBottomSheet(
                      context: context,
                      child:
                          FilterSortSheet(filterController: filterController));
                  loading = true;
                  setState(() {});
                  if (context.mounted) {
                    products = await filterController.sortProducts(
                        filterController
                            .filterProducts(commerceController.products),
                        context);
                    loading = false;
                    setState(() {});
                  } else {
                    loading = false;
                    setState(() {});
                  }
                },
                child: const Icon(
                  Icons.filter_alt,
                  color: primaryFgColor,
                ),
              ),
        appBar: IAppBar(
          title: t(context).advertisements,
          hasBackButton: widget.hasBackButton,
          toolbarHeight: widget.hasBackButton ? null : kToolbarHeight,
        ),
        body: loading
            ? const LoadingIndicator()
            : Skeletonizer(
                enabled: !loaded,
                child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: loaded
                        ? ListView.builder(
                            itemBuilder: (ctx, i) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: BigProductCard(
                                  product: products[i],
                                  provider: Get.find<CommerceController>()
                                      .providers
                                      .where((test) =>
                                          test.name == products[i].spId)
                                      .firstOrNull,
                                  pushRoute: true,
                                ),
                              );
                            },
                            itemCount: products.length,
                          )
                        : ListView.builder(
                            itemBuilder: (ctx, i) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                    color: Colors.grey,
                                    width: getScreenWidth(context),
                                    height: 256),
                              );
                            },
                            itemCount: 12,
                          ))));
  }
}

class BigProductCard extends StatefulWidget {
  const BigProductCard(
      {super.key,
      required this.product,
      required this.provider,
      this.pushRoute = false});
  final Product product;
  final Provider? provider;
  final bool pushRoute;

  @override
  State<BigProductCard> createState() => _BigProductCardState();
}

class _BigProductCardState extends State<BigProductCard> {
  bool favorited = false;
  StreamSubscription<RealmResultsChanges<BasketItem>>? streamSub;

  @override
  void initState() {
    super.initState();
    if (Get.find<AuthController>().currentUser.value != null) {
      RealmController realmController = Get.find<RealmController>();
      BasketItem basketItem = BasketItem(
          '${widget.product.id}_${Get.find<AuthController>().currentUser.value!.email}_true',
          widget.product.id,
          Get.find<AuthController>().currentUser.value!.email,
          widget.product.catId,
          widget.product.subcatId,
          widget.product.spId,
          widget.product.spbId,
          widget.product.name,
          widget.product.description,
          widget.product.photo,
          widget.product.active,
          widget.product.spPrice,
          widget.product.spTotal,
          widget.product.idocPrice,
          widget.product.idocDiscountAmt,
          widget.product.idocNet,
          widget.product.idocType,
          widget.product.startDate,
          widget.product.endDate,
          widget.product.availablePurchases,
          widget.product.createdAt,
          widget.product.updatedAt,
          1,
          true);

      favorited = realmController.containsFavoriteItem(
          basketItem, Get.find<AuthController>().currentUser.value!.email);
      realmController
          .listenFavoriteStreamItem(
              Get.find<AuthController>().currentUser.value!.email,
              widget.product.id)
          .listen((d) {
        d.results.firstOrNull;
        BasketItem? item = d.results.firstOrNull;
        if (item != null) {
          favorited = true;
          setState(() {});
        } else {
          favorited = false;
          setState(() {});
        }
      });
    } else {
      favorited = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    streamSub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO: THis might just fuck up soon, will watch out
        String branch = GoRouter.of(context)
            .routeInformationProvider
            .value
            .uri
            .pathSegments[0];
        if (widget.pushRoute) {
          context.push('/$branch/advert/${widget.product.id}');
        } else {
          context.go('/$branch/advert/${widget.product.id}');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedContainer(
            blackWhite: getBlackWhite(context),
            crossAxisAlignment: CrossAxisAlignment.start,
            padding: EdgeInsets.zero,
            children: [
              Stack(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  child: Image.network(
                      width: getScreenWidth(context),
                      height: 256,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (context, error, stackTrace) => Container(
                            width: getScreenWidth(context),
                            height: 256,
                            color: Colors.black,
                          ),
                      '$hostUrlBase/public/storage/${widget.product.photo}'),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: IconButton(
                          onPressed: () {
                            if (Get.find<AuthController>().currentUser.value ==
                                null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          t(context).mustLoginToFavorite)));
                              return;
                            }
                            setState(() {
                              favorited = !favorited;
                              if (favorited) {
                                BasketItem basketItem = BasketItem(
                                    '${widget.product.id}_${Get.find<AuthController>().currentUser.value!.email}_true',
                                    widget.product.id,
                                    Get.find<AuthController>()
                                        .currentUser
                                        .value!
                                        .email,
                                    widget.product.catId,
                                    widget.product.subcatId,
                                    widget.product.spId,
                                    widget.product.spbId,
                                    widget.product.name,
                                    widget.product.description,
                                    widget.product.photo,
                                    widget.product.active,
                                    widget.product.spPrice,
                                    widget.product.spTotal,
                                    widget.product.idocPrice,
                                    widget.product.idocDiscountAmt,
                                    widget.product.idocNet,
                                    widget.product.idocType,
                                    widget.product.startDate,
                                    widget.product.endDate,
                                    widget.product.availablePurchases,
                                    widget.product.createdAt,
                                    widget.product.updatedAt,
                                    1,
                                    true);
                                Get.find<RealmController>().addItem(basketItem);
                              } else {
                                BasketItem? basketItem =
                                    Get.find<RealmController>().getFavoriteItem(
                                        Get.find<AuthController>()
                                            .currentUser
                                            .value!
                                            .email,
                                        widget.product.id);
                                if (basketItem != null) {
                                  Get.find<RealmController>()
                                      .deleteItem(basketItem);
                                }
                              }
                            });
                          },
                          icon: Icon(
                            !favorited
                                ? CupertinoIcons.heart
                                : CupertinoIcons.heart_fill,
                            fill: 1,
                            weight: 1,
                            color: favorited ? errorColor : Colors.black,
                          )),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      alignment: Alignment.center,
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share,
                            size: 20,
                          )),
                    ),
                  ),
                )
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.product.name,
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 8),
                    MediaQuery.removePadding(
                        context: context,
                        child: TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap),
                            onPressed: () {
                              if (widget.provider != null) {
                                String branch = GoRouter.of(context)
                                    .routeInformationProvider
                                    .value
                                    .uri
                                    .pathSegments[0];

                                context.push(
                                    '/$branch/clinic/${widget.provider!.id}');
                              }
                            },
                            child: Text(
                              widget.product.spId,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: primaryColor),
                            ))),
                    const SizedBox(height: 4),
                    if (widget.provider != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${Get.find<AuthController>().countries!.where((test) => test.id == widget.provider!.countryId).first.name}, ${widget.provider!.shortAddress}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Text(
                                  '${widget.provider!.district}, ${widget.provider!.street}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: Colors.grey)),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                List<double> numbers = widget.provider!.location
                                    .split(',')
                                    .map((e) => double.parse(e))
                                    .toList();

                                MapUtils.openMap(numbers[0], numbers[1]);
                              },
                              icon: const Icon(
                                Icons.location_pin,
                                color: secondaryColor,
                              ))
                        ],
                      ),
                    const SizedBox(height: 4),
                    PriceText2(
                      price: double.parse(widget.product.idocPrice),
                      spPrice: double.parse(widget.product.spTotal),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: primaryColor),
                      smallStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 4,
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
