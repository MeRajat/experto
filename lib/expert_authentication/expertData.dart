import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:experto/utils/bloc/syncDocuments.dart';

class ExpertData {
  DocumentSnapshot detailsData;
  FirebaseUser profileData;
}

class ExpertDocumentSync extends StatefulWidget {
  final Widget child;
  final ExpertData expert;

  ExpertDocumentSync(this.expert, this.child);

  @override
  _ExpertDocumentSync createState() => _ExpertDocumentSync();

  static TrueInheritedWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(TrueInheritedWidget);
}

class _ExpertDocumentSync extends State<ExpertDocumentSync> {
  ExpertData expert;

  @override
  void initState() {
    expert = widget.expert;
    syncDocument();
    super.initState();
  }

  void syncDocument() async {
    syncDocumentUser.getStatus.listen((newDocument) {
      setState(() {
        expert = newDocument;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TrueInheritedWidget(user, widget.child);
  }
}

class TrueInheritedWidget extends InheritedWidget {
  final ExpertData expert;

  TrueInheritedWidget(this.expert, child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

class Experts {
  final String name,
      email,
      city,
      m,
      userId,
      skype,
      index,
      description,
      workExperience;
  final List<DocumentReference> skills;
  bool status;
  int mobile;

  Experts({
    @required this.name,
    @required this.email,
    @required this.city,
    @required this.m,
    @required this.userId,
    @required this.skype,
    @required this.status,
    @required this.index,
    this.mobile = 0,
    @required this.description,
    @required this.workExperience,
    @required this.skills,
  }) {
    mobile = int.parse(m);
  }

  Map<String, dynamic> toJson() => {
        'Name': name,
        'emailID': email,
        'userID': userId,
        'SkypeUser': skype,
        'City': city,
        'Mobile': mobile,
        'Status': status,
        'Index': index,
        "Description": description,
        "Work Experience": workExperience,
        "Skills": skills,
        "Availablity": {
          'slot1': {"start": null, "end": null}
        },
        "Available":true,
        "Availability Mode":"normal",
      };
}

var currentExpert;
