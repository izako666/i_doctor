import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/api/data_classes/category.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/data_classes/subcategory.dart';
import 'package:i_doctor/fake_data.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/state/filter_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FilterSortSheet extends StatefulWidget {
  const FilterSortSheet({super.key, required this.filterController});
  final FilterController filterController;
  @override
  State<FilterSortSheet> createState() => _FilterSortSheetState();
}

class _FilterSortSheetState extends State<FilterSortSheet> {
  late PageController pageController;
  DateTime startTime = DateTime(1950);
  DateTime endTime = DateTime.now();

  double startPrice = 0.0;
  double endPrice = 2000.0;
  double requiredRating = 0.0;
  String selectedCategory = '';

  List<Category> selectedCategories = List.empty(growable: true);
  List<Subcategory> selectedSubcategories = List.empty(growable: true);
  List<Provider> selectedProviders = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    pageController =
        PageController(initialPage: widget.filterController.pageIndex.value);
    startTime = widget.filterController.startTime.value;
    endTime = widget.filterController.endTime.value;
    startPrice = widget.filterController.startPrice.value;
    endPrice = widget.filterController.endPrice.value;
    selectedCategories = List.from(widget.filterController.categoriesSelected);
    selectedSubcategories =
        List.from(widget.filterController.subcategoriesSelected);
    selectedProviders = List.from(widget.filterController.selectedProviders);
    requiredRating = widget.filterController.requiredRating.value;
    selectedCategory = widget.filterController.selectedSortCategory.value;
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: IAppBar(
        title: t(context).filterAndSort,
        hasBackButton: false,
        toolbarHeight: kToolbarHeight * 2,
        actions: [
          IconButton(
              onPressed: () async {
                bool reset = await _showCancelDialog(context);

                if (reset && context.mounted) {
                  widget.filterController.resetValues();
                  context.pop();
                } else {}
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Hero(
        tag: 'filter',
        child: Stack(children: [
          Column(
            children: [
              const SizedBox(height: 8),
              SizedBox(
                width: getScreenWidth(context),
                height: 64,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    widget.filterController.pageIndex.value == 0
                                        ? const BorderSide(
                                            color: primaryColor, width: 2)
                                        : BorderSide.none),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                pageController.jumpToPage(0);
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.filter_alt_rounded,
                                      color: widget.filterController.pageIndex
                                                  .value ==
                                              0
                                          ? primaryColor
                                          : Colors.grey),
                                  Text(t(context).filter)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      widget.filterController.pageIndex.value ==
                                              1
                                          ? const BorderSide(
                                              color: primaryColor, width: 2)
                                          : BorderSide.none)),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                pageController.jumpToPage(1);
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.sort,
                                      color: widget.filterController.pageIndex
                                                  .value ==
                                              1
                                          ? primaryColor
                                          : Colors.grey),
                                  Text(t(context).sort)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: getScreenHeight(context) * 0.5,
                child: PageView(
                  controller: pageController,
                  padEnds: true,
                  onPageChanged: (value) {
                    widget.filterController.pageIndex.value = value;
                  },
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          ElevatedContainer(
                              blackWhite: getBlackWhite(context),
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    title: Text(t(context).date),
                                    subtitle: Text(t(context).selectDesiredDate,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: secondaryColor)),
                                    children: <Widget>[
                                      SfDateRangePicker(
                                        headerStyle:
                                            const DateRangePickerHeaderStyle(
                                                backgroundColor:
                                                    backgroundColor),
                                        backgroundColor: backgroundColor,
                                        initialSelectedRange:
                                            startTime.isBefore(DateTime(1951))
                                                ? null
                                                : PickerDateRange(
                                                    startTime, endTime),
                                        onSelectionChanged: (args) {
                                          startTime =
                                              (args.value as PickerDateRange)
                                                      .startDate ??
                                                  startTime;
                                          endTime =
                                              (args.value as PickerDateRange)
                                                      .endDate ??
                                                  endTime;
                                          setState(() {});
                                        },
                                        selectionMode:
                                            DateRangePickerSelectionMode.range,
                                      )
                                    ],
                                  ),
                                )
                              ]),
                          const SizedBox(height: 4),
                          // ElevatedContainer(
                          //     blackWhite: getBlackWhite(context),
                          //     children: [
                          //       Theme(
                          //         data: Theme.of(context).copyWith(
                          //             dividerColor: Colors.transparent),
                          //         child: ExpansionTile(
                          //           title: Text(t(context).review),
                          //           subtitle: Text(
                          //               t(context).selectDesiredRating,
                          //               style: Theme.of(context)
                          //                   .textTheme
                          //                   .bodyMedium!
                          //                   .copyWith(color: secondaryColor)),
                          //           children: <Widget>[
                          //             RatingBar.builder(
                          //               itemSize: 26,
                          //               initialRating: requiredRating,
                          //               minRating: 1,
                          //               direction: Axis.horizontal,
                          //               allowHalfRating: true,
                          //               itemCount: 5,
                          //               itemPadding: EdgeInsets.zero,
                          //               itemBuilder: (context, _) => const Icon(
                          //                 Icons.star,
                          //                 color: Colors.amber,
                          //               ),
                          //               onRatingUpdate: (rating) {
                          //                 requiredRating = rating;
                          //                 setState(() {});
                          //               },
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          //     ]),
                          // const SizedBox(height: 4),
                          ElevatedContainer(
                              blackWhite: getBlackWhite(context),
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    title: Text(t(context).priceWord),
                                    subtitle: Text(
                                        t(context).selectDesiredPrice,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: secondaryColor)),
                                    children: <Widget>[
                                      const SizedBox(height: 4),
                                      RangeSlider(
                                          min: 0.0,
                                          max: 2000.0,
                                          divisions: 20,
                                          labels: RangeLabels(
                                              formatPrice(startPrice),
                                              formatPrice(endPrice)),
                                          values:
                                              RangeValues(startPrice, endPrice),
                                          onChanged: (val) {
                                            startPrice = val.start;
                                            endPrice = val.end;
                                            setState(() {});
                                          }),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(formatPrice(0.0)),
                                          Text(formatPrice(2000.0)),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ]),
                          const SizedBox(height: 4),
                          ElevatedContainer(
                              blackWhite: getBlackWhite(context),
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    title: Text(t(context).serviceProviders),
                                    subtitle: Text(
                                        t(context).selectedDesiredProviders,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: secondaryColor)),
                                    children: <Widget>[
                                      Wrap(
                                        runSpacing: 10,
                                        runAlignment:
                                            WrapAlignment.spaceBetween,
                                        spacing: 15,
                                        children: widget
                                            .filterController.totalProviders
                                            .map(
                                          (e) {
                                            return SelectableTextButton(
                                                selected: selectedProviders
                                                    .where((test) =>
                                                        test.id == e.id)
                                                    .isNotEmpty,
                                                text: e.name,
                                                id: e.id,
                                                onTap: () {
                                                  if (selectedProviders
                                                      .where((test) =>
                                                          test.id == e.id)
                                                      .isEmpty) {
                                                    selectedProviders.add(e);
                                                  } else {
                                                    selectedProviders
                                                        .removeWhere((test) =>
                                                            test.id == e.id);
                                                  }
                                                  setState(() {});
                                                });
                                          },
                                        ).toList(),
                                      )
                                    ],
                                  ),
                                )
                              ]),

                          const SizedBox(height: 4),
                          ElevatedContainer(
                              blackWhite: getBlackWhite(context),
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    title: Text(t(context).subCategories),
                                    subtitle: Text(
                                        t(context).selectDesiredSubcategories,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: secondaryColor)),
                                    children: <Widget>[
                                      if (widget
                                              .filterController.categoryType ==
                                          2) ...[
                                        ...widget
                                            .filterController.categoriesTotal!
                                            .map((cat) {
                                          return ElevatedContainer(
                                              blackWhite:
                                                  getBlackWhite(context),
                                              children: [
                                                Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                          dividerColor: Colors
                                                              .transparent),
                                                  child: ExpansionTile(
                                                    title: Text(cat.name),
                                                    children: [
                                                      Wrap(
                                                        runSpacing: 10,
                                                        runAlignment:
                                                            WrapAlignment
                                                                .spaceBetween,
                                                        spacing: 15,
                                                        children: [
                                                          ...widget
                                                              .filterController
                                                              .subCategoriesTotal!
                                                              .where((subcat) =>
                                                                  subcat
                                                                      .catId ==
                                                                  cat.id)
                                                              .map((e) {
                                                            return SelectableTextButton(
                                                                selected: selectedSubcategories
                                                                    .where((test) =>
                                                                        test.id ==
                                                                        e.id)
                                                                    .isNotEmpty,
                                                                text:
                                                                    e.localName,
                                                                id: e.id,
                                                                onTap: () {
                                                                  if (selectedSubcategories
                                                                      .where((test) =>
                                                                          test.id ==
                                                                          e.id)
                                                                      .isEmpty) {
                                                                    selectedSubcategories
                                                                        .add(e);
                                                                  } else {
                                                                    selectedSubcategories.removeWhere(
                                                                        (test) =>
                                                                            test.id ==
                                                                            e.id);
                                                                  }
                                                                  setState(
                                                                      () {});
                                                                });
                                                          })
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ]);
                                        })
                                      ] else
                                        Wrap(
                                          runSpacing: 10,
                                          runAlignment:
                                              WrapAlignment.spaceBetween,
                                          spacing: 15,
                                          children: [
                                            if (widget.filterController
                                                    .categoryType ==
                                                0) ...[
                                              ...widget.filterController
                                                  .categoriesTotal!
                                                  .map(
                                                (e) {
                                                  return SelectableTextButton(
                                                      selected:
                                                          selectedCategories
                                                              .where((test) =>
                                                                  test.id ==
                                                                  e.id)
                                                              .isNotEmpty,
                                                      text: e.name,
                                                      id: e.id,
                                                      onTap: () {
                                                        if (selectedCategories
                                                            .where((test) =>
                                                                test.id == e.id)
                                                            .isEmpty) {
                                                          selectedCategories
                                                              .add(e);
                                                        } else {
                                                          selectedCategories
                                                              .removeWhere(
                                                                  (test) =>
                                                                      test.id ==
                                                                      e.id);
                                                        }
                                                        setState(() {});
                                                      });
                                                },
                                              ),
                                            ] else ...[
                                              ...widget.filterController
                                                  .subCategoriesTotal!
                                                  .map(
                                                (e) {
                                                  return SelectableTextButton(
                                                      selected:
                                                          selectedSubcategories
                                                              .where((test) =>
                                                                  test.id ==
                                                                  e.id)
                                                              .isNotEmpty,
                                                      text: e.localName,
                                                      id: e.id,
                                                      onTap: () {
                                                        if (selectedSubcategories
                                                            .where((test) =>
                                                                test.id == e.id)
                                                            .isEmpty) {
                                                          selectedSubcategories
                                                              .add(e);
                                                        } else {
                                                          selectedSubcategories
                                                              .removeWhere(
                                                                  (test) =>
                                                                      test.id ==
                                                                      e.id);
                                                        }
                                                        setState(() {});
                                                      });
                                                },
                                              ),
                                            ]
                                          ],
                                        )
                                    ],
                                  ),
                                )
                              ]),
                          const SizedBox(height: 100)
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        ...sortCategories.map((category) {
                          return RadioListTile<String>(
                            title: Text(category.name),
                            value: category.id, // Unique ID for this category
                            groupValue: selectedCategory, // Current selection
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value!; // Update selected ID
                              });
                            },
                          );
                        }),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: WideButton(
                title: Text(t(context).confirmSmall),
                onTap: () async {
                  widget.filterController.startTime.value = startTime;
                  widget.filterController.endTime.value = endTime;
                  widget.filterController.startPrice.value = startPrice;
                  widget.filterController.endPrice.value = endPrice;
                  widget.filterController.requiredRating.value = requiredRating;
                  widget.filterController.categoriesSelected.clear();
                  widget.filterController.categoriesSelected
                      .addAll(selectedCategories);
                  widget.filterController.subcategoriesSelected.clear();
                  widget.filterController.subcategoriesSelected
                      .addAll(selectedSubcategories);
                  if (selectedCategory == 'distance') {
                    Position? pos = await getCurrentLocation(context);
                    if (pos == null) {
                      selectedCategory = "";
                    }
                  }
                  widget.filterController.selectedSortCategory.value =
                      selectedCategory;
                  widget.filterController.selectedProviders.clear();
                  widget.filterController.selectedProviders
                      .addAll(selectedProviders);
                  if (context.mounted) {
                    context.pop();
                  }
                },
              ))
        ]),
      ),
    );
  }

  Future<bool> _showCancelDialog(
    BuildContext context,
  ) async {
    return await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(16)),
          width: getScreenWidth(ctx) * 0.5,
          height: getScreenWidth(ctx) * 0.5,
          child: Column(
            children: [
              const SizedBox(
                height: 32,
              ),
              Text(
                t(context).resetFiltering,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            ctx.pop(false);
                          },
                          child: Container(
                            height: 32,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(16))),
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
                            ctx.pop(true);
                          },
                          child: Container(
                            height: 32,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16))),
                            child: Center(
                                child: Text(
                              t(context).confirm,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: successColor),
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
  }
}

class SelectableTextButton extends StatelessWidget {
  const SelectableTextButton(
      {super.key,
      required this.selected,
      required this.text,
      required this.id,
      required this.onTap});
  final bool selected;
  final String text;
  final int id;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(24),
      color: selected
          ? primaryColor.withAlpha(100)
          : getBlackWhite(context).inverse.withAlpha(100),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: (getScreenWidth(context) - 32) / 2,
          height: 32,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Center(child: Text(text)),
          ),
        ),
      ),
    );
  }
}

class SortCategory {
  final String id;
  final String name;

  SortCategory(this.id, this.name);
}

Future<Position?> getCurrentLocation(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;
  if (!context.mounted) return null;
  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t(context).locationServiceBlockedPleaseActivate)),
    );
    return null;
  }

  // Check permission status
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t(context).allowLocationServices)),
      );
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(t(context).locationServicesDisallowedPleaseActivate)),
    );
    return null;
  }

  // Get the current location
  return await Geolocator.getCurrentPosition();
}
