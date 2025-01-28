// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:i_doctor/UI/app_theme.dart';
// import 'package:i_doctor/fake_data.dart';
// import 'package:i_doctor/portable_api/helper.dart';
// import 'package:i_doctor/state/auth_controller.dart';

// class CitySelectDialog extends StatefulWidget {
//   const CitySelectDialog({
//     super.key,
//     required this.auth,
//   });

//   final AuthController auth;

//   @override
//   State<CitySelectDialog> createState() => _CitySelectDialogState();
// }

// class _CitySelectDialogState extends State<CitySelectDialog> {
//   String selectedCity = '';

//   @override
//   void initState() {
//     super.initState();
//     selectedCity = widget.auth.cityName.value.isEmpty
//         ? cities[0]
//         : widget.auth.cityName.value;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         ...cities.map((city) {
//           return InkWell(
//             onTap: () {
//               selectedCity = city;
//               setState(() {});
//             },
//             child: Container(
//               padding: const EdgeInsets.only(top: 8.0),
//               width: 1000,
//               decoration: BoxDecoration(
//                   color: selectedCity == city ? primaryColor : null,
//                   border: const Border(bottom: BorderSide())),
//               child: Center(child: Text(city)),
//             ),
//           );
//         }),
//         Row(
//           children: [
//             Expanded(
//                 child: InkWell(
//                     onTap: () {
//                       context.pop();
//                     },
//                     child: Container(
//                       height: 32,
//                       decoration: BoxDecoration(
//                           color: Colors.red.lighten(0.1),
//                           borderRadius: const BorderRadius.only(
//                               bottomRight: Radius.circular(16))),
//                       child: const Center(child: Text('ابطال')),
//                     ))),
//             Expanded(
//                 child: InkWell(
//                     onTap: () {
//                       widget.auth.cityName.value = selectedCity;
//                       context.pop();
//                     },
//                     child: Container(
//                       height: 32,
//                       decoration: BoxDecoration(
//                           color: Colors.green.lighten(0.1),
//                           borderRadius: const BorderRadius.only(
//                               bottomLeft: Radius.circular(16))),
//                       child: const Center(child: Text('التاكيد')),
//                     )))
//           ],
//         )
//       ],
//     );
//   }
// }
