import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class Detail extends StatefulWidget {
  final DocumentSnapshot expert;

  Detail({@required this.expert});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List<String> skillName = [];
  List<String> workExp = [];
  bool loading = true;

  @override
  void initState() {
    getSkills();
    getWorkExp();
    super.initState();
  }

  void getSkills() async {
    loading = true;
    for (int i = 0; i < widget.expert['Skills'].length; i++) {
      await widget.expert['Skills'][i].get().then(
        (DocumentSnapshot skill) {
          skillName.add(skill['Name']);
        },
      );
    }
    loading = false;
    try {
      setState(() {});
    } catch (e) {}
  }

  void getWorkExp() async {
    workExp = widget.expert['Work Experience'].split('\n');
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 20, bottom: 80),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 10, top: 20),
                  child: Text(
                    "Descirption",
                    style: Theme.of(context).textTheme.title,
                    textScaleFactor: 1.2,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, top: 15, bottom: 20, right: 20),
                  child: Text(
                    widget.expert['Description'],
                    style: Theme.of(context).primaryTextTheme.body2.copyWith(
                          fontSize: 13,
                          color:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? Colors.grey[400]
                                  : Colors.grey[800],
                        ),
                  ),
                )
              ],
            ),
          ),
          // Card(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       Padding(
          //         padding: EdgeInsets.only(left: 20, right: 10, top: 20),
          //         child: Text(
          //           "Availability",
          //           style: Theme.of(context).textTheme.title,
          //           textScaleFactor: 1.2,
          //         ),
          //       ),
          //       Padding(
          //         padding:
          //             EdgeInsets.only(left: 20, top: 15, bottom: 20, right: 20),
          //         child: Text(
          //           widget.expert['Description'],
          //           style: Theme.of(context).primaryTextTheme.body2.copyWith(
          //                 fontSize: 13,
          //                 color:
          //                     (Theme.of(context).brightness == Brightness.dark)
          //                         ? Colors.grey[400]
          //                         : Colors.grey[800],
          //               ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 10, top: 20),
                  child: Text(
                    "Categories",
                    style: Theme.of(context).textTheme.title,
                    textScaleFactor: 1.2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 15, bottom: 20),
                  child: (loading)
                      ? Center(
                          heightFactor: 2.0,
                          //widthFactor: .4,
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: skillName
                              .map(
                                (element) => Container(
                                      padding: EdgeInsets.only(bottom: 3),
                                      child: Text(
                                        element,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .body2
                                            .copyWith(
                                              fontSize: 13,
                                              color: (Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark)
                                                  ? Colors.grey[400]
                                                  : Colors.grey[800],
                                            ),
                                      ),
                                    ),
                              )
                              .toList(),
                        ),
                )
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 10, top: 20),
                  child: Text(
                    "Work Experience",
                    style: Theme.of(context).textTheme.title,
                    textScaleFactor: 1.2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 15, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: workExp
                        .map(
                          (element) => Container(
                                width: 230,
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  element,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .body2
                                      .copyWith(
                                        fontSize: 13,
                                        color: (Theme.of(context).brightness ==
                                                Brightness.dark)
                                            ? Colors.grey[400]
                                            : Colors.grey[800],
                                      ),
                                ),
                              ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
