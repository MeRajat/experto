import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

class CustomAppBar extends StatelessWidget {
  final double expandedHeight;
  final String title;
  final Widget flexibleSpaceWidget;
  final bool isFloating;

  CustomAppBar(this.expandedHeight, this.title, this.flexibleSpaceWidget,{this.isFloating:false});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      titleSpacing: 0,
      expandedHeight: expandedHeight,
      pinned: true,
      floating: isFloating,
      leading: Icon(CupertinoIcons.book_solid, size: 30),
      title: Text(
        title,
        style: Theme.of(context).textTheme.title.copyWith(letterSpacing: -.7),
      ),
      flexibleSpace: flexibleSpaceWidget,
    );
  }
}
