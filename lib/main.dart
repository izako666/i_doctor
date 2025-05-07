import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/portable_api/local_data/local_data.dart';
import 'package:i_doctor/router.dart';
import 'package:i_doctor/state/dio_controller.dart';
import 'package:i_doctor/state/feed_controller.dart';
import 'package:i_doctor/state/language_controller.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Get.put(FeedController());
  Get.put(DioController());
  await LocalDataHandler.initDataHandler();

  Get.put(LanguageController());
  Logger().i("Initializing App: 25%");
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MaterialApp.router(
        title: '',
        scaffoldMessengerKey: scaffoldMessengerKey,
        localizationsDelegates: const [
          LocaleNamesLocalizationsDelegate(),
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ar'), Locale('tr')],
        locale: Locale(Get.find<LanguageController>().locale.value),
        theme: ThemeData(
          colorScheme: colorScheme,
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const FeedPage();
  }
}
