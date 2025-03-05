import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/pages/main_pages/appointments_page.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/realm_controller.dart';

import '../../../api/data_classes/basket_item.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  List<BasketItem> basketList = List.empty(growable: true);
  bool loaded = false;
  @override
  void initState() {
    super.initState();
    RealmController realmController = Get.find<RealmController>();
    AuthController auth = Get.find<AuthController>();
    if (auth.currentUser.value != null) {
      basketList = realmController.getItems(auth.currentUser.value!.email);
    }

    loaded = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RealmController realmController = Get.find<RealmController>();
    AuthController auth = Get.find<AuthController>();
    if (auth.currentUser.value != null) {
      basketList = realmController.getItems(auth.currentUser.value!.email);
    }
    return Scaffold(
      appBar: IAppBar(
        title: t(context).basket,
        toolbarHeight: kToolbarHeight,
        hasBackButton: false,
      ),
      body: (!loaded)
          ? const LoadingIndicator()
          : Get.find<AuthController>().currentUser.value == null
              ? Center(
                  child: Text(
                    t(context).pleaseLoginFirst,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                )
              : Stack(
                  children: [
                    StreamBuilder(
                        stream: realmController
                            .listenStream(auth.currentUser.value!.email),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const LoadingIndicator();
                          }
                          return CustomScrollView(
                            slivers: [
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 16),
                              ),
                              SliverList.builder(
                                itemBuilder: (ctx, i) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4),
                                  child: CartCard(
                                    isDisplay: false,
                                    basketItem: basketList[i],
                                    onDelete: () {
                                      setState(() {
                                        basketList = realmController.getItems(
                                            auth.currentUser.value!.email);
                                      });
                                    },
                                  ),
                                ),
                                itemCount: basketList.length,
                              ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 96),
                              ),
                            ],
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: WideButton(
                            title: Text(t(context).toPayment,
                                style: Theme.of(context).textTheme.titleLarge),
                            disabled: basketList.isEmpty,
                            onTap: () {
                              context.go('/cart/confirm');
                            }),
                      ),
                    )
                  ],
                ),
    );
  }
}
