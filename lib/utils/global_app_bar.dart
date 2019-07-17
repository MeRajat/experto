import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

class CustomAppBar extends StatelessWidget {
  final double expandedHeight;
  final String title;
  final Widget flexibleSpaceWidget;
  final bool isFloating, logout;

  CustomAppBar(this.expandedHeight, this.title, this.flexibleSpaceWidget,
      {this.isFloating: false, this.logout: true});

  // List<Widget> logOut(BuildContext context) {
  //   List<Widget> list = new List<Widget>();
  //   list.add(
  //     FlatButton(
  //       padding: EdgeInsets.only(right: 20),
  //       onPressed: () async {
  //         await FirebaseAuth.instance.signOut();
  //         Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
  //             MaterialPageRoute(builder: (buildContext) => HomePage()),
  //             ModalRoute.withName(':'));
  //       },
  //       child: Text("Logout",
  //           style: Theme.of(context)
  //               .primaryTextTheme
  //               .body2
  //               .copyWith(color: Colors.red)),
  //       //color: Colors.redAccent,
  //     ),
  //   );
  //   if (logout)
  //     return list;
  //   else
  //     return null;
  // }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      titleSpacing: 0,
      expandedHeight: expandedHeight,
      pinned: true,
      floating: isFloating,
      leading: Container(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
        ),
        child: Image.asset(
          "assets/logo_transparent.png",
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.title.copyWith(letterSpacing: -.7),
      ),
      //actions: logOut(context),
      flexibleSpace: flexibleSpaceWidget,
    );
  }
}
