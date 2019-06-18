import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:experto/user_authentication/userData.dart';
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
  DocumentSnapshot user;
  CollectionReference interaction, expert;
  bool timedout, load, checkingAvail = false, expertAvailable = true;
  bool stateMounted;

  @override
  void didChangeDependencies() {
    user = UserDocumentSync.of(context).user;
    if (stateMounted == true) {
      getInteraction();
      stateMounted = false;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    stateMounted = true;
    expert = Firestore.instance.collection("Experts");
    interaction = Firestore.instance.collection("Interactions");
    experts = new List<DocumentSnapshot>();
    timedout = false;
    load = false;
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
        .where("user", isEqualTo: UserDocumentSync.of(context).user["emailID"])
        .orderBy("interactionTime", descending: true)
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

  Future<void> checkAvail(int index) async {
    setState(() {
      checkingAvail = true;
    });

    experts[index] = await experts[index].reference.get();

    if (experts[index]["Availability Mode"] == 'normal') {
      expertAvailable = experts[index]['Available'];
    } else {
      DateTime now = DateTime.now();
      var expertAvailability = experts[index]["Availablity"];
      expertAvailability.forEach((_, timeSlot) {
        if (timeSlot['start'] != null || timeSlot['end'] != null) {
          DateTime start = timeSlot['start'].toDate();
          DateTime end = timeSlot['end'].toDate();
          if (now.hour > start.hour && now.hour < end.hour) {
            expertAvailable = true;
          } else if (now.hour == start.hour || now.hour == end.hour) {
            if (now.minute > start.minute && now.minute < start.minute) {
              expertAvailable = true;
            }
          } else {
            expertAvailable = false;
          }
        }
      });
    }

    setState(() {
      checkingAvail = false;
    });
  }

  void contactOnTap(
      {@required String secondaryText,
      @required Widget icon,
      @required String serviceType,
      @required int index}) async {
    checkingAvail = true;

    if (checkingAvail) {
      bottomSheet.showBottomSheet(
        context: context,
        icon: CircularProgressIndicator(),
        secondaryText: "Checking Availablity",
        callback: null,
      );
    }

    await checkAvail(index);

    if (expertAvailable) {
      bottomSheet.showBottomSheet(
        context: context,
        icon: icon,
        secondaryText: secondaryText,
        callback: () {
          contactExpert.launchSkype(
              context: context,
              skypeUsername: experts[index]['SkypeUser'],
              serviceType: serviceType,
              afterLaunchFunc: () {});
        },
      );
    } else if (!expertAvailable) {
      bottomSheet.showBottomSheet(
        context: context,
        icon: Icon(Icons.not_interested, size: 120),
        secondaryText: "Expert is not available right now!",
        callback: null,
      );
    }
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
                            //Hero(
                            //  tag: experts[index]['emailID'],
                            //  child:
                            Text(
                              "Your Expert : ${experts[index]["Name"]}",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .body2
                                  .copyWith(
                                    fontSize: 13,
                                  ),
                            ),
                            //),
                          ],
                        ),
                      ),
                      Hero(
                        tag: "contact${experts[index]["emailID"]}",
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
                                contactOnTap(
                                    secondaryText:
                                        "Are you sure you want to call this expert",
                                    serviceType: "chat",
                                    index: index,
                                    icon: Icon(Icons.face, size: 120));
                              },
                            ),
                            Spacer(flex: 1),
                            InkWell(
                              child: Icon(Icons.chat, size: 16),
                              onTap: () {
                                contactOnTap(
                                    secondaryText:
                                        "Are you sure you want to messsage this expert",
                                    serviceType: "chat",
                                    index: index,
                                    icon: Icon(Icons.chat_bubble_outline,
                                        size: 120));
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
