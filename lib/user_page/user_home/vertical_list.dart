import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experto/user_authentication/userAdd.dart';
import 'package:flutter/material.dart';
import '../expert_detail/expert_detail.dart';

class VerticalList extends StatefulWidget {
  @override
  _VerticalListState createState() => _VerticalListState();
}

class _VerticalListState extends State<VerticalList> {
  final List<List> activeSessions = [
    ["Yoga", "Rahul saini"],
    ["Dieting", "Nihal Sharma"]
  ];

  QuerySnapshot interactionSnapshot;
  List<DocumentSnapshot> experts;
  CollectionReference interaction, expert;
  Widget loading;
  void initState() {
    expert = Firestore.instance.collection("Experts");
    interaction = Firestore.instance.collection("Interactions");
    experts = new List<DocumentSnapshot>();
    getInteraction();
    super.initState();
  }

  Future<void> getInteraction() async {
    interactionSnapshot = await interaction
        .where("user", isEqualTo: currentUser["emailID"])
        .getDocuments();
    experts.clear();
    for(int i=0;i<interactionSnapshot.documents.length;i++){
      QuerySnapshot q =
          await expert.where("emailID", isEqualTo: interactionSnapshot.documents[i]["expert"]).getDocuments();
      experts.add(q.documents[0]);
    }
    print(experts.length);
    setState(() {});
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
                            Text("Your Expert : ",
                                style:
                                    Theme.of(context).primaryTextTheme.body2),
                            Text(
                              experts[index]["Name"],
                              style: Theme.of(context).primaryTextTheme.body2,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                            width: 75,
                            child: FlatButton(
                              child: Text("view detail",
                                  style:
                                      Theme.of(context).primaryTextTheme.body2),
                              padding: EdgeInsets.all(0),
                              onPressed: () {
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
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            childCount: experts.length,
          ),
        ),
      );
    else {
      return SliverPadding(
        padding: EdgeInsets.all(20),
        sliver: SliverList(delegate: SliverChildBuilderDelegate(
        (BuildContext context,int index){
          return Center(child: loading);
    },
          childCount: 1,
        ),
      ));
    }
  }
}
