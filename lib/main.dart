import 'package:experto/video_call/init.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

import "./home_page/home_page.dart";
import "./user_authentication/signup_page.dart";
import "./user_authentication/login_page.dart";
import "./user_page/home_page.dart" as user;
import "./expert_authentication/login.dart" as expertLogin;
import "./expert_authentication/signup.dart" as expertSignup;
import './expert_page/expert_home.dart' as expertHome;

import './theme.dart';
import 'Splash.dart';

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
        "/expert_signup": (context) => expertSignup.SignupPage(),
        "/expert_home" : (context) => expertHome.HomePage(),
        "/home_page":(context)=>HomePage(),
        "/video_call":(context)=>StartVideo(),
      },
      //darkTheme: theme.darkTheme(),
      theme: theme.lightTheme(),
      home: Splash(),
    );
  }
}
