import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';

import './search_result_cards.dart';
import '../bloc/search_bloc.dart';
import '../bloc/is_searching.dart';

class Cards extends StatefulWidget {
  @override
  _Cards createState() => _Cards();
}

class _Cards extends State<Cards> {
  int searchingStatus = 0;
  CollectionReference expert;
  QuerySnapshot expertSnapshot,searchSnapshot;
  Widget loading;

  @override
  void dispose() {
    expertSearchBloc.dispose();
    isSearchingExpert.dispose();
    super.dispose();
  }

  @override
  void initState() {
    loading=CircularProgressIndicator();
    getExpert();
    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        loading=Text("Timed Out!",style: Theme.of(context).textTheme.title,
          textScaleFactor: 1.2,);
      });
    });
    super.initState();
  }

  Future<void> getExpert() async {
    expert = Firestore.instance.collection("Experts");
    expertSnapshot = await expert.getDocuments();
    setState(() {});
  }

  void getSearchingStatus() async {
    isSearchingExpert.getStatus.listen((result) {
      setState(() {
        searchingStatus = result;
      });
    });
  }

  Future<void> search(searchQuery) async{
    int flag = 0;
    searchSnapshot=null;
    setState(() {

    });

    searchSnapshot=await expert.where("Name",isEqualTo: searchQuery).getDocuments();
    searchSnapshot.documents.clear();
    expertSnapshot.documents.forEach((expert){
      if(expert["Name"].toLowerCase().contains(searchQuery))
        {
          flag=1;
          setState(() {
            searchSnapshot.documents.add(expert);
          });
        }
    });
    if (flag == 0) {
      setState(() {
        loading=Text("No Results!",style: Theme.of(context).textTheme.title,
          textScaleFactor: 1.2,);
      });
    }
  }

  void getSearch() async {
    expertSearchBloc.value.listen((searchQuery) {
      searchingStatus = 1;
      loading=CircularProgressIndicator();
      search(searchQuery);
      Future.delayed(Duration(seconds: 10), () {
        if(searchSnapshot==null){
        setState(() {
          loading=Text("Timed Out!",style: Theme.of(context).textTheme.title,
            textScaleFactor: 1.2,);
        });}
      });
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
        if (searchSnapshot != null&&searchSnapshot.documents.length!=0)
          return SearchResults(searchSnapshot, searchHeaderText);
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
