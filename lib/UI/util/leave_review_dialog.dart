import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/api/data_classes/appointment.dart';
import 'package:i_doctor/portable_api/helper.dart';

class LeaveReviewDialog extends StatefulWidget {
  const LeaveReviewDialog({super.key, required this.appointment});
  final Appointment appointment;
  @override
  State<LeaveReviewDialog> createState() => _LeaveReviewDialogState();
}

class _LeaveReviewDialogState extends State<LeaveReviewDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.appointment.serviceName,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(
              width: 4,
            ),
            Text(widget.appointment.serviceCode.toString()),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Text(widget.appointment.clinicName),
        const Divider(),
        RatingBar.builder(
          itemSize: 30,
          initialRating: 3.5,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.zero,
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {},
        ),
        const SizedBox(
          height: 6,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: getScreenWidth(context) * 0.6,
            height: getScreenWidth(context) * 0.5,
            decoration: BoxDecoration(
              color: backgroundColor.lighten(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              maxLines: 10,
              controller: controller,
            ),
          ),
        ),
        WideButton(
            radius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16)),
            color: secondaryColor.darken(0.2),
            title: Text('ثبت', style: Theme.of(context).textTheme.titleLarge),
            onTap: () {
              context.pop();
            })
      ],
    );
  }
}
