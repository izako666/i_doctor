import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/portable_api/helper.dart';

class CancelAppointmentDialog extends StatelessWidget {
  const CancelAppointmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 32),
        Text(t(context).areYouSureWithDecision,
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
                child: InkWell(
                    onTap: () {
                      context.pop(false);
                    },
                    child: Container(
                      height: 64,
                      decoration: const BoxDecoration(
                          color: errorColor,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(16))),
                      child: Center(child: Text(t(context).cancel)),
                    ))),
            Expanded(
                child: InkWell(
                    onTap: () {
                      context.pop(true);
                    },
                    child: Container(
                      height: 64,
                      decoration: const BoxDecoration(
                          color: successColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16))),
                      child: Center(child: Text(t(context).confirm)),
                    )))
          ],
        )
      ],
    );
  }
}
