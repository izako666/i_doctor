import 'package:flutter/material.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/fake_data.dart';
import 'package:i_doctor/portable_api/helper.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    super.key,
  });
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IAppBar(
        title: 'إشعارات (12)',
        hasBackButton: true,
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: Container(
              width: getScreenWidth(ctx),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: notifications[i].seen
                          ? [Colors.grey, Colors.grey.lighten(0.2)]
                          : [primaryColor, primaryColor.lighten(0.2)],
                      stops: const [0.0, 0.7]),
                  border: Border(
                      bottom: notifications[i].seen
                          ? BorderSide.none
                          : const BorderSide())),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: getScreenWidth(context) * 0.7,
                          child: Text(
                            notifications[i].message,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Icon(Icons.align_vertical_bottom),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                        '${formatDate(notifications[i].date)}  ${formatTime(notifications[i].date)}'),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: reviews.length,
      ),
    );
  }
}
