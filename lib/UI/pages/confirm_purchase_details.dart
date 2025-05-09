import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/data_from_id.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/state/auth_controller.dart';

class ConfirmPurchaseDetailsPage extends StatelessWidget {
  const ConfirmPurchaseDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find<AuthController>();

    return Scaffold(
      appBar: IAppBar(
        title: t(context).toBuy,
        hasBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 96,
                ),
                SizedBox(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t(context).phoneNumber),
                      Container(
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(4)),
                          height: 40,
                          width: getScreenWidth(context) * 0.8,
                          child: Row(
                            textDirection: TextDirection.ltr,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Text('+')),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, right: 4, top: 0, bottom: 0),
                                child: TextFormField(
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  enabled: false,
                                  initialValue: auth.currentUser.value!.mobile,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                  ),
                                  textDirection: TextDirection.ltr,
                                  validator: (value) => null,
                                ),
                              )),
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 0,
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t(context).country),
                      Container(
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(4)),
                          width: getScreenWidth(context) * 0.8,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              enabled: false,
                              initialValue: getCountryFromId(
                                      auth.currentUser.value!.countryId)!
                                  .name,
                              style: Theme.of(context).textTheme.bodyLarge,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                isCollapsed: true,
                                border: InputBorder.none,
                              ),
                              textDirection: TextDirection.rtl,
                              validator: (value) => null,
                            ),
                          )),
                    ],
                  ),
                ),
                if (getCityFromId(auth.currentUser.value!.cityId) != null) ...[
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t(context).city),
                        Container(
                            decoration: BoxDecoration(
                                color: backgroundColor,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(4)),
                            width: getScreenWidth(context) * 0.8,
                            child: TextFormField(
                              enabled: false,
                              initialValue:
                                  getCityFromId(auth.currentUser.value!.cityId)!
                                      .name,
                              style: Theme.of(context).textTheme.bodyLarge,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                isCollapsed: true,
                                isDense: true,
                                border: InputBorder.none,
                              ),
                              textDirection: TextDirection.rtl,
                              validator: (value) => null,
                            )),
                      ],
                    ),
                  ),
                ],
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  child: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(4)),
                          height: 40,
                          width: getScreenWidth(context) * 0.8,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, right: 4, top: 4, bottom: 0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: t(context).address,
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  textDirection: TextDirection.rtl,
                                  validator: (value) => null,
                                ),
                              )),
                            ],
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 48),
                  child: Row(
                    children: [
                      Text(t(context).card,
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ),
                SizedBox(
                  child: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(4)),
                          width: getScreenWidth(context) * 0.8,
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: t(context).cardName,
                                  contentPadding: EdgeInsets.zero,
                                  isCollapsed: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                textDirection: TextDirection.rtl,
                                validator: (value) => null,
                              )),
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  child: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(4)),
                          width: getScreenWidth(context) * 0.8,
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CreditCardNumberInputFormatter()
                                ],
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                textDirection: TextDirection.ltr,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  icon: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: RetryImage(
                                      imageUrl:
                                          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/800px-Mastercard-logo.svg.png',
                                      height: 30,
                                      width: 34,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  hintText: t(context).cardNumber,
                                ),
                                onChanged: (value) {},
                              )),
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: getScreenWidth(context) * 0.8,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: backgroundColor,
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(4)),
                                width: getScreenWidth(context) * 0.4,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      keyboardType: TextInputType.datetime,
                                      inputFormatters: [
                                        CreditCardExpirationDateFormatter()
                                      ],
                                      decoration: InputDecoration(
                                        hintText: t(context).expirationDate,
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                      ),
                                      validator: (value) => null,
                                    )),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: backgroundColor,
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(4)),
                                width: getScreenWidth(context) * 0.4,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        CreditCardCvcInputFormatter()
                                      ],
                                      decoration: const InputDecoration(
                                          hintText: 'CVV',
                                          border: InputBorder.none,
                                          isDense: true,
                                          isCollapsed: true,
                                          contentPadding: EdgeInsets.zero),
                                      validator: (value) => null,
                                    )),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WideButton(
                      title: Text(t(context).payment,
                          style: Theme.of(context).textTheme.titleLarge),
                      onTap: () {}),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class CardNumberFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue previousValue,
//     TextEditingValue nextValue,
//   ) {
//     var inputText = nextValue.text;

//     if (nextValue.selection.baseOffset == 0) {
//       return nextValue;
//     }

//     var bufferString = StringBuffer();
//     for (int i = 0; i < inputText.length; i++) {
//       bufferString.write(inputText[i]);
//       var nonZeroIndexValue = i + 1;
//       if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
//         bufferString.write(' ');
//       }
//     }

//     var string = bufferString.toString();
//     return nextValue.copyWith(
//       text: string,
//       selection: TextSelection.collapsed(
//         offset: string.length,
//       ),
//     );
//   }
// }
