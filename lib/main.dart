import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

import "./home_page/home_page.dart";
import "./user_authentication/signup_page.dart";
import "./user_authentication/login_page.dart";
import "./user_page/home_page.dart" as user;
import "./expert_authentication/login.dart" as expertLogin;
import "./expert_authentication/signup.dart" as expertSignup;

import './theme.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/user_signup": (context) => SignupPage(),
        "/user_home": (context) => user.HomePage(),
        "/user_login": (context) => LoginPage(),
        "/expert_login": (context) => expertLogin.LoginPage(),
        "/expert_signup": (context) => expertSignup.SignupPage()
      },
      //darkTheme: theme.darkTheme(),
      theme: theme.darkTheme(),
      home: HomePage(),
    );
  }
}
