import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_ui/helpers/colors.dart';

ThemeData themeData(BuildContext context) {
  return ThemeData(
      appBarTheme: AppBarTheme(
        color: kPrimaryColor,
      ),
      primaryColor: kPrimaryColor,
      brightness: Brightness.light,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          headline1: GoogleFonts.poppins(
              color: kPrimaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal),
          bodyText1: GoogleFonts.bubblegumSans(
            color: Colors.deepPurple,
          )),
      buttonTheme: ButtonThemeData(
          buttonColor: Colors.indigoAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))));
}
