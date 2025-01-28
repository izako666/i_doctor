import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:i_doctor/api/data_classes/product.dart';

class Clinic {
  final String id;
  final String name;
  final Position location;
  final Placemark address;
  final List<String> subcategories;
  final List<Product> products;
  final String logoUrl;
  final String imageUrl;

  Clinic(
      {required this.id,
      required this.name,
      required this.location,
      required this.address,
      required this.subcategories,
      required this.products,
      required this.logoUrl,
      required this.imageUrl});
}
