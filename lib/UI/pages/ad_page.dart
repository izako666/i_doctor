import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/bottom_nav_page.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/data_from_id.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/UI/util/price_text.dart';
import 'package:i_doctor/api/data_classes/basket_item.dart';
import 'package:i_doctor/api/data_classes/category.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/networking/rest_functions.dart';
import 'package:i_doctor/helper.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/maps/map_utils.dart';
import 'package:i_doctor/router.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/commerce_controller.dart';
import 'package:i_doctor/state/realm_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../api/data_classes/product.dart';

class AdPage extends StatefulWidget {
  const AdPage({super.key, required this.id});
  final String id;

  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  bool loaded = true;
  bool favorited = false;
  bool inBasket = false;
  List<String> extraPhotos = List.empty(growable: true);
  Product? prod;
  Provider? provider;
  Category? category;
  List<Product> categoryProducts = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    prod = Get.find<CommerceController>()
        .products
        .where((prod) => prod.id == int.parse(widget.id))
        .firstOrNull;
    if (prod != null && prod!.spId != null) {
      provider = getProviderFromId(prod!.spId!);
      if (provider != null) {
        getPhotos(prod!.id, provider!.id).then((resp) {
          if (resp.statusCode == 200) {
            List<Map<String, dynamic>> dataList =
                (resp.data['data'] as List<dynamic>)
                    .cast<Map<String, dynamic>>();
            extraPhotos =
                dataList.map((item) => item['Path']).toList().cast<String>();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {});
            });
          }
        });
      }

      category = Get.find<CommerceController>()
          .categories
          .where((test) => test.id == prod!.catId)
          .firstOrNull;
      if (category != null) {
        categoryProducts.addAll(Get.find<CommerceController>()
            .products
            .where((test) => test.catId == category!.id)
            .toList());
      }
    }

    if (Get.find<AuthController>().currentUser.value != null && prod != null) {
      RealmController realmController = Get.find<RealmController>();
      BasketItem basketItem = BasketItem(
          '${prod!.id}_${Get.find<AuthController>().currentUser.value!.email}_true',
          prod!.id,
          Get.find<AuthController>().currentUser.value!.email,
          prod!.catId,
          prod!.spbId,
          prod!.name,
          prod!.description,
          prod!.photo,
          prod!.active,
          prod!.spPrice,
          prod!.spTotal,
          prod!.idocPrice,
          prod!.idocDiscountAmt,
          prod!.idocNet,
          prod!.idocType,
          prod!.startDate,
          prod!.endDate,
          prod!.availablePurchases,
          prod!.createdAt,
          prod!.updatedAt,
          1,
          true,
          prod!.currency,
          subcatId: prod!.subcatId,
          spId: prod!.spId,
          name2: prod!.name2,
          description2: prod!.description2);

      favorited = realmController.containsFavoriteItem(
          basketItem, Get.find<AuthController>().currentUser.value!.email);
      BasketItem regularBasketItem = BasketItem(
          '${prod!.id}_${Get.find<AuthController>().currentUser.value!.email}_false',
          prod!.id,
          Get.find<AuthController>().currentUser.value!.email,
          prod!.catId,
          prod!.spbId,
          prod!.name,
          prod!.description,
          prod!.photo,
          prod!.active,
          prod!.spPrice,
          prod!.spTotal,
          prod!.idocPrice,
          prod!.idocDiscountAmt,
          prod!.idocNet,
          prod!.idocType,
          prod!.startDate,
          prod!.endDate,
          prod!.availablePurchases,
          prod!.createdAt,
          prod!.updatedAt,
          1,
          false,
          prod!.currency,
          subcatId: prod!.subcatId,
          spId: prod!.spId,
          name2: prod!.name2,
          description2: prod!.description2);
      inBasket = realmController.containsBasketItem(regularBasketItem,
          Get.find<AuthController>().currentUser.value!.email);
    } else {
      favorited = false;
      inBasket = false;
    }
    loaded = true;
  }

  @override
  Widget build(BuildContext context) {
    List<AdBanner> mainBanners = [prod!.photo, ...extraPhotos]
        .map(
          (e) => AdBanner(url: e, id: 0, bannerClickable: false),
        )
        .toList();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: IAppBar(
        title: prod == null ? t(context).advert : prod!.localName,
        hasBackButton: true,
      ),
      body: Skeletonizer(
          enabled: !loaded,
          child: (loaded && prod == null)
              ? Center(child: Text(t(context).productNotFound))
              : (loaded && getProviderBranchFromId(prod!.spbId) == null)
                  ? Center(child: Text(t(context).errorOccuredTryLater))
                  : Stack(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: (kToolbarHeight) + 48),
                            child: Column(children: [
                              loaded
                                  ? Stack(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: CarouselAdBanner(
                                            skeleton: !loaded,
                                            blackWhite: getBlackWhite(context),
                                            banners: mainBanners,
                                            height: MediaQuery.of(context)
                                                .size
                                                .width,
                                            autoPlay: mainBanners.length > 1,
                                            showIndicator: true,
                                            fit: BoxFit.scaleDown,
                                            decompress: true,
                                            onTap: () {}),
                                        // child: Image.network(
                                        //     width: getScreenWidth(context),
                                        //     errorBuilder: (context, error,
                                        //             stackTrace) =>
                                        //         Container(
                                        //           width: getScreenWidth(context),
                                        //           height: 256,
                                        //           color: Colors.black,
                                        //         ),
                                        //     fit: BoxFit.fitWidth,
                                        //     '$hostUrlBase/public/storage/${prod!.photo}'),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: IconButton(
                                                onPressed: () async {
                                                  if (Get.find<AuthController>()
                                                          .currentUser
                                                          .value ==
                                                      null) {
                                                    bool login =
                                                        await showCartFavoriteDialog(
                                                            context, false);
                                                    if (login) {
                                                      if (context.mounted) {
                                                        context.push(
                                                            "/feed/login");
                                                      }
                                                    }
                                                    // ScaffoldMessenger.of(context)
                                                    //     .showSnackBar(SnackBar(
                                                    //         content: Text(t(context)
                                                    //             .mustLoginToFavorite)));
                                                    return;
                                                  }
                                                  setState(() {
                                                    favorited = !favorited;
                                                    if (favorited) {
                                                      BasketItem basketItem = BasketItem(
                                                          '${prod!.id}_${Get.find<AuthController>().currentUser.value!.email}_true',
                                                          prod!.id,
                                                          Get.find<
                                                                  AuthController>()
                                                              .currentUser
                                                              .value!
                                                              .email,
                                                          prod!.catId,
                                                          prod!.spbId,
                                                          prod!.name,
                                                          prod!.description,
                                                          prod!.photo,
                                                          prod!.active,
                                                          prod!.spPrice,
                                                          prod!.spTotal,
                                                          prod!.idocPrice,
                                                          prod!.idocDiscountAmt,
                                                          prod!.idocNet,
                                                          prod!.idocType,
                                                          prod!.startDate,
                                                          prod!.endDate,
                                                          prod!
                                                              .availablePurchases,
                                                          prod!.createdAt,
                                                          prod!.updatedAt,
                                                          1,
                                                          true,
                                                          prod!.currency,
                                                          subcatId:
                                                              prod!.subcatId,
                                                          spId: prod!.spId,
                                                          name2: prod!.name2,
                                                          description2: prod!
                                                              .description2);
                                                      Get.find<
                                                              RealmController>()
                                                          .addItem(basketItem);
                                                    } else {
                                                      BasketItem? basketItem = Get
                                                              .find<
                                                                  RealmController>()
                                                          .getFavoriteItem(
                                                              Get.find<
                                                                      AuthController>()
                                                                  .currentUser
                                                                  .value!
                                                                  .email,
                                                              prod!.id);
                                                      if (basketItem != null) {
                                                        Get.find<
                                                                RealmController>()
                                                            .deleteItem(
                                                                basketItem);
                                                      }
                                                    }
                                                  });
                                                },
                                                icon: Icon(
                                                  !favorited
                                                      ? CupertinoIcons.heart
                                                      : CupertinoIcons
                                                          .heart_fill,
                                                  fill: 1,
                                                  weight: 1,
                                                  color: favorited
                                                      ? errorColor
                                                      : Colors.black,
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
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: IconButton(
                                                onPressed: () {
                                                  shareProduct(
                                                      prod!, hostUrlBase);
                                                },
                                                icon: const Icon(
                                                  Icons.share,
                                                  size: 20,
                                                )),
                                          ),
                                        ),
                                      )
                                    ])
                                  : Container(
                                      color: Colors.grey,
                                      width: getScreenWidth(context),
                                      height: 256),
                              const SizedBox(
                                height: 16,
                              ),
                              ElevatedContainer(
                                  blackWhite: getBlackWhite(context),
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(prod!.localName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                    const SizedBox(height: 0),
                                    if (prod!.spId != null)
                                      MediaQuery.removePadding(
                                        context: context,
                                        child: TextButton(
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap),
                                            onPressed: () {
                                              if (provider != null) {
                                                String branch = GoRouter.of(
                                                        context)
                                                    .routeInformationProvider
                                                    .value
                                                    .uri
                                                    .pathSegments[0];
                                                ProviderBranch? provBranch =
                                                    Get.find<
                                                            CommerceController>()
                                                        .branches
                                                        .where((test) =>
                                                            test.id ==
                                                            prod!.spbId)
                                                        .firstOrNull;
                                                if (provBranch != null) {
                                                  context.push(
                                                      '/$branch/clinic_branch/${provider!.id}/${provBranch.id}');
                                                } else {
                                                  context.push(
                                                      '/$branch/clinic/${provider!.id}');
                                                }
                                              }
                                            },
                                            child: Text(
                                              getProviderBranchFromId(
                                                      prod!.spbId)!
                                                  .localName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      color: primaryColor),
                                            )),
                                      ),
                                    const SizedBox(height: 4),
                                    if (provider != null)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${Get.find<AuthController>().countries!.where((test) => test.id == provider!.countryId).first.name}, ${provider!.localShortAddress}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium),
                                              Text(
                                                  '${provider!.localDistrict}, ${provider!.localStreet}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          color: Colors.grey)),
                                            ],
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                List<double> numbers = provider!
                                                    .location
                                                    .split(',')
                                                    .map((e) => double.parse(e))
                                                    .toList();

                                                MapUtils.openMap(
                                                    numbers[0], numbers[1]);
                                              },
                                              icon: const Icon(
                                                Icons.location_pin,
                                                color: secondaryColor,
                                              ))
                                        ],
                                      ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    PriceText2(
                                      price: double.parse(prod!.idocNet),
                                      spPrice: double.parse(prod!.spTotal),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(color: primaryColor),
                                      smallStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.grey),
                                      currency:
                                          getCurrencyFromId(prod!.currency) ??
                                              Currency(
                                                  id: 0,
                                                  name1: "SAR",
                                                  name2: "س.ر."),
                                    )
                                  ]),
                              // const SizedBox(height: 16),
                              // ElevatedContainer(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     blackWhite: getBlackWhite(context),
                              //     children: [
                              //       Text(t(context).reviews,
                              //           style:
                              //               Theme.of(context).textTheme.titleLarge),
                              //       const SizedBox(height: 16),
                              //       Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           Skeleton.ignore(
                              //             child: RatingBar.builder(
                              //               itemSize: 30,
                              //               ignoreGestures: true,
                              //               initialRating: 3.5,
                              //               minRating: 1,
                              //               direction: Axis.horizontal,
                              //               allowHalfRating: true,
                              //               itemCount: 5,
                              //               itemPadding: EdgeInsets.zero,
                              //               itemBuilder: (context, _) => const Icon(
                              //                 Icons.star,
                              //                 color: Colors.amber,
                              //               ),
                              //               onRatingUpdate: (rating) {},
                              //             ),
                              //           ),
                              //           TextButton(
                              //             style: ButtonStyle(
                              //                 overlayColor:
                              //                     WidgetStateColor.resolveWith(
                              //                         (states) => states.contains(
                              //                                 WidgetState.pressed)
                              //                             ? secondaryColor
                              //                             : Colors.transparent)),
                              //             onPressed: () {
                              //               String branch = GoRouter.of(context)
                              //                   .routeInformationProvider
                              //                   .value
                              //                   .uri
                              //                   .pathSegments[0];

                              //               context.push(
                              //                   '/$branch/reviews_product/1234');
                              //             },
                              //             child: Text(t(context).readReviews(120),
                              //                 style: Theme.of(context)
                              //                     .textTheme
                              //                     .bodyMedium!
                              //                     .copyWith(color: secondaryColor)),
                              //           )
                              //         ],
                              //       ),
                              //       const SizedBox(height: 16)
                              //     ]),
                              const SizedBox(height: 16),
                              ElevatedContainer(
                                  blackWhite: getBlackWhite(context),
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t(context).details,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(prod!.localDesc),
                                    )
                                    // Theme(
                                    //   data: Theme.of(context).copyWith(
                                    //       dividerColor: Colors.transparent),
                                    //   child: ExpansionTile(
                                    //     title: Text(t(context).details),
                                    //     subtitle: Text(
                                    //         t(context).clickHereForDetails,
                                    //         style: Theme.of(context)
                                    //             .textTheme
                                    //             .bodyMedium!
                                    //             .copyWith(color: secondaryColor)),
                                    //     children: <Widget>[
                                    //       ListTile(title: Text(prod!.description)),
                                    //     ],
                                    //   ),
                                    // )
                                  ]),
                              const SizedBox(height: 16),
                              // ElevatedContainer(
                              //     blackWhite: getBlackWhite(context),
                              //     children: [
                              //       Theme(
                              //         data: Theme.of(context).copyWith(
                              //             dividerColor: Colors.transparent),
                              //         child: ExpansionTile(
                              //             title: Text(t(context).pictures),
                              //             subtitle: Text(
                              //                 t(context).clickHereForPictures,
                              //                 style: Theme.of(context)
                              //                     .textTheme
                              //                     .bodyMedium!
                              //                     .copyWith(color: secondaryColor)),
                              //             children: <Widget>[
                              //               SizedBox(
                              //                 width: getScreenWidth(context),
                              //                 child: GridView.builder(
                              //                     shrinkWrap: true,
                              //                     itemCount: extraPhotos.length,
                              //                     physics:
                              //                         const NeverScrollableScrollPhysics(),
                              //                     gridDelegate:
                              //                         const SliverGridDelegateWithFixedCrossAxisCount(
                              //                             crossAxisCount: 2),
                              //                     itemBuilder: (ctx, i) => Padding(
                              //                           padding:
                              //                               const EdgeInsets.all(
                              //                                   2.0),
                              //                           child: Image.network(
                              //                               width: getScreenWidth(
                              //                                       context) *
                              //                                   0.5,
                              //                               '$hostUrlBase/public/storage/${extraPhotos[i]}'),
                              //                         )),
                              //               )
                              //             ]),
                              //       )
                              //     ]),
                              const SizedBox(
                                height: 16,
                              ),
                              CategoryBox(
                                  skeleton: !loaded,
                                  blackWhite: getBlackWhite(context),
                                  banners: (categoryProducts.length > 5
                                          ? categoryProducts.sublist(0, 4)
                                          : categoryProducts)
                                      .map((pr) =>
                                          AdBanner(url: pr.photo, id: pr.id))
                                      .toList(),
                                  categoryName:
                                      category!.getCategoryName(context),
                                  categoryId: category!.id),
                              const SizedBox(height: 256),
                            ]),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: WideButton(
                                  title: Text(
                                      inBasket
                                          ? t(context).toBasket
                                          : t(context).addToCart,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                  icon: Icons.shopping_basket,
                                  onTap: () async {
                                    if (Get.find<AuthController>()
                                            .currentUser
                                            .value ==
                                        null) {
                                      bool login = await showCartFavoriteDialog(
                                          context, true);
                                      if (login) {
                                        if (context.mounted) {
                                          context.push("/feed/login");
                                        }
                                      }
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //     SnackBar(
                                      //         content: Text(
                                      //             t(context).mustLoginToUseCart)));
                                      return;
                                    }
                                    BasketItem basketItem = BasketItem(
                                        '${prod!.id}_${Get.find<AuthController>().currentUser.value!.email}_false',
                                        prod!.id,
                                        Get.find<AuthController>()
                                            .currentUser
                                            .value!
                                            .email,
                                        prod!.catId,
                                        prod!.spbId,
                                        prod!.name,
                                        prod!.description,
                                        prod!.photo,
                                        prod!.active,
                                        prod!.spPrice,
                                        prod!.spTotal,
                                        prod!.idocPrice,
                                        prod!.idocDiscountAmt,
                                        prod!.idocNet,
                                        prod!.idocType,
                                        prod!.startDate,
                                        prod!.endDate,
                                        prod!.availablePurchases,
                                        prod!.createdAt,
                                        prod!.updatedAt,
                                        1,
                                        false,
                                        prod!.currency,
                                        subcatId: prod!.subcatId,
                                        spId: prod!.spId,
                                        name2: prod!.name2,
                                        description2: prod!.description2);
                                    RealmController realmController =
                                        Get.find<RealmController>();
                                    AuthController authController =
                                        Get.find<AuthController>();
                                    if (realmController.containsBasketItem(
                                        basketItem,
                                        authController
                                            .currentUser.value!.email)) {
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //     SnackBar(
                                      //         content:
                                      //             Text(t(context).productInCart)));
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        print('setting state');
                                        basketPageKey.currentState
                                            ?.setState(() {});
                                      });
                                      bottomNavKey.currentState?.widget.shell
                                          .goBranch(2);
                                      return;
                                    }
                                    realmController.addItem(basketItem);
                                    inBasket = true;
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(t(context)
                                                .productAddedToCartSuccessfully)));
                                  },
                                )))
                      ],
                    )),
    );
  }
}

class CategoryBox extends StatelessWidget {
  const CategoryBox(
      {super.key,
      required this.skeleton,
      required this.blackWhite,
      required this.banners,
      required this.categoryName,
      required this.categoryId});
  final bool skeleton;
  final Color blackWhite;
  final List<AdBanner> banners;
  final String categoryName;
  final int categoryId;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 4),
        width: getScreenWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: blackWhite == black ? white : black,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    categoryName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                      overlayColor: WidgetStateColor.resolveWith((states) =>
                          states.contains(WidgetState.pressed)
                              ? secondaryColor
                              : Colors.transparent)),
                  onPressed: () {
                    String branch = GoRouter.of(context)
                        .routeInformationProvider
                        .value
                        .uri
                        .pathSegments[0];

                    context.push('/$branch/category/$categoryId');
                  },
                  child: Text(t(context).showAll,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: secondaryColor)),
                )
              ],
            ),
            const Divider(
              indent: 5,
              endIndent: 80,
              color: Colors.grey,
            ),
            Material(
              color: Colors.transparent,
              child: CarouselAdBanner(
                onTap: () {},
                skeleton: skeleton,
                blackWhite: blackWhite,
                height: 180,
                infinityScroll: false,
                banners: banners,
                autoPlay: false,
                showIndicator: false,
                viewportFraction: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
