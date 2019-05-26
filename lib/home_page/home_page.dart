import "package:flutter/material.dart";

import "./app_bar.dart";
import "./cards.dart";

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          Appbar(),
          Cards(),
    
    //       SliverToBoxAdapter(
    //         child: Container(
    //           color: Theme.of(context).appBarTheme.color,
    //           height: MediaQuery.of(context).size.height * .7,
    //           child: Align(
    //             child: RaisedButton(
    //               child: Text("User Signup"),
    //               onPressed: () {
    //                 Navigator.pushNamed(context,'/user_signup');
    //               },
    //             ),
    //           ),
    //         ),
    //       ),
    //       SliverToBoxAdapter(
    //         child: Container(
    //           color: Theme.of(context).scaffoldBackgroundColor,
    //           height: MediaQuery.of(context).size.height * .7,
    //           child: Align(
    //             child: RaisedButton(
    //               child: Text("Expert Signup"),
    //               onPressed: () {},
    //             ),
    //           ),
    //         ),
    //       ),
         ],
      ),
    );
  }
}