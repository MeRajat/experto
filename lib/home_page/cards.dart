import 'package:experto/user_authentication/signUpReq.dart' as user;
import 'package:experto/expert_authentication/signUpReq.dart' as expert;

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class CardInfo {
  String text, greetingText, navigatorLink;
  Icon icon;

  CardInfo(this.icon, this.text, this.greetingText, this.navigatorLink);
}

class Cards extends StatelessWidget {
  final List<CardInfo> card = [
    CardInfo(
      Icon(Icons.person, size: 100),
      'User',
      '',
      '/user_login',
    ),
    CardInfo(
      Icon(CupertinoIcons.person_solid, size: 100),
      'Expert',
      '',
      '/expert_login',
    )
  ];

  final user.Authenticate authenticateUser = new user.Authenticate();
  final expert.Authenticate authenticateExpert = new expert.Authenticate();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 10, bottom: 40),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Card(
              child: InkWell(
                onTap: () async {
                  Navigator.pushNamed(context, card[index].navigatorLink);
                },
                child: SizedBox(
                  height: 130,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 10),
                        child: card[index].icon,
                      ),
                      Container(
                        width: 200,
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 5,
                              ),
                              child: Text(
                                card[index].text,
                                style: Theme.of(context).textTheme.subhead,
                                textScaleFactor: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: card.length,
        ),
      ),
    );
  }
}
