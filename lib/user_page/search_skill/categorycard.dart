import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import "package:cached_network_image/cached_network_image.dart";

import './expert_list.dart';

class CustomCategoryCard extends StatefulWidget {
  final DocumentSnapshot category;
  CustomCategoryCard(this.category);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCategoryCard> {
  List<DocumentSnapshot> skillsSnapshot;
  final List<Color> colorsDarkMode = [
    Color.fromRGBO(46, 117, 178, 1),
    Color.fromRGBO(229, 107, 107, 1),
    Color.fromRGBO(172, 95, 175, 1),
    Color.fromRGBO(255, 138, 96, 1),
    Color.fromRGBO(94, 165, 95, 1),
    Color.fromRGBO(67, 168, 127, 1)
  ];

  final List<Color> colorsLightMode = [
    Colors.red,
    Colors.purple,
    Colors.blue,
    Colors.deepOrangeAccent,
    Colors.green,
    Colors.cyan,
  ];

  final random = new Random();
  Future<void> getSkills() async{

    widget.category['Skills'].forEach((d)async{
      DocumentSnapshot temp=await d.get();
      skillsSnapshot.add(temp);
      setState(() {

      });
    });
  }
  List<Widget> getSkillsList(){
    List<Widget> skillList=new List<Widget>();
    if(skillsSnapshot==null)
    {
      skillsSnapshot=new List<DocumentSnapshot>();
      skillList.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ));
      getSkills();
    }
    else
    {
      skillList.clear();
      skillsSnapshot.forEach((skill){

        skillList.add(
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ExpertList(skill: skill);
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
                          width: 45,
                          height: 45,
                          child: CachedNetworkImage(
                            imageUrl: skill["IconURL"],
                            placeholder: (BuildContext context, string) => Center(
                              heightFactor: 1.1,
                              widthFactor: 1.1,
                              child: CircularProgressIndicator(),
                            ),
                            color: (Theme.of(context).brightness == Brightness.dark)
                                ? colorsDarkMode[random.nextInt(colorsDarkMode.length)]
                                : colorsLightMode[random.nextInt(colorsLightMode.length)],
                          ),
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
                                  skill['Name'],
                                  style: Theme.of(context).textTheme.title.copyWith(
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              Text(
                                skill['tagLine'],
                                style: Theme.of(context).primaryTextTheme.body2.copyWith(
                                  fontSize: 12,
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
            )
        );
      });
    }
    return skillList;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.category["Name"]);
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
          child: CachedNetworkImage(
            imageUrl: widget.category["IconURL"],
            placeholder: (BuildContext context, string) => Center(
              heightFactor: 1.1,
              widthFactor: 1.1,
              child: CircularProgressIndicator(),
            ),
            color: (Theme.of(context).brightness == Brightness.dark)
                ? colorsDarkMode[random.nextInt(colorsDarkMode.length)]
                : colorsLightMode[random.nextInt(colorsLightMode.length)],
          ),
        ),
        title: Container(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 15,top: 15),
                child: Text(
                  widget.category['Name'],
                  style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
        children: getSkillsList(),
      ),
    );
  }
}