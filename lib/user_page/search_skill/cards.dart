import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';

import './search_result_cards.dart';
import "package:experto/utils/bloc/search_bloc.dart";
import "package:experto/utils/bloc/reload.dart";
import "package:experto/utils/bloc/is_searching.dart";
import 'package:experto/utils/timed_out.dart';
import 'package:experto/utils/no_result.dart';

class Cards extends StatefulWidget {
  final List recommendedSkills = ["Fashion", "Mathematics", "Data science"];

  final List skills = [
    "Fashion",
    "Mathematics",
    "Data science",
    "OS",
    "DS and Algorithms"
  ];

  @override
  _Cards createState() => _Cards();
}

class _Cards extends State<Cards> {
  List results = [];
  List recommendedSkills;
  int searchingStatus = 0;
  String searchString;
  bool resultAvailable = false, timedOut = false;

  @override
  void dispose() {
    searchBloc.dispose();
    isSearching.dispose();
    super.dispose();
  }

  void reload() async {
    userSearchSkill.getStatus.listen((value) {
      if (value == true) {
        setState(() {
          searchingStatus = 0;
        });
      }
    });
  }

  void retrySearch(){
    timedOut = false;
    searchingStatus = 1;
    search(searchString);
  }
  
  void getSearchingStatus() async {
    isSearching.getStatus.listen((result) {
      setState(() {
        searchingStatus = result;
      });
    });
  }

  void search(searchQuery) {
    List tempResultList = [];
    int flag = 0;
    widget.skills.forEach((expert) {
      if (expert.toLowerCase().contains(searchQuery)) {
        flag = 1;
        tempResultList.add(expert);
        setState(() {
          results = tempResultList;
        });
      }
    });
    if (flag == 0) {
      setState(() {
        results = [];
      });
    }
  }

  void getSearch() async {
    searchBloc.value.listen((searchQuery) {
      searchString = searchQuery;
      searchingStatus = 1;
      search(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    {
      reload();
      getSearchingStatus();
      getSearch();
      String recommendationHeaderText = "Top Skills";
      String searchHeaderText = "Results";
      if (timedOut) {
        return SliverToBoxAdapter(child: TimedOut(retrySearch));
      }
      if (searchingStatus == 0) {
        return SearchResults(
            widget.recommendedSkills, recommendationHeaderText);
      } else {
        if (resultAvailable) {
          return SearchResults(results, searchHeaderText);
        } else {
          return SliverToBoxAdapter(child: NoResultCard());
        }
      }
    }
  }
}
