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
      'Join As User',
      'sub text welcome gret',
      '/user_signup',
    ),
    CardInfo(
      Icon(CupertinoIcons.person_solid, size: 100),
      'Join As Expert',
      'sub text welcome gret',
      '/expert_signup',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 10, bottom: 40),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, card[index].navigatorLink);
                },
                child: SizedBox(
                  height: 150,
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
                            Text(
                              card[index].greetingText,
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
