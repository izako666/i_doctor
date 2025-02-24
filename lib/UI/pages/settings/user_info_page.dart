import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/local_data/local_data.dart';
import 'package:i_doctor/router.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/language_controller.dart';
import 'package:i_doctor/state/realm_controller.dart';

class UserInformationPage extends StatelessWidget {
  const UserInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find<AuthController>();

    return Scaffold(
      appBar: IAppBar(
        title: t(context).myInfo,
        hasBackButton: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t(context).clientIdNumber,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        auth.currentUser.value!.id.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t(context).name,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        auth.currentUser.value!.custArbName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t(context).email,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        auth.currentUser.value!.email,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t(context).nationality,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        auth.currentUser.value!.nationalityId.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t(context).phoneNumber,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        auth.currentUser.value!.mobile,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t(context).city,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        auth.currentUser.value!.cityId.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t(context).language,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Obx(
                        () => DropdownButton2<String>(
                          value: Get.find<LanguageController>().locale.value,
                          items: Get.find<LanguageController>()
                              .localeLangMap
                              .keys
                              .map((k) => DropdownMenuItem(
                                  value: k,
                                  child: Text(Get.find<LanguageController>()
                                      .localeLangMap[k]!)))
                              .toList(),
                          style: Theme.of(context).textTheme.bodyLarge,
                          onChanged: (v) {
                            if (v != null) {
                              Get.find<LanguageController>().setLocale(v);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        onTap: () {
                          RealmController realmController =
                              Get.find<RealmController>();
                          bool isEmpty = realmController
                              .getFavoriteItems(Get.find<AuthController>()
                                  .currentUser
                                  .value!
                                  .email)
                              .isEmpty;
                          if (isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text(t(context).noProductsFavoriteList)));
                            return;
                          }
                          context.go("/feed/user_info/favorites");
                        },
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                        ),
                        title: Text(
                          t(context).favoritedProductsList,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100)
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: WideButton(
                  title: Text(
                    t(context).signOut,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  color: errorColor,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        contentPadding: EdgeInsets.zero,
                        content: Container(
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(16)),
                          width: getScreenWidth(ctx) * 0.5,
                          height: getScreenWidth(ctx) * 0.5,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 32,
                              ),
                              Text(
                                t(context).areYouSure,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            context.pop();
                                          },
                                          child: Container(
                                            height: 32,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(16))),
                                            child: Center(
                                                child: Text(
                                              t(context).cancel,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(color: errorColor),
                                            )),
                                          ))),
                                  Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            auth.currentUser.value = null;
                                            auth.authToken.value = null;
                                            LocalDataHandler.deleteData(
                                                'email');
                                            LocalDataHandler.deleteData(
                                                'password');
                                            context.pop();
                                            if (context.mounted) {
                                              GoRouter.of(context)
                                                  .clearStackAndNavigate(
                                                      '/feed');
                                            }
                                          },
                                          child: Container(
                                            height: 32,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(16))),
                                            child: Center(
                                                child: Text(
                                              t(context).confirm,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: successColor),
                                            )),
                                          )))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      barrierDismissible: true,
                    );
                  }))
        ],
      ),
    );
  }
}
