import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  //Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    primaryColor: primary,
    primaryColorDark: primaryDark,
    primaryColorLight: primaryLight,
    hoverColor: divider,
    highlightColor: primaryDark,
    colorScheme: const ColorScheme.light(primary: primary),
  );
}


class AppTextStyle {
  static const TextStyle headerTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textprimary,    
    fontFamily: "Sarabun",  
  );

  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textprimary,    
    fontFamily: "Sarabun",  
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: textprimary,    
    fontFamily: "Sarabun",  
  );

   static const TextStyle content = TextStyle(
    fontSize: 14,
    color: textprimary,    
    fontFamily: "Sarabun",  
  );



}