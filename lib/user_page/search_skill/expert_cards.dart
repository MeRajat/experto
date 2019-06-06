import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experto/user_page/search_expert/card.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

import "package:experto/utils/bloc/reload.dart";
import 'package:experto/utils/timed_out.dart';

class Cards extends StatefulWidget {
  final DocumentSnapshot skill;

  Cards({this.skill});

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  QuerySnapshot expert;
  CollectionReference experts;
  bool load, timedOut = false;

  @override
  void initState() {
    experts = Firestore.instance.collection("Experts");
    load = false;
    listenReload();
    timedOut = false;
    getExperts();
    super.initState();
  }

  void listenReload() async {
    userSearchSkillExpertList.getStatus.listen((value) {
      if (value == true) {
        reload();
      }
    });
  }

  void reload() {
    setState(() {
      expert = null;
      timedOut = false;
      load = false;
      getExperts();
    });
  }

  Future<void> getExperts() async {
    timedOut = false;
    expert = await experts
        .where("Skills", arrayContains: widget.skill.reference)
        .getDocuments()
        .timeout(Duration(seconds: 10), onTimeout: () {
      setState(() {
        timedOut = true;
      });
    });
    setState(() {
      load = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (timedOut == true) {
      return SliverToBoxAdapter(
        child: TimedOut(reload, text: "Timed Out", iconSize: 130),
      );
    }
    if (!load)
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
    else if (expert == null || expert.documents.length == 0)
      return SliverPadding(
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 10),
                    child: Icon(Icons.error, size: 130),
                  ),
                  Text(
                    "No Experts Found",
                    style: Theme.of(context).primaryTextTheme.body2,
                  ),
                ],
              );
            },
            childCount: 1,
          ),
        ),
        padding: EdgeInsets.only(top: 20, bottom: 80),
      );
    else
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
  }
}
