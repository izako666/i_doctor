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
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/data_classes/product.dart';
import 'package:i_doctor/api/networking/rest_functions.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/maps/map_utils.dart';
import 'package:i_doctor/portable_api/ui/bottom_sheet.dart';
import 'package:i_doctor/router.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/commerce_controller.dart';
import 'package:i_doctor/state/filter_controller.dart';
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
  bool favorited = false;
  List<Product> products = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    CommerceController commerceController = Get.find<CommerceController>();

    FilterController filterController = Get.put(FilterController(
        categoryType: 0, categoriesTotal: commerceController.categories ?? []));
    filterController.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<FilterController>();
  }

  @override
  Widget build(BuildContext context) {
    CommerceController commerceController = Get.find<CommerceController>();

    FilterController filterController = Get.find<FilterController>();
    products = commerceController.products ?? [];
    products = filterController.filterProducts(products);
    //filterController.filterProducts(commerceController.products ?? []);
    return Scaffold(
        extendBodyBehindAppBar: true,
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
        appBar: IAppBar(
          title: 'اعلانات',
          hasBackButton: widget.hasBackButton,
          toolbarHeight: widget.hasBackButton ? null : kToolbarHeight,
        ),
        body: Skeletonizer(
            enabled: !loaded,
            child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: loaded
                    ? ListView.builder(
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: BigProductCard(
                              product: products[i],
                              provider: Get.find<CommerceController>()
                                  .providers
                                  .where(
                                      (test) => test.name == products[i].spId)
                                  .firstOrNull,
                            ),
                          );
                        },
                        itemCount: products.length,
                      )
                    : ListView.builder(
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
      {super.key, required this.product, required this.provider});
  final Product product;
  final Provider? provider;

  @override
  State<BigProductCard> createState() => _BigProductCardState();
}

class _BigProductCardState extends State<BigProductCard> {
  bool favorited = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String branch = GoRouter.of(context)
            .routeInformationProvider
            .value
            .uri
            .pathSegments[0];

        context.go('/$branch/advert/${widget.product.id}');
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
                            setState(() {
                              favorited = !favorited;
                            });
                          },
                          icon: Icon(
                            !favorited
                                ? CupertinoIcons.heart
                                : CupertinoIcons.heart_fill,
                            fill: 1,
                            weight: 1,
                            color: favorited ? Colors.red : Colors.black,
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
                        RatingBarIndicator(
                          itemSize: 16,
                          itemBuilder: (ctx, i) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          rating: 3.5,
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(widget.product.spId),
                    const SizedBox(height: 4),
                    if (widget.provider != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${Get.find<AuthController>().countries!.where((test) => test.id == widget.provider!.countryId).first.arbName}, ${widget.provider!.shortAddress}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Text(
                                  '${widget.provider!.district}, ${widget.provider!.street}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: Colors.grey.darken(0.3))),
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
                              icon: Icon(
                                Icons.location_pin,
                                color: secondaryColor.darken(0.5),
                              ))
                        ],
                      ),
                    const SizedBox(height: 4),
                    PriceText(
                      price: double.parse(widget.product.idocPrice),
                      discount: double.parse(widget.product.idocDiscountAmt),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: primaryColor.darken(0.4)),
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
