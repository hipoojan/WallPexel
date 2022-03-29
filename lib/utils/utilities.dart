import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

final SystemUiOverlayStyle OVERLAY_STYLE = SystemUiOverlayStyle(
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarColor: Color(0xff0044e5),
  statusBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.light,
);

final ThemeData THEME = ThemeData(
  brightness: Brightness.light,
  backgroundColor: Colors.white,
  primaryColor: Color(0xff0044e5),
  floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Color(0xff0044e5)),
  scaffoldBackgroundColor: Colors.white,
  canvasColor: Colors.black.withOpacity(0.5),
  indicatorColor: Colors.blueGrey,
  iconTheme: IconThemeData(color: Colors.black),
  appBarTheme: AppBarTheme(backgroundColor: Colors.white, elevation: 0, titleSpacing: 0, systemOverlayStyle: OVERLAY_STYLE),
  textTheme: TextTheme(
    bodyText1: GoogleFonts.inter(color: Colors.black),
    bodyText2: GoogleFonts.inter(color: Colors.black.withOpacity(0.3)),
  ),
);

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
