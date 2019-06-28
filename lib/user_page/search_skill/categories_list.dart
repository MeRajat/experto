import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './card.dart';
import './categorycard.dart';

class SearchResults extends StatelessWidget {
  final List<DocumentSnapshot> results;
  final String headerText;
  bool status;
  SearchResults(this.results, this.headerText,this.status);

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
                    padding: EdgeInsets.only(left: 15,bottom: 10),
                    child: Text(
                      headerText,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontSize: 15),
                    ),
                  ),
                  status?CustomCard(results[index]):CustomCategoryCard(results[index]),
                ],
              );
            } else {
              return status?CustomCard(results[index]):CustomCategoryCard(results[index]);
            }
          },
          childCount: results.length,
        ),
      ),
    );
  }
}
