import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './expert_list.dart';

class CustomCard extends StatelessWidget {
  final DocumentSnapshot skill;
  final Icon icon;
  CustomCard(this.skill, this.icon);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return ExpertList(skill:skill);
              },
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5, bottom: 12, top: 5),
          child: Row(
            children: <Widget>[
              icon,
              Container(
                padding: EdgeInsets.only(left: 5),
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        skill['Name'],
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 17,),
                      ),
                    ),
                    Text(
                      skill['tagLine'],
                      style: Theme.of(context)
                          .primaryTextTheme
                          .body2
                          .copyWith(fontSize:12),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
