//import 'package:experto/expert_authentication/expertData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './app_bar.dart';

import "package:experto/utils/bloc/reload.dart";
import './vertical_list.dart';

class ExpertHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return CustomScrollView(
       physics: BouncingScrollPhysics(parent:AlwaysScrollableScrollPhysics()),
       slivers: <Widget>[
         Appbar(),
         CupertinoSliverRefreshControl(
          onRefresh: () {
            expertInteractions.updateStatus(true);
            return Future.delayed(
              Duration(seconds: 1),
            );
          },
        ),
         VerticalList(),
       ],
     );
  }
}
