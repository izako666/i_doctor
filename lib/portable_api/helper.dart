import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:intl/intl.dart';

extension ColorUtils on Color {
  // Method to darken a color
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  // Method to lighten a color
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
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
  return DateFormat.yMd('ar').format(dateTime);
}

String formatTime(DateTime dateTime) {
  // Use a localized time format
  return DateFormat.Hm('ar').format(dateTime); // 24-hour format
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
