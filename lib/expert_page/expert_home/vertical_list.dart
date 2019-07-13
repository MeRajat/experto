import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:experto/global_data.dart';
import 'package:flutter/material.dart';

import 'package:experto/utils/timed_out.dart';
import "package:experto/utils/bloc/reload.dart";

class VerticalList extends StatefulWidget {
  @override
  _VerticalListState createState() => _VerticalListState();
}

class _VerticalListState extends State<VerticalList> {
  QuerySnapshot interactionSnapshot;
  List<DocumentSnapshot> users;
  Data expert;
  CollectionReference interaction, user;
  bool timedout, load;
  bool stateMounted;

  @override
  void didChangeDependencies() {
    expert = DocumentSync.of(context).account;
    if (stateMounted == true) {
      getInteraction();
      stateMounted = false;
    }
    super.didChangeDependencies();
  }

  void initState() {
    stateMounted = true;
    user = Firestore.instance.collection("Users");
    interaction = Firestore.instance.collection("Interactions");
    users = new List<DocumentSnapshot>();
    timedout = false;
    load = false;
    listenReload();
    super.initState();
  }

  void listenReload() async {
    expertInteractions.getStatus.listen((value) {
      if (value == true) {
        reload();
      }
    });
  }

  void reload() {
    setState(() {
      interactionSnapshot = null;
      users = [];
      load = false;
      timedout = false;
      getInteraction();
    });
  }

  void retry() {
    timedout = false;
    load = false;
    getInteraction();
  }

  Future<void> getInteraction() async {
    interactionSnapshot = await interaction
        .where("expert", isEqualTo: expert.profileData.uid)
        .orderBy("interactionTime", descending: true)
        .getDocuments()
        .timeout(Duration(seconds: 10), onTimeout: () {
      setState(() {
        timedout = true;
      });
    });
    users.clear();
    //print(interactionSnapshot.documents.length);
    for (int i = 0; i < interactionSnapshot.documents.length; i++) {
      DocumentSnapshot q =
          await user.document(interactionSnapshot.documents[i]["user"]).get();
      users.add(q);
      setState(() {
        load = true;
      });
    }
    print(interactionSnapshot.documents.length);
    if (interactionSnapshot.documents.length == 0)
      setState(() {
        load = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    if (users != null && users.length > 0)
      return SliverPadding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              int lastInteractionIndex = interactionSnapshot
                      .documents[index]['interactionTime'].length -
                  1;
              DateTime lastInteractionDate = interactionSnapshot
                  .documents[index]['interactionTime'][lastInteractionIndex]
                  .toDate(); //.toString();
              String lastInteraction =
                  lastInteractionDate.toString().split('.')[0];
              return Card(
                child: Container(
                  padding:
                      EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        users[index]["Name"],
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 20),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12, bottom: 10),
                        child: Text(
                                "Last interaction : $lastInteraction",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .body2
                                    .copyWith(
                                      fontSize: 12,
                                      color: (Theme.of(context).brightness ==
                                              Brightness.dark)
                                          ? Colors.grey[400]
                                          : Colors.grey[800],
                                    ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: users.length,
          ),
        ),
      );
    else if (load && users.length == 0) {
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
              padding: EdgeInsets.only(top: 70, bottom: 20),
            ),
            Text("No Interactions Yet",
                style: Theme.of(context).primaryTextTheme.body2),
          ],
        ),
      );
    } else if (timedout) {
      return SliverToBoxAdapter(
        child: TimedOut(
          retry,
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
        ),
      );
    }
  }
}
