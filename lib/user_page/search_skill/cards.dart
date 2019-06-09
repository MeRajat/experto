import 'package:cloud_firestore/cloud_firestore.dart';
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
  @override
  _Cards createState() => _Cards();
}

class _Cards extends State<Cards> {
  int searchingStatus = 0;
  String searchString = '';
  bool resultAvailable = false, timedOut = false, loading = false;
  List<DocumentSnapshot> querySetResult = [], tempResult = [], topSkills = [];
  QuerySnapshot searchSnapshot, topSkillSnapshot;
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

    topSkillSnapshot = await Firestore.instance
        .collection('TopSkills')
        .getDocuments()
        .timeout(Duration(seconds: 10), onTimeout: () {
      setState(() {
        timedOut = true;
      });
    }).then((snapshot) async {
      for (int i = 0; i < snapshot.documents.length; i++) {
        skillReference = snapshot.documents[i].data['Skill'];
        topSkills.add(await skillReference.get());
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
      searchingStatus = 0;
      topSkills = [];
      searchSnapshot = null;
      getTopSkills();
    });
  }

  void retrySearch() {
    timedOut = false;
    if (searchingStatus == 0) {
      reload();
    } else {
      search(searchString);
    }
  }

  void getSearchingStatus() async {
    isSearching.getStatus.listen((result) {
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
    QuerySnapshot searchSnapshot = await Firestore.instance
        .collection("Skills")
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
      if (snapshot.data['Name'].toLowerCase().contains(searchQuery.toLowerCase())) {
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

  void getSearch() async {
    searchBloc.value.listen((searchQuery) {
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
      String recommendationHeaderText = "Top Domains";
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
        return SearchResults(topSkills, recommendationHeaderText);
      }

      if (searchingStatus == 1 && resultAvailable) {
        return SearchResults(tempResult, searchHeaderText);
      }

      if (searchingStatus == 1 && !resultAvailable) {
        return SliverToBoxAdapter(child: NoResultCard());
      } else
        return SliverToBoxAdapter(child: Container());
    }
  }
}
