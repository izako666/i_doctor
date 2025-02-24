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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loggingIn = false;
  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find<AuthController>();
    return Scaffold(
      appBar: IAppBar(
        title: t(context).loginFull,
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
                                  color: backgroundColor,
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
                                      decoration: InputDecoration(
                                        hintText: t(context).email,
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
                                    .copyWith(color: errorColor),
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
                                  color: backgroundColor,
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
                                      decoration: InputDecoration(
                                        hintText: t(context).password,
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                      textDirection: TextDirection.ltr,
                                      validator: (value) =>
                                          t(context).passwordIncorrect,
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
                                    .copyWith(color: errorColor),
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
                          t(context).noAccountSignUp,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: secondaryColor),
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
                  title: Text(t(context).login,
                      style: Theme.of(context).textTheme.titleLarge),
                  disabled: loggingIn,
                  onTap: () async {
                    loggingIn = true;
                    setState(() {});
                    auth.emailError.value =
                        auth.validateEmail(auth.emailController.text, context);
                    auth.passwordError.value = auth.validatePassword(
                        auth.passwordController.text, context);

                    if (auth.emailError.value.isEmpty &&
                        auth.passwordError.value.isEmpty) {
                      response.Response resp = await logIn(
                          auth.emailController.text,
                          auth.passwordController.text);
                      if (resp.statusCode == 200) {
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

                        Future.delayed(const Duration(milliseconds: 200), () {
                          if (context.mounted) {
                            GoRouter.of(context).clearStackAndNavigate('/feed');
                          }
                        });
                        auth.emailController.clear();
                        auth.passwordController.clear();
                      } else if (resp.statusCode == 404) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: errorColor,
                              content:
                                  Text(t(context).emailOrPasswordIncorrect)));
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: errorColor,
                              content: Text(t(context).errorOccured)));
                        }
                      }
                      loggingIn = false;
                      setState(() {});
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}
