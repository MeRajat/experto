import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';

import './search_result_cards.dart';
import "package:experto/utils/bloc/search_bloc.dart";
import "package:experto/utils/bloc/reload.dart";
import "package:experto/utils/bloc/is_searching.dart";
import 'package:experto/utils/no_result.dart';
import 'package:experto/utils/timed_out.dart';

class Cards extends StatefulWidget {
  @override
  _Cards createState() => _Cards();
}

class _Cards extends State<Cards> {
  List<DocumentSnapshot> querySetResult = [], tempResult = [];
  int searchingStatus = 0;
  String searchString;
  bool timedOut = false, resultAvailable = false, loading = false;
  CollectionReference expert;
  QuerySnapshot expertSnapshot, searchSnapshot;

  @override
  void dispose() {
    expertSearchBloc.dispose();
    isSearchingExpert.dispose();
    super.dispose();
  }

  void listenReload() async {
    userSearchExpert.getStatus.listen((value) {
      if (value == true) {
        reload();
      }
    });
  }

  void reload() {
    setState(() {
      timedOut = false;
      searchingStatus = 0;
      expert = null;
      expertSnapshot = null;
      searchSnapshot = null;
      getExpert();
    });
  }

  @override
  void initState() {
    timedOut = false;
    getExpert();
    super.initState();
  }

  Future<void> getExpert() async {
    setState(() {
      loading = true;
    });
    expert = Firestore.instance.collection("Experts");
    expertSnapshot = await expert
        .where("Status", isEqualTo: true)
        .getDocuments()
        .timeout(Duration(seconds: 10), onTimeout: () {
      timedOut = true;
    });
    setState(() {
      loading = false;
    });
  }

  void getSearchingStatus() async {
    isSearchingExpert.getStatus.listen((result) {
      setState(() {
        timedOut = false;
        if (result == 0) {
          searchString = '';
        }
        searchingStatus = result;
      });
    });
  }

  void getQuerySet(String searchQuery) async {
    QuerySnapshot searchSnapshot = await expert
        .where("Index", isEqualTo: searchQuery.toUpperCase())
        .getDocuments()
        .timeout(Duration(seconds: 10), onTimeout: () {});

    searchSnapshot.documents.forEach((snapshot) {
      querySetResult.add(snapshot);
      tempResult.add(snapshot);
    });

    (tempResult.length == 0) ? resultAvailable = false : resultAvailable = true;

    setState(() {
      loading = false;
    });
  }

  void getTempSet(String searchQuery) async {
    querySetResult.forEach((snapshot) {
      if (snapshot['Name'].toLowerCase().contains(searchQuery.toLowerCase())) {
        tempResult.add(snapshot);
      }
    });

    (tempResult.length == 0) ? resultAvailable = false : resultAvailable = true;

    setState(() {
      loading = false;
    });
  }

  Future<void> search(searchQuery) async {
    setState(() {
      loading = true;
    });
    searchSnapshot = null;
    tempResult = [];
    if (querySetResult.length == 0 || searchQuery.length == 1) {
      querySetResult = [];
      getQuerySet(searchQuery);
    } else {
      getTempSet(searchQuery);
    }
  }

  void retrySearch() async {
    timedOut = false;
    if (searchingStatus == 0) {
      reload();
    } else {
      search(searchString);
    }
  }

  void getSearch() async {
    expertSearchBloc.value.listen((searchQuery) {
      searchingStatus = 1;
      timedOut = false;
      if (searchString != searchQuery) {
        searchString = searchQuery;
        search(searchQuery);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    {
      getSearchingStatus();
      getSearch();
      listenReload();
      String allExpertHeaderText = "All Experts";
      String searchHeaderText = "Results";

      if (timedOut) {
        return SliverToBoxAdapter(child: TimedOut(retrySearch));
      }

      if (loading) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }

      if (searchingStatus == 0) {
        return SearchResults(expertSnapshot.documents, allExpertHeaderText);
      }

      if (searchingStatus == 1 && resultAvailable) {
        return SearchResults(tempResult, searchHeaderText);
      }

      if (searchingStatus == 1 && !resultAvailable) {
        return SliverToBoxAdapter(child: NoResultCard());
      } else
        return Container();
    }
  }
}
