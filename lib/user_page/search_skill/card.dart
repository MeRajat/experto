import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experto/utils/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import "package:cached_network_image/cached_network_image.dart";
import './expert_list.dart';

class CustomCard extends StatelessWidget {
  final DocumentSnapshot skill;
  CustomCard(this.skill);

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
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
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
          padding: EdgeInsets.only(left: 5, right: 5, bottom: 12, top: 5),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  left: 5,
                  top: 5,
                ),
                width: 55,
                height: 55,
                child: CachedNetworkImage(
                  imageUrl: skill["IconURL"],
                  fadeOutDuration: Duration.zero,
                  placeholder: (BuildContext context, string) => CustomPlaceholder(),
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
    );
  }
}
