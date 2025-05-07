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
import 'package:i_doctor/api/networking/rest_functions.dart';
import 'package:i_doctor/fake_data.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/maps/map_utils.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/commerce_controller.dart';

class ProviderBranchPage extends StatefulWidget {
  const ProviderBranchPage({super.key, required this.id, required this.spId});
  final String id;
  final String spId;

  @override
  State<ProviderBranchPage> createState() => _ProviderBranchPageState();
}

class _ProviderBranchPageState extends State<ProviderBranchPage> {
  late PageController pageController;
  int pageIndex = 0;
  int carouselPage = 0;
  ProviderBranch? branch;
  Provider? provider;
  Category? category;
  List<Product> products = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    branch = Get.find<CommerceController>()
        .branches
        .where((test) =>
            test.id.toString() == widget.id &&
            test.spId.toString() == widget.spId)
        .firstOrNull;
    provider = Get.find<CommerceController>()
        .providers
        .where((test) => test.id.toString() == widget.spId)
        .firstOrNull;
    if (branch != null) {
      category = Get.find<CommerceController>()
          .categories
          .where((cat) => cat.id == int.parse(branch!.code))
          .firstOrNull;

      products.addAll(Get.find<CommerceController>()
          .products
          .where((test) => test.spbId == branch!.id));
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
      appBar: IAppBar(
        title: t(context).clinicBranchPage,
        hasBackButton: true,
      ),
      body: branch == null
          ? Center(child: Text(t(context).clinicNotFound))
          : CustomScrollView(slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  ElevatedContainer(
                      blackWhite: getBlackWhite(context),
                      padding: const EdgeInsets.all(8),
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SizedBox(
                                  height: 64,
                                  width: 64,
                                  child: RetryImage(
                                    imageUrl:
                                        '$hostUrlBase/public/storage/${provider!.logo}',
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.fill,
                                  ),
                                )),
                            const SizedBox(width: 8),
                            Text(branch!.localName,
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
                          AdBanner(
                              url: provider!.photo,
                              id: 0,
                              bannerClickable: false),
                        ],
                        skeleton: false,
                        autoPlay: false,
                        infinityScroll: false,
                        blackWhite: getBlackWhite(context),
                        showIndicator: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedContainer(
                      blackWhite: getBlackWhite(context),
                      children: [
                        Align(
                          alignment: getTextDirectionLocal(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: MediaQuery.removePadding(
                              context: context,
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap),
                                  onPressed: () {
                                    if (provider != null) {
                                      String branch = GoRouter.of(context)
                                          .routeInformationProvider
                                          .value
                                          .uri
                                          .pathSegments[0];

                                      context.push(
                                          '/$branch/clinic/${provider!.id}');
                                    }
                                  },
                                  child: Text(
                                    provider!.localName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: primaryColor),
                                  )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${Get.find<AuthController>().countries!.where((test) => test.id == branch!.countryId).first.name}, ${branch!.localShortAddress}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  Text(
                                      '${branch!.localDistrict}, ${branch!.localStreet}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: Colors.grey)),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () async {
                                    List<double> numbers = branch!.location
                                        .split(',')
                                        .map((e) => double.parse(e))
                                        .toList();

                                    MapUtils.openMap(numbers[0], numbers[1]);
                                  },
                                  icon: const Icon(
                                    Icons.location_pin,
                                    color: secondaryColor,
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
                                t(context).rating,
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
                                    t(context).mainCategory,
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
                                        formatCatName(
                                            category!.getCategoryName(context)),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(color: primaryColor),
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
                                    Text(t(context).services)
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
                                    Text(t(context).reviews)
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
