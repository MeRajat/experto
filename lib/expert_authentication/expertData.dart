import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

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
        "Available": true,
        "Availability Mode": "normal",
      };
}

var currentExpert;
