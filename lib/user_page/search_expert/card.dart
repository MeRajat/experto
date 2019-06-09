import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../expert_detail/expert_detail.dart';

class CustomCard extends StatelessWidget {
  final DocumentSnapshot expert;
  CustomCard({@required this.expert});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return ExpertDetail(expert);
              },
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5, bottom: 12, top: 5),
          child: Row(
            children: <Widget>[
              Hero(
                tag:expert["emailID"],
                child: Icon(
                  CupertinoIcons.person_solid,
                  size: 80,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top:10,left: 10,bottom: 5),
                width: 230,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        expert["Name"],
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontWeight: FontWeight.bold),
                        textScaleFactor: .85,
                      ),
                    ),
                    Text(
                      expert['Description'],
                      style: Theme.of(context)
                          .primaryTextTheme
                          .body2
                          .copyWith(fontSize: 12),
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
