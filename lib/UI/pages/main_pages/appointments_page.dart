import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/cancel_app_dialog.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/UI/util/leave_review_dialog.dart';
import 'package:i_doctor/UI/util/price_text.dart';
import 'package:i_doctor/api/data_classes/appointment.dart';
import 'package:i_doctor/api/data_classes/basket_item.dart';
import 'package:i_doctor/fake_data.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/maps/map_utils.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/realm_controller.dart';
import 'package:realm/realm.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  int pageIndex = 0;
  late List<Appointment> currentAppointments;
  late List<Appointment> pastAppointments;

  @override
  void initState() {
    super.initState();
    currentAppointments = [];
    pastAppointments = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IAppBar(
        title: 'مواعيد',
        toolbarHeight: kToolbarHeight,
        hasBackButton: false,
      ),
      body: Get.find<AuthController>().currentUser.value == null
          ? Center(
              child: Text(
                'يرجى تسجيل الدخول أولا',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            )
          : CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    width: getScreenWidth(context),
                    height: 64,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: pageIndex == 0
                                      ? const BorderSide(
                                          color: primaryColor, width: 2)
                                      : BorderSide.none),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  pageIndex = 0;
                                  setState(() {});
                                },
                                child: Column(
                                  children: [
                                    Icon(Icons.event,
                                        color: pageIndex == 0
                                            ? primaryColor
                                            : Colors.grey),
                                    const Text("المواعيد الحالية")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: pageIndex == 1
                                        ? const BorderSide(
                                            color: primaryColor, width: 2)
                                        : BorderSide.none)),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  pageIndex = 1;
                                  setState(() {});
                                },
                                child: Column(
                                  children: [
                                    Icon(Icons.event_available,
                                        color: pageIndex == 1
                                            ? primaryColor
                                            : Colors.grey),
                                    const Text("المواعيد السابقة")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if (pageIndex == 0)
                  SliverList.builder(
                    itemBuilder: (ctx, i) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4),
                      child:
                          AppointmentCard(appointment: currentAppointments[i]),
                    ),
                    itemCount: currentAppointments.length,
                  ),
                if (pageIndex == 1)
                  SliverList.builder(
                    itemBuilder: (ctx, i) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4),
                      child: AppointmentCard(appointment: pastAppointments[i]),
                    ),
                    itemCount: pastAppointments.length,
                  )
              ],
            ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key, required this.appointment, this.type = 0});
  final Appointment appointment;
  //type 0 for in appointments list, type 1 for in basket, type 2 for in confirm basket
  final int type;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: getScreenWidth(context),
        decoration: BoxDecoration(
            border: Border(
                top: const BorderSide(),
                right: const BorderSide(),
                left: const BorderSide(),
                bottom: type == 2 ? const BorderSide() : BorderSide.none),
            borderRadius: BorderRadius.circular(16),
            color: backgroundColor.lighten(0.05)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(appointment.serviceName),
                  Text(appointment.serviceCode.toString())
                ],
              ),
            ),
            if (type < 2)
              Divider(
                indent: 8,
                endIndent: 8,
                color: secondaryColor.darken(0.5),
              ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 8, vertical: type == 2 ? 0 : 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(appointment.clinicName),
                  IconButton(
                    onPressed: () => MapUtils.openMap(
                        appointment.location.latitude,
                        appointment.location.longitude),
                    icon: const Icon(
                      Icons.location_pin,
                    ),
                  )
                ],
              ),
            ),
            Divider(
              indent: 8,
              endIndent: 8,
              color: secondaryColor.darken(0.5),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDate(appointment.startTime)),
                  Text(
                      ' ${formatTime(appointment.startTime)} - ${formatTime(appointment.endTime)}')
                ],
              ),
            ),
            if (type < 2)
              Divider(
                indent: 8,
                endIndent: 8,
                color: secondaryColor.darken(0.5),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('السعر'),
                  PriceText(
                      price: appointment.price, discount: appointment.discount)
                ],
              ),
            ),
            if (type < 2)
              const Divider(
                indent: 8,
                endIndent: 8,
              ),
            if (type < 2) const SizedBox(height: 8),
            if (type < 2)
              WideButton(
                  radius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                  title: type == 1
                      ? const Text('حذف')
                      : appointment.completed
                          ? const Text('ترك التعليق')
                          : const Text('ابطال'),
                  color: type == 1 || (!appointment.completed)
                      ? Colors.red.lighten(0.2)
                      : null,
                  onTap: () {
                    if (appointment.completed) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: primaryColor.lighten(),
                          contentPadding: EdgeInsets.zero,
                          content: LeaveReviewDialog(
                            appointment: appointment,
                          ),
                        ),
                        barrierDismissible: true,
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: primaryColor.lighten(),
                          contentPadding: EdgeInsets.zero,
                          content: const CancelAppointmentDialog(),
                        ),
                        barrierDismissible: true,
                      );
                    }
                  })
          ],
        ),
      ),
    );
  }
}

class BasketCard extends StatelessWidget {
  const BasketCard(
      {super.key,
      required this.basketItem,
      required this.onDelete,
      required this.isDisplay});
  final BasketItem basketItem;
  final VoidCallback onDelete;
  final bool isDisplay;

  @override
  Widget build(BuildContext context) {
    RealmController realmController = Get.find<RealmController>();
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: getScreenWidth(context),
        decoration: BoxDecoration(
            border: Border(
                top: const BorderSide(),
                right: const BorderSide(),
                left: const BorderSide(),
                bottom: isDisplay ? const BorderSide() : BorderSide.none),
            borderRadius: BorderRadius.circular(16),
            color: backgroundColor.lighten(0.05)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(basketItem.name),
                  Row(
                    children: [
                      if (!isDisplay)
                        IconButton(
                            onPressed: () {
                              int newQuantity = basketItem.quantity - 1;
                              if (newQuantity == 0) {
                              } else {
                                realmController.updateQuantity(
                                    basketItem, newQuantity);
                                onDelete();
                              }
                            },
                            icon: const Icon(
                              Icons.remove,
                              fill: 1,
                            )),
                      Text(basketItem.quantity.toString()),
                      if (!isDisplay)
                        IconButton(
                            onPressed: () {
                              if (basketItem.availablePurchases <=
                                  (basketItem.quantity + 1)) return;
                              realmController.updateQuantity(
                                  basketItem, basketItem.quantity + 1);
                              onDelete();
                            },
                            icon: const Icon(
                              Icons.add,
                              fill: 1.0,
                            ))
                    ],
                  )
                ],
              ),
            ),
            Divider(
              indent: 8,
              endIndent: 8,
              color: secondaryColor.darken(0.5),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(basketItem.spId),
                  IconButton(
                    onPressed: () {},
                    // onPressed: () => MapUtils.openMap(
                    //     appointment.location.latitude,
                    //     appointment.location.longitude),
                    icon: const Icon(
                      Icons.location_pin,
                    ),
                  )
                ],
              ),
            ),
            Divider(
              indent: 8,
              endIndent: 8,
              color: secondaryColor.darken(0.5),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      ' ${formatDate(DateTime.parse(basketItem.startDate))} - ${formatDate(DateTime.parse(basketItem.endDate))}')
                ],
              ),
            ),
            Divider(
              indent: 8,
              endIndent: 8,
              color: secondaryColor.darken(0.5),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('السعر'),
                  PriceText(
                      price: double.parse(basketItem.idocPrice),
                      discount: double.parse(basketItem.idocDiscountAmt))
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (!isDisplay) ...[
              const Divider(
                indent: 8,
                endIndent: 8,
              ),
              WideButton(
                  radius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                  title: const Text('حذف'),
                  color: Colors.red.lighten(0.2),
                  onTap: () {
                    _showCancelDialog(context, realmController);
                  })
            ]
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(
      BuildContext context, RealmController realmController) {
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
                style: Theme.of(ctx).textTheme.headlineSmall,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            ctx.pop();
                          },
                          child: Container(
                            height: 32,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(16))),
                            child: Center(
                                child: Text(
                              'ابطال',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.red.lighten(0.1)),
                            )),
                          ))),
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            realmController.deleteItem(basketItem);
                            onDelete();
                            ctx.pop();
                          },
                          child: Container(
                            height: 32,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16))),
                            child: Center(
                                child: Text(
                              'التاكيد',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.green.lighten(0.1)),
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
