import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experto/user_page/search_expert/card.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class Cards extends StatefulWidget {
  String name;

  Cards({this.name});

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  QuerySnapshot expert;
  CollectionReference experts;
  bool load;

  @override
  void initState() {
    experts = Firestore.instance.collection("Experts");
    load = false;
    getExperts();
    super.initState();
  }

  Future<void> getExperts() async {
    expert = await experts
        .where("Skills", arrayContains: widget.name)
        .getDocuments();
    setState(() {
      load = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (expert == null || expert.documents.length == 0)
      return SliverPadding(
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Center(child: Text("No expert!"));
            },
            childCount: 1,
          ),
        ),
        padding: EdgeInsets.only(top: 20, bottom: 80),
      );
    else if (load)
      return SliverPadding(
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return CustomCard(expert: expert.documents[index]);
            },
            childCount: expert.documents.length,
          ),
        ),
        padding: EdgeInsets.only(top: 20, bottom: 80),
      );
    else
      return SliverPadding(
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Center(child: CircularProgressIndicator());
            },
            childCount: 1,
          ),
        ),
        padding: EdgeInsets.only(top: 20, bottom: 80),
      );
  }
}
