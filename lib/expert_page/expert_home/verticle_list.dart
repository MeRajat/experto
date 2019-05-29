import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experto/expert_authentication/expertAdd.dart';
import 'package:flutter/material.dart';

import '../../user_page/search_expert/timed_out.dart';
import '../../user_page/bloc/reload.dart';

class VerticalList extends StatefulWidget {
  @override
  _VerticalListState createState() => _VerticalListState();
}

class _VerticalListState extends State<VerticalList> {
  QuerySnapshot interactionSnapshot;
  List<DocumentSnapshot> experts;
  CollectionReference interaction, expert;
  bool timedout, load;

  void initState() {
    expert = Firestore.instance.collection("Experts");
    interaction = Firestore.instance.collection("Interactions");
    experts = new List<DocumentSnapshot>();
    timedout = false;
    load = false;
    getInteraction();
    reload();
    super.initState();
  }

  void reload() async {
    expertInteractions.getStatus.listen((value){
      if(value == true){
        setState(() {
          interactionSnapshot = null;
          experts = [];
          load = false;
          timedout= false;
          getInteraction();
        });
      }
    });
  }

  Future<void> getInteraction() async {
    interactionSnapshot = await interaction
        .where("user", isEqualTo: currentExpert["emailID"])
        .getDocuments()
        .timeout(Duration(seconds: 10), onTimeout: () {
      setState(() {
        timedout = true;
      });
    });
    experts.clear();
    for (int i = 0; i < interactionSnapshot.documents.length; i++) {
      QuerySnapshot q = await expert
          .where("emailID",
              isEqualTo: interactionSnapshot.documents[i]["expert"])
          .getDocuments();
      experts.add(q.documents[0]);
    }
    setState(() {
      load = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (experts != null && experts.length > 0)
      return SliverPadding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Card(
                child: Container(
                  padding:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Noname",
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 19),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12, bottom: 5),
                        child: Row(
                          children: <Widget>[
                            Text("User : ",
                                style:
                                    Theme.of(context).primaryTextTheme.body2),
                            Text(
                              experts[index]["Name"],
                              style: Theme.of(context).primaryTextTheme.body2,
                            ),
                          ],
                        ),
                      ),
                      //Row(
                      //  children: <Widget>[
                      //    SizedBox(
                      //      height: 30,
                      //      width: 75,
                      //      child: FlatButton(
                      //        child: Text("view detail",
                      //            style:
                      //                Theme.of(context).primaryTextTheme.body2),
                      //        padding: EdgeInsets.all(0),
                      //        onPressed: () {
                      //          Navigator.push(
                      //            context,
                      //            MaterialPageRoute(
                      //              builder: (BuildContext context) {
                      //                return ExpertDetail(experts[index]);
                      //              },
                      //            ),
                      //          );
                      //        },
                      //      ),
                      //    ),
                      //  ],
                      //)
                    ],
                  ),
                ),
              );
            },
            childCount: experts.length,
          ),
        ),
      );
    else if (load && experts.length == 0) {
      return SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              child: Icon(
                Icons.question_answer,
                size: 130,
              ),
              padding: EdgeInsets.only(top:70,bottom:20),
            ),
            Text("No Interactions Yet",
                style: Theme.of(context).primaryTextTheme.body2),
          ],
        ),
      );
    } else if (timedout) {
      return SliverToBoxAdapter(
        child: TimedOut(
          iconSize: 130,
          text: "timedOut",
        ),
      );
    } else {
      return SliverPadding(
          padding: EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Center(child: CircularProgressIndicator());
              },
              childCount: 1,
            ),
          ));
    }
  }
}
