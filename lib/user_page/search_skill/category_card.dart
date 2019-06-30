import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import "package:cached_network_image/cached_network_image.dart";

import './expert_list.dart';

class CustomCategoryCard extends StatelessWidget {
  final DocumentSnapshot category;
  final Map<String, dynamic> subSkill;
  final Widget categoryIcon;
  CustomCategoryCard(this.category, this.categoryIcon, this.subSkill);

  List<Widget> getSkillsList(BuildContext context) {
    List<Widget> skillList = [];
    for (int i = 0; i < subSkill["skills"].length; i++) {
      skillList.add(Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ExpertList(skill: subSkill["skills"][i]);
                  },
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 5, bottom: 12, top: 5),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: 5,
                      top: 5,
                    ),
                    width: 42,
                    height: 42,
                    child: subSkill["icons"][i],
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            subSkill['skills'][i]['Name'],
                            style: Theme.of(context).textTheme.title.copyWith(
                                  fontSize: 15,
                                ),
                          ),
                        ),
                        Text(
                          subSkill["skills"][i]['tagLine'],
                          style:
                              Theme.of(context).primaryTextTheme.body2.copyWith(
                                    fontSize: 11,
                                    color: (Theme.of(context).brightness ==
                                            Brightness.dark)
                                        ? Colors.grey[400]
                                        : Colors.grey[800],
                                  ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ));
    }
    return skillList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, bottom: 0, top: 0),
      child: ExpansionTile(
        leading: Container(
            margin: EdgeInsets.only(
              left: 0,
              top: 5,
              bottom: 5,
            ),
            width: 55,
            height: 55,
            child: categoryIcon),
        title: Container(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 15, top: 15),
                child: Text(
                  category['Name'],
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontSize: 17,
                      ),
                ),
              ),
            ],
          ),
        ),
        children: getSkillsList(context),
      ),
    );
  }
}
