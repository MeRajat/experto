import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:experto/utils/bloc/syncDocuments.dart';

class UserData {
  //static DocumentSnapshot currentUser;
  static FirebaseUser usr;
}

class UserDocumentSync extends StatefulWidget {
  final Widget child;
  final DocumentSnapshot user;

  UserDocumentSync(this.user, this.child);

  @override
  _UserDocumentSync createState() => _UserDocumentSync();

  static TrueInheritedWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(TrueInheritedWidget);
}

class _UserDocumentSync extends State<UserDocumentSync> {
  DocumentSnapshot user;

  @override
  void initState() {
    user = widget.user;
    syncDocument();
    super.initState();
  }

  void syncDocument() async {
    syncDocumentUser.getStatus.listen((newDocument) {
      setState(() {
        user = newDocument;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TrueInheritedWidget(user, widget.child);
  }
}

class TrueInheritedWidget extends InheritedWidget {
  final DocumentSnapshot user;

  TrueInheritedWidget(this.user, child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

class Users {
  final String name, email, city, m;
  int mobile;

  Users({
    @required this.name,
    @required this.email,
    @required this.city,
    @required this.m,
    this.mobile = 0,
  }) {
    mobile = int.parse(m);
  }

  Map<String, dynamic> toJson() => {
        'Name': name,
        'emailID': email,
        'City': city,
        'Mobile': mobile,
      };
}

var currentUser;
