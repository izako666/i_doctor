import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

// https://stackoverflow.com/questions/47046637/open-google-maps-app-if-available-with-flutter
// for integration with ios, consult the url above, additionally the url above is to credit the original author of the openMap code

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&zoom=15';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<List<double>?> getCoordinates(String address) async {
    try {
      // Fetch latitude and longitude from address
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;
        return [latitude, longitude];
      } else {
        print('No results found.');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}
