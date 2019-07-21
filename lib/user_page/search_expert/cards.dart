import 'package:cloud_firestore/cloud_firestore.dart';
import "package:experto/utils/bloc/is_searching.dart";
import "package:experto/utils/bloc/reload.dart";
import "package:experto/utils/bloc/search_bloc.dart";
import 'package:experto/utils/no_result.dart';
import 'package:experto/utils/timed_out.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';

import './search_result_cards.dart';
//import "package:cached_network_image/cached_network_image.dart";

class Cards extends StatefulWidget {
  @override
  _Cards createState() => _Cards();
}

class _Cards extends State<Cards> {
  List<DocumentSnapshot> querySetResult = [], tempResult = [];
  String searchString;
  bool timedOut = false,
      resultAvailable = false,
      loading = false,
      searchingStatus = false,
      isInitialSearch = true;
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
      searchingStatus = false;
      expert = null;
      expertSnapshot = null;
      searchSnapshot = null;
      getExpert();
    });
  }

  @override
  void initState() {
    timedOut = false;
    getSearchingStatus();
    getSearch();
    listenReload();
    getExpert();
    super.initState();
  }

  Future<void> getExpert() async {
    setState(() {
      loading = true;
    });

    expert = Firestore.instance.collection("Experts");
    expertSnapshot = await expert
        .where("Status", isEqualTo: true).orderBy('Available', descending: true)
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
        searchingStatus = result;
        if (result == false) {
          searchString = '';
          isInitialSearch = true;
        }
      });
    });
  }

  void getQuerySet(String searchQuery) async {
    QuerySnapshot searchSnapshot = await expert
        .where("Index", isEqualTo: searchQuery.toUpperCase())
        .where("Status", isEqualTo: true)
        .getDocuments()
        .timeout(Duration(seconds: 10), onTimeout: () {});

    searchSnapshot.documents.forEach((snapshot) {
      querySetResult.add(snapshot);
      tempResult.add(snapshot);
    });

    (tempResult.length == 0) ? resultAvailable = false : resultAvailable = true;

    setState(() {
      loading = false;
      isInitialSearch = false;
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
    if (isInitialSearch) {
      querySetResult = [];
      getQuerySet(searchQuery[0]);
    } else {
      getTempSet(searchQuery);
    }
  }

  void retrySearch() async {
    timedOut = false;
    if (searchingStatus == false) {
      reload();
    } else {
      search(searchString);
    }
  }

  void getSearch() async {
    expertSearchBloc.value.listen((searchQuery) {
      searchingStatus = true;
      timedOut = false;
      searchString = searchQuery;
      search(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    {
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

      if (searchingStatus == false) {
        return SearchResults(
          expertSnapshot.documents,
          allExpertHeaderText,
        );
      }

      if (searchingStatus == true && resultAvailable) {
        return SearchResults(tempResult, searchHeaderText);
      }

      if (searchingStatus == true && !resultAvailable) {
        return SliverToBoxAdapter(child: NoResultCard());
      } else
        return Container();
    }
  }
}
