import 'package:dio/src/response.dart' as response;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/api/data_classes/user.dart';
import 'package:i_doctor/api/encryption.dart';
import 'package:i_doctor/api/networking/rest_functions.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/local_data/local_data.dart';
import 'package:i_doctor/router.dart';
import 'package:i_doctor/state/auth_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find<AuthController>();
    return Scaffold(
      appBar: const IAppBar(
        title: "تسجيل الدخول",
        hasBackButton: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 96,
                    ),
                    Image.asset(
                      'assets/images/dummy-logo.png',
                      width: 64,
                      height: 64,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      height: 60,
                      child: Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: backgroundColor.lighten(0.05),
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(4)),
                              height: 40,
                              width: getScreenWidth(context) * 0.8,
                              child: Row(
                                textDirection: TextDirection.ltr,
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, right: 4, top: 4, bottom: 0),
                                    child: TextFormField(
                                      controller: auth.emailController,
                                      decoration: const InputDecoration(
                                        hintText: 'بريد إلكتروني',
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                      validator: (value) => null,
                                    ),
                                  )),
                                ],
                              )),
                          if (auth.emailError.value.isNotEmpty)
                            SizedBox(
                              width: getScreenWidth(context) * 0.8,
                              child: Text(
                                textAlign: TextAlign.start,
                                auth.sEmailError.value,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 60,
                      child: Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: backgroundColor.lighten(0.05),
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(4)),
                              height: 40,
                              width: getScreenWidth(context) * 0.8,
                              child: Row(
                                textDirection: TextDirection.ltr,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        auth.showPassword.value =
                                            !auth.showPassword.value;
                                      },
                                      icon: Icon(
                                        auth.showPassword.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 24,
                                      )),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, right: 4, top: 4, bottom: 0),
                                    child: TextFormField(
                                      controller: auth.passwordController,
                                      obscureText: !auth.showPassword.value,
                                      decoration: const InputDecoration(
                                        hintText: 'الشفرة',
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                      textDirection: TextDirection.ltr,
                                      validator: (value) => 'الشفرة غير صحيحة',
                                    ),
                                  )),
                                ],
                              )),
                          if (auth.passwordError.value.isNotEmpty)
                            SizedBox(
                              width: getScreenWidth(context) * 0.8,
                              child: Text(
                                textAlign: TextAlign.start,
                                auth.passwordError.value,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          context.push('/feed/login/signup');
                        },
                        child: Text(
                          'ليس لديك حساب؟ اشترك.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: secondaryColor.darken(0.5)),
                        ))
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: WideButton(
                  title:
                      Text('تم', style: Theme.of(context).textTheme.titleLarge),
                  onTap: () async {
                    auth.emailError.value =
                        auth.validateEmail(auth.emailController.text);
                    auth.passwordError.value =
                        auth.validatePassword(auth.passwordController.text);

                    if (auth.emailError.value.isEmpty &&
                        auth.passwordError.value.isEmpty) {
                      response.Response resp = await logIn(
                          auth.emailController.text,
                          auth.passwordController.text);
                      if (resp.statusCode == 200) {
                        auth.emailController.clear();
                        auth.passwordController.clear();
                        Map<String, dynamic> data =
                            resp.data as Map<String, dynamic>;
                        String encryptedPassword =
                            await encryptPassword(auth.passwordController.text);
                        LocalDataHandler.addData(
                            "email", auth.emailController.text);
                        LocalDataHandler.addData("password", encryptedPassword);
                        Map<String, dynamic> nestData = data['data'];
                        auth.currentUser.value = User.fromJson(nestData);
                        auth.authToken.value = nestData['token'];

                        Future.delayed(const Duration(seconds: 2), () {
                          if (context.mounted) {
                            GoRouter.of(context).clearStackAndNavigate('/feed');
                          }
                        });
                      } else if (resp.statusCode == 404) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                  'البريد الإلكتروني أو كلمة المرور كانت غير صحيحة.')));
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('حدث خطأ ما')));
                        }
                      }
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}
