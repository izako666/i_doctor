import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getRepo;
import 'package:go_router/go_router.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/pages/main_pages/feed_page.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/api/data_classes/id_mappers.dart';
import 'package:i_doctor/api/networking/rest_functions.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool loadingSignUpButton = false;
  @override
  Widget build(BuildContext context) {
    return getRepo.Obx(() {
      AuthController auth = getRepo.Get.find<AuthController>();
      List<City>? filteredCities = auth.cities;
      if (auth.cities != null && auth.countryId.value != -1) {
        filteredCities = auth.cities!
            .where((city) => city.countryId == auth.countryId.value)
            .toList();
      }
      return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          auth.sPasswordError.value = '';
          auth.rePasswordError.value = '';
          auth.sPhoneError.value = '';
          auth.firstNameError.value = '';
          auth.lastNameError.value = '';
          auth.countryId.value = -1;
          auth.cityId.value = -1;
          auth.genderId.value = -1;
          auth.sEmailError = ''.obs;
          auth.dateOfBirth.value = '';
          auth.dateOfBirthError.value = '';
          auth.dateOfBirthDate = DateTime(2020);
          auth.sNationalityError.value = '';
          auth.showSPassword.value = false;
          auth.showRePassword.value = false;
          auth.countryError.value = '';
          auth.cityError.value = '';
          auth.sPasswordController.text = '';
          auth.rePasswordController.text = '';
          auth.sPhoneController.text = '';
          auth.firstNameController.text = '';
          auth.lastNameController.text = '';
          auth.sEmailController.text = '';
          auth.sNationalityController.text = '';
          auth.genderError.value = '';
          auth.nationalityId.value = -1;
        },
        child: Scaffold(
          appBar: IAppBar(
            title: t(context).createNewAccount,
            hasBackButton: true,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Center(
                  child: getRepo.Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          height: 32,
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
                                            color: backgroundColor,
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        height: 40,
                                        width: getScreenWidth(context) * 0.4,
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4,
                                                  right: 4,
                                                  top: 4,
                                                  bottom: 0),
                                              child: TextFormField(
                                                controller:
                                                    auth.firstNameController,
                                                decoration: InputDecoration(
                                                  hintText: t(context).name,
                                                  border: InputBorder.none,
                                                  isDense: true,
                                                ),
                                                validator: (value) => null,
                                              ),
                                            )),
                                          ],
                                        )),
                                    if (auth.firstNameError.value.isNotEmpty)
                                      SizedBox(
                                        width: getScreenWidth(context) * 0.4,
                                        child: Text(
                                          textAlign: TextAlign.start,
                                          auth.firstNameError.value,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: errorColor),
                                        ),
                                      ),
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
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        height: 40,
                                        width: getScreenWidth(context) * 0.4,
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4,
                                                  right: 4,
                                                  top: 4,
                                                  bottom: 0),
                                              child: TextFormField(
                                                controller:
                                                    auth.lastNameController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      t(context).familyName,
                                                  border: InputBorder.none,
                                                  isDense: true,
                                                ),
                                                validator: (value) => null,
                                              ),
                                            )),
                                          ],
                                        )),
                                    if (auth.lastNameError.value.isNotEmpty)
                                      SizedBox(
                                        width: getScreenWidth(context) * 0.4,
                                        child: Text(
                                          textAlign: TextAlign.start,
                                          auth.lastNameError.value,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: errorColor),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 60,
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
                                    textDirection: TextDirection.ltr,
                                    children: [
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4,
                                            right: 4,
                                            top: 4,
                                            bottom: 0),
                                        child: TextFormField(
                                          controller: auth.sEmailController,
                                          decoration: InputDecoration(
                                            hintText: t(context).email,
                                            border: InputBorder.none,
                                            isDense: true,
                                          ),
                                          validator: (value) => null,
                                        ),
                                      )),
                                    ],
                                  )),
                              if (auth.sEmailError.value.isNotEmpty)
                                SizedBox(
                                  width: getScreenWidth(context) * 0.8,
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    auth.sEmailError.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: errorColor),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 60,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDialog<Widget>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: SizedBox(
                                            width:
                                                getScreenWidth(context) * 0.8,
                                            height:
                                                getScreenHeight(context) * 0.6,
                                            child: SfDateRangePicker(
                                              view: DateRangePickerView.decade,
                                              confirmText:
                                                  t(context).confirmSmall,
                                              cancelText: t(context).cancel,
                                              showActionButtons: true,
                                              // onSelectionChanged: (args) {
                                              //   auth.dateOfBirthDate =
                                              //       (args.value as DateTime);
                                              //   auth.dateOfBirth.value =
                                              //       "${auth.dateOfBirthDate.year}-${auth.dateOfBirthDate.month.toString().padLeft(2, '0')}-${auth.dateOfBirthDate.day.toString().padLeft(2, '0')}";
                                              // },
                                              onSubmit: (val) {
                                                if (val is DateTime) {
                                                  auth.dateOfBirthDate = val;
                                                  auth.dateOfBirth.value =
                                                      "${auth.dateOfBirthDate.year}-${auth.dateOfBirthDate.month.toString().padLeft(2, '0')}-${auth.dateOfBirthDate.day.toString().padLeft(2, '0')}";
                                                }
                                                context.pop();
                                              },
                                              onCancel: () {
                                                context.pop();
                                              },
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: backgroundColor,
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(4)),
                                    height: 40,
                                    width: getScreenWidth(context) * 0.8,
                                    child: Row(
                                      textDirection: TextDirection.ltr,
                                      children: [
                                        getRepo.Obx(
                                          () => Expanded(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4,
                                                          right: 4,
                                                          top: 4,
                                                          bottom: 0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          t(context).birthdate),
                                                      Text(auth
                                                          .dateOfBirth.value)
                                                    ],
                                                  ))),
                                        ),
                                      ],
                                    )),
                              ),
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
                                      color: backgroundColor,
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(4)),
                                  height: 40,
                                  width: getScreenWidth(context) * 0.8,
                                  child: Row(
                                    textDirection: TextDirection.ltr,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Text('+')),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4,
                                            right: 4,
                                            top: 4,
                                            bottom: 0),
                                        child: TextFormField(
                                          controller: auth.sPhoneController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: t(context).phoneNumber,
                                            border: InputBorder.none,
                                          ),
                                          textDirection: TextDirection.ltr,
                                          validator: (value) => null,
                                        ),
                                      )),
                                    ],
                                  )),
                              if (auth.sPhoneError.value.isNotEmpty)
                                SizedBox(
                                  width: getScreenWidth(context) * 0.8,
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    auth.sPhoneError.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: errorColor),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t(context).nationality),
                              getRepo.Obx(
                                () => DropdownButton2<int>(
                                  value: auth.nationalityId.value == -1
                                      ? null
                                      : auth.nationalityId.value,
                                  underline: const SizedBox(),
                                  hint: Text(t(context).selectNationality),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: getScreenHeight(context) * 0.3,
                                  ),
                                  buttonStyleData: ButtonStyleData(
                                      height: 40,
                                      width: getScreenWidth(context) * 0.8,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: backgroundColor,
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(4))),
                                  items: auth.nationalities!
                                      .map((Nationality nationality) {
                                    return DropdownMenuItem<int>(
                                      value: nationality.id,
                                      child: Text(nationality.localName),
                                    );
                                  }).toList(),
                                  onChanged: (int? nationalityId) {
                                    auth.nationalityId.value =
                                        nationalityId ?? -1;
                                  },
                                ),
                              ),
                              if (auth.sNationalityError.value.isNotEmpty)
                                SizedBox(
                                  width: getScreenWidth(context) * 0.8,
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    auth.sNationalityError.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: errorColor),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t(context).country),
                              getRepo.Obx(
                                () => DropdownButton2<int>(
                                  value: auth.countryId.value == -1
                                      ? null
                                      : auth.countryId.value,
                                  underline: const SizedBox(),
                                  hint: Text(t(context).selectCountry),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: getScreenHeight(context) * 0.3,
                                  ),
                                  buttonStyleData: ButtonStyleData(
                                      height: 40,
                                      width: getScreenWidth(context) * 0.8,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: backgroundColor,
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(4))),
                                  items: auth.countries!.map((Country country) {
                                    return DropdownMenuItem<int>(
                                      value: country.id,
                                      child: Text(country.name),
                                    );
                                  }).toList(),
                                  onChanged: (int? selectedCountry) {
                                    auth.countryId.value =
                                        selectedCountry ?? -1;
                                    auth.cityId.value = -1;
                                  },
                                ),
                              ),
                              if (auth.countryError.value.isNotEmpty)
                                SizedBox(
                                  width: getScreenWidth(context) * 0.8,
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    auth.countryError.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: errorColor),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (auth.countryId.value != -1) ...[
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t(context).city),
                                getRepo.Obx(
                                  () => DropdownButton2<int>(
                                    value: auth.cityId.value == -1
                                        ? null
                                        : auth.cityId.value,
                                    hint: Text(t(context).selectCity),
                                    underline: const SizedBox(),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: getScreenHeight(context) * 0.3,
                                    ),
                                    buttonStyleData: ButtonStyleData(
                                        height: 40,
                                        width: getScreenWidth(context) * 0.8,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: backgroundColor,
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(4))),
                                    items: filteredCities!.map((City city) {
                                      return DropdownMenuItem<int>(
                                        value: city.id,
                                        child: Text(city.name),
                                      );
                                    }).toList(),
                                    onChanged: (int? selectedCity) {
                                      auth.cityId.value = selectedCity ?? -1;
                                    },
                                  ),
                                ),
                                if (auth.cityError.value.isNotEmpty)
                                  SizedBox(
                                    width: getScreenWidth(context) * 0.8,
                                    child: Text(
                                      textAlign: TextAlign.start,
                                      auth.cityError.value,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: errorColor),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t(context).gender),
                              getRepo.Obx(
                                () => DropdownButton2<int>(
                                  value: auth.genderId.value == -1
                                      ? null
                                      : auth.genderId.value,
                                  hint: Text(t(context).selectGender),
                                  underline: const SizedBox(),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: getScreenHeight(context) * 0.3,
                                  ),
                                  buttonStyleData: ButtonStyleData(
                                      height: 40,
                                      width: getScreenWidth(context) * 0.8,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: backgroundColor,
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(4))),
                                  items: auth.genders!.map((Gender gender) {
                                    return DropdownMenuItem<int>(
                                      value: gender.id,
                                      child: Text(gender.localName),
                                    );
                                  }).toList(),
                                  onChanged: (int? selectedGender) {
                                    auth.genderId.value = selectedGender ?? -1;
                                  },
                                ),
                              ),
                              if (auth.genderError.value.isNotEmpty)
                                SizedBox(
                                  width: getScreenWidth(context) * 0.8,
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    auth.genderError.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: errorColor),
                                  ),
                                ),
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
                                      color: backgroundColor,
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(4)),
                                  height: 40,
                                  width: getScreenWidth(context) * 0.8,
                                  child: Row(
                                    textDirection: TextDirection.ltr,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            auth.showSPassword.value =
                                                !auth.showSPassword.value;
                                          },
                                          icon: Icon(
                                            auth.showSPassword.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            size: 24,
                                          )),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4,
                                            right: 4,
                                            top: 4,
                                            bottom: 0),
                                        child: TextFormField(
                                          controller: auth.sPasswordController,
                                          obscureText:
                                              !auth.showSPassword.value,
                                          decoration: InputDecoration(
                                            hintText: t(context).password,
                                            border: InputBorder.none,
                                            isDense: true,
                                          ),
                                          textDirection: TextDirection.ltr,
                                          validator: (value) => null,
                                        ),
                                      )),
                                    ],
                                  )),
                              if (auth.sPasswordError.value.isNotEmpty)
                                SizedBox(
                                  width: getScreenWidth(context) * 0.8,
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    auth.sPasswordError.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: errorColor),
                                  ),
                                ),
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
                                      color: backgroundColor,
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(4)),
                                  height: 40,
                                  width: getScreenWidth(context) * 0.8,
                                  child: Row(
                                    textDirection: TextDirection.ltr,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            auth.showRePassword.value =
                                                !auth.showRePassword.value;
                                          },
                                          icon: Icon(
                                            auth.showRePassword.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            size: 24,
                                          )),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4,
                                            right: 4,
                                            top: 4,
                                            bottom: 0),
                                        child: TextFormField(
                                          controller: auth.rePasswordController,
                                          obscureText:
                                              !auth.showRePassword.value,
                                          decoration: InputDecoration(
                                            hintText: t(context).repeatPassword,
                                            border: InputBorder.none,
                                            isDense: true,
                                          ),
                                          textDirection: TextDirection.ltr,
                                          validator: (value) => null,
                                        ),
                                      )),
                                    ],
                                  )),
                              if (auth.rePasswordError.value.isNotEmpty)
                                SizedBox(
                                  width: getScreenWidth(context) * 0.8,
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    auth.rePasswordError.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: errorColor),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 128),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WideButton(
                      title: Text(t(context).signup,
                          style: Theme.of(context).textTheme.titleLarge),
                      disabled: loadingSignUpButton,
                      onTap: () async {
                        loadingSignUpButton = true;
                        setState(() {});
                        bool isValid = auth.validateSignup(context);

                        if (isValid) {
                          Response resp = await register({
                            'CustArbName':
                                '${auth.firstNameController.text} ${auth.lastNameController.text}',
                            'email': auth.sEmailController.text,
                            'password': auth.sPasswordController.text,
                            'NationalityID': auth.nationalityId.value,
                            'Mobile': auth.sPhoneController.text,
                            'CountryID': auth.countryId.value,
                            'CityID': auth.cityId.value,
                            'Gender': auth.genderId.value,
                            'DOB': auth.dateOfBirth.value,
                            'CustEngName': 'NULL',
                          });
                          if (resp.statusCode == 200) {
                            loadingSignUpButton = false;
                            setState(() {});
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(t(context).success)));
                            }

                            Future.delayed(const Duration(seconds: 2), () {
                              if (context.mounted) {
                                context.pop();
                              }
                            });
                          } else if (resp.statusCode == 404 &&
                              resp.data['data']['email'] != null) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: errorColor,
                                      content: Text(t(context).emailUsed)));
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: errorColor,
                                      content: Text(t(context).errorOccured)));
                            }
                          }
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
