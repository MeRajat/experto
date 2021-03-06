import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';

import './categories_list.dart';
import "package:experto/utils/bloc/search_bloc.dart";
import "package:experto/utils/bloc/reload.dart";
import "package:experto/utils/bloc/is_searching.dart";
import 'package:experto/utils/timed_out.dart';
import 'package:experto/utils/no_result.dart';

class Cards extends StatefulWidget {
  @override
  _Cards createState() => _Cards();
}

class _Cards extends State<Cards> {
  String searchString = '';
  bool resultAvailable = false,
      timedOut = false,
      loading = false,
      isInitialSearch = true,
      searchingStatus = false;
  List<DocumentSnapshot> querySetResult = [], tempResult = [], topSkills = [];
  QuerySnapshot searchSnapshot, categorySnapshot;
  DocumentReference skillReference;

  @override
  void dispose() {
    searchBloc.dispose();
    isSearching.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getTopSkills();
    listenReload();
    getSearchingStatus();
    getSearch();
    super.initState();
  }

  void getTopSkills() async {
    setState(() {
      loading = true;
    });

    categorySnapshot = await Firestore.instance
        .collection('Categories')
        .getDocuments()
        .timeout(Duration(seconds: 10), onTimeout: () {
      setState(() {
        timedOut = true;
      });
    }).then((snapshot) async {
      for (int i = 0; i < snapshot.documents.length; i++) {
        skillReference = snapshot.documents[i].data['Skill'];
        topSkills.add(snapshot.documents[i]);
      }
      setState(() {
        loading = false;
      });
    });
  }

  void listenReload() async {
    userSearchSkill.getStatus.listen((value) {
      if (value == true) {
        reload();
      }
    });
  }

  void reload() {
    setState(() {
      timedOut = false;
      searchingStatus = false;
      topSkills = [];
      searchSnapshot = null;
      getTopSkills();
    });
  }

  void retrySearch() {
    timedOut = false;
    if (searchingStatus == false) {
      reload();
    } else {
      search(searchString);
    }
  }

  void getSearchingStatus() async {
    isSearching.getStatus.listen((result) {
      setState(() {
        timedOut = false;
        searchingStatus = result;
        if (result == false) {
          isInitialSearch = true;
          searchString = '';
        }
      });
    });
  }

  void getQuerySet(String searchQuery) async {
    QuerySnapshot searchSnapshot = await Firestore.instance
        .collection("Skills")
        .where("Index", arrayContains: searchQuery.toUpperCase())
        .getDocuments()
        .timeout(Duration(seconds: 10), onTimeout: () {});

    searchSnapshot.documents.forEach((snapshot) {
      querySetResult.add(snapshot);
      tempResult.add(snapshot);
    });

    (tempResult.length == 0) ? resultAvailable = false : resultAvailable = true;

    setState(() {
      isInitialSearch = false;
      loading = false;
    });
  }

  void getTempSet(String searchQuery) async {
    querySetResult.forEach((snapshot) {
      if (snapshot.data['Name']
          .toLowerCase()
          .contains(searchQuery.toLowerCase())) {
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
      getQuerySet(searchQuery);
    } else {
      getTempSet(searchQuery);
    }
  }

  void getSearch() async {
    searchBloc.value.listen((searchQuery) {
      searchingStatus = true;
      timedOut = false;
      searchString = searchQuery;
      search(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    {
      String recommendationHeaderText = "Top Categories";
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
        return SearchResults(topSkills, recommendationHeaderText, false);
      }

      if (searchingStatus == true && resultAvailable) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: SearchResults(tempResult, searchHeaderText, true),
        );
      }

      if (searchingStatus == true && !resultAvailable) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: SliverToBoxAdapter(child: NoResultCard()),
        );
      } else
        return SliverToBoxAdapter(child: Container());
    }
  }
}
