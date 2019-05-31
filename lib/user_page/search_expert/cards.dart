import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';

import './search_result_cards.dart';
import '../bloc/search_bloc.dart';
import '../bloc/reload.dart';
import '../bloc/is_searching.dart';
import './no_result.dart';
import './timed_out.dart';

class Cards extends StatefulWidget {
  @override
  _Cards createState() => _Cards();
}

class _Cards extends State<Cards> {
  List results = [];
  List allExperts;
  int searchingStatus = 0;
  String searchString;
  bool timedOut = false, resultAvailable =false;
  CollectionReference expert;
  QuerySnapshot expertSnapshot, searchSnapshot;
  Widget loading;

  @override
  void dispose() {
    expertSearchBloc.dispose();
    isSearchingExpert.dispose();
    super.dispose();
  }

  void listenReload() async { 
    userSearchExpert.getStatus.listen((value){
      if (value == true){
        setState(() {
          timedOut = false;
          searchingStatus = 0;
          expert = null;
          expertSnapshot = null;
          searchSnapshot = null;
          getExpert();
        });
      }
  });
  }

  @override
  void initState() {
    timedOut = false;
    loading = CircularProgressIndicator();
    getExpert();
    super.initState();
  }

  Future<void> getExpert() async {
    expert = Firestore.instance.collection("Experts");
    expertSnapshot = await expert.where("Status",isEqualTo: true).getDocuments().timeout(Duration(seconds: 10),
        onTimeout: () {
      timedOut = true;
    });
    setState(() {});
  }

  void getSearchingStatus() async {
    isSearchingExpert.getStatus.listen((result) {
      setState(() {
        getExpert();
        timedOut = false;
        searchingStatus = result;
      });
    });
  }

  Future<void> search(searchQuery) async {
    int flag = 0;
    searchSnapshot = null;
    setState(() {});
    searchSnapshot = await expert
        .where("Name", isEqualTo: searchQuery)
        .getDocuments()
        .timeout(Duration(seconds: 10), onTimeout: () {
      timedOut = true;
    });
    searchSnapshot.documents.clear();
    expertSnapshot.documents.forEach((expert) {
      if (expert["Name"].toLowerCase().contains(searchQuery)) {
        flag = 1;
        setState(() {
          resultAvailable = true;
          searchSnapshot.documents.add(expert);
        });
      }
    });
    if (flag == 0) {
      setState(() {
        resultAvailable = false;
      });
    }
  }

  void retrySearch(){
    timedOut = false;
    searchingStatus = 1;
    print(searchString);
    search(searchString);
  } 

  void getSearch() async {
    expertSearchBloc.value.listen((searchQuery) {
      searchingStatus = 1;
      searchString = searchQuery;
      timedOut = false;
      loading = CircularProgressIndicator();
      search(searchQuery);
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
      if (searchingStatus == 0) {
        if (expertSnapshot != null)
          return SearchResults(expertSnapshot, allExpertHeaderText);
        else
          return SliverPadding(
            padding: EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Center(
                    child: loading,
                  );
                },
                childCount: 1,
              ),
            ),
          );
      } else {
        if (searchSnapshot != null && searchSnapshot.documents.length != 0)
          return SearchResults(searchSnapshot, searchHeaderText);
        else if(searchSnapshot != null && resultAvailable==false){
          return SliverToBoxAdapter(child:NoResultCard());
        }
        else
          return SliverPadding(
            padding: EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Center(
                    child: loading,
                  );
                },
                childCount: 1,
              ),
            ),
          );
      }
    }
  }
}
