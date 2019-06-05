import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetSkills {
  List<String> skillName;
  List<DocumentReference> skillReference;
  List<Widget> children;

  GetSkills() {
    this.skillName = [];
    this.skillReference = [];
    this.children = [];
  }

  void getSkills() async {
    await Firestore.instance
        .collection("Skills")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      for (int i = 0; i < snapshot.documents.length; i++) {
        skillName.add(snapshot.documents[i]['Name']);
        skillReference.add(snapshot.documents[i].reference);
      }
    });
  }

  List<Widget> getSkillAsWidget(BuildContext context) {
    children = [];
    skillName.forEach((String name) {
      children.add(
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            name,
            style: Theme.of(context).primaryTextTheme.body2.copyWith(
                  fontSize: 18,
                ),
          ),
        ),
      );
    });
    return children;
  }
}
