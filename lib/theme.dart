import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Theme {
  ThemeData lightTheme() {
    return ThemeData(
      primaryColor: Color(0xFFF2F4ED),
      canvasColor: Color.fromRGBO(250, 250, 250, 1),
      scaffoldBackgroundColor: Color.fromRGBO(243, 242, 244, 1),
      bottomAppBarColor: Colors.transparent,
      errorColor: Colors.red,
      buttonColor: Colors.blue,
      brightness: Brightness.light,
      fontFamily: 'Ubuntu',
      accentColor: Colors.blue,
      primaryTextTheme: TextTheme(
        title: TextStyle(
          wordSpacing: 1,
        ),
        subtitle: TextStyle(
          wordSpacing: 1,
        ),
        subhead: TextStyle(
          wordSpacing: 1,
        ),
        body1: TextStyle(
          wordSpacing: 1,
        ),
        body2: TextStyle(
          wordSpacing: 1,
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
      buttonTheme: ButtonThemeData(
        height: 45,
        disabledColor: Color.fromRGBO(243, 242, 244, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      appBarTheme: AppBarTheme(
        color: Color.fromRGBO(234, 234, 234, .93),
      ),
      cardTheme: CardTheme(
        margin: EdgeInsets.only(
          right: 15,
          left: 15,
          top: 10,
        ),
        color: Color.fromRGBO(240, 240, 240, 1),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Color.fromRGBO(250, 250, 250, 1),
        errorStyle: TextStyle(fontWeight: FontWeight.w700),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.none,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            style: BorderStyle.none,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            style: BorderStyle.none,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            style: BorderStyle.none,
          ),
        ),
        contentPadding: EdgeInsets.all(13),
      ),
      textTheme: TextTheme(
        title: TextStyle(
          wordSpacing: 1,
          fontWeight: FontWeight.w700,
        ),
        subhead: TextStyle(
          wordSpacing: 1,
          fontWeight: FontWeight.w600,
          letterSpacing: -1.4,
        ),
      ),
    );
  }

  ThemeData darkTheme() {
    Color textColor = Color.fromRGBO(236, 236, 236, 1);
    return ThemeData(
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      canvasColor: Color.fromRGBO(50, 50, 50, 1),
      scaffoldBackgroundColor: Color.fromRGBO(28, 28, 28, 1),
      buttonColor: Colors.blue[800],
      errorColor: Colors.red[800],
      bottomAppBarColor: Color(0xFFfcfffe),
      dialogTheme: DialogTheme(
        backgroundColor: Color.fromRGBO(45, 45, 45, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
      primaryTextTheme: TextTheme(
        title: TextStyle(
          color: textColor,
          wordSpacing: 1,
        ),
        subtitle: TextStyle(
          color: textColor,
          wordSpacing: 1,
        ),
        subhead: TextStyle(
          color: textColor,
          wordSpacing: 1,
        ),
        body1: TextStyle(
          color: textColor,
          wordSpacing: 1,
        ),
        body2: TextStyle(
          color: textColor,
          wordSpacing: 1,
        ),
      ),
      fontFamily: 'Ubuntu',
      buttonTheme: ButtonThemeData(
        height: 45,
        disabledColor: Color.fromRGBO(28, 28, 28, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            title: TextStyle(
              color: textColor,
            ),
          ),
          color: Color.fromRGBO(
              20, 20, 20, .93) //Color.fromRGBO(234, 234, 234, .93),
          ),
      cardTheme: CardTheme(
        margin: EdgeInsets.only(
          right: 15,
          left: 15,
          top: 10,
        ),
        color: Color.fromRGBO(42, 42, 42, 1),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Color.fromRGBO(50, 50, 50, 1),
        errorStyle: TextStyle(fontWeight: FontWeight.w700),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.none,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            style: BorderStyle.none,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            style: BorderStyle.none,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            style: BorderStyle.none,
          ),
        ),
        contentPadding: EdgeInsets.all(13),
      ),
      textTheme: TextTheme(
        title: TextStyle(
          wordSpacing: 1,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
        subhead: TextStyle(
          wordSpacing: 1,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: -1.4,
        ),
      ),
    );
  }
}

final Theme theme = Theme();
