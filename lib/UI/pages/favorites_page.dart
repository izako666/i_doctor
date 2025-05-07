import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_doctor/UI/pages/ad_list_page.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/api/data_classes/basket_item.dart';
import 'package:i_doctor/api/data_classes/product.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/filter_controller.dart';
import 'package:i_doctor/state/realm_controller.dart';
import 'package:realm/realm.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key, this.hasBackButton = true});
  final bool hasBackButton;
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool loaded = true;
  bool loading = false;
  bool favorited = false;
  List<Product> favoriteProducts = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    RealmController realmController = Get.find<RealmController>();
    if (Get.find<AuthController>().currentUser.value != null) {
      favoriteProducts = realmController
          .getFavoriteItems(Get.find<AuthController>().currentUser.value!.email)
          .map((b) => Product(
              id: b.productId,
              catId: b.catId,
              subcatId: b.subcatId,
              spId: b.spId,
              spbId: b.spbId,
              name: b.name,
              name2: b.name2,
              description: b.description,
              description2: b.description2,
              photo: b.photo,
              active: b.active,
              spPrice: b.spPrice,
              spDiscountPercent: null,
              spDiscountAmount: null,
              countryId: -1,
              cityId: -1,
              currency: b.currency,
              spTotal: b.spTotal,
              idocPrice: b.idocPrice,
              idocDiscountAmt: b.idocDiscountAmt,
              idocNet: b.idocNet,
              idocType: b.idocType,
              startDate: b.startDate,
              endDate: b.endDate,
              availablePurchases: b.availablePurchases,
              createdAt: b.createdAt,
              updatedAt: b.updatedAt))
          .toList();
    }
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<FilterController>();
  }

  @override
  Widget build(BuildContext context) {
    RealmController realmController = Get.find<RealmController>();
    if (Get.find<AuthController>().currentUser.value == null) {
      return Container();
    }
    //filterController.filterProducts(commerceController.products ?? []);
    return StreamBuilder<RealmResultsChanges<BasketItem>>(
        stream: realmController.listenFavoriteStream(
            Get.find<AuthController>().currentUser.value!.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            favoriteProducts = snapshot.data!.results
                .toList()
                .map((b) => Product(
                    id: b.productId,
                    catId: b.catId,
                    subcatId: b.subcatId,
                    spId: b.spId,
                    spbId: b.spbId,
                    name: b.name,
                    name2: b.name2,
                    description: b.description,
                    description2: b.description2,
                    photo: b.photo,
                    active: b.active,
                    spPrice: b.spPrice,
                    spDiscountPercent: null,
                    spDiscountAmount: null,
                    countryId: -1,
                    cityId: -1,
                    currency: b.currency,
                    spTotal: b.spTotal,
                    idocPrice: b.idocPrice,
                    idocDiscountAmt: b.idocDiscountAmt,
                    idocNet: b.idocNet,
                    idocType: b.idocType,
                    startDate: b.startDate,
                    endDate: b.endDate,
                    availablePurchases: b.availablePurchases,
                    createdAt: b.createdAt,
                    updatedAt: b.updatedAt))
                .toList();
          }
          return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: IAppBar(
                title: t(context).favoriteProducts,
                hasBackButton: widget.hasBackButton,
                toolbarHeight: widget.hasBackButton ? null : kToolbarHeight,
              ),
              body: loading
                  ? const LoadingIndicator()
                  : Skeletonizer(
                      enabled: !loaded,
                      child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 8),
                          child: loaded
                              ? ListView.builder(
                                  itemBuilder: (ctx, i) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: BigProductCard(
                                        product: favoriteProducts[i],
                                        pushRoute: true,
                                      ),
                                    );
                                  },
                                  itemCount: favoriteProducts.length,
                                )
                              : ListView.builder(
                                  itemBuilder: (ctx, i) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Container(
                                          color: Colors.grey,
                                          width: getScreenWidth(context),
                                          height: 256),
                                    );
                                  },
                                  itemCount: 12,
                                ))));
        });
  }
}
