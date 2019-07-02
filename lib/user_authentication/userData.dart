import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:experto/global_data.dart';

class TrueInheritedWidget extends InheritedWidget {
  final Data user;

  TrueInheritedWidget(this.user, child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

class Users {
  final String name, city, m,docID;
  int mobile;

  Users({
    @required this.name,
//    @required this.email,
    @required this.city,
    @required this.m,
    this.docID,
    this.mobile = 0,
  }) {
    mobile = int.parse(m);
  }

  Map<String, dynamic> toJson() => {
        'Name': name,
       // 'emailID': email,
        'City': city,
        'Mobile': mobile,
    'docID':docID,
      };
}

var currentUser;
