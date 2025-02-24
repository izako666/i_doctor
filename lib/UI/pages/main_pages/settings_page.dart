import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsController settingsController = Get.find<SettingsController>();
    AuthController auth = Get.find<AuthController>();
    return Scaffold(
      appBar: IAppBar(
        title: t(context).settings,
        hasBackButton: false,
        toolbarHeight: kToolbarHeight,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Material(
            //   elevation: 2,
            //   color: getBlackWhite(context) == black
            //       ? white.darken(0.07)
            //       : black.lighten(0.08),
            //   borderRadius: const BorderRadius.only(
            //       topLeft: Radius.circular(16),
            //       topRight: Radius.circular(16)),
            //   child: InkWell(
            //     splashColor: primaryColor.withAlpha(50),
            //     borderRadius: const BorderRadius.only(
            //         topLeft: Radius.circular(16),
            //         topRight: Radius.circular(16)),
            //     onTap: () async {
            //       if (auth.currentUser.value == null) {
            //         context.push('/feed/settings/login');
            //       } else {
            //         context.go('/feed/settings/user_info');
            //       }
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 16),
            //       child: ListTile(
            //         contentPadding: EdgeInsets.zero,
            //         title: Obx(
            //           () => Text(auth.currentUser.value != null
            //               ? 'معلوماتي'
            //               : 'تسجيل الدخول'),
            //         ),
            //         leading: const Icon(Icons.person),
            //         trailing: const Icon(Icons.arrow_forward_ios_rounded),
            //       ),
            //     ),
            //   ),
            // ),
            // Obx(
            //   () => Material(
            //     elevation: 2,
            //     color: getBlackWhite(context) == black
            //         ? white.darken(0.07)
            //         : black.lighten(0.08),
            //     borderRadius: auth.currentUser.value != null
            //         ? null
            //         : const BorderRadius.only(
            //             bottomLeft: Radius.circular(16),
            //             bottomRight: Radius.circular(16)),
            //     child: InkWell(
            //       splashColor: primaryColor.withAlpha(50),
            //       borderRadius: const BorderRadius.only(
            //           topLeft: Radius.circular(16),
            //           topRight: Radius.circular(16)),
            //       onTap: () {
            //         showDialog(
            //           context: context,
            //           builder: (ctx) => AlertDialog(
            //             contentPadding: EdgeInsets.zero,
            //             content: CitySelectDialog(auth: auth),
            //           ),
            //           barrierDismissible: true,
            //         );
            //       },
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 16),
            //         child: Obx(
            //           () => ListTile(
            //             splashColor: Colors.grey,
            //             contentPadding: EdgeInsets.zero,
            //             title: const Text('المدينة'),
            //             leading: const Icon(Icons.location_city_rounded),
            //             trailing: auth.cityName.value.isEmpty
            //                 ? const Icon(Icons.arrow_forward_ios_rounded)
            //                 : Text(auth.cityName.value),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 16),
            Material(
              elevation: 2,
              color: getBlackWhite(context) == black ? white : black,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: InkWell(
                splashColor: primaryColor.withAlpha(50),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                onTap: () {
                  context.go('/settings/faq');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListTile(
                    splashColor: Colors.grey,
                    contentPadding: EdgeInsets.zero,
                    title: Text(t(context).faq),
                    leading: const Icon(Icons.info_outline),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
              ),
            ),
            Material(
              elevation: 2,
              color: getBlackWhite(context) == black ? white : black,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16)),
              child: InkWell(
                splashColor: primaryColor.withAlpha(50),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                onTap: () {
                  context.go('/settings/privacy_policy');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListTile(
                    splashColor: Colors.grey,
                    contentPadding: EdgeInsets.zero,
                    title: Text(t(context).privacyPolicy),
                    leading: const Icon(Icons.privacy_tip_rounded),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                  splashColor: Colors.transparent),
              child: Material(
                elevation: 2,
                color: getBlackWhite(context) == black ? white : black,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  splashColor: primaryColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {},
                  child: Obx(
                    () => ExpansionTile(
                      title: Text(t(context).contactUs),
                      leading: const Icon(Icons.send_rounded),
                      trailing: Icon(settingsController.contactExpanded.value
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded),
                      clipBehavior: Clip.none,
                      onExpansionChanged: (val) =>
                          settingsController.contactExpanded.value = val,
                      children: [
                        Material(
                          elevation: 2,
                          color:
                              getBlackWhite(context) == black ? white : black,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16)),
                          child: InkWell(
                            splashColor: primaryColor.withAlpha(50),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16)),
                            onTap: () {},
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(t(context).email),
                                leading: const Icon(Icons.mail),
                                trailing:
                                    const Icon(Icons.arrow_forward_ios_rounded),
                              ),
                            ),
                          ),
                        ),
                        Material(
                          elevation: 0,
                          color:
                              getBlackWhite(context) == black ? white : black,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16)),
                          child: InkWell(
                            splashColor: primaryColor.withAlpha(50),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16)),
                            onTap: () {
                              context.push('/settings/chat');
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ListTile(
                                splashColor: Colors.grey,
                                contentPadding: EdgeInsets.zero,
                                title: Text(t(context).customerServiceChat),
                                leading: const Icon(Icons.chat_bubble_outline),
                                trailing:
                                    const Icon(Icons.arrow_forward_ios_rounded),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
