import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:experto/global_data.dart';
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
  Data user;
  CollectionReference interaction, expert;
  bool timedout, load;
  List<bool> checkingAvail , expertAvailable;
  bool stateMounted;

  @override
  void didChangeDependencies() {
    user = DocumentSync.of(context).account;
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
    checkingAvail=new List<bool>();
    expertAvailable=new List<bool>();
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
        .where("user", isEqualTo: user.profileData.uid)
        .orderBy("interactionTime", descending: true)
        .getDocuments()
        .timeout(Duration(seconds: 10), onTimeout: () {
      setState(() {
        timedout = true;
      });
    });
    experts.clear();
    interactionSnapshot.documents.forEach((d) async {
      DocumentSnapshot doc = await expert.document(d["expert"]).get();
      experts.add(doc);
      expertAvailable.add(false);
      checkingAvail.add(false);
      checkAvail(experts.length-1);
      setState(() {
        load = true;
      });
    });
    if (interactionSnapshot.documents.length == 0)
      setState(() {
        load = true;
      });
  }

  Future<void> checkAvail(int index) async {
    setState(() {

      checkingAvail[index]= true;
    });
    expertAvailable[index] = await contactExpert.checkAvail(experts[index]);

    setState(() {
      checkingAvail[index]= false;
    });
  }

  void contactOnTap(
      {@required String secondaryText,
      @required Widget icon,
      @required String serviceType,
      @required int index}) async {

    if (checkingAvail[index]) {
      bottomSheet.showBottomSheet(
        context: context,
        icon: CircularProgressIndicator(),
        secondaryText: "Checking Availablity",
        callback: null,
      );
    }

    if (expertAvailable[index]) {
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
    }
//    else if (!expertAvailable[index]) {
//      bottomSheet.showBottomSheet(
//        context: context,
//        icon: Icon(Icons.not_interested, size: 120),
//        secondaryText: "Expert is not available right now!",
//        callback: null,
//      );
//    }
  }

  @override
  Widget build(BuildContext context) {
    if (experts != null && experts.length > 0)
      return SliverPadding(
        padding: EdgeInsets.only(top: 20, bottom: 100),
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
                        experts[index]['Name'],
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
                      Hero(
                        tag: "contact${experts[index]["emailID"]}",
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Spacer(flex: 10),
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[800],
                                ),
                                height: 25,
                                width: 25,
                                child: Icon(
                                  Icons.info,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ),
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

                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: checkingAvail[index]?Colors.grey:expertAvailable[index]?Colors.grey[800]:Colors.grey,
                                ),
                                height: 25,
                                width: 25,
                                child: Icon(
                                  Icons.video_call,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ),
                              onTap: !expertAvailable[index]?null:() {
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
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: checkingAvail[index]?Colors.grey:expertAvailable[index]?Colors.grey[800]:Colors.grey,
                                ),
                                height: 25,
                                width: 25,
                                child: Icon(
                                  Icons.chat,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              onTap:!expertAvailable[index]?null: () {
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
        ),
      );
    }
  }
}
