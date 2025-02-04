import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/commerce_controller.dart';

class ConfirmPurchaseDetailsPage extends StatelessWidget {
  const ConfirmPurchaseDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find<AuthController>();
    CommerceController commerceController = Get.find<CommerceController>();
    List<City>? filteredCities = auth.cities;
    if (auth.cities != null) {
      filteredCities = auth.cities!
          .where((city) => city.countryId == auth.currentUser.value!.countryId)
          .toList();
    }

    return Scaffold(
      appBar: const IAppBar(
        title: 'الشراء',
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
                      const Text("رقم التليفون"),
                      Container(
                          decoration: BoxDecoration(
                              color: backgroundColor.lighten(0.05),
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
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("البلد"),
                      Container(
                          decoration: BoxDecoration(
                              color: backgroundColor.lighten(0.05),
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(4)),
                          height: 40,
                          width: getScreenWidth(context) * 0.8,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              enabled: false,
                              initialValue: auth.currentUser.value!.countryId,
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
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("المدينة"),
                      Container(
                          decoration: BoxDecoration(
                              color: backgroundColor.lighten(0.05),
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(4)),
                          height: 40,
                          width: getScreenWidth(context) * 0.8,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              enabled: false,
                              initialValue: auth.currentUser.value!.cityId,
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
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 60,
                  child: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: backgroundColor.lighten(0.05),
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
                                  decoration: const InputDecoration(
                                    hintText: 'العنوان',
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
                      Text('الكرت',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: backgroundColor.lighten(0.05),
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
                                  decoration: const InputDecoration(
                                    hintText: 'الاسم على الكرت',
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
                const SizedBox(height: 16),
                SizedBox(
                  height: 60,
                  child: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: backgroundColor.lighten(0.05),
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(4)),
                          height: 40,
                          width: getScreenWidth(context) * 0.8,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 4, top: 4, bottom: 0),
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
                                    isDense: true,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/800px-Mastercard-logo.svg.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                    hintText: 'رقم الكرت',
                                  ),
                                  onChanged: (value) {},
                                ),
                              )),
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: getScreenWidth(context) * 0.8,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: backgroundColor.lighten(0.05),
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(4)),
                                height: 40,
                                width: getScreenWidth(context) * 0.4,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, right: 4, top: 4, bottom: 0),
                                      child: TextFormField(
                                        keyboardType: TextInputType.datetime,
                                        inputFormatters: [
                                          CreditCardExpirationDateFormatter()
                                        ],
                                        decoration: const InputDecoration(
                                          hintText: 'تاريخ الانتهاء',
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                        validator: (value) => null,
                                      ),
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
                                    color: backgroundColor.lighten(0.05),
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(4)),
                                height: 40,
                                width: getScreenWidth(context) * 0.4,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, right: 4, top: 4, bottom: 0),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          CreditCardCvcInputFormatter()
                                        ],
                                        decoration: const InputDecoration(
                                          hintText: 'CVV',
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                        validator: (value) => null,
                                      ),
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
                      title: Text("الدفع",
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

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue previousValue,
    TextEditingValue nextValue,
  ) {
    var inputText = nextValue.text;

    if (nextValue.selection.baseOffset == 0) {
      return nextValue;
    }

    var bufferString = StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var string = bufferString.toString();
    return nextValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}
