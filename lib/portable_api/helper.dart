import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/state/language_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

String formatPrice(double price) {
  String formattedPrice = NumberFormat.currency(
    locale: Get.find<LanguageController>().locale.value,
    symbol: Get.find<LanguageController>().locale.value == "en" ? "SAR" : "ر.س",
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
