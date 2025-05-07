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
    List<Map> languages = [
      {"name": "English", "flag": "🇺🇸", "locale": "en"},
      {"name": "العربية", "flag": "🇸🇦", "locale": "ar"},
      {"name": "Türkçe", "flag": "🇹🇷", "locale": "tr"}
    ]
        .where(
          (element) =>
              element["locale"] == auth.currentCountry.value!.lang1 ||
              element["locale"] == auth.currentCountry.value!.lang2,
        )
        .toList();
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.numbers),
                              const SizedBox(
                                height: 25,
                                child: VerticalDivider(color: Colors.grey),
                              ),
                              Text(
                                auth.currentUser.value!.id.toString(),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.person),
                              const SizedBox(
                                height: 25,
                                child: VerticalDivider(color: Colors.grey),
                              ),
                              Text(
                                auth.currentUser.value!.custArbName,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.email),
                              const SizedBox(
                                height: 25,
                                child: VerticalDivider(color: Colors.grey),
                              ),
                              Text(
                                auth.currentUser.value!.email,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 40,
                        child: Row(
                          children: [
                            const Icon(Icons.flag),
                            const SizedBox(
                              height: 25,
                              child: VerticalDivider(color: Colors.grey),
                            ),
                            Text(
                              Get.find<AuthController>()
                                      .nationalities!
                                      .where((test) =>
                                          test.id ==
                                          auth.currentUser.value!.nationalityId)
                                      .firstOrNull
                                      ?.name ??
                                  "",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.phone),
                              const SizedBox(
                                height: 25,
                                child: VerticalDivider(color: Colors.grey),
                              ),
                              Text(
                                auth.currentUser.value!.mobile,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t(context).country,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.public),
                              const SizedBox(
                                height: 25,
                                child: VerticalDivider(color: Colors.grey),
                              ),
                              Text(
                                Get.find<AuthController>()
                                        .countries!
                                        .where((test) =>
                                            test.id ==
                                            auth.currentUser.value!.countryId)
                                        .firstOrNull
                                        ?.name ??
                                    "",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (auth.currentUser.value!.cityId != -1) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.location_city),
                                const SizedBox(
                                  height: 25,
                                  child: VerticalDivider(color: Colors.grey),
                                ),
                                Text(
                                  Get.find<AuthController>()
                                          .cities!
                                          .where((test) =>
                                              test.id ==
                                              auth.currentUser.value!.cityId)
                                          .firstOrNull
                                          ?.name ??
                                      "",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t(context).language,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.language),
                              const SizedBox(
                                height: 25,
                                child: VerticalDivider(color: Colors.grey),
                              ),
                              Obx(
                                () => DropdownButton2<String>(
                                  underline: const SizedBox(),
                                  dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16))),
                                  value: Get.find<LanguageController>()
                                      .locale
                                      .value,
                                  items: languages
                                      .map((k) => DropdownMenuItem(
                                          value: k["locale"] as String,
                                          child: Text(k["name"]!)))
                                      .toList(),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  onChanged: (v) {
                                    if (v != null) {
                                      Get.find<LanguageController>()
                                          .setLocale(v);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: WideButton(
                    icon: Icons.arrow_forward_ios_rounded,
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
                            content: Text(t(context).noProductsFavoriteList)));
                        return;
                      }
                      context.go("/feed/user_info/favorites");
                    },
                    title: Text(
                      t(context).favoritedProductsList,
                    ),
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
                                          onTap: () async {
                                            auth.currentUser.value = null;
                                            auth.authToken.value = null;
                                            await auth.reInitData();

                                            LocalDataHandler.deleteData(
                                                'email');
                                            LocalDataHandler.deleteData(
                                                'password');

                                            if (context.mounted) {
                                              context.pop();

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
