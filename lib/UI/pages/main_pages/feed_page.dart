import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/ad_list_page.dart';
import 'package:i_doctor/UI/util/filter_sort_sheet.dart';
import 'package:i_doctor/api/data_classes/category.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/data_classes/product.dart';
import 'package:i_doctor/api/networking/rest_functions.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/ui/bottom_sheet.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/commerce_controller.dart';
import 'package:i_doctor/state/feed_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:i_doctor/state/filter_controller.dart';
import 'package:i_doctor/state/language_controller.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:skeletonizer/skeletonizer.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool loading = false;

  List<Product> products = [];
  List<Product> adBarProducts = [];

  @override
  void initState() {
    super.initState();
    CommerceController commerceController = Get.find<CommerceController>();
    products = commerceController.products.toList();
    adBarProducts = getRecentProducts(products);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Color blackWhite = getBlackWhite(context);

      FeedController controller = Get.find<FeedController>();
      CommerceController commerceController = Get.find<CommerceController>();
      controller.searchVal.value;

      return Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: (!controller.openFeedView.value && !loading)
            ? FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () async {
                  await showIzBottomSheet(
                      context: context,
                      child: FilterSortSheet(
                          filterController: controller.controller!));
                  if (context.mounted) {
                    loading = true;
                    controller
                        .filterSearch(
                            commerceController.products.toList(), context)
                        .then((val) {
                      products = val;
                      loading = false;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {});
                      });
                    });
                  }
                },
                child: const Icon(
                  Icons.filter_alt,
                  color: primaryFgColor,
                ),
              )
            : null,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: kToolbarHeight * 0.1,
          flexibleSpace: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: primaryColor,
            ),
          ),
        ),
        body: loading
            ? const LoadingIndicator()
            : Obx(
                () => Skeletonizer(
                    enabled: controller.skeleton.value,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: kToolbarHeight * 0.7,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 4, right: 4, bottom: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: blackWhite.inverse,
                          ),
                          width: getScreenWidth(context),
                          child: Row(
                            mainAxisAlignment: (!controller.openFeedView.value)
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.spaceBetween,
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(24),
                                elevation: 0,
                                color: Colors.transparent,
                                child: Obx(
                                  () => InkWell(
                                      borderRadius: BorderRadius.circular(24),
                                      onTap: Get.find<AuthController>()
                                                  .currentUser
                                                  .value ==
                                              null
                                          ? () {
                                              context.go('/feed/login');
                                            }
                                          : () {
                                              context.go('/feed/user_info');
                                            },
                                      splashFactory: InkRipple.splashFactory,
                                      child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                          child: Icon(
                                            Get.find<AuthController>()
                                                        .currentUser
                                                        .value ==
                                                    null
                                                ? Icons.login
                                                : Icons.person,
                                          ))),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  child: Skeleton.leaf(
                                      child: SearchBox(
                                controller: controller,
                                closeable: (!controller.openFeedView.value)
                                    ? true
                                    : false,
                                onClose: () async {
                                  controller.controller = null;

                                  await Get.delete<FilterController>(
                                      force: true);

                                  controller.node.unfocus();
                                  controller.openFeedView.value = true;
                                },
                              ))),
                              const SizedBox(
                                width: 8,
                              ),
                              if (controller.openFeedView.value)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(24),
                                      onTap: () {
                                        LanguageController lang =
                                            Get.find<LanguageController>();
                                        lang.locale.value == "en"
                                            ? lang.setLocale('ar')
                                            : lang.setLocale('en');
                                      },
                                      splashFactory: InkRipple.splashFactory,
                                      child: Obx(
                                        () => Text(
                                          languageFlags[
                                              Get.find<LanguageController>()
                                                  .locale
                                                  .value]!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      )),
                                )
                            ],
                          ),
                        ),
                        (!controller.openFeedView.value)
                            ? Expanded(
                                child: ListView.builder(
                                  itemBuilder: (ctx, i) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: BigProductCard(
                                        product: products[i],
                                        provider: Get.find<CommerceController>()
                                            .providers
                                            .where((test) =>
                                                test.name == products[i].spId)
                                            .firstOrNull,
                                      ),
                                    );
                                  },
                                  itemCount: products.length,
                                ),
                              )
                            : Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Column(children: [
                                      const SizedBox(height: 16),
                                      if (adBarProducts.isNotEmpty)
                                        CarouselAdBanner(
                                          onTap: () {
                                            //   context.push('/feed/advert/1234');
                                          },
                                          skeleton: controller.skeleton.value,
                                          blackWhite: blackWhite,
                                          banners: adBarProducts
                                              .map((prod) => AdBanner(
                                                  url: prod.photo, id: prod.id))
                                              .toList(),
                                          autoPlay: true,
                                          showIndicator: true,
                                        ),
                                      const SizedBox(height: 16),
                                      Material(
                                        borderRadius: BorderRadius.circular(16),
                                        elevation: 2,
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 96,
                                          decoration: BoxDecoration(
                                            color: blackWhite == black
                                                ? white
                                                : black,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Skeleton.leaf(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Scrollbar(
                                                child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    itemCount: (commerceController
                                                                .categories ??
                                                            [])
                                                        .length,
                                                    itemBuilder: (ctx, i) {
                                                      return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      24),
                                                          child: CategoryCircleButton(
                                                              category:
                                                                  commerceController
                                                                          .categories[
                                                                      i]));
                                                    }),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      DealsBox(
                                          blackWhite: blackWhite,
                                          controller: controller),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: getScreenWidth(context),
                                        child: ElevatedContainer(
                                          blackWhite: blackWhite,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(
                                                    t(context).clinics,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge,
                                                  ),
                                                ),
                                                TextButton(
                                                  style: ButtonStyle(
                                                      overlayColor: WidgetStateColor
                                                          .resolveWith((states) =>
                                                              states.contains(
                                                                      WidgetState
                                                                          .pressed)
                                                                  ? secondaryColor
                                                                  : Colors
                                                                      .transparent)),
                                                  onPressed: () {
                                                    context
                                                        .push('/feed/clinics');
                                                  },
                                                  child: Text(
                                                      t(context).showAll,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color:
                                                                  secondaryColor)),
                                                )
                                              ],
                                            ),
                                            MediaQuery.removePadding(
                                              context: context,
                                              child: GridView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: commerceController
                                                              .providers
                                                              .length >
                                                          4
                                                      ? 4
                                                      : commerceController
                                                          .providers.length,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          childAspectRatio:
                                                              0.7),
                                                  itemBuilder: (ctx, i) {
                                                    return ClinicButton(
                                                        provider:
                                                            commerceController
                                                                .providers[i]);
                                                  }),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedContainer(
                                          blackWhite: blackWhite,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                    t(context).moreOffers,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            ...[1, 2, 3, 4].map(
                                              (c) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: Material(
                                                  child: Ink(
                                                    width:
                                                        getScreenWidth(context),
                                                    height: 196,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        image:
                                                            const DecorationImage(
                                                                image:
                                                                    AssetImage(
                                                                  'assets/images/placeholder.png',
                                                                ),
                                                                fit: BoxFit
                                                                    .fill)),
                                                    child: Material(
                                                        color: Colors
                                                            .transparent,
                                                        child: InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                            splashColor:
                                                                blackWhite
                                                                    .inverse
                                                                    .withAlpha(
                                                                        60),
                                                            splashFactory:
                                                                InkRipple
                                                                    .splashFactory,
                                                            onTap: () {
                                                              context.push(
                                                                  '/feed/advert/1234');
                                                            })),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ])
                                    ]),
                                  ),
                                ),
                              ),
                      ],
                    )),
              ),
      );
    });
  }
}

List<Product> getRecentProducts(List<Product> products) {
  // Get the current date
  DateTime now = DateTime.now();

  // Parse and filter products based on startDate
  List<Product> recentProducts = products.where((product) {
    DateTime startDate;
    try {
      startDate = DateTime.parse(product.startDate);
    } catch (e) {
      return false; // Skip invalid dates
    }

    return startDate.isAfter(now.subtract(const Duration(days: 7)));
  }).toList();

  // Sort products by startDate in descending order (most recent first)
  recentProducts.sort((a, b) {
    DateTime dateA = DateTime.parse(a.startDate);
    DateTime dateB = DateTime.parse(b.startDate);
    return dateB.compareTo(dateA); // Descending order
  });

  return recentProducts;
}

class ClinicButton extends StatelessWidget {
  const ClinicButton({super.key, required this.provider});
  final Provider provider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            String branch = GoRouter.of(context)
                .routeInformationProvider
                .value
                .uri
                .pathSegments[0];

            context.push('/$branch/clinic/${provider.id}');
          },
          splashFactory: InkRipple.splashFactory,
          child: SizedBox(
              width: 128,
              child: Column(
                children: [
                  SizedBox(
                      width: 1000,
                      height: 128,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        child: Image.network(
                          '$hostUrlBase/public/storage/${provider.photo}',
                          fit: BoxFit.fill,
                        ),
                      )),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          provider.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        )),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(provider.shortAddress)),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8),
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: Text("بعيد ءءء ك.م",
                  //         style: Theme.of(context)
                  //             .textTheme
                  //             .bodyMedium!
                  //             .copyWith(color: secondaryColor.darken(0.5))),
                  //   ),
                  // )
                ],
              )),
        ),
      ),
    );
  }
}

class WideButton extends StatelessWidget {
  const WideButton({
    super.key,
    required this.title,
    this.icon,
    required this.onTap,
    this.radius,
    this.color,
    this.disabled = false,
  });
  final Widget title;
  final IconData? icon;
  final VoidCallback onTap;
  final BorderRadius? radius;
  final Color? color;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    FeedController controller = Get.find<FeedController>();
    return Material(
      color: controller.skeleton.value
          ? Colors.grey
          : disabled
              ? Colors.grey
              : color ?? primaryColor,
      borderRadius: radius ?? BorderRadius.circular(8),
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: radius ?? BorderRadius.circular(8),
        splashColor: Colors.white.withAlpha(100),
        splashFactory: InkRipple.splashFactory,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 64,
          decoration: BoxDecoration(
              borderRadius: radius ?? BorderRadius.circular(8),
              border: Border.all(width: 0.5),
              color: Colors.transparent),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Icon(
                    icon ?? Icons.abc,
                    color: Colors.transparent,
                  )),
              Padding(padding: const EdgeInsets.only(right: 0), child: title),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Icon(
                    icon ?? Icons.abc,
                    color: icon == null ? Colors.transparent : null,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class ElevatedContainer extends StatelessWidget {
  const ElevatedContainer({
    super.key,
    required this.blackWhite,
    required this.children,
    this.width,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final Color blackWhite;
  final List<Widget> children;
  final double? width;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets? padding;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        child: Container(
            padding: padding ??
                const EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 4),
            width: width ?? getScreenWidth(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: blackWhite == black ? white : black,
            ),
            child: Column(
                crossAxisAlignment: crossAxisAlignment,
                mainAxisAlignment: mainAxisAlignment,
                children: children)));
  }
}

class DealsBox extends StatelessWidget {
  const DealsBox({
    super.key,
    required this.blackWhite,
    required this.controller,
  });

  final Color blackWhite;
  final FeedController controller;

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
                    t(context).offers,
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

                    context.push('/$branch/advert_list/123');
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
                onTap: () {
                  String branch = GoRouter.of(context)
                      .routeInformationProvider
                      .value
                      .uri
                      .pathSegments[0];

                  context.push('/$branch/advert/124');
                },
                skeleton: controller.skeleton.value,
                blackWhite: blackWhite,
                height: 180,
                infinityScroll: false,
                banners: [
                  AdBanner(url: 'assets/images/placeholder.png', id: 1),
                  AdBanner(url: 'assets/images/placeholder.png', id: 1),
                  AdBanner(url: 'assets/images/placeholder.png', id: 1),
                  AdBanner(url: 'assets/images/placeholder.png', id: 1),
                ],
                autoPlay: false,
                showIndicator: false,
                viewportFraction: 0.9,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CarouselAdBanner extends StatefulWidget {
  const CarouselAdBanner(
      {super.key,
      required this.skeleton,
      required this.blackWhite,
      required this.banners,
      required this.autoPlay,
      required this.showIndicator,
      this.viewportFraction = 1.0,
      this.infinityScroll = true,
      this.height,
      this.aspectRatio,
      required this.onTap});

  final bool skeleton;
  final Color blackWhite;
  final List<AdBanner> banners;
  final bool autoPlay;
  final bool showIndicator;
  final double viewportFraction;
  final bool infinityScroll;
  final double? height;
  final double? aspectRatio;
  final VoidCallback onTap;

  @override
  State<CarouselAdBanner> createState() => _CarouselAdBannerState();
}

class AdBanner {
  final String url;
  final int id;
  final bool bannerClickable;

  AdBanner({this.bannerClickable = true, required this.url, required this.id});
}

class _CarouselAdBannerState extends State<CarouselAdBanner> {
  late CarouselSliderController controller;

  @override
  void initState() {
    super.initState();
    controller = CarouselSliderController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: controller,
          options: CarouselOptions(
            padEnds: false,
            aspectRatio: widget.aspectRatio ?? 16 / 9,
            viewportFraction: widget.viewportFraction,
            height: widget.height,
            initialPage: 0,
            enableInfiniteScroll: widget.infinityScroll,
            autoPlay: widget.autoPlay,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              currentPage = index;
              setState(() {});
            },
          ),
          items: widget.banners.map((banner) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: widget.height,
                child: Skeleton.leaf(
                  child: widget.skeleton
                      ? Container(
                          color: Colors.grey,
                        )
                      : BannerImage(
                          widget: widget,
                          banner: banner,
                        ),
                ),
              ),
            );
          }).toList(),
        ),
        if (widget.showIndicator)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.banners.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => controller.animateToPage(entry.key,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(currentPage == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class BannerImage extends StatefulWidget {
  const BannerImage({
    super.key,
    required this.widget,
    required this.banner,
  });

  final CarouselAdBanner widget;
  final AdBanner banner;

  @override
  State<BannerImage> createState() => _BannerImageState();
}

class _BannerImageState extends State<BannerImage> {
  bool errored = false;
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
              image: errored
                  ? const AssetImage('assets/images/placeholder.png')
                  : NetworkImage(
                      '$hostUrlBase/public/storage/${widget.banner.url}',
                    ),
              onError: (e, s) {
                errored = true;
                setState(() {});
              },
              fit: BoxFit.fill)),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            splashColor: widget.widget.blackWhite.inverse.withAlpha(60),
            splashFactory: InkRipple.splashFactory,
            onTap: () {
              if (widget.banner.bannerClickable) {
                context.go("/feed/advert/${widget.banner.id}");
              }
            },
          )),
    );
  }
}

class AdvertFilterTab extends StatelessWidget {
  const AdvertFilterTab({
    super.key,
    required this.blackWhite,
  });

  final Color blackWhite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.grey.withAlpha(50),
              blurRadius: 2,
              spreadRadius: 1,
              blurStyle: BlurStyle.normal)
        ]),
        child: Material(
            elevation: 0,
            color: blackWhite == black ? white : black,
            child: Ink(
              decoration:
                  BoxDecoration(color: blackWhite == black ? white : black),
              child: InkWell(
                splashFactory: InkRipple.splashFactory,
                onTap: () {},
                child: SizedBox(
                    width: 128,
                    height: 40,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(t(context).goodDeal),
                        ))),
              ),
            )),
      ),
    );
  }
}

class CategoryCircleButton extends StatelessWidget {
  const CategoryCircleButton({
    super.key,
    required this.category,
  });
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            String branch = GoRouter.of(context)
                .routeInformationProvider
                .value
                .uri
                .pathSegments[0];

            context.push('/$branch/category/${category.id}');
          },
          child: SizedBox(
            width: 76,
            height: 128,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: 48,
                    height: 48,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Image.asset('assets/images/placeholder.png'))),
                Text(
                  formatCatName(category.name),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    required this.controller,
    required this.closeable,
    this.onClose,
    this.onSubmit,
  });

  final FeedController controller;
  final bool closeable;
  final VoidCallback? onClose;
  final Function(String)? onSubmit;
  @override
  Widget build(BuildContext context) {
    Color blackWhite = getBlackWhite(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: kToolbarHeight * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: blackWhite == black ? white : black,
          border: Border.all(color: blackWhite),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 5,
              child: SizedBox(
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  controller: controller.searchController,
                  focusNode: controller.node,
                  onSubmitted: onSubmit,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.search,
                      size: 24,
                    ),
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    hintText: AppLocalizations.of(context)!.searchHere,
                  ),
                ),
              ),
            ),
            if (closeable)
              Flexible(
                  flex: 1,
                  child: IconButton(
                      onPressed: onClose,
                      icon: const Icon(size: 20, Icons.close))),
          ],
        ),
      ),
    );
  }
}
