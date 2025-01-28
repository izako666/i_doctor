import 'package:flutter/material.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/api/data_classes/message.dart';
import 'package:i_doctor/fake_data.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/portable_api/ui/image_worker.dart';
import 'package:photo_manager/photo_manager.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IAppBar(
        title: 'دردشة خدمة العملاء',
        hasBackButton: true,
      ),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: messages.length + 1,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (ctx, i) {
                if (i == 0) {
                  return const SizedBox(height: 100);
                }
                Message message = messages[messages.length - (i)];
                return Align(
                  alignment: message.isCustomerService
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: message.isCustomerService ? 0 : 8,
                        right: message.isCustomerService ? 8 : 0,
                        top: 8,
                        bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            constraints: BoxConstraints.loose(
                                Size.fromWidth(getScreenWidth(context) * 0.5)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: message.isCustomerService
                                  ? Colors.blue.lighten(0.2)
                                  : primaryColor,
                              border: Border.all(
                                  color: (message.isCustomerService
                                          ? Colors.blue
                                          : primaryColor)
                                      .darken(0.2)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                message.text,
                                maxLines: 1000,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, left: 8, right: 8),
                          child: Text(
                              '${formatDate(message.date)}  ${formatTime(message.date)}',
                              style: Theme.of(context).textTheme.bodySmall),
                        )
                      ],
                    ),
                  ),
                );
              }),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: getScreenWidth(context),
                  decoration: BoxDecoration(
                    color: secondaryColor.darken(0.6),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                  ),
                  height: 64,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const RotatedBox(
                            quarterTurns: 2, child: Icon(Icons.send_rounded)),
                        onPressed: () {},
                      ),
                      Expanded(
                          child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                            color: secondaryColor.lighten(0),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 4, right: 4, top: 4, bottom: 0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            validator: (value) => null,
                          ),
                        ),
                      )),
                      IconButton(
                        icon: const Icon(Icons.add_photo_alternate_sharp),
                        onPressed: () async {
                          final PermissionState ps = await PhotoManager
                              .requestPermissionExtend(); // the method can use optional param `permission`.
                          if ((ps.isAuth || ps.hasAccess) && context.mounted) {
                            imageLcPickerBottomSheet(context,
                                onImageTap: (album, image) => {},
                                onSendTap: (a, i) {});
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('مطلوب إذن الصورة')));
                            }
                          }
                        },
                      )
                    ],
                  )))
        ],
      ),
    );
  }
}
