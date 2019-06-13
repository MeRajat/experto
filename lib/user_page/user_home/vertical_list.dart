import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experto/user_authentication/userAdd.dart';
import 'package:flutter/material.dart';
import '../expert_detail/expert_detail.dart';

import 'package:experto/utils/timed_out.dart';
import "package:experto/utils/bloc/reload.dart";
import "package:experto/utils/contact_expert.dart" as contactExpert;
import "package:experto/utils/bottomSheet.dart" as bottomSheet;

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
    listenReload();
    super.initState();
  }

  void listenReload() async {
    userInteractions.getStatus.listen((value) {
      if (value == true) {
        reload();
      }
    });
  }

  void reload() {
    setState(() {
      interactionSnapshot = null;
      experts = [];

      load = false;
      timedout = false;
      getInteraction();
    });
  }

  void retry() {
    reload();
  }

  Future<void> getInteraction() async {
    interactionSnapshot = await interaction
        .where("user", isEqualTo: UserData.currentUser["emailID"])
        .orderBy("interactionTime", descending: true)
        .getDocuments()
        .timeout(Duration(seconds: 10), onTimeout: () {
      setState(() {
        timedout = true;
      });
    });
    experts.clear();
    print(interactionSnapshot.documents.length);
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
        padding: EdgeInsets.only(top: 20, bottom: 100),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Card(
                child: Container(
                  padding:
                      EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Noname",
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 20),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12, bottom: 10),
                        child: Row(
                          children: <Widget>[
                            Hero(
                              tag: experts[index]['emailID'],
                              child: Text(
                                "Your Expert : ${experts[index]["Name"]}",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .body2
                                    .copyWith(
                                      fontSize: 13,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Hero(
                        tag: "contact",
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Spacer(flex: 10),
                            InkWell(
                              child: Icon(Icons.info, size: 17),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ExpertDetail(experts[index]);
                                    },
                                  ),
                                );
                              },
                            ),
                            Spacer(flex: 1),
                            InkWell(
                              child: Icon(Icons.video_call, size: 20),
                              onTap: () {
                                bottomSheet.showBottomSheet(
                                  context: context,
                                  icon: Icon(Icons.face, size: 120),
                                  secondaryText:
                                      "Are you sure you want to call this expert ?",
                                  callback: () {
                                    contactExpert.videoCall(context: context);
                                  },
                                );
                              },
                            ),
                            Spacer(flex: 1),
                            InkWell(
                              child: Icon(Icons.chat, size: 16),
                              onTap: () {
                                bottomSheet.showBottomSheet(
                                    context: context,
                                    icon: Icon(Icons.chat_bubble_outline,
                                        size: 120),
                                    secondaryText:
                                        "Are you sure you want to message this expert",
                                    callback: () {
                                      contactExpert.launchSkype(
                                          context: context,
                                          skypeUsername: experts[index]
                                              ['SkypeUser'],
                                          serviceType: "chat",
                                          afterLaunchFunc: () {});
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
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
          text: "TimedOut",
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
