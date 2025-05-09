import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/cancel_app_dialog.dart';
import 'package:i_doctor/UI/util/data_from_id.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/UI/util/leave_review_dialog.dart';
import 'package:i_doctor/UI/util/price_text.dart';
import 'package:i_doctor/api/data_classes/appointment.dart';
import 'package:i_doctor/api/data_classes/basket_item.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/networking/rest_functions.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/maps/map_utils.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/commerce_controller.dart';
import 'package:i_doctor/state/realm_controller.dart';

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
        appBar: IAppBar(
          title: t(context).appointments,
          toolbarHeight: kToolbarHeight,
          hasBackButton: false,
        ),
        body: Obx(() {
          return Get.find<AuthController>().currentUser.value == null
              ? Center(
                  child: Text(
                    t(context).pleaseLoginFirst,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                )
              : Center(
                  child: Text(
                    t(context).comingSoon,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                );
          // : CustomScrollView(
          //     slivers: [
          //       const SliverToBoxAdapter(
          //         child: SizedBox(height: 16),
          //       ),
          //       SliverToBoxAdapter(
          //         child: SizedBox(
          //           width: getScreenWidth(context),
          //           height: 64,
          //           child: Row(
          //             mainAxisSize: MainAxisSize.max,
          //             children: [
          //               Expanded(
          //                 child: Container(
          //                   decoration: BoxDecoration(
          //                     border: Border(
          //                         bottom: pageIndex == 0
          //                             ? const BorderSide(
          //                                 color: primaryColor, width: 2)
          //                             : BorderSide.none),
          //                   ),
          //                   child: Material(
          //                     color: Colors.transparent,
          //                     child: InkWell(
          //                       onTap: () {
          //                         pageIndex = 0;
          //                         setState(() {});
          //                       },
          //                       child: Column(
          //                         children: [
          //                           Icon(Icons.event,
          //                               color: pageIndex == 0
          //                                   ? primaryColor
          //                                   : Colors.grey),
          //                           Text(t(context).currentAppointments)
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               Expanded(
          //                 child: Container(
          //                   decoration: BoxDecoration(
          //                       border: Border(
          //                           bottom: pageIndex == 1
          //                               ? const BorderSide(
          //                                   color: primaryColor, width: 2)
          //                               : BorderSide.none)),
          //                   child: Material(
          //                     color: Colors.transparent,
          //                     child: InkWell(
          //                       onTap: () {
          //                         pageIndex = 1;
          //                         setState(() {});
          //                       },
          //                       child: Column(
          //                         children: [
          //                           Icon(Icons.event_available,
          //                               color: pageIndex == 1
          //                                   ? primaryColor
          //                                   : Colors.grey),
          //                           Text(t(context).oldAppointments)
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //       if (pageIndex == 0)
          //         SliverList.builder(
          //           itemBuilder: (ctx, i) => Padding(
          //             padding: const EdgeInsets.symmetric(
          //                 vertical: 8.0, horizontal: 4),
          //             child: AppointmentCard(
          //                 appointment: currentAppointments[i]),
          //           ),
          //           itemCount: currentAppointments.length,
          //         ),
          //       if (pageIndex == 1)
          //         SliverList.builder(
          //           itemBuilder: (ctx, i) => Padding(
          //             padding: const EdgeInsets.symmetric(
          //                 vertical: 8.0, horizontal: 4),
          //             child:
          //                 AppointmentCard(appointment: pastAppointments[i]),
          //           ),
          //           itemCount: pastAppointments.length,
          //         )
          //     ],
          //   );
        }));
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
            color: backgroundColor),
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
              const Divider(
                indent: 8,
                endIndent: 8,
                color: secondaryColor,
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
            const Divider(
              indent: 8,
              endIndent: 8,
              color: secondaryColor,
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
              const Divider(
                indent: 8,
                endIndent: 8,
                color: secondaryColor,
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t(context).priceWord),
                  PriceText(
                    price: appointment.price,
                    discount: appointment.discount,
                    currency: Currency(id: 0, name1: "SAR", name2: "س.ر."),
                  )
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
                      ? Text(t(context).delete)
                      : appointment.completed
                          ? Text(t(context).leaveReview)
                          : Text(t(context).cancel),
                  color:
                      type == 1 || (!appointment.completed) ? errorColor : null,
                  onTap: () {
                    if (appointment.completed) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: backgroundColor,
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
                        builder: (ctx) => const AlertDialog(
                          backgroundColor: backgroundColor,
                          contentPadding: EdgeInsets.zero,
                          content: CancelAppointmentDialog(),
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
            color: backgroundColor),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t(context).offer),
                      Text(Get.find<CommerceController>()
                              .products
                              .where((p) => p.id == basketItem.productId)
                              .firstOrNull
                              ?.localName ??
                          basketItem.name),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              indent: 8,
              endIndent: 8,
              color: secondaryColor,
            ),
            if (basketItem.spId != null &&
                getProviderFromId(basketItem.spId!) != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t(context).serviceProvider),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(getProviderFromId(basketItem.spId!)!.localName),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: IconButton(
                            iconSize: 12,
                            onPressed: () {
                              Provider? provider =
                                  getProviderFromId(basketItem.spId!);
                              if (provider != null) {
                                List<double> numbers = provider.location
                                    .split(',')
                                    .map((e) => double.parse(e))
                                    .toList();

                                MapUtils.openMap(numbers[0], numbers[1]);
                              }
                            },
                            // onPressed: () => MapUtils.openMap(
                            //     appointment.location.latitude,
                            //     appointment.location.longitude),
                            icon: const Icon(
                              Icons.location_pin,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            const Divider(
              indent: 8,
              endIndent: 8,
              color: secondaryColor,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t(context).date),
                  Text(
                      ' ${formatDate(DateTime.parse(basketItem.startDate))} - ${formatDate(DateTime.parse(basketItem.endDate))}')
                ],
              ),
            ),
            const Divider(
              indent: 8,
              endIndent: 8,
              color: secondaryColor,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t(context).priceWord),
                  PriceText(
                    price: double.parse(basketItem.idocPrice),
                    discount: double.parse(basketItem.idocDiscountAmt),
                    currency: getCurrencyFromId(basketItem.currency) ??
                        Currency(id: 0, name1: "SAR", name2: "س.ر."),
                  )
                ],
              ),
            ),
            const Divider(
              indent: 8,
              endIndent: 8,
              color: secondaryColor,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t(context).count),
                  Row(
                    children: [
                      if (!isDisplay)
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: IconButton(
                              iconSize: 16,
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
                        ),
                      Text(basketItem.quantity.toString()),
                      if (!isDisplay)
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: IconButton(
                              iconSize: 16,
                              onPressed: () {
                                if (basketItem.availablePurchases <=
                                    (basketItem.quantity + 1)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(t(context)
                                              .cantRequestMoreProduct)));

                                  return;
                                }
                                realmController.updateQuantity(
                                    basketItem, basketItem.quantity + 1);
                                onDelete();
                              },
                              icon: const Icon(
                                Icons.add,
                                fill: 1.0,
                              )),
                        )
                    ],
                  ),
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
                  title: Text(t(context).delete),
                  color: errorColor,
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
              color: secondaryColor, borderRadius: BorderRadius.circular(16)),
          width: getScreenWidth(ctx) * 0.5,
          height: getScreenWidth(ctx) * 0.5,
          child: Column(
            children: [
              const SizedBox(
                height: 32,
              ),
              Text(
                t(context).areYouSure,
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

class CartCard extends StatefulWidget {
  const CartCard({
    super.key,
    required this.basketItem,
    required this.onDelete,
    required this.isDisplay,
  });
  final BasketItem basketItem;
  final VoidCallback onDelete;
  final bool isDisplay;

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  Provider? provider;

  @override
  void initState() {
    super.initState();
    provider = getProviderFromId(widget.basketItem.spId ?? -1);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double zoomScale = getZoomScale(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedContainer(
          blackWhite: getBlackWhite(context),
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: EdgeInsets.zero,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: RetryImage(
                            width: getScreenWidth(context) * 0.3,
                            height: getScreenWidth(context) * 0.3,
                            fit: BoxFit.fill,
                            imageUrl:
                                '$hostUrlBase/public/storage/${widget.basketItem.photo}'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.only(left: 8.0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          onPressed: () {
                            String branch = GoRouter.of(context)
                                .routeInformationProvider
                                .value
                                .uri
                                .pathSegments[0];

                            context.push(
                                '/$branch/advert/${widget.basketItem.productId}');
                          },
                          child: Text(
                            Get.find<CommerceController>()
                                    .products
                                    .where((p) =>
                                        p.id == widget.basketItem.productId)
                                    .firstOrNull
                                    ?.localName ??
                                widget.basketItem.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: primaryColor),
                          )),
                      const SizedBox(height: 4),
                      if (widget.basketItem.spId != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(provider!.localName,
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                      const SizedBox(
                        height: 0,
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            if (provider != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            softWrap: true,
                            maxLines: 3,
                            '${Get.find<AuthController>().countries!.where((test) => test.id == provider!.countryId).first.name}, ${provider!.localShortAddress}',
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        List<double> numbers = provider!.location
                            .split(',')
                            .map((e) => double.parse(e))
                            .toList();

                        MapUtils.openMap(numbers[0], numbers[1]);
                      },
                      icon: const Icon(
                        Icons.location_pin,
                        color: secondaryColor,
                      ))
                ],
              ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t(context).date),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                      softWrap: true,
                      maxLines: 3,
                      '${formatDate(DateTime.parse(widget.basketItem.startDate))} - ${formatDate(DateTime.parse(widget.basketItem.endDate))}'),
                )
              ],
            ),
            const SizedBox(height: 2),
            Text(
              formatPrice(
                  double.parse(widget.basketItem.idocPrice),
                  getCurrencyFromId(widget.basketItem.currency) ??
                      Currency(id: 0, name1: "SAR", name2: "س.ر.")),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: primaryColor),
            ),
            if (!widget.isDisplay)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: zoomScale > 2.8 ? 36 : 42,
                          height: zoomScale > 2.8 ? 36 : 42,
                          child: IconButton(
                              iconSize: 28,
                              onPressed: () {
                                int newQuantity =
                                    widget.basketItem.quantity - 1;
                                if (newQuantity == 0) {
                                } else {
                                  RealmController realmController =
                                      Get.find<RealmController>();
                                  realmController.updateQuantity(
                                      widget.basketItem, newQuantity);
                                  widget.onDelete();
                                }
                              },
                              icon: const Icon(
                                Icons.remove,
                                fill: 1,
                              )),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: zoomScale > 2.8 ? 8.0 : 0),
                          child: Text(widget.basketItem.quantity.toString()),
                        ),
                        SizedBox(
                          width: zoomScale > 2.8 ? 36 : 42,
                          height: zoomScale > 2.8 ? 36 : 42,
                          child: IconButton(
                              iconSize: 28,
                              onPressed: () {
                                RealmController realmController =
                                    Get.find<RealmController>();
                                if (widget.basketItem.availablePurchases <=
                                    (widget.basketItem.quantity + 1)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(t(context)
                                              .cantRequestMoreProduct)));

                                  return;
                                }
                                realmController.updateQuantity(
                                    widget.basketItem,
                                    widget.basketItem.quantity + 1);
                                widget.onDelete();
                              },
                              icon: const Icon(
                                Icons.add,
                                fill: 1.0,
                              )),
                        )
                      ],
                    ),
                  ),
                  WideButton(
                      width: MediaQuery.of(context).size.width * 0.6,
                      borderColor: Colors.grey,
                      radius: BorderRadius.only(
                          bottomLeft:
                              !(Directionality.of(context) == TextDirection.rtl)
                                  ? const Radius.circular(0)
                                  : const Radius.circular(16),
                          topLeft:
                              !(Directionality.of(context) == TextDirection.rtl)
                                  ? const Radius.circular(0)
                                  : const Radius.circular(0),
                          bottomRight:
                              Directionality.of(context) == TextDirection.rtl
                                  ? const Radius.circular(0)
                                  : const Radius.circular(16),
                          topRight:
                              Directionality.of(context) == TextDirection.rtl
                                  ? const Radius.circular(0)
                                  : const Radius.circular(0)),
                      title: Text(
                        t(context).delete,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: errorColor),
                      ),
                      color: Colors.white,
                      onTap: () {
                        _showCancelDialog(context, Get.find<RealmController>());
                      }),
                ],
              ),
            if (widget.isDisplay)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t(context).count,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.basketItem.quantity.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ]),
              )
          ]),
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
              color: backgroundColor, borderRadius: BorderRadius.circular(16)),
          width: getScreenWidth(ctx) * 0.5,
          height: getScreenWidth(ctx) * 0.5,
          child: Column(
            children: [
              const SizedBox(
                height: 32,
              ),
              Text(
                t(context).areYouSure,
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
                            realmController.deleteItem(widget.basketItem);
                            widget.onDelete();
                            ctx.pop();
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
