import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/ad_list_page.dart';
import 'package:i_doctor/UI/util/filter_sort_sheet.dart';
import 'package:i_doctor/api/data_classes/category.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/data_classes/product.dart';
import 'package:i_doctor/api/networking/rest_functions.dart';
import 'package:i_doctor/fake_data.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/ui/bottom_sheet.dart';
import 'package:i_doctor/portable_api/ui/image_worker.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/commerce_controller.dart';
import 'package:i_doctor/state/feed_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:i_doctor/state/filter_controller.dart';
import 'package:i_doctor/state/language_controller.dart';

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
  late ScrollController catScrollController;
  late CarouselSliderController clinicCarController;
  bool hideLang = false;
  @override
  void initState() {
    super.initState();
    CommerceController commerceController = Get.find<CommerceController>();
    products = commerceController.products.toList();
    catScrollController = ScrollController();
    clinicCarController = CarouselSliderController();
    adBarProducts = getRecentProducts(products);
  }

  @override
  void dispose() {
    super.dispose();
    catScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Color blackWhite = getBlackWhite(context);

      FeedController controller = Get.find<FeedController>();
      CommerceController commerceController = Get.find<CommerceController>();
      List<Category> categories = List.empty(growable: true);
      categories.addAll(commerceController.categories);

      categories.sort((cat1, cat2) => cat1.id.compareTo(cat2.id));
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
                                  controller.searchController.clear();
                                  controller.node.unfocus();
                                  controller.openFeedView.value = true;
                                },
                                onSubmit: (val) {
                                  loading = true;
                                  controller
                                      .filterSearch(
                                          commerceController.products, context)
                                      .then((val) {
                                    products = val;
                                    loading = false;
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      setState(() {});
                                    });
                                  });
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
                                      hideLang = true;
                                      LanguageController lang =
                                          Get.find<LanguageController>();
                                      lang.locale.value ==
                                              Get.find<AuthController>()
                                                  .currentCountry
                                                  .value!
                                                  .lang1
                                          ? lang.setLocale(
                                              Get.find<AuthController>()
                                                  .currentCountry
                                                  .value!
                                                  .lang2)
                                          : lang.setLocale(
                                              Get.find<AuthController>()
                                                  .currentCountry
                                                  .value!
                                                  .lang1);

                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        hideLang = false;
                                        setState(() {});
                                        if (catScrollController.hasClients) {
                                          catScrollController.jumpTo(0);
                                        }
                                      });
                                    },
                                    splashFactory: InkRipple.splashFactory,
                                    child: Text(
                                      hideLang
                                          ? "     "
                                          : Get.find<LanguageController>()
                                              .locale
                                              .value
                                              .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                        Obx(() {
                          return (!controller.openFeedView.value &&
                                  commerceController.products.isNotEmpty)
                              ? Expanded(
                                  child: ListView.builder(
                                    itemBuilder: (ctx, i) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: BigProductCard(
                                          product: products[i],
                                        ),
                                      );
                                    },
                                    itemCount: products.length,
                                  ),
                                )
                              : (commerceController.products.isNotEmpty)
                                  ? Expanded(
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
                                                skeleton:
                                                    controller.skeleton.value,
                                                blackWhite: blackWhite,
                                                decompress: true,
                                                fit: BoxFit.cover,
                                                banners: adBarProducts
                                                    .map((prod) => AdBanner(
                                                        url: prod.photo,
                                                        id: prod.id))
                                                    .toList(),
                                                autoPlay: true,
                                                showIndicator: true,
                                              ),
                                            const SizedBox(height: 16),
                                            Material(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              elevation: 2,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
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
                                                        BorderRadius.circular(
                                                            16),
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                            iconSize: 12,
                                                            visualDensity:
                                                                VisualDensity
                                                                    .compact,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              catScrollController.animateTo(
                                                                  catScrollController
                                                                          .offset -
                                                                      300,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          200),
                                                                  curve: Curves
                                                                      .easeIn);
                                                            },
                                                            icon: const Icon(Icons
                                                                .arrow_back_ios_new)),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                          child: Scrollbar(
                                                            trackVisibility:
                                                                false,
                                                            thumbVisibility:
                                                                false,
                                                            thickness: 0,
                                                            child: ListView
                                                                .builder(
                                                                    controller:
                                                                        catScrollController,
                                                                    scrollDirection: Axis
                                                                        .horizontal,
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            20),
                                                                    itemCount: (commerceController
                                                                            .categories)
                                                                        .length,
                                                                    itemBuilder:
                                                                        (ctx,
                                                                            i) {
                                                                      return Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal:
                                                                                  12),
                                                                          child:
                                                                              CategoryCircleButton(category: categories[i]));
                                                                    }),
                                                          ),
                                                        ),
                                                        IconButton(
                                                            iconSize: 12,
                                                            visualDensity:
                                                                VisualDensity
                                                                    .compact,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              catScrollController.animateTo(
                                                                  catScrollController
                                                                          .offset +
                                                                      300,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          200),
                                                                  curve: Curves
                                                                      .easeIn);
                                                            },
                                                            icon: const Icon(Icons
                                                                .arrow_forward_ios)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
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
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: Text(
                                                          t(context).clinics,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        style: ButtonStyle(
                                                            overlayColor: WidgetStateColor.resolveWith((states) => states
                                                                    .contains(
                                                                        WidgetState
                                                                            .pressed)
                                                                ? secondaryColor
                                                                : Colors
                                                                    .transparent)),
                                                        onPressed: () {
                                                          context.push(
                                                              '/feed/clinics');
                                                        },
                                                        child: Text(
                                                            t(context).showAll,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                    color:
                                                                        secondaryColor)),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                          iconSize: 12,
                                                          visualDensity:
                                                              VisualDensity
                                                                  .compact,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          onPressed: () {
                                                            clinicCarController
                                                                .previousPage(
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            200),
                                                                    curve: Curves
                                                                        .easeIn);
                                                          },
                                                          icon: const Icon(Icons
                                                              .arrow_back_ios_new)),
                                                      Expanded(
                                                        child: CarouselSlider
                                                            .builder(
                                                                carouselController:
                                                                    clinicCarController,
                                                                itemCount: commerceController
                                                                            .providers.length >
                                                                        4
                                                                    ? 4
                                                                    : commerceController
                                                                        .providers
                                                                        .length,
                                                                itemBuilder:
                                                                    (ctx, i,
                                                                        b) {
                                                                  return ClinicButton(
                                                                      provider:
                                                                          commerceController
                                                                              .providers[i]);
                                                                },
                                                                options: CarouselOptions(
                                                                    height: 200,
                                                                    viewportFraction:
                                                                        0.5,
                                                                    autoPlay:
                                                                        true)),
                                                      ),
                                                      IconButton(
                                                          iconSize: 12,
                                                          visualDensity:
                                                              VisualDensity
                                                                  .compact,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          onPressed: () {
                                                            clinicCarController.nextPage(
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            200),
                                                                curve: Curves
                                                                    .easeIn);
                                                          },
                                                          icon: const Icon(Icons
                                                              .arrow_forward_ios)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 32),
                                            Center(
                                                child: Text(
                                              "This is some random footer with information to be determined later....",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(color: Colors.grey),
                                            )),
                                            const SizedBox(
                                              height: 32,
                                            )
                                          ]),
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        const SizedBox(
                                          height: 200,
                                        ),
                                        Center(
                                            child: Text(
                                          t(context).noProductsFoundInRegion,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(fontSize: 18),
                                        )),
                                      ],
                                    );
                        })
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
  if (recentProducts.isEmpty) {
    recentProducts.clear();
    recentProducts.addAll(products);
    recentProducts.sort((a, b) {
      DateTime dateA = DateTime.parse(a.startDate);
      DateTime dateB = DateTime.parse(b.startDate);
      return dateB.compareTo(dateA); // Descending order
    });
  } else {
    // Sort products by startDate in descending order (most recent first)
    recentProducts.sort((a, b) {
      DateTime dateA = DateTime.parse(a.startDate);
      DateTime dateB = DateTime.parse(b.startDate);
      return dateB.compareTo(dateA); // Descending order
    });
  }
  return recentProducts;
}

class ClinicButton extends StatelessWidget {
  const ClinicButton({super.key, required this.provider});
  final Provider provider;

  @override
  Widget build(BuildContext context) {
    final logicalSize = MediaQuery.of(context).size;
    final physicalSize = View.of(context).physicalSize;
    final dpr = MediaQuery.of(context).devicePixelRatio;

    final calculatedZoom = physicalSize.width / logicalSize.width;
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
                      height: calculatedZoom > 2.8 ? 80 : 128,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        child: RetryImage(
                          imageUrl:
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
                          provider.localName,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          provider.localShortAddress,
                          overflow: TextOverflow.ellipsis,
                        )),
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

class ClinicBranchButton extends StatelessWidget {
  const ClinicBranchButton(
      {super.key, required this.provider, required this.providerBranch});
  final Provider provider;
  final ProviderBranch providerBranch;

  @override
  Widget build(BuildContext context) {
    final logicalSize = MediaQuery.of(context).size;
    final physicalSize = View.of(context).physicalSize;
    final dpr = MediaQuery.of(context).devicePixelRatio;

    final calculatedZoom = physicalSize.width / logicalSize.width;

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

            context.push(
                '/$branch/clinic_branch/${providerBranch.spId}/${providerBranch.id}');
          },
          splashFactory: InkRipple.splashFactory,
          child: SizedBox(
              width: 200,
              child: Column(
                children: [
                  SizedBox(
                      width: 1000,
                      height: calculatedZoom > 2.8 ? 80 : 128,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        child: RetryImage(
                          imageUrl:
                              '$hostUrlBase/public/storage/${provider.photo}',
                          fit: BoxFit.fill,
                        ),
                      )),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                        alignment: getTextDirectionLocal(context),
                        child: Text(
                          providerBranch.localName,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                        alignment: getTextDirectionLocal(context),
                        child: Text(
                          providerBranch.localShortAddress,
                          overflow: TextOverflow.ellipsis,
                        )),
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
    this.borderColor,
    this.width,
    this.height,
  });
  final Widget title;
  final IconData? icon;
  final VoidCallback onTap;
  final BorderRadius? radius;
  final Color? color;
  final bool disabled;
  final Color? borderColor;
  final double? width;
  final double? height;

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
          width: width ?? MediaQuery.of(context).size.width,
          height: height ?? 64,
          decoration: BoxDecoration(
              borderRadius: radius ?? BorderRadius.circular(8),
              border:
                  Border.all(width: 0.5, color: borderColor ?? Colors.black),
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
    this.height,
    this.radius,
  });

  final Color blackWhite;
  final List<Widget> children;
  final double? width;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets? padding;
  final MainAxisAlignment mainAxisAlignment;
  final double? height;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: radius ?? BorderRadius.circular(16),
        elevation: 1,
        child: Container(
            padding: padding ??
                const EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 4),
            width: width ?? getScreenWidth(context),
            height: height,
            decoration: BoxDecoration(
              borderRadius: radius ?? BorderRadius.circular(16),
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
      required this.onTap,
      this.decompress = false,
      this.fit = BoxFit.fill});

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
  final bool decompress;
  final BoxFit fit;
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
                          fit: widget.fit,
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
    this.fit = BoxFit.fill,
  });

  final CarouselAdBanner widget;
  final AdBanner banner;
  final BoxFit fit;

  @override
  State<BannerImage> createState() => _BannerImageState();
}

class _BannerImageState extends State<BannerImage> {
  bool errored = false;
  @override
  Widget build(BuildContext context) {
    return Material(
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: RetryImage(
                imageUrl: '$hostUrlBase/public/storage/${widget.banner.url}'),
          ),
        ));
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
            width: 64,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    width: 34,
                    height: 34,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.asset('assets/images/${category.id}.png',
                            fit: BoxFit.scaleDown))),
                SizedBox(
                  width: 100,
                  child: Text(
                    formatCatName(category.getCategoryName(context)),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
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
