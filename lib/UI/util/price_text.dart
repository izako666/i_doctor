import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/state/language_controller.dart';

class PriceText extends StatelessWidget {
  const PriceText(
      {super.key,
      required this.price,
      required this.discount,
      this.align,
      this.style,
      required this.currency});
  final double price;
  final double discount;
  final TextAlign? align;
  final TextStyle? style;
  final Currency currency;
  @override
  Widget build(BuildContext context) {
    if (discount == 0) {
      return Text(formatPrice(price, currency),
          style: style ?? Theme.of(context).textTheme.bodyMedium);
    }
    return Text.rich(
      TextSpan(
        text: price.toString(),
        style: style != null
            ? style!.copyWith(decoration: TextDecoration.lineThrough)
            : Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(decoration: TextDecoration.lineThrough),
        children: [
          TextSpan(
            text: formatPrice(price - discount, currency),
            style: style ?? Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      textAlign: align,
    );
  }
}

class PriceText2 extends StatelessWidget {
  const PriceText2(
      {super.key,
      required this.price,
      required this.spPrice,
      required this.currency,
      this.align,
      this.style,
      this.smallStyle});
  final double price;
  final double spPrice;
  final TextAlign? align;
  final TextStyle? style;
  final TextStyle? smallStyle;
  final Currency currency;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: spPrice.toString(),
        style: smallStyle != null
            ? smallStyle!.copyWith(decoration: TextDecoration.lineThrough)
            : Theme.of(context).textTheme.bodySmall!.copyWith(
                decoration: TextDecoration.lineThrough, color: Colors.grey),
        children: [
          TextSpan(
            text: formatPrice(price, currency),
            style: style ?? Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      textAlign: align,
    );
  }
}
