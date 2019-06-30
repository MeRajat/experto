//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './card.dart';

class SearchResults extends StatelessWidget {
  final List results;
  final String headerText;
  final List<Widget> expertProfilePic;
  SearchResults(this.results, this.headerText, {this.expertProfilePic});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 20, bottom: 80),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      headerText,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontSize: 15),
                    ),
                  ),
                  (expertProfilePic != null)
                      ? CustomCard(
                          expert: results[index],
                          profilePic: expertProfilePic[index],
                        )
                      : CustomCard(expert: results[index]),
                ],
              );
            } else {
              return (expertProfilePic != null)
                  ? CustomCard(
                      expert: results[index],
                      profilePic: expertProfilePic[index],
                    )
                  : CustomCard(expert: results[index]);
            }
          },
          childCount: results.length,
        ),
      ),
    );
  }
}
