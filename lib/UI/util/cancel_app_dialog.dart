import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/portable_api/helper.dart';

class CancelAppointmentDialog extends StatelessWidget {
  const CancelAppointmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 32),
        Text("هل انت واثق بقرارك؟",
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
                child: InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                          color: Colors.red.lighten(0.1),
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(16))),
                      child: const Center(child: Text('ابطال')),
                    ))),
            Expanded(
                child: InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                          color: Colors.green.lighten(0.1),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16))),
                      child: const Center(child: Text('التاكيد')),
                    )))
          ],
        )
      ],
    );
  }
}
