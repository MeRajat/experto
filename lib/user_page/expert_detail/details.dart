import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class Detail extends StatelessWidget {
  final DocumentSnapshot expert;
  final List classes = ["Speciality", "Work Experience", "Achivement"];
  final List<List> detail = [
    ["Speciality1", "Speciality1", "Speciality1"],
    ["Work Experience1", "Work Experience2", "Work Experience3"],
    ["Achivement1", "Achivement2", "Achivement3"],
  ];
  //CollectionReference spl;
  //QuerySnapshot speaciality;
  Detail({@required this.expert});//{
    //getData();
  //}


  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 20, bottom: 80),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 10, top: 20),
                    child: Text(
                      classes[index],
                      style: Theme.of(context).textTheme.title,
                      textScaleFactor: 1.2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 15, bottom: 20),
                    child: Column(
                      children: detail[index]
                          .map(
                            (element) => Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(element,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .body2),
                                ),
                          )
                          .toList(),
                    ),
                  )
                ],
              ),
            );
          },
          childCount: classes.length,
        ),
      ),
    );
  }
}
