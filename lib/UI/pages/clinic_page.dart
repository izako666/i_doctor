import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/pages/ad_list_page.dart';
import 'package:i_doctor/UI/pages/review_view.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/api/data_classes/category.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/data_classes/product.dart';
import 'package:i_doctor/fake_data.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/maps/map_utils.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/commerce_controller.dart';

class ClinicPage extends StatefulWidget {
  const ClinicPage({super.key, required this.id});
  final String id;

  @override
  State<ClinicPage> createState() => _ClinicPageState();
}

class _ClinicPageState extends State<ClinicPage> {
  late PageController pageController;
  int pageIndex = 0;
  int carouselPage = 0;
  Provider? provider;
  Category? category;
  List<Product> products = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    CommerceController commerceController = Get.find<CommerceController>();
    List<Category> categories = commerceController.categories;
    pageController = PageController();
    provider = Get.find<CommerceController>()
        .providers
        .where((test) => test.id.toString() == widget.id)
        .firstOrNull;
    if (provider != null) {
      category = Get.find<CommerceController>()
          .categories
          .where((cat) => cat.id == int.parse(provider!.code))
          .firstOrNull;
      products.addAll(Get.find<CommerceController>()
          .products
          .where((test) => test.spId == provider!.name));
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IAppBar(
        title: 'صفحة العيادة',
        hasBackButton: true,
      ),
      body: provider == null
          ? const Center(child: Text("لم يتم العثور على هذه العيادة "))
          : CustomScrollView(slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  ElevatedContainer(
                      blackWhite: getBlackWhite(context),
                      children: [
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Image.asset(
                                  clinic.logoUrl,
                                  width: 64,
                                  height: 64,
                                )),
                            const SizedBox(width: 8),
                            Text(provider!.name,
                                style: Theme.of(context).textTheme.titleLarge)
                          ],
                        ),
                      ]),
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      CarouselAdBanner(
                        onTap: () {},
                        banners: [
                          AdBanner(url: 'assets/images/placeholder.png'),
                          AdBanner(url: 'assets/images/placeholder.png'),
                          AdBanner(url: 'assets/images/placeholder.png'),
                          AdBanner(url: 'assets/images/placeholder.png'),
                          AdBanner(url: 'assets/images/placeholder.png'),
                        ],
                        skeleton: false,
                        autoPlay: false,
                        infinityScroll: true,
                        blackWhite: getBlackWhite(context),
                        showIndicator: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedContainer(
                      blackWhite: getBlackWhite(context),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${Get.find<AuthController>().countries!.where((test) => test.id == provider!.countryId).first.arbName}, ${provider!.shortAddress}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  Text(
                                      '${provider!.district}, ${provider!.street}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              color: Colors.grey.darken(0.3))),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () async {
                                    List<double> numbers = provider!.location
                                        .split(',')
                                        .map((e) => double.parse(e))
                                        .toList();

                                    MapUtils.openMap(numbers[0], numbers[1]);

                                    print(
                                        "MapUtils get coords found ${await MapUtils.getCoordinates(provider!.shortAddress) == null ? "nothing" : "something"}");
                                  },
                                  icon: Icon(
                                    Icons.location_pin,
                                    color: secondaryColor.darken(0.5),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Text(
                                'معدل المراجعة',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Spacer(),
                              RatingBarIndicator(
                                itemSize: 30,
                                itemBuilder: (ctx, i) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                rating: 3.5,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (category != null)
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Text(
                                    "الفئة الرئيسية",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const Spacer(),
                                  TextButton(
                                      onPressed: () {
                                        if (category == null) return;
                                        String branch = GoRouter.of(context)
                                            .routeInformationProvider
                                            .value
                                            .uri
                                            .pathSegments[0];

                                        context.push(
                                            '/$branch/category/${category!.id}');
                                      },
                                      child: Text(
                                        formatCatName(category!.name),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                color:
                                                    primaryColor.darken(0.4)),
                                      ))
                                ],
                              )),
                        const SizedBox(height: 4)
                      ]),
                  const SizedBox(height: 16),
                  SizedBox(
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
                                    Icon(Icons.reviews,
                                        color: pageIndex == 1
                                            ? primaryColor
                                            : Colors.grey),
                                    const Text("المراجعات")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ]),
              ),
              if (pageIndex == 0)
                SliverToBoxAdapter(
                  child: Column(
                      children: List.generate(
                          products.length,
                          (i) => BigProductCard(
                                product: products[i],
                              ))
                      // padding: EdgeInsets.all(8), child: BigProductCard())),
                      ),
                ),
              if (pageIndex == 1)
                ReviewView(
                  reviews: reviews,
                  type: 'clinic',
                  tabExists: false,
                )
            ]),
    );
  }
}
