import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/api/data_classes/basket_item.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/networking/rest_functions.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/commerce_controller.dart';
import 'package:i_doctor/state/realm_controller.dart';
import 'package:realm/realm.dart';
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
  List<String> extraPhotos = List.empty(growable: true);
  Product? prod;
  Provider? provider;

  @override
  void initState() {
    super.initState();
    prod = Get.find<CommerceController>()
        .products
        .where((prod) => prod.id == int.parse(widget.id))
        .firstOrNull;
    if (prod != null) {
      provider = Get.find<CommerceController>()
          .providers
          .where((test) => test.name == prod!.spId)
          .firstOrNull;
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
    }
    loaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const IAppBar(
        title: 'اعلان',
        hasBackButton: true,
      ),
      body: Skeletonizer(
          enabled: !loaded,
          child: (loaded && prod == null)
              ? const Center(child: Text('لم يتم العثور على هذا المنتج'))
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
                                    child: Image.network(
                                        width: getScreenWidth(context),
                                        errorBuilder: (context, error,
                                                stackTrace) =>
                                            Container(
                                              width: getScreenWidth(context),
                                              height: 256,
                                              color: Colors.black,
                                            ),
                                        fit: BoxFit.fitWidth,
                                        '$hostUrlBase/public/storage/${prod!.photo}'),
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
                                              color: favorited
                                                  ? Colors.red
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
                                            onPressed: () {},
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
                                Text(prod!.name,
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                const SizedBox(height: 0),
                                MediaQuery.removePadding(
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
                                        prod!.spId,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color:
                                                    primaryColor.darken(0.4)),
                                      )),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    color: Colors.grey
                                                        .darken(0.3))),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.location_pin,
                                          color: secondaryColor.darken(0.5),
                                        ))
                                  ],
                                )
                              ]),
                          const SizedBox(height: 16),
                          ElevatedContainer(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              blackWhite: getBlackWhite(context),
                              children: [
                                Text("التقييمات",
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Skeleton.ignore(
                                      child: RatingBar.builder(
                                        itemSize: 30,
                                        ignoreGestures: true,
                                        initialRating: 3.5,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.zero,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                          overlayColor:
                                              WidgetStateColor.resolveWith(
                                                  (states) => states.contains(
                                                          WidgetState.pressed)
                                                      ? secondaryColor
                                                      : Colors.transparent)),
                                      onPressed: () {
                                        String branch = GoRouter.of(context)
                                            .routeInformationProvider
                                            .value
                                            .uri
                                            .pathSegments[0];

                                        context.push(
                                            '/$branch/reviews_product/1234');
                                      },
                                      child: Text(' اقرا التقييمات (١٢٠)',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: secondaryColor
                                                      .darken(0.5))),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16)
                              ]),
                          const SizedBox(height: 16),
                          ElevatedContainer(
                              blackWhite: getBlackWhite(context),
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    title: const Text('التفاصيل'),
                                    subtitle: Text('اضغط هنا كي تقرا التفاصيل',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: secondaryColor
                                                    .darken(0.5))),
                                    children: <Widget>[
                                      ListTile(title: Text(prod!.description)),
                                    ],
                                  ),
                                )
                              ]),
                          const SizedBox(height: 16),
                          ElevatedContainer(
                              blackWhite: getBlackWhite(context),
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                      title: const Text('الصور'),
                                      subtitle: Text('اضغط هنا كي ترا الصور',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: secondaryColor
                                                      .darken(0.5))),
                                      children: <Widget>[
                                        SizedBox(
                                          width: getScreenWidth(context),
                                          child: GridView.builder(
                                              shrinkWrap: true,
                                              itemCount: extraPhotos.length,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2),
                                              itemBuilder: (ctx, i) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Image.network(
                                                        width: getScreenWidth(
                                                                context) *
                                                            0.5,
                                                        '$hostUrlBase/public/storage/${extraPhotos[i]}'),
                                                  )),
                                        )
                                      ]),
                                )
                              ]),
                          const SizedBox(height: 256),
                        ]),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: WideButton(
                              title: Text("أضف الى العربة",
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              icon: Icons.shopping_basket,
                              onTap: () {
                                if (Get.find<AuthController>()
                                        .currentUser
                                        .value ==
                                    null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'يجب عليك تسجيل الدخول لاستخدام السلة.')));
                                  return;
                                }
                                BasketItem basketItem = BasketItem(
                                    '${prod!.id}_${Get.find<AuthController>().currentUser.value!.email}',
                                    prod!.id,
                                    Get.find<AuthController>()
                                        .currentUser
                                        .value!
                                        .email,
                                    prod!.catId,
                                    prod!.subcatId,
                                    prod!.spId,
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
                                    1);
                                RealmController realmController =
                                    Get.find<RealmController>();
                                AuthController authController =
                                    Get.find<AuthController>();
                                realmController.addItem(basketItem);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'تمت إضافة المنتج للسلة بنجاح.')));
                              },
                            )))
                  ],
                )),
    );
  }
}
