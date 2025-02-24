import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/filter_sort_sheet.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/ui/bottom_sheet.dart';
import 'package:i_doctor/state/commerce_controller.dart';
import 'package:i_doctor/state/filter_controller.dart';

class ClinicListView extends StatelessWidget {
  const ClinicListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.7),
      itemBuilder: (ctx, i) =>
          ClinicButton(provider: Get.find<CommerceController>().providers[i]),
      itemCount: Get.find<CommerceController>().providers.length,
    );
  }
}

class ClinicListPage extends StatefulWidget {
  const ClinicListPage({super.key});

  @override
  State<ClinicListPage> createState() => _ClinicListPageState();
}

class _ClinicListPageState extends State<ClinicListPage> {
  @override
  void dispose() {
    super.dispose();
    Get.delete<FilterController>();
  }

  @override
  Widget build(BuildContext context) {
    FilterController filterController =
        Get.put(FilterController(categoryType: 0, categoriesTotal: []));
    filterController.onInit();

    return Scaffold(
      appBar: IAppBar(
        title: t(context).clinics,
        hasBackButton: true,
      ),
      body: const CustomScrollView(slivers: [ClinicListView()]),
    );
  }
}
