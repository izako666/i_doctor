import 'package:flutter/material.dart';

const textColor = Color(0xFF050315);
const backgroundColor = Color.fromARGB(255, 231, 231, 231);
const primaryColor = Color(0xFF95f087);
const primaryFgColor = Color(0xFF050315);
const secondaryColor = Color(0xFFfcdec4);
const secondaryFgColor = Color(0xFF050315);
const accentColor = Color(0xFF208228);
const accentFgColor = Color(0xFFfbfbfe);
const black = Color(0xFF000000);
const white = Color(0xFFFFFFFF);

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
