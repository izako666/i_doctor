import 'package:flutter/material.dart';

const textColor = Color(0xFF000000);
const backgroundColor = Color(0xFFFBFBFE);
const primaryColor = Color(0xFF87CEEB);
const primaryFgColor = Color(0xFF1E3A8A);
const secondaryColor = Color(0xFFFFB6C1);
const secondaryFgColor = Color(0xFF4A2040);
const accentColor = Color(0xFFD8BFD8);
const accentFgColor = Color(0xFF3B1F47);
const black = Color(0xFF000000);
const white = Color(0xFFFFFFFF);
const errorColor = Color(0xFFFF6961);
const successColor = Color(0xFF81C784);

const colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primaryColor,
  onPrimary: primaryFgColor,
  secondary: secondaryColor,
  onSecondary: secondaryFgColor,
  tertiary: accentColor,
  onTertiary: accentFgColor,
  surface: backgroundColor,
  onSurface: textColor,
  error: Brightness.light == Brightness.light
      ? Color(0xffB3261E)
      : Color(0xffF2B8B5),
  onError: Brightness.light == Brightness.light
      ? Color(0xffFFFFFF)
      : Color(0xff601410),
);

Color getBlackWhite(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light ? black : white;
}
