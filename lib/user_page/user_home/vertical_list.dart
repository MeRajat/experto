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

  CollectionReference interaction,expert;
  QuerySnapshot interactionSnapshot,experts;

  @override
  void initState(){
    expert=Firestore.instance.collection("Experts");
    interaction=Firestore.instance.collection("Interactions");
    getInteraction();
    super.initState();
  }
  Future<void> getInteraction() async{
    interactionSnapshot=await interaction.where("user",isEqualTo: currentUser["emailID"]).getDocuments();
    experts=await expert.getDocuments();
    experts.documents.clear();
    List.from(interactionSnapshot.documents).forEach((i){
      expert.where("emailID",isEqualTo: i["expert"]).getDocuments().then((QuerySnapshot q){
        experts.documents.add(q.documents[0]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      activeSessions[index][0],
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
                              style: Theme.of(context).primaryTextTheme.body2),
                          Text(
                            "name",
                            //experts.documents[index]["Name"],
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
                                style: Theme.of(context).primaryTextTheme.body2),
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return ExpertDetail(
                                        activeSessions[index][1]);
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
          childCount: activeSessions.length,
        ),
      ),
    );
  }
}
