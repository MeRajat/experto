import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';

import './search_result_cards.dart';
import '../bloc/search_bloc.dart';
import '../bloc/is_searching.dart';

class Cards extends StatefulWidget {
  final List allExperts = [
    'Pravin Gupta',
    'Rahul Saini',
    'Anand Panwal',
    'Himanshu Pandey',
    'Nihal Sharma',
    'Rahul Gupta',
    'Dhruv Khosla',
  ];

  @override
  _Cards createState() => _Cards();
}

class _Cards extends State<Cards> {
  List results = [];
  List allExperts;
  int searchingStatus = 0;

  @override
  void dispose() {
    expertSearchBloc.dispose();
    isSearchingExpert.dispose();
    super.dispose();
  }

  void getSearchingStatus() async {
    isSearchingExpert.getStatus.listen((result) {
      setState(() {
        searchingStatus = result;
      });
    });
  }

  void search(searchQuery) {
    List tempResultList = [];
    int flag = 0;
    widget.allExperts.forEach((expert) {
      if (expert.toLowerCase().contains(searchQuery)) {
        flag = 1 ;
        tempResultList.add(expert);
        setState(() {
          results = tempResultList;
        });
      }
    });
    if(flag==0){
      setState(() {
        results=[];
      });
    }
  }

  void getSearch() async {
    expertSearchBloc.value.listen((searchQuery) {
      searchingStatus = 1;
      search(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    {
      getSearchingStatus();
      getSearch();
      String allExpertHeaderText = "All Experts";
      String searchHeaderText = "Results";
      if (searchingStatus == 0) {
        return SearchResults(widget.allExperts, allExpertHeaderText);
      } else {
        return SearchResults(results, searchHeaderText);
      }
    }
  }
}
