import 'package:geolocator/geolocator.dart';

class Appointment {
  final String serviceName;
  final String clinicName;
  final int serviceCode;
  //should be a difference of hours, same day
  final DateTime startTime;
  final DateTime endTime;
  final bool completed;
  final Position location;
  final double price;
  final double discount;
  const Appointment(
      {required this.serviceName,
      required this.clinicName,
      required this.serviceCode,
      required this.startTime,
      required this.endTime,
      required this.location,
      required this.completed,
      required this.price,
      required this.discount});
}
