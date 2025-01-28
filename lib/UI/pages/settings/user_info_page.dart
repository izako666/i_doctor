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

class UserInformationPage extends StatelessWidget {
  const UserInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find<AuthController>();

    return Scaffold(
      appBar: const IAppBar(
        title: 'معلوماتي',
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
                        "الاسم",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey.darken(0.3)),
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
                  child: Divider(
                    endIndent: 64,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "البريد الإلكتروني",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey.darken(0.3)),
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
                  child: Divider(
                    endIndent: 64,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "الجنسية",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey.darken(0.3)),
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
                  child: Divider(
                    endIndent: 64,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "رقم الهاتف",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey.darken(0.3)),
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
                  child: Divider(
                    endIndent: 64,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "المدينة",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey.darken(0.3)),
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
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: WideButton(
                  title: Text(
                    "تسجيل الخروخ",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  color: Colors.red.lighten(0.01),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        contentPadding: EdgeInsets.zero,
                        content: Container(
                          decoration: BoxDecoration(
                              color: secondaryColor.lighten(0.1),
                              borderRadius: BorderRadius.circular(16)),
                          width: getScreenWidth(ctx) * 0.5,
                          height: getScreenWidth(ctx) * 0.5,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 32,
                              ),
                              Text(
                                'هل انت متاكد؟',
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
                                              'ابطال',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.red
                                                          .lighten(0.1)),
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
                                              'التاكيد',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.green
                                                          .lighten(0.1)),
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
