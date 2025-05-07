import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/portable_api/helper.dart';

Future<bool> showCartFavoriteDialog(BuildContext context, bool cart) async {
  double zoomScale = getZoomScale(context);
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
            Center(
              child: Text(
                cart
                    ? t(context).mustLoginToUseCart
                    : t(context).mustLoginToFavorite,
                style: zoomScale > 2.8
                    ? Theme.of(ctx).textTheme.titleSmall
                    : Theme.of(ctx).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
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
                            t(context).loginFull,
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
