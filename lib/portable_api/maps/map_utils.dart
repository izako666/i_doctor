import 'package:url_launcher/url_launcher.dart';

// https://stackoverflow.com/questions/47046637/open-google-maps-app-if-available-with-flutter
// for integration with ios, consult the url above, additionally the url above is to credit the original author of the openMap code

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }
}
