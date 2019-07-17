import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experto/utils/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../expert_detail/expert_detail.dart';

class CustomCard extends StatelessWidget {
  final DocumentSnapshot expert;
  CustomCard({@required this.expert});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return ExpertDetail(expert);
              },
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5, bottom: 12, top: 5),
          child: Row(
            children: <Widget>[
              expert["profilePicThumb"] == null
                  ? Icon(
                Icons.person,
                size: 80,
              )
                  : CachedNetworkImage(
                imageBuilder: (context, imageProvider) =>
                    Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[400],
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                imageUrl: expert["profilePicThumb"],
                height: 80,
                width: 80,
                placeholder: (context, a) =>
                    Container(
                        width: 80.0,
                        height: 80.0,
                        child: CustomPlaceholder()),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 10, left: 10, bottom: 5, right: 10),
                width: 230,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        expert["Name"],
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontWeight: FontWeight.bold),
                        textScaleFactor: .85,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: expert['Description'],
                        style:
                            Theme.of(context).primaryTextTheme.body2.copyWith(
                                  fontSize: 12,
                                  color: (Theme.of(context).brightness ==
                                          Brightness.dark)
                                      ? Colors.grey[400]
                                      : Colors.grey[800],
                                ),
                      ),
                      maxLines: 2,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
