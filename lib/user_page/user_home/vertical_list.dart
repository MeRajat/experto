import 'package:flutter/material.dart';
import '../expert_detail/expert_detail.dart';

class VerticalList extends StatelessWidget {
  final List<List> activeSessions = [
    ["Yoga", "Rahul saini"],
    ["Dieting", "Nihal Sharma"]
  ];
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
                            activeSessions[index][1],
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
                        SizedBox(
                          height: 30,
                          width: 110,
                          child: FlatButton(
                            child: Text("feedback",
                                style: Theme.of(context).primaryTextTheme.body2),
                            padding: EdgeInsets.all(0),
                            onPressed: () {},
                          ),
                        )
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
