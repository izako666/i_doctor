import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/api/data_classes/category.dart';
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
  String selectedCategory = 'distance';

  List<Category> selectedCategories = List.empty(growable: true);
  List<Subcategory> selectedSubcategories = List.empty(growable: true);

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
    requiredRating = widget.filterController.requiredRating.value;
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
      appBar: const IAppBar(
        title: 'فلتر و ترتيب',
        hasBackButton: false,
        toolbarHeight: kToolbarHeight * 2,
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
                                  const Text("فلتر")
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
                                  const Text("ترتيب")
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
                                    title: const Text('التاريخ'),
                                    subtitle: Text('اختر التاريخ الذي تريدو',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: secondaryColor
                                                    .darken(0.5))),
                                    children: <Widget>[
                                      SfDateRangePicker(
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
                          ElevatedContainer(
                              blackWhite: getBlackWhite(context),
                              children: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    title: const Text('التقييم'),
                                    subtitle: Text('اختر التقييم الذي تريدو',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: secondaryColor
                                                    .darken(0.5))),
                                    children: <Widget>[
                                      RatingBar.builder(
                                        itemSize: 26,
                                        initialRating: requiredRating,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.zero,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          requiredRating = rating;
                                          setState(() {});
                                        },
                                      ),
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
                                    title: const Text('السعر'),
                                    subtitle: Text('اختر السعر الذي تريدو',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: secondaryColor
                                                    .darken(0.5))),
                                    children: <Widget>[
                                      const SizedBox(height: 4),
                                      RangeSlider(
                                          min: 0.0,
                                          max: 2000.0,
                                          divisions: 20,
                                          labels: RangeLabels(
                                              '${startPrice.toStringAsFixed(2)} ر.س',
                                              '${endPrice.toStringAsFixed(2)} ر.س'),
                                          values:
                                              RangeValues(startPrice, endPrice),
                                          onChanged: (val) {
                                            startPrice = val.start;
                                            endPrice = val.end;
                                            setState(() {});
                                          }),
                                      const SizedBox(height: 4),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('0.0 ر.س'),
                                          Text('2000.0 ر.س'),
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
                                    title: const Text('الفئات الفرعية'),
                                    subtitle: Text(
                                        'اختر الفئات الفرعية الذي تريدها',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: secondaryColor
                                                    .darken(0.5))),
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
                                                                text: e.name,
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
                                                      text: e.name,
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
                        ...categories.map((category) {
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
                title: const Text('ثبت'),
                onTap: () {
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
                  context.pop();
                },
              ))
        ]),
      ),
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
