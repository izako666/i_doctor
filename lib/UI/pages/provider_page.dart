import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/api/data_classes/category.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/networking/rest_functions.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/state/commerce_controller.dart';

class ProviderPage extends StatefulWidget {
  const ProviderPage({super.key, required this.id});
  final String id;

  @override
  State<ProviderPage> createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  late PageController pageController;
  int pageIndex = 0;
  int carouselPage = 0;
  Provider? provider;
  List<ProviderBranch>? branches;
  Category? category;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    provider = Get.find<CommerceController>()
        .providers
        .where((test) => test.id.toString() == widget.id)
        .firstOrNull;
    if (provider != null) {
      branches = Get.find<CommerceController>()
          .branches
          .where((test) => test.spId == provider!.id)
          .toList();
      category = Get.find<CommerceController>()
          .categories
          .where((cat) => cat.id == int.parse(provider!.code))
          .firstOrNull;
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
        title: t(context).clinicPage,
        hasBackButton: true,
      ),
      body: provider == null
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
                            Text(provider!.localName,
                                style: Theme.of(context).textTheme.titleMedium)
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
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Row(
                        //     children: [
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //               '${Get.find<AuthController>().countries!.where((test) => test.id == provider!.countryId).first.name}, ${provider!.localShortAddress}',
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .titleMedium),
                        //           Text(
                        //               '${provider!.localDistrict}, ${provider!.localStreet}',
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .titleSmall!
                        //                   .copyWith(color: Colors.grey)),
                        //         ],
                        //       ),
                        //       const Spacer(),
                        //       IconButton(
                        //           onPressed: () async {
                        //             List<double> numbers = provider!.location
                        //                 .split(',')
                        //                 .map((e) => double.parse(e))
                        //                 .toList();

                        //             MapUtils.openMap(numbers[0], numbers[1]);
                        //           },
                        //           icon: const Icon(
                        //             Icons.location_pin,
                        //             color: secondaryColor,
                        //           )),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(height: 16),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Row(
                        //     children: [
                        //       Text(
                        //         t(context).rating,
                        //         style: Theme.of(context).textTheme.titleMedium,
                        //       ),
                        //       const Spacer(),
                        //       RatingBarIndicator(
                        //         itemSize: 30,
                        //         itemBuilder: (ctx, i) => const Icon(
                        //           Icons.star,
                        //           color: Colors.amber,
                        //         ),
                        //         rating: 3.5,
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(height: 16),
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
                  // SizedBox(
                  //   width: getScreenWidth(context),
                  //   height: 64,
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.max,
                  //     children: [
                  //       Expanded(
                  //         child: Container(
                  //           decoration: BoxDecoration(
                  //             border: Border(
                  //                 bottom: pageIndex == 0
                  //                     ? const BorderSide(
                  //                         color: primaryColor, width: 2)
                  //                     : BorderSide.none),
                  //           ),
                  //           child: Material(
                  //             color: Colors.transparent,
                  //             child: InkWell(
                  //               onTap: () {
                  //                 pageIndex = 0;
                  //                 setState(() {});
                  //               },
                  //               child: Column(
                  //                 children: [
                  //                   Icon(Icons.supervised_user_circle_sharp,
                  //                       color: pageIndex == 0
                  //                           ? primaryColor
                  //                           : Colors.grey),
                  //                   Text(t(context).services)
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Container(
                  //           decoration: BoxDecoration(
                  //               border: Border(
                  //                   bottom: pageIndex == 1
                  //                       ? const BorderSide(
                  //                           color: primaryColor, width: 2)
                  //                       : BorderSide.none)),
                  //           child: Material(
                  //             color: Colors.transparent,
                  //             child: InkWell(
                  //               onTap: () {
                  //                 pageIndex = 1;
                  //                 setState(() {});
                  //               },
                  //               child: Column(
                  //                 children: [
                  //                   Icon(Icons.reviews,
                  //                       color: pageIndex == 1
                  //                           ? primaryColor
                  //                           : Colors.grey),
                  //                   Text(t(context).reviews)
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ]),
              ),
              if (branches != null)
                SliverToBoxAdapter(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text(
                        t(context).branches,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    CarouselClinicBranches(
                        blackWhite: getBlackWhite(context),
                        branches: branches!,
                        autoPlay: false,
                        viewportFraction: 0.5,
                        showIndicator: true,
                        onTap: () {},
                        provider: provider!),
                  ],
                )),
            ]),
    );
  }
}

class CarouselClinicBranches extends StatefulWidget {
  const CarouselClinicBranches(
      {super.key,
      required this.blackWhite,
      required this.branches,
      required this.autoPlay,
      required this.showIndicator,
      this.viewportFraction = 1.0,
      this.infinityScroll = true,
      this.height,
      this.aspectRatio,
      required this.onTap,
      required this.provider});

  final Color blackWhite;
  final List<ProviderBranch> branches;
  final Provider provider;
  final bool autoPlay;
  final bool showIndicator;
  final double viewportFraction;
  final bool infinityScroll;
  final double? height;
  final double? aspectRatio;
  final VoidCallback onTap;

  @override
  State<CarouselClinicBranches> createState() => _CarouselClinicBranchesState();
}

class _CarouselClinicBranchesState extends State<CarouselClinicBranches> {
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
          items: widget.branches.map((branch) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClinicBranchButton(
                    provider: widget.provider, providerBranch: branch));
          }).toList(),
        ),
        if (widget.showIndicator)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.branches.asMap().entries.map((entry) {
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
