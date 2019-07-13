import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

import "./home_page/home_page.dart";
import "./user_authentication/signup_page.dart";
import "./user_authentication/login_page.dart";
import "./user_page/user_home.dart" as user;
import "./expert_authentication/login_page.dart" as expertLogin;
import "./expert_authentication/signup_page.dart" as expertSignup;
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
//         "/user_home": (context) => user.HomePage(),
        "/user_login": (context) => LoginPage(),
        "/expert_login": (context) => expertLogin.LoginPage(),
        "/expert_signup": (context) => expertSignup.SignupPage(),
//        "/expert_home": (context) => expertHome.HomePage(),
        "/home_page": (context) => HomePage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/user_home') {
         return MaterialPageRoute(builder: (BuildContext context) {
            return user.HomePage(settings.arguments);
          });
         } else if (settings.name == '/expert_home') {
          return MaterialPageRoute(builder: (BuildContext context) {
            return expertHome.HomePage(settings.arguments);
          });
        }
      },
      darkTheme: theme.lightTheme(),
      theme: theme.lightTheme(),
      home: Splash(),
    );
  }
}
