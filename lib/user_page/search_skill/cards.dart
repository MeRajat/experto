import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import "dart:math";

import './categories_list.dart';
import "package:experto/utils/bloc/search_bloc.dart";
import "package:experto/utils/bloc/reload.dart";
import "package:experto/utils/bloc/is_searching.dart";
import 'package:experto/utils/timed_out.dart';
import 'package:experto/utils/no_result.dart';

class Cards extends StatefulWidget {
  final List<Color> colorsDarkMode = [
    Color.fromRGBO(46, 117, 178, 1),
    Color.fromRGBO(229, 107, 107, 1),
    Color.fromRGBO(172, 95, 175, 1),
    Color.fromRGBO(255, 138, 96, 1),
    Color.fromRGBO(94, 165, 95, 1),
    Color.fromRGBO(67, 168, 127, 1)
  ];

  final List<Color> colorsLightMode = [
    Colors.red,
    Colors.purple,
    Colors.blue,
    Colors.deepOrangeAccent,
    Colors.green,
    Colors.cyan,
  ];

  final random = new Random();

  @override
  _Cards createState() => _Cards();
}

class _Cards extends State<Cards> {
  int searchingStatus = 0;
  String searchString = '';
  bool resultAvailable = false, timedOut = false, loading = false;
  List<DocumentSnapshot> querySetResult = [], tempResult = [], categories = [];
  List<Map<String, dynamic>> subSkills = [];
  List<Widget> categoryIcons = [];
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
    getCategories();
    listenReload();
    getSearchingStatus();
    getSearch();
    super.initState();
  }

  Future<void> getSubSkills(DocumentSnapshot category) async {
    List<DocumentSnapshot> skillList = [];
    List<Widget> skillIconList = [];

    await Firestore.instance
        .collection("Skills")
        .where("Category", arrayContains: category.reference)
        .getDocuments()
        .then((QuerySnapshot skills) {
      for (int i = 0; i < skills.documents.length; i++) {
        skillList.add(skills.documents[i]);
        skillIconList.add(
          CachedNetworkImage(
            imageUrl: skills.documents[i]["IconURL"],
            color: (Theme.of(context).brightness == Brightness.dark)
                ? widget.colorsDarkMode[
                    widget.random.nextInt(widget.colorsDarkMode.length)]
                : widget.colorsLightMode[
                    widget.random.nextInt(widget.colorsLightMode.length)],
          ),
        );
      }
    });

    subSkills.add({'skills': skillList, "icons": skillIconList});
  }

  void getCategories() async {
    setState(() {
      loading = true;
    });

    categoryIcons = [];
    categorySnapshot = await Firestore.instance
        .collection('Categories')
        .getDocuments()
        .timeout(Duration(seconds: 10), onTimeout: () {
      setState(() {
        timedOut = true;
      });
    }).then((snapshot) async {
      for (int i = 0; i < snapshot.documents.length; i++) {
        categories.add(snapshot.documents[i]);
        categoryIcons.add(
          CachedNetworkImage(
            imageUrl: snapshot.documents[i]["IconURL"],
            color: (Theme.of(context).brightness == Brightness.dark)
                ? widget.colorsDarkMode[
                    widget.random.nextInt(widget.colorsDarkMode.length)]
                : widget.colorsLightMode[
                    widget.random.nextInt(widget.colorsLightMode.length)],
          ),
        );
        await getSubSkills(snapshot.documents[i]);
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
      categories = [];
      searchSnapshot = null;
      getCategories();
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
        .where("Index", arrayContains: searchQuery.toUpperCase())
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

      if (searchingStatus == 0) {
        return SearchResults(
          categories,
          recommendationHeaderText,
          false,
          subSkills: subSkills,
          categoryIcon: categoryIcons,
        );
      }

      if (searchingStatus == 1 && resultAvailable) {
        return SearchResults(tempResult, searchHeaderText, true);
      }

      if (searchingStatus == 1 && !resultAvailable) {
        return SliverToBoxAdapter(child: NoResultCard());
      } else
        return SliverToBoxAdapter(child: Container());
    }
  }
}
