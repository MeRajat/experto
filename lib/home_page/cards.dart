import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class CardInfo {
  //class to model relative information about cards shown

  String imageUrl, text, greetingText, navigatorLink;
  CardInfo(this.imageUrl, this.text, this.greetingText, this.navigatorLink);
}

class Cards extends StatelessWidget {
  final List<CardInfo> card = [
    CardInfo(
      'assets/user.png',
      'Join As User',
      'sub text welcome gret',
      '/user_signup',
    ),
    CardInfo(
      'assets/expert.png',
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
                        child: Image.asset(
                          card[index].imageUrl,
                          height: 85,
                          width: 85,
                        ),
                      ),
                      Container(
                        width: 200,
                        padding: EdgeInsets.only(left: 10, bottom: 10),
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
