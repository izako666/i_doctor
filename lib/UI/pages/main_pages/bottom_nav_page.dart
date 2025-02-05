import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
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
import 'package:restart_app/restart_app.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage(
      {super.key, required this.ctx, required this.state, required this.shell});
  final BuildContext ctx;
  final GoRouterState state;
  final StatefulNavigationShell shell;

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
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
    try {
      await LocalDataHandler.initDataHandler();
    } catch (e) {}

    Get.put(SettingsController());
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }
    Get.find<AuthController>().loaded.listen((val) async {
      await Get.find<AuthController>().retrieveSignUpData();
      CommerceController commerceController = Get.find<CommerceController>();
      RealmController realmController = Get.put(RealmController());
      await Get.find<CommerceController>().resyncBasket();

      loaded = true;
      setState(() {});
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
          content: const Text('لا يوجد اتصال بالإنترنت'),
          backgroundColor: Colors.red,
          duration: const Duration(days: 1), // Keep visible indefinitely
          action: SnackBarAction(
            label: 'أعد المحاولة',
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
          unselectedItemColor: secondaryColor.darken(0.5),
          selectedItemColor: primaryColor.darken(0.3),
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
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'مواعيد'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket), label: 'السلة'),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_offer), label: 'تخفيضات'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'الاعدادات'),
          ]),
    );
  }
}
