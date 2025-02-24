import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/main.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/local_data/local_data.dart';
import 'package:i_doctor/router.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/commerce_controller.dart';
import 'package:i_doctor/state/realm_controller.dart';
import 'package:i_doctor/state/settings_controller.dart';

import 'package:intl/date_symbol_data_local.dart' as date_symbol;
import 'package:logger/logger.dart';
import 'package:restart_app/restart_app.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage(
      {super.key, required this.ctx, required this.state, required this.shell});
  final BuildContext ctx;
  final GoRouterState state;
  final StatefulNavigationShell shell;

  @override
  State<BottomNavPage> createState() => BottomNavPageState();
}

final GlobalKey<BottomNavPageState> bottomNavKey = GlobalKey();

class BottomNavPageState extends State<BottomNavPage> {
  bool loaded = false;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isSnackbarVisible = false;
  @override
  void initState() {
    super.initState();
    loadAsync();
  }

  Future<void> loadAsync() async {
    await date_symbol.initializeDateFormatting('ar', null);

    Get.put(SettingsController());
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
      Logger().i("Initializing App: 50%");
    }
    Get.find<AuthController>().loaded.listen((val) async {
      try {
        await Get.find<AuthController>().retrieveSignUpData();
        Logger().i("Initializing App: 75%");

        CommerceController commerceController = Get.find<CommerceController>();
        RealmController realmController = Get.put(RealmController());
        await Get.find<CommerceController>().resyncBasket();
        Logger().i("Initializing App: 100%");

        loaded = true;
        setState(() {});
      } catch (e) {
        print(e);
      } finally {
        FlutterNativeSplash.remove();
      }
    });
    _monitorInternetConnection();
  }

  void _monitorInternetConnection() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.none)) {
        _showPersistentSnackbar();
      } else {
        // _hideSnackbar();
      }
    });
  }

  void _showPersistentSnackbar() {
    if (!_isSnackbarVisible) {
      _isSnackbarVisible = true;
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
              t(scaffoldMessengerKey.currentContext!).noInternetConnection),
          backgroundColor: errorColor,
          duration: const Duration(days: 1), // Keep visible indefinitely
          action: SnackBarAction(
            label: t(scaffoldMessengerKey.currentContext!).tryAgain,
            textColor: Colors.white,
            onPressed: () async {
              Restart.restartApp();
            }, // Can be left empty
          ),
        ),
      );
    }
  }

  void _hideSnackbar() {
    if (_isSnackbarVisible) {
      _isSnackbarVisible = false;
      scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loaded ? widget.shell : const LoadingIndicator(),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 4,
          unselectedItemColor: secondaryColor,
          selectedItemColor: primaryColor,
          currentIndex: widget.shell.currentIndex,
          onTap: (int index) {
            if (index == 2) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                print('setting state');
                basketPageKey.currentState?.setState(() {});
              });
            }
            widget.shell.goBranch(index);
          },
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home), label: t(context).main),
            BottomNavigationBarItem(
                icon: const Icon(Icons.event), label: t(context).appointments),
            BottomNavigationBarItem(
                icon: const Icon(Icons.shopping_basket),
                label: t(context).basket),
            BottomNavigationBarItem(
                icon: const Icon(Icons.settings), label: t(context).settings),
          ]),
    );
  }
}
