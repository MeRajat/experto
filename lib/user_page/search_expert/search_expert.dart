import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './app_bar.dart' as search_app_bar;
import './cards.dart';

class SearchExpert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        search_app_bar.AppBar(),
        Cards(),
      ],
    );
    }
}
