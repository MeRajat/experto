import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

class CustomAppBar extends StatelessWidget {
  final double expandedHeight;
  final String title;
  final Widget flexibleSpaceWidget;

  CustomAppBar(this.expandedHeight, this.title, this.flexibleSpaceWidget);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      titleSpacing: 0,
      expandedHeight: expandedHeight,
      pinned: true,
      leading: Icon(CupertinoIcons.book_solid, size: 30),
      title: Text(
        title,
        style: Theme.of(context).textTheme.title.copyWith(letterSpacing: -.7),
      ),
      flexibleSpace: flexibleSpaceWidget,
    );
  }
}
