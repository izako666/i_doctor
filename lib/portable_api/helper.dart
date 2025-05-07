import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/api/data_classes/product.dart';
import 'package:i_doctor/state/auth_controller.dart';
import 'package:i_doctor/state/language_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:http/http.dart' as http;
import 'package:phonecodes/phonecodes.dart';
import 'package:retry/retry.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;
import 'package:i_doctor/api/data_classes/id_mappers.dart' as id_mappers;

extension ColorUtils on Color {
  // Method to darken a color
  Color darken([double amount = 0.1]) {
    // assert(amount >= 0 && amount <= 1);
    // final hsl = HSLColor.fromColor(this);
    // final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    // return hslDark.toColor();
    return this;
  }

  // Method to lighten a color
  Color lighten([double amount = 0.1]) {
    // assert(amount >= 0 && amount <= 1);
    // final hsl = HSLColor.fromColor(this);
    // final hslLight =
    //     hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    // return hslLight.toColor();
    return this;
  }

  Color get inverse {
    return Color.fromARGB(
      alpha, // Preserve alpha value
      255 - red, // Invert red component
      255 - green, // Invert green component
      255 - blue, // Invert blue component
    );
  }
}

double getScreenWidth(BuildContext ctx) {
  return MediaQuery.of(ctx).size.width;
}

double getScreenHeight(BuildContext ctx) {
  return MediaQuery.of(ctx).size.height;
}

String formatDate(DateTime dateTime) {
  // Use a localized date format
  return DateFormat.yMd(Get.find<LanguageController>().locale.value)
      .format(dateTime);
}

String formatTime(DateTime dateTime) {
  // Use a localized time format
  return DateFormat.Hm(Get.find<LanguageController>().locale.value)
      .format(dateTime); // 24-hour format
  // For 12-hour format with AM/PM, use: DateFormat.jm().format(dateTime)
}

String formatCatName(String input) {
  return input
      .replaceAll('_', ' ')
      .split(' ')
      .map((word) => word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : '')
      .join(' ');
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpinKitThreeBounce(
      size: 25,
      color: primaryColor,
    );
  }
}

AppLocalizations t(BuildContext ctx) => AppLocalizations.of(ctx)!;

String formatPrice(double price, id_mappers.Currency currency) {
  String formattedPrice = NumberFormat.currency(
    locale: Get.find<LanguageController>().locale.value,
    symbol: currency.localName,
  ).format(price);

  // Ensure there is a space between symbol and number
  return formattedPrice.replaceFirstMapped(RegExp(r'(\D+)(\d)'), (match) {
    return '${match.group(1)} ${match.group(2)}';
  });
}

Map<String, String> languageFlags = {
  'en': '🇺🇸',
  'en_GB': '🇬🇧',
  'ar': '🇸🇦',
  'fr': '🇫🇷',
  'de': '🇩🇪',
  'es': '🇪🇸',
  'it': '🇮🇹',
  'ru': '🇷🇺',
  'zh': '🇨🇳',
  'zh_TW': '🇹🇼',
  'ja': '🇯🇵',
  'ko': '🇰🇷',
  'pt': '🇵🇹',
  'pt_BR': '🇧🇷',
  'nl': '🇳🇱',
  'tr': '🇹🇷',
  'hi': '🇮🇳',
  'bn': '🇧🇩',
  'ur': '🇵🇰',
  'fa': '🇮🇷',
  'he': '🇮🇱',
  'th': '🇹🇭',
  'id': '🇮🇩',
  'ms': '🇲🇾',
  'vi': '🇻🇳',
  'pl': '🇵🇱',
  'sv': '🇸🇪',
  'fi': '🇫🇮',
  'no': '🇳🇴',
  'da': '🇩🇰',
  'el': '🇬🇷',
  'hu': '🇭🇺',
  'cs': '🇨🇿',
  'ro': '🇷🇴',
  'sk': '🇸🇰',
  'bg': '🇧🇬',
  'uk': '🇺🇦',
  'sr': '🇷🇸',
  'hr': '🇭🇷',
  'lt': '🇱🇹',
  'lv': '🇱🇻',
  'et': '🇪🇪',
  'sl': '🇸🇮',
  'is': '🇮🇸',
  'mt': '🇲🇹',
  'ga': '🇮🇪',
  'af': '🇿🇦',
  'sw': '🇰🇪',
  'fil': '🇵🇭',
  'mn': '🇲🇳',
};

Future<Position?> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  // Check permission status
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return null;
  }

  // Get the current location
  return await Geolocator.getCurrentPosition();
}

Future<String?> getCountryFromCoordinates(Position position) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  return placemarks.first.isoCountryCode ?? "";
}

Future<String?> getUserCountry() async {
  Position? position = await getCurrentLocation();
  if (position == null) return null;
  return await getCountryFromCoordinates(position);
}

Alignment getTextDirectionLocal(BuildContext context) {
  return Directionality.of(context) == ui.TextDirection.ltr
      ? Alignment.centerLeft
      : Alignment.centerRight;
}

String countryNameToEmoji(List<String> countryNames) {
  int i = 0;
  while (i < countryNames.length) {
    try {
      Country c = Countries.findByName(countryNames[i]);
      return c.flag;
    } catch (e) {
      i++;
    }
  }

  // If not found, return a default flag or handle accordingly
  return '🏳️'; // Default flag
}

Future<void> shareProduct(Product prod, String hostUrlBase) async {
  String photoUrl = '$hostUrlBase/public/storage/${prod.photo}';

  try {
    final response = await http.get(Uri.parse(photoUrl));
    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;

      // Try to get the MIME type from the response headers
      String? mimeType = response.headers['content-type'];

      // If unavailable, infer from file extension
      mimeType ??= _inferMimeType(photoUrl);

      final xFile = XFile.fromData(
        bytes,
        mimeType: mimeType,
        name: p.basename(photoUrl),
      );

      SharePlus.instance.share(
        ShareParams(
          title: prod.localName,
          text: "${prod.localDesc}\nhttp://fakeappurl.com",
          files: [xFile],
        ),
      );
    } else {
      print('Failed to download image: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sharing product: $e');
  }
}

// Helper to infer mime type from extension
String _inferMimeType(String url) {
  final ext = p.extension(url).toLowerCase();
  switch (ext) {
    case '.jpg':
    case '.jpeg':
      return 'image/jpeg';
    case '.png':
      return 'image/png';
    case '.gif':
      return 'image/gif';
    case '.webp':
      return 'image/webp';
    default:
      return 'application/octet-stream'; // generic fallback
  }
}

double getZoomScale(BuildContext context) {
  final logicalSize = MediaQuery.of(context).size;
  final physicalSize = View.of(context).physicalSize;
  final dpr = MediaQuery.of(context).devicePixelRatio;

  final calculatedZoom = physicalSize.width / logicalSize.width;
  return calculatedZoom;
}

class RetryImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const RetryImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: const LoadingIndicator(),
      ),
      errorWidget: (context, url, error) {
        // Log connection errors, optionally retry via other logic
        debugPrint("Image load failed: $error");

        return Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
        );
      },
      // Optionally handle headers, timeouts, etc. via custom HttpClient (advanced use case)
    );
  }
}
