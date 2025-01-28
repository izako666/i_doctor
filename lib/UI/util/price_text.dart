import 'package:flutter/material.dart';

class PriceText extends StatelessWidget {
  const PriceText(
      {super.key,
      required this.price,
      required this.discount,
      this.align,
      this.style});
  final double price;
  final double discount;
  final TextAlign? align;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    if (discount == 0) {
      return Text(' ${(price).toString()} ر.س',
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
            text: ' ${(price - discount).toString()} ر.س',
            style: style ?? Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      textAlign: align,
      textDirection: TextDirection.rtl, // Force RTL for proper layout
    );
  }
}
